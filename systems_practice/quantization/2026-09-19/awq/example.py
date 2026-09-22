#!/usr/bin/env python3
"""调用固定版本AWQ的激活感知裁剪和真实打包API；CPU重建推理，不声称低位kernel性能。"""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import time

COMMIT = "d6e797a42b9ef7778de8ee2352116e0f48a78d61"
HERE = Path(__file__).resolve().parent
PRACTICE = HERE.parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True)
    args = parser.parse_args()
    source = args.source.resolve()
    if not source.is_relative_to(PRACTICE / ".tmp" / "quant_sources"):
        parser.error("source must be an ignored systems_practice/.tmp/quant_sources checkout")
    if not (source / ".git").exists():
        parser.error("verified upstream checkout missing; see source.json and retry instructions")
    actual = subprocess.check_output(["git", "-C", str(source), "rev-parse", "HEAD"], text=True).strip()
    dirty = subprocess.check_output(["git", "-C", str(source), "status", "--porcelain", "--untracked-files=no"], text=True)
    if actual != COMMIT or dirty:
        parser.error("expected clean pinned source " + COMMIT)
    sys.path.insert(0, str(source))
    # qmodule原生导入要求awq_inference_engine；不能用stub冒充安装或CPU支持。
    import torch
    import torch.nn.functional as F
    from awq.quantize.auto_clip import auto_clip_layer
    from awq.quantize.quantizer import pseudo_quantize_tensor
    from awq.quantize.qmodule import WQLinear

    torch.set_num_threads(1)
    def rand(rows, cols, seed):
        return torch.randn(rows, cols, generator=torch.Generator().manual_seed(seed))

    # 固定参数，不用评估集选阈值。这里只搜索clip，不做AWQ完整block缩放搜索或QAT。
    weight = rand(64, 128, 10) * .1
    weight[:, 0] *= 5
    calibration = rand(512, 128, 20)
    calibration[:, 0] *= .1
    evaluation = rand(128, 128, 30)
    evaluation[:, 0] *= .1
    config = {"zero_point": True, "q_group_size": 128}
    with torch.no_grad():
        begin = time.perf_counter()
        limits = auto_clip_layer(weight.clone(), calibration, n_bit=4, q_config=config,
                                 n_grid=20, max_shrink=.5, n_sample_token=128)
        calibration_ms = (time.perf_counter() - begin) * 1000
        clipped = weight.reshape(64, 1, 128).clamp(-limits, limits).reshape_as(weight)
        # 与部署FP16 scale一致；上游API返回重建值及实际打包所需scale/zero。
        reconstructed, scales, zeros = pseudo_quantize_tensor(
            clipped.half(), n_bit=4, get_scale_zp=True, **config)
        layer = torch.nn.Linear(128, 64, bias=False).half()
        layer.weight.copy_(reconstructed)
        packed = WQLinear.from_linear(layer, 4, 128, False, scales, zeros)
        state = packed.state_dict()
        payload = {key: value.numel() * value.element_size() for key, value in state.items()}
        assert state["qweight"].dtype == torch.int16
        assert payload["qweight"] == 64 * 128 // 2
        # 存档为被忽略build中的权重，不提交模型；加载至同版本原生容器。
        output = HERE / "build"
        output.mkdir(exist_ok=True)
        checkpoint = output / "awq-clip-state.pt"
        torch.save(state, checkpoint)
        restored = WQLinear(4, 128, 128, 64, False, "cpu", dtype=torch.float16)
        restored.load_state_dict(torch.load(checkpoint, map_location="cpu", weights_only=True))
        for key, value in state.items():
            assert torch.equal(value, restored.state_dict()[key])

        ref = F.linear(evaluation, weight)
        half_ref = F.linear(evaluation.half().float(), weight.half().float())
        # 独立absmax基线，明确非上游zero_point=False路径（该commit此路径有未绑定变量）。
        step = weight.abs().amax(dim=1, keepdim=True).clamp_min(1e-5) / 7
        absmax = (weight / step).round().clamp(-8, 7) * step
        no_clip = pseudo_quantize_tensor(weight.half(), n_bit=4, **config).float()
        candidates = {"fp16_storage_fp32_mac": half_ref,
                      "independent_absmax_w4": F.linear(evaluation.half().float(), absmax),
                      "upstream_minmax_no_clip": F.linear(evaluation.half().float(), no_clip),
                      "awq_clip_reconstruction": F.linear(evaluation.half().float(), reconstructed.float())}
        def metrics(got, expected):
            error = got - expected
            return {"nrmse": float(error.norm() / expected.norm().clamp_min(1e-12)),
                    "max_abs": float(error.abs().max()),
                    "cosine": float(F.cosine_similarity(got.flatten(), expected.flatten(), dim=0))}
        comparison = {key: metrics(value, ref) for key, value in candidates.items()}
        # 故障边界：评估时突然出现未校准强激活；保持既定clip，不重新拟合。
        shifted = evaluation.clone()
        shifted[:, 0] *= 100
        shift_metrics = metrics(F.linear(shifted.half().float(), reconstructed.float()), F.linear(shifted, weight))
        # 只测CPU FP32解码后矩阵乘；不调用packed.forward，不当作W4A16内核吞吐。
        decoded = reconstructed.float()
        x = evaluation.half().float()
        samples = []
        for i in range(120):
            begin = time.perf_counter_ns()
            result = F.linear(x, decoded)
            end = time.perf_counter_ns()
            if i >= 20:
                samples.append((end - begin) / 1e6)
        assert torch.isfinite(result).all()
        samples.sort()
        codes = (reconstructed.reshape(64, 1, 128) / scales.reshape(64, 1, 1)
                 + zeros.reshape(64, 1, 1)).round()
        endpoint_fraction = float((codes.eq(0) | codes.eq(15)).float().mean())
        report = {"commit": COMMIT, "torch": torch.__version__, "device": "cpu",
                  "scope": "upstream AWQ clip-only + native packing/export; reconstructed FP32 MAC, no native low-bit inference",
                  "comparison": comparison, "distribution_shift": shift_metrics,
                  "clip_fraction": float((clipped != weight).float().mean()),
                  "q_endpoint_fraction": endpoint_fraction,
                  "fp32_weight_bytes": weight.numel() * 4, "fp16_weight_bytes": weight.numel() * 2,
                  "actual_packed_buffer_bytes": payload, "packed_total_bytes": sum(payload.values()),
                  "checkpoint_file_bytes_including_serialization": checkpoint.stat().st_size,
                  "calibration_single_run_ms": calibration_ms,
                  "cpu_decoded_gemm_p50_ms": samples[49], "cpu_decoded_gemm_p95_ms": samples[94],
                  "warmup": 20, "samples": 100, "thor_verified": False}
        text = json.dumps(report, ensure_ascii=False, indent=2)
        (output / "metrics.json").write_text(text + "\n")
        print(text)


if __name__ == "__main__":
    main()
