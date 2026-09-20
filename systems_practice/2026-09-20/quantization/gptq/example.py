#!/usr/bin/env python3
"""调用固定原仓库GPTQ；独立INT4导出容器，不冒充上游3-bit CUDA后端。"""
import argparse
import importlib.metadata
import json
import os
from pathlib import Path
import subprocess
import sys
import time

COMMIT = "2d65066eeb06a5c9ff5184d8cebdf33662c67faf"
HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", required=True)
    args = parser.parse_args()
    source = Path(args.source).resolve()
    cache = HERE.parents[2] / ".tmp" / "quant_sources"
    if cache.resolve() not in source.parents:
        raise RuntimeError("源码必须位于systems_practice/.tmp/quant_sources缓存")
    if not (source / "gptq.py").is_file():
        raise RuntimeError("缺少已检出的原仓库gptq.py；fetch --no-checkout只获取Git对象/快照")
    head = subprocess.check_output(["git", "-C", str(source), "rev-parse", "HEAD"], text=True).strip()
    if head != COMMIT:
        raise RuntimeError("源码commit与阅读版本不一致")
    if subprocess.check_output(["git", "-C", str(source), "status", "--porcelain", "--untracked-files=no"], text=True).strip():
        raise RuntimeError("拒绝使用有已跟踪修改的源码")
    os.environ["PYTHONDONTWRITEBYTECODE"] = "1"
    sys.dont_write_bytecode = True
    sys.path.insert(0, str(source))
    import torch
    import torch.nn.functional as F
    from gptq import GPTQ
    from quant import Quantizer

    if not torch.cuda.is_available() or torch.cuda.get_device_capability(0) != (11, 0):
        raise RuntimeError("原生fasterquant无条件cuda同步；本例要求Thor SM110，不能当CPU运行成功")
    torch.cuda.set_device(0)
    if "sm_110" not in torch.cuda.get_arch_list():
        raise RuntimeError("当前PyTorch未列出sm_110；需要验证匹配Thor的软件栈")
    torch.backends.cuda.matmul.allow_tf32 = False
    torch.backends.cudnn.allow_tf32 = False
    dev = "cuda:0"
    results = HERE / "results"
    build = HERE / "build"
    results.mkdir(exist_ok=True)
    build.mkdir(exist_ok=True)

    def sync():
        torch.cuda.synchronize()

    def duration(fn):
        sync()
        start = time.perf_counter()
        value = fn()
        sync()
        return value, (time.perf_counter() - start) * 1000

    def metrics(y, ref):
        y, ref = y.double(), ref.double()
        diff = y - ref
        return {"nrmse": (diff.norm() / ref.norm().clamp_min(1e-30)).item(),
                "max_abs": diff.abs().max().item(),
                "cosine": F.cosine_similarity(y.flatten(), ref.flatten(), dim=0).item()}

    def measure(fn):
        # CUDA event包含torch算子区间；CPU分配/解码在另一E2E计时边界。
        for _ in range(20):
            fn()
        sync()
        samples = []
        start, end = torch.cuda.Event(enable_timing=True), torch.cuda.Event(enable_timing=True)
        for _ in range(100):
            start.record()
            fn()
            end.record()
            end.synchronize()
            samples.append(start.elapsed_time(end))
        samples.sort()
        return {"gpu_interval_p50_ms": samples[49], "gpu_interval_p95_ms": samples[94]}

    def data(seed, n):
        gen = torch.Generator().manual_seed(seed)
        x = torch.randn(n, 128, generator=gen)
        # 校准集中制造相关特征，但评估样本独立；零通道触发H的dead-column路径。
        x[:, 1] = .9 * x[:, 0] + .1 * x[:, 1]
        x[:, 7] = 0
        return x.to(dev)

    def pack(weight, scale, zero):
        # 本课自定义的无符号affine INT4容器；并非GPTQ Quant3Linear格式。
        unrounded = weight.float() / scale + zero
        codes = unrounded.round().clamp(0, 15).to(torch.uint8).cpu().contiguous()
        flat = codes.flatten()
        payload = flat[0::2] | (flat[1::2] << 4)
        restored_codes = torch.stack((payload & 15, payload >> 4), dim=1).flatten().reshape_as(codes)
        assert torch.equal(codes, restored_codes)
        restored = (restored_codes.to(dev).float() - zero) * scale
        torch.testing.assert_close(restored, weight, rtol=1e-5, atol=1e-6)
        return payload, {"endpoint_fraction": ((codes == 0) | (codes == 15)).float().mean().item(),
                         "out_of_grid_fraction": ((unrounded < -.5) | (unrounded > 15.5)).float().mean().item()}

    def decode(payload, scale, zero):
        codes = torch.stack((payload & 15, payload >> 4), dim=1).flatten().reshape(32,128)
        return ((codes.to(dev).float() - zero.to(dev)) * scale.to(dev)).half()

    with torch.no_grad():
        torch.manual_seed(30)
        original = torch.randn(32, 128, device="cpu").to(dev) * .1
        original[0] = 0  # 全零权重行的scale保护
        calibration, validation, evaluation = data(31, 256), data(32, 128), data(33, 128)
        candidates = []
        # 无训练更新：GPTQ为PTQ。只用validation选择阻尼，evaluation从不参与选择。
        for damping in (.01, .1):
            layer = torch.nn.Linear(128, 32, bias=False, device=dev, dtype=torch.float32)
            layer.weight.copy_(original)
            engine = GPTQ(layer)
            engine.quantizer = Quantizer()
            engine.quantizer.configure(4, perchannel=True, sym=False, mse=False)
            _, calibration_ms = duration(lambda: engine.add_batch(calibration, layer(calibration)))
            _, quant_ms = duration(lambda: engine.fasterquant(blocksize=32, percdamp=damping,
                                      groupsize=-1, actorder=False, static_groups=False))
            error = metrics(F.linear(validation, layer.weight), F.linear(validation, original))["nrmse"]
            candidates.append({"damping": damping, "validation_nrmse": error,
                               "weight": layer.weight.detach().clone(),
                               "scale": engine.quantizer.scale.clone(), "zero": engine.quantizer.zero.clone(),
                               "calibration_ms": calibration_ms, "quantization_ms": quant_ms})
            engine.free()
        selected = min(candidates, key=lambda x: x["validation_nrmse"])
        quantized = selected["weight"]
        scale, zero = selected["scale"], selected["zero"]
        (payload, code_stats), pack_ms = duration(lambda: pack(quantized, scale, zero))
        # 导出张量payload后重新加载、解码、接入原有Linear；二进制只进被忽略build。
        artifact = build / "gptq_int4.pt"
        torch.save({"packed": payload, "scale": scale.cpu(), "zero": zero.cpu(),
                    "shape": [32,128], "format": "lesson_u4_low_nibble_first", "commit": COMMIT}, artifact)
        restored = torch.load(artifact, map_location="cpu", weights_only=True)
        decoded = decode(restored["packed"], restored["scale"], restored["zero"])
        target = torch.nn.Linear(128,32,bias=False,device=dev,dtype=torch.float16)
        target.weight.copy_(decoded)
        torch.testing.assert_close(decoded, quantized.half(), rtol=0, atol=0)
        torch.testing.assert_close(target(evaluation.half()), F.linear(evaluation.half(),decoded), rtol=0, atol=0)
        rtn = Quantizer()
        rtn.configure(4, perchannel=True, sym=False, mse=False)
        rtn.find_params(original, weight=True)
        nearest = rtn.quantize(original)
        abs_scale = original.abs().amax(dim=1,keepdim=True).clamp_min(1e-12) / 7
        absmax = (original / abs_scale).round().clamp(-7,7) * abs_scale
        ref = F.linear(evaluation,original)
        x16 = evaluation.half()
        weights = {"fp16_reference": original.half(), "absmax_s4": absmax.half(),
                   "same_grid_rtn_u4": nearest.half(), "gptq_decoded_fp16": decoded}
        comparisons = {}
        for name, w in weights.items():
            y = F.linear(x16,w)
            comparisons[name] = metrics(y,ref)
            comparisons[name].update(measure(lambda w=w: F.linear(x16,w)))
        # 未见过的校准死通道在shift评估中激活，保留误差退化而非再次调参。
        shifted = evaluation.clone()
        shifted[:,7] = 8
        shifted_result = metrics(F.linear(shifted.half(),decoded), F.linear(shifted,original))
        def reload_inference():
            w = decode(restored["packed"], restored["scale"], restored["zero"])
            return F.linear(evaluation.half(),w)
        e2e = []
        for i in range(120):
            _, ms = duration(reload_inference)
            if i >= 20:
                e2e.append(ms)
        e2e.sort()
        report = {"commit":COMMIT, "torch":torch.__version__, "torch_cuda":torch.version.cuda,
                  "transformers":importlib.metadata.version("transformers"),
                  "numpy":importlib.metadata.version("numpy"), "target":"sm_110",
                  "selected_damping":selected["damping"],
                  "candidates":[{k:v for k,v in c.items() if k not in ("weight","scale","zero")} for c in candidates],
                  "comparisons":comparisons, "shifted_dead_channel":shifted_result,
                  "packing_statistics":code_stats, "packing_roundtrip_ms":pack_ms,
                  "bytes":{"original_fp32":original.numel()*4,"reference_fp16":original.numel()*2,
                           "packed":payload.numel(),"scale":scale.numel()*4,"zero":zero.numel()*4,
                           "file_including_serialization":artifact.stat().st_size()},
                  "e2e_cpu_unpack_H2D_decode_fp16_gemm_sync_p50_ms":e2e[49],
                  "e2e_cpu_unpack_H2D_decode_fp16_gemm_sync_p95_ms":e2e[94],
                  "note":"Dense FP16 torch GEMM after decode, NOT packed INT4 Tensor Core performance. No full-model task accuracy."}
        (results / "measured.json").write_text(json.dumps(report,indent=2)+"\n")
        print(json.dumps(report,indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"UNVERIFIED: {type(error).__name__}: {error}", file=sys.stderr)
        sys.exit(2)
