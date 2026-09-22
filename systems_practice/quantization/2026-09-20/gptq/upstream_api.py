#!/usr/bin/env python3
"""原生量化算法与 PyTorch 评估主流程；底层 C++ 实验可选。"""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
import time

COMMIT = "2d65066eeb06a5c9ff5184d8cebdf33662c67faf"
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1]))
from torch_evaluation import evaluate_torch


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

    def data(seed, n):
        gen = torch.Generator().manual_seed(seed)
        x = torch.randn(n, 128, generator=gen)
        # 校准集中制造相关特征，但评估样本独立；零通道触发H的dead-column路径。
        x[:, 1] = .9 * x[:, 0] + .1 * x[:, 1]
        x[:, 7] = 0
        return x.to(dev)

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
        rtn = Quantizer()
        rtn.configure(4, perchannel=True, sym=False, mse=False)
        rtn.find_params(original, weight=True)
        nearest = rtn.quantize(original)
        shifted = evaluation.clone()
        shifted[:, 7] = 8
        evaluation_report = evaluate_torch(build, original, quantized, nearest, scale, zero,
                               evaluation, shifted, 128)
        report = {"commit": COMMIT, "target": "sm_110", "selected_damping": selected["damping"],
                  "candidates": [{k: v for k, v in c.items() if k not in ("weight", "scale", "zero")}
                                 for c in candidates],
                  "torch_evaluation": evaluation_report,
                  "packed_gpu_kernel_verified": False,
                  "note": "Native GPTQ requires Thor; PyTorch evaluates reconstructed tensors; C++ layout experiment is optional. No packed GPU performance claim."}
        (results / "measured.json").write_text(json.dumps(report, indent=2)+"\n")
        print(json.dumps(report, indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"UNVERIFIED: {type(error).__name__}: {error}", file=sys.stderr)
        sys.exit(2)
