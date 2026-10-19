"""原生 SmoothQuant API；独立导出格式与评估编排，不是原生 INT8 kernel。"""
import copy
import json
import math
import struct
import time
from pathlib import Path

import torch
from torch import nn
from smoothquant.smooth import smooth_ln_fcs
from smoothquant.fake_quant import W8A8Linear


def metrics(ref, pred):
    diff = (pred - ref).float()
    return {"nrmse": float(diff.norm() / ref.norm().clamp(min=1e-12)),
            "max_abs": float(diff.abs().max()),
            "cosine": float(torch.nn.functional.cosine_similarity(ref.flatten(), pred.flatten(), dim=0))}


def output(ln, fcs, x):
    a = ln(x)
    # 上游act_quant原地修改输入；fan-out的每个消费者必须获得自己的副本。
    return torch.cat([fc(a.clone()) for fc in fcs], dim=-1)


def prepare(ln, fcs, scales, alpha):
    ln, fcs = copy.deepcopy(ln), copy.deepcopy(fcs)
    if scales.shape != (ln.weight.numel(),) or not torch.isfinite(scales).all():
        raise ValueError("invalid calibration scales")
    if alpha is not None:
        smooth_ln_fcs(ln, fcs, scales, alpha=alpha)
    weights = [fc.weight.detach().clone() for fc in fcs]
    # from_float会原地量化传入Linear权重，因此只能在副本上调用。
    quant = [W8A8Linear.from_float(fc, weight_quant="per_channel", act_quant="per_token", quantize_output=False) for fc in fcs]
    return ln, quant, weights


def export_reload(path, ln, quant, weights):
    k = ln.weight.numel()
    data = bytearray(struct.pack("<4sII", b"SQ81", k, len(quant)))
    def floats(t):
        v = t.detach().flatten().float().tolist()
        return struct.pack("<" + "f" * len(v), *v)
    data.extend(floats(ln.weight)); data.extend(floats(ln.bias))
    saturated = total = 0
    for fc, w in zip(quant, weights):
        scales = w.abs().amax(dim=1, keepdim=True).clamp(min=1e-5) / 127
        q = (w / scales).round().clamp(-127, 127).to(torch.int8)
        saturated += int((q.abs() == 127).sum()); total += q.numel()
        data.extend(struct.pack("<I", w.shape[0]))
        data.extend(bytes(v & 255 for v in q.flatten().tolist()))
        data.extend(floats(scales)); data.extend(floats(fc.bias))
    path.write_bytes(data)
    raw = path.read_bytes(); magic, rk, count = struct.unpack_from("<4sII", raw); offset = 12
    assert magic == b"SQ81" and rk == k and count == len(quant)
    def readfloats(n):
        nonlocal offset
        out = torch.tensor(struct.unpack_from("<" + "f" * n, raw, offset)); offset += n * 4
        return out
    restored_ln = nn.LayerNorm(k)
    with torch.no_grad():
        restored_ln.weight.copy_(readfloats(k)); restored_ln.bias.copy_(readfloats(k))
    restored = []
    for fc in quant:
        n, = struct.unpack_from("<I", raw, offset); offset += 4
        q = torch.tensor([v if v < 128 else v - 256 for v in raw[offset:offset+n*k]], dtype=torch.int8).reshape(n, k); offset += n*k
        scales = readfloats(n).reshape(n, 1); bias = readfloats(n)
        # 从真实i8存储还原浮点权重，保留上游per-token激活QDQ；不是整数GEMM。
        layer = copy.deepcopy(fc); layer.weight.copy_(q.float() * scales); layer.bias.copy_(bias)
        restored.append(layer)
    assert offset == len(raw)
    return restored_ln, restored, {"actual_file_bytes": len(raw), "weight_i8_bytes": sum(w.numel() for w in weights),
                                  "weight_endpoint_fraction": saturated / max(total, 1)}


def timing(fn):
    for _ in range(3): fn()
    values = []
    for _ in range(11):
        start = time.perf_counter()
        for _ in range(20): fn()
        values.append((time.perf_counter()-start) * 1e6 / 20)
    return sorted(values)[5]


def main():
    torch.manual_seed(19); torch.set_num_threads(1)
    ln = nn.LayerNorm(32).eval(); fcs = [nn.Linear(32, 24).eval(), nn.Linear(32, 16).eval()]
    with torch.no_grad(): ln.weight[0] = 32
    # PTQ无训练分区；校准64、调参32、评估31及漂移31互不重用。
    cal, tune, test, shifted = [torch.randn(n, 32) for n in (64, 32, 31, 31)]
    shifted[:, 7] *= 12
    folder = Path(__file__).resolve().parent / "build"; folder.mkdir(exist_ok=True)
    with torch.inference_mode():
        scales = ln(cal).abs().amax(dim=0)
        ref_tune = output(ln, fcs, tune)
        t0 = time.perf_counter()
        choices = []
        for alpha in (0.0, 0.5, 0.8, 1.0):
            sln, sfcs = copy.deepcopy(ln), copy.deepcopy(fcs)
            smooth_ln_fcs(sln, sfcs, scales, alpha=alpha)
            torch.testing.assert_close(output(sln, sfcs, tune), ref_tune, rtol=2e-5, atol=2e-5)
            qln, qfcs, ws = prepare(ln, fcs, scales, alpha)
            choices.append((metrics(ref_tune, output(qln, qfcs, tune))["nrmse"], alpha))
        alpha = min(choices)[1]; search_ms = (time.perf_counter()-t0)*1000
        baseline = prepare(ln, fcs, scales, None); selected = prepare(ln, fcs, scales, alpha)
        rln, rfcs, storage = export_reload(folder/"weights.bin", *selected)
        result = {"torch": torch.__version__, "device": "cpu", "selected_alpha": alpha, "tune_scores": choices,
                  "alpha_search_ms": search_ms, "training_steps": 0, "storage": storage,
                  "reference_fp32_payload_bytes": (sum(p.numel() for p in ln.parameters()) + sum(p.numel() for fc in fcs for p in fc.parameters()))*4}
        result["reference_fp16_payload_bytes"] = result["reference_fp32_payload_bytes"] // 2
        half_ln, half_fcs = copy.deepcopy(ln).half(), [copy.deepcopy(fc).half() for fc in fcs]
        for label, x in [("eval",test),("shift",shifted),("zero",torch.zeros(1,32))]:
            ref = output(ln, fcs, x)
            a = selected[0](x)
            aq = (a / (a.abs().amax(dim=-1, keepdim=True).clamp(min=1e-5) / 127)).round()
            activation_endpoint_fraction = float((aq.abs() == 127).float().mean())
            y = output(selected[0], selected[1], x)
            yr = output(rln, rfcs, x)
            torch.testing.assert_close(yr, y, rtol=2e-5, atol=2e-5)
            result[label] = {"activation_endpoint_fraction": activation_endpoint_fraction, "absmax": metrics(ref,output(baseline[0],baseline[1],x)), "smooth": metrics(ref,y),
                             "fp16": metrics(ref,output(half_ln,half_fcs,x.half()).float())}
        rejected = False
        try: prepare(ln,fcs,scales[:-1],alpha)
        except ValueError: rejected = True
        assert rejected
        result["cpu_framework_batch_mean_p50_us"] = {"fp32": timing(lambda:output(ln,fcs,test)),
           "absmax_qdq":timing(lambda:output(baseline[0],baseline[1],test)),
           "smooth_qdq":timing(lambda:output(selected[0],selected[1],test))}
        result["scope"] = "CPU LayerNorm + input clones + QDQ + FP32 linear; excludes export/calibration; not INT8 kernel or task accuracy"
        print(json.dumps(result,ensure_ascii=False,indent=2))

if __name__ == "__main__": main()
