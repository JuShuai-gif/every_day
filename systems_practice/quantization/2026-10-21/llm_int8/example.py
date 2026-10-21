"""原生 bitsandbytes Linear8bitLt；小张量，不下载模型，不安装依赖。"""
import argparse
import json
from pathlib import Path
import platform
import os
import subprocess
import statistics
import sys
import time

if sys.version_info < (3, 10):
    raise SystemExit("BLOCKED: bitsandbytes source requires Python>=3.10; host=" + platform.python_version())
import torch

# 固定导入来源，避免把任意已安装wheel冒充已读commit。
source = Path(os.environ.get("BNB_SOURCE", "")).resolve()
expected_commit = "833649043474794b8fe7a4136e0c40faf077b2e0"
if not (source / "bitsandbytes" / "__init__.py").is_file():
    raise SystemExit("BNB_SOURCE must point to a checked-out bitsandbytes source tree")
actual_commit = subprocess.check_output(["git", "-C", str(source), "rev-parse", "HEAD"], text=True).strip()
if actual_commit != expected_commit:
    raise SystemExit("bitsandbytes commit differs from the source studied in this lesson")
if subprocess.check_output(["git", "-C", str(source), "diff", "HEAD", "--", "bitsandbytes", "CMakeLists.txt"], text=True):
    raise SystemExit("bitsandbytes tracked implementation is modified; audit before running")
sys.path.insert(0, str(source))
import bitsandbytes as bnb
if source not in Path(bnb.__file__).resolve().parents:
    raise SystemExit("Imported bitsandbytes is outside BNB_SOURCE")


def metrics(y, ref):
    a, b = y.detach().float().cpu().flatten(), ref.float().cpu().flatten()
    d = a - b
    return {"nrmse": (d.norm() / b.norm().clamp_min(1e-12)).item(),
            "max_abs": d.abs().max().item(),
            "cosine": torch.nn.functional.cosine_similarity(a, b, dim=0).item()}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--device", choices=["cpu", "cuda"], default="cpu")
    args = ap.parse_args()
    device = torch.device(args.device)
    if device.type == "cuda" and torch.cuda.get_device_capability() != (11, 0):
        raise SystemExit("This lesson only permits Thor SM110 for CUDA execution")
    torch.set_num_threads(1)
    torch.manual_seed(1020)
    out = Path(__file__).resolve().parent / "build"
    out.mkdir(exist_ok=True)
    # 校准只描述分布；调参决定threshold；评估不参与选择；本方法无训练更新。
    def dataset(seed, count, shift=1):
        g = torch.Generator().manual_seed(seed)
        x = torch.randn(count, 64, generator=g) * 0.4
        x[:, 3] *= 30 * shift
        return x.half().to(device)
    calibration = dataset(1, 64)
    tuning, evaluation, shifted = dataset(2, 32), dataset(3, 31), dataset(4, 31, 3)
    w = torch.randn(32, 64).half() * 0.15
    w[0].zero_()  # 零权重行也是原生后端的验收项目。

    def make(threshold):
        m = bnb.nn.Linear8bitLt(64, 32, bias=False, has_fp16_weights=False, threshold=threshold)
        m.load_state_dict({"weight": w.clone()})
        # eval必要：当前CPU train分派会走MatMul8bitFp，与本课路径不同。
        return m.to(device).eval()
    w_device = w.to(device)  # 权重传输在所有计时外，FP16对照不额外计入H2D。
    reference = lambda x: x.float() @ w_device.float().t()
    models = {t: make(t) for t in [0.0, 3.0, 6.0]}
    with torch.inference_mode():
        scores = {t: metrics(m(tuning), reference(tuning))["nrmse"] for t, m in models.items()}
        selected = min(scores, key=scores.get)
        m = models[selected]
        report = {"python": platform.python_version(), "torch": torch.__version__,
                  "bitsandbytes": bnb.__version__, "device": str(device),
                  "source_commit": "833649043474794b8fe7a4136e0c40faf077b2e0",
                  "tune_scores": scores, "selected_threshold": selected,
                  "calibration_outlier_column_counts": {t: int((calibration.abs() >= t).any(dim=0).sum()) for t in [3, 6]},
                  "training_steps": 0, "results": {}}
        for name, x in [("eval", evaluation), ("shift", shifted)]:
            ref = reference(x)
            report["results"][name] = {str(t): metrics(layer(x), ref) for t, layer in models.items()}
            report["results"][name]["fp16"] = metrics(x @ w_device.t(), ref)
        # 保存原生INT8权重、SCB与布局标记；容器字节和张量payload分别计量。
        state = {k: v.detach().cpu() for k, v in m.state_dict().items()}
        assert state["weight"].dtype == torch.int8 and "SCB" in state
        checkpoint = out / "native_state.pt"
        torch.save(state, checkpoint)
        restored = make(selected)  # 先初始化量化buffer再加载SCB，遵循已读load路径。
        restored.load_state_dict(torch.load(checkpoint, map_location=device, weights_only=True))
        torch.testing.assert_close(restored(evaluation), m(evaluation), rtol=0, atol=0)
        report["storage"] = {"tensor_payload_bytes": sum(v.numel() * v.element_size() for v in state.values()),
                             "serialized_file_bytes": checkpoint.stat().st_size,
                             "fp16_weight_payload_bytes": w.numel() * 2,
                             "state_fields": {k: [list(v.shape), str(v.dtype)] for k, v in state.items()}}
        for x in [torch.zeros(1, 64, dtype=torch.float16, device=device), evaluation[:1], evaluation[:0]]:
            y = m(x)
            assert y.shape == (x.shape[0], 32) and bool(torch.isfinite(y).all())
        try:
            m(torch.zeros(1, 63, dtype=torch.float16, device=device))
        except (RuntimeError, ValueError, AssertionError):
            report["bad_shape_rejected"] = True
        else:
            raise AssertionError("bad shape accepted")
        def sync():
            if device.type == "cuda": torch.cuda.synchronize()
        def bench(call):
            for _ in range(5): call()
            sync()
            samples = []
            for _ in range(11):
                sync(); begin = time.perf_counter()
                for _ in range(20): call()
                sync(); samples.append((time.perf_counter() - begin) * 1e6 / 20)
            return statistics.median(samples)
        report["framework_sync_batch_mean_p50_us"] = {
            "fp16": bench(lambda: evaluation @ w_device.t()),
            "int8_no_outlier": bench(lambda: models[0.0](evaluation)),
            "selected": bench(lambda: m(evaluation))}
        print(json.dumps(report, ensure_ascii=False, indent=2))
        (out / "report.json").write_text(json.dumps(report, indent=2) + "\n")

if __name__ == "__main__":
    main()
