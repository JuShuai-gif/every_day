#!/usr/bin/env python3
"""原生量化算法与 PyTorch 评估主流程；底层 C++ 实验可选。"""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import time

COMMIT = "d6e797a42b9ef7778de8ee2352116e0f48a78d61"
HERE = Path(__file__).resolve().parent
PRACTICE = HERE.parents[2]
sys.path.insert(0, str(HERE.parents[1]))
from torch_evaluation import evaluate_torch


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

        no_clip = pseudo_quantize_tensor(weight.half(), n_bit=4, **config).float()
        shifted = evaluation.clone()
        shifted[:, 0] *= 100
        evaluation_report = evaluate_torch(output, weight, reconstructed, no_clip, scales, zeros,
                               evaluation, shifted, 128)
        report = {"commit": COMMIT, "torch": torch.__version__,
                  "scope": "native clip-only calibration and WQLinear API export; PyTorch evaluation; optional C++ storage experiment",
                  "actual_native_packed_buffer_bytes": payload,
                  "checkpoint_file_bytes": checkpoint.stat().st_size,
                  "calibration_single_run_ms": calibration_ms,
                  "torch_evaluation": evaluation_report, "thor_verified": False}
        text = json.dumps(report, ensure_ascii=False, indent=2)
        (output / "metrics.json").write_text(text + "\n")
        print(text)


if __name__ == "__main__":
    main()
