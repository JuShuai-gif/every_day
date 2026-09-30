"""原生bitsandbytes 0.48.1用法；无下载/安装；只允许CPU或Thor SM110。"""
import argparse
import json
from pathlib import Path
import time
import torch
import bitsandbytes as bnb


def error(got, ref):
    got, ref = got.float(), ref.float()
    delta = got - ref
    return {"nrmse": float(delta.norm() / ref.norm().clamp_min(1e-12)),
            "max_abs": float(delta.abs().max()),
            "cosine": float(torch.nn.functional.cosine_similarity(got.flatten(), ref.flatten(), dim=0))}


def sync(device):
    if device == "cuda":
        torch.cuda.synchronize()


def timed(fn, device):
    for _ in range(20):
        fn()
    sync(device)
    values = []
    for _ in range(101):
        sync(device)
        t = time.perf_counter()
        fn()
        sync(device)
        values.append((time.perf_counter() - t) * 1e6)
    values.sort()
    return {"host_synchronized_forward_us_p50": values[50], "p95": values[95]}


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--device", choices=["cpu", "cuda"], default="cpu")
    args = p.parse_args()
    if bnb.__version__ != "0.48.1":
        raise RuntimeError("This example is source-reviewed for bitsandbytes 0.48.1")
    if args.device == "cuda" and torch.cuda.get_device_capability() != (11, 0):
        raise RuntimeError("Only Thor SM110 is authorized")
    torch.manual_seed(30)
    torch.set_num_threads(1)
    # 权重固定，无训练。校准只观察；调参集选threshold，评估集不参与选择。
    weight = torch.randn(32, 64) * 0.2
    def samples(seed, scale=12.0):
        g = torch.Generator().manual_seed(seed)
        x = torch.randn(16, 64, generator=g) * 0.4
        x[:, 3] *= scale
        return x.to(args.device, torch.float16)
    calibration, tuning, evaluation = samples(101), samples(202), samples(303)
    reference = torch.nn.Linear(64, 32, bias=False).to(args.device, torch.float32)
    reference.weight.data.copy_(weight.to(args.device))
    fp16 = torch.nn.Linear(64, 32, bias=False).to(args.device, torch.float16)
    fp16.weight.data.copy_(weight.to(args.device, torch.float16))
    def layer(threshold):
        # 替换既有model.proj的位置；加载原权重后.to(device)量化，再eval。
        q = bnb.nn.Linear8bitLt(64, 32, bias=False, has_fp16_weights=False, threshold=threshold)
        q.load_state_dict({"weight": weight.half()})
        return q.to(args.device).eval()
    with torch.no_grad():
        candidates = {v: layer(v) for v in [0.0, 3.0, 6.0, 10.0]}
        tune_ref = reference(tuning.float())
        tuning_errors = {v: error(q(tuning), tune_ref)["nrmse"] for v, q in candidates.items()}
        best = min([3.0, 6.0, 10.0], key=lambda v: tuning_errors[v])
        q = candidates[best]
        ref = reference(evaluation.float())
        report = {"versions": {"torch": torch.__version__, "bnb": bnb.__version__, "cuda": torch.version.cuda},
                  "device": args.device, "shape": {"A": [16,64], "W": [32,64]},
                  "calibration_absmax": float(calibration.abs().max()),
                  "tuning_nrmse": tuning_errors, "frozen_threshold": best,
                  "fp16": error(fp16(evaluation), ref),
                  "absmax_threshold0": error(candidates[0.0](evaluation), ref),
                  "llm_int8": error(q(evaluation), ref)}
        state = q.state_dict()
        if state["weight"].dtype != torch.int8 or "SCB" not in state:
            raise RuntimeError("Expected real INT8 weight and FP32 row scales")
        report["tensor_payload_bytes"] = {k: v.numel() * v.element_size() for k, v in state.items()}
        report["fp32_weight_bytes"] = weight.numel() * 4
        report["fp16_weight_bytes"] = weight.numel() * 2
        # 使用上游state_dict格式；目标层先量化初始化SCB，之后加载量化检查点。
        out = Path("build")
        out.mkdir(exist_ok=True)
        torch.save(state, out / "linear-int8.pt")
        restored = layer(best)
        restored.load_state_dict(torch.load(out / "linear-int8.pt", map_location=args.device, weights_only=True))
        torch.testing.assert_close(restored(evaluation), q(evaluation), rtol=0, atol=0)
        report["serialized_file_bytes"] = (out / "linear-int8.pt").stat().st_size
        report["forward_timing"] = {"fp16": timed(lambda: fp16(evaluation), args.device),
                                    "threshold0": timed(lambda: candidates[0.0](evaluation), args.device),
                                    "mixed": timed(lambda: q(evaluation), args.device)}
        for name, x in [("zero", torch.zeros_like(evaluation)), ("shifted", samples(404, 30)),
                        ("one_row", evaluation[:1]), ("empty", evaluation[:0])]:
            y = q(x)
            if y.shape != (x.shape[0], 32) or not torch.isfinite(y).all():
                raise RuntimeError("boundary failure: " + name)
            report[name] = error(y, reference(x.float())) if x.numel() else {"shape": list(y.shape)}
        ca, sca, cols = bnb.functional.int8_vectorwise_quant(evaluation.clone(), threshold=best)
        report["activation_payload_bytes"] = ca.numel() * ca.element_size() + sca.numel() * sca.element_size()
        report["outlier_columns"] = [] if cols is None else cols.cpu().tolist()
        report["outlier_index_bytes"] = 0 if cols is None else cols.numel() * cols.element_size()
        report["code_at_rail_fraction"] = float((ca.abs() == 127).float().mean())
        report["scope"] = "Native API; synchronized framework forward, not isolated kernel or request E2E; no QAT updates"
        print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
