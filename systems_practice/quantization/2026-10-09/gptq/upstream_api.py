#!/usr/bin/env python3
"""真实 GPTQ API 的 Thor-only 最小调用；不下载模型或数据。"""
import argparse
import json
import sys
from pathlib import Path

COMMIT = "2d65066eeb06a5c9ff5184d8cebdf33662c67faf"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True, help="GPTQ 固定 commit 的工作树")
    args = parser.parse_args()
    source = Path(args.source).resolve()
    if not (source / "gptq.py").is_file() or not (source / "quant.py").is_file():
        raise RuntimeError("需要包含 gptq.py 与 quant.py 的已检出上游源码")
    sys.path.insert(0, str(source))
    import torch
    import torch.nn.functional as F
    from gptq import GPTQ
    from quant import Quantizer

    if not torch.cuda.is_available() or torch.cuda.get_device_capability(0) != (11, 0):
        raise RuntimeError("上游 fasterquant 无条件调用 cuda synchronize；只能在 Thor SM110 运行")
    device = "cuda:0"
    generator = torch.Generator(device="cpu").manual_seed(20261009)
    calibration = torch.randn(128, 64, generator=generator).to(device)
    validation = torch.randn(64, 64, generator=generator).to(device)
    evaluation = torch.randn(64, 64, generator=generator).to(device)
    original = torch.randn(16, 64, generator=generator).to(device) * 0.1
    # calibration 只构造 Hessian；validation 只选 damping；evaluation 从不参与选择。
    candidates = []
    for damping in (0.01, 0.10):
        layer = torch.nn.Linear(64, 16, bias=False, device=device)
        layer.weight.data.copy_(original)
        engine = GPTQ(layer)
        engine.quantizer = Quantizer()
        engine.quantizer.configure(4, perchannel=True, sym=False, mse=False)
        engine.add_batch(calibration, layer(calibration))
        engine.fasterquant(blocksize=32, percdamp=damping, groupsize=32, actorder=True, static_groups=True)
        nrmse = (F.linear(validation, layer.weight) - F.linear(validation, original)).norm() / F.linear(validation, original).norm()
        candidates.append((float(nrmse), damping, layer.weight.detach().clone()))
        engine.free()
    _, selected_damping, selected_weight = min(candidates)
    output = F.linear(evaluation, selected_weight)
    reference = F.linear(evaluation, original)
    report = {"commit": COMMIT, "format": "W4A16 QDQ weights, FP16/FP32 activation path", "selected_damping": selected_damping,
              "evaluation_nrmse": float((output-reference).norm()/reference.norm()),
              "note": "This is upstream GPTQ QDQ evaluation, not Quant3Linear packed-kernel throughput."}
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"UNVERIFIED: {type(error).__name__}: {error}", file=sys.stderr)
        raise SystemExit(2)
