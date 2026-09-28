#!/usr/bin/env python3
"""调用固定版本 OmniQuant LWC；浮点 QDQ 及 checkpoint，不宣称 packed INT4。"""
import argparse
import copy
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import time

COMMIT = 'feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', required=True)
    parser.add_argument('--out', required=True)
    args = parser.parse_args()
    root = Path(args.source).resolve()
    missing = [name for name in ('torch', 'numpy', 'tqdm')
               if importlib.util.find_spec(name) is None]
    errors = []
    if sys.version_info < (3, 10):
        errors.append('requires Python >=3.10; current=' + sys.version.split()[0])
    if missing:
        errors.append('missing dependencies: ' + ', '.join(missing))
    if not (root / 'quantize/int_linear.py').is_file():
        errors.append('missing source checkout: ' + str(root))
    else:
        rev = subprocess.check_output(['git', '-C', str(root), 'rev-parse', 'HEAD'], text=True).strip()
        dirty = subprocess.check_output(['git', '-C', str(root), 'status', '--porcelain', '--untracked-files=no'], text=True)
        if rev != COMMIT or dirty:
            errors.append('source must be clean at ' + COMMIT)
    if errors:
        print('\n'.join(errors), file=sys.stderr)
        return 2
    sys.path.insert(0, str(root))
    import torch
    import torch.nn.functional as F
    from quantize.int_linear import QuantLinear
    from quantize.quantizer import UniformAffineQuantizer

    torch.manual_seed(928)
    torch.set_num_threads(1)
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    # 输入和权重固定；校准优化、调参、最终评估分别用不同随机样本。
    layer = torch.nn.Linear(32, 8, bias=False).float().requires_grad_(False)
    with torch.no_grad():
        layer.weight[:, 0] *= 7
        layer.weight[:, 7] *= 3
    calibration = torch.randn(128, 32)
    tuning = torch.randn(64, 32)
    evaluation = torch.randn(64, 32)
    shifted = evaluation.clone()
    shifted[:, 0] *= 4
    params = dict(n_bits=4, symmetric=False, dynamic_method='per_channel', group_size=16, lwc=True)
    module = QuantLinear(copy.deepcopy(layer), weight_quant_params=params,
                         act_quant_params=dict(n_bits=16), disable_input_quant=True)
    module.set_quant_state(weight_quant=True, act_quant=False)
    quantizer = module.weight_quantizer
    initial = copy.deepcopy(quantizer.state_dict())
    target = F.linear(calibration, layer.weight).detach()
    best_loss = float('inf')
    best = None
    trace = []
    # 真正更新原生 upbound_factor / lowbound_factor；冻结原始模型参数。
    start = time.perf_counter()
    for lr in (0.01, 0.05):
        quantizer.load_state_dict(initial)
        optimizer = torch.optim.AdamW(quantizer.parameters(), lr=lr, weight_decay=0)
        before = torch.cat([p.detach().flatten().clone() for p in quantizer.parameters()])
        for step in range(80):
            optimizer.zero_grad(set_to_none=True)
            loss = F.mse_loss(module(calibration), target)
            if not torch.isfinite(loss):
                raise RuntimeError('nonfinite calibration loss')
            loss.backward()
            optimizer.step()
            if step in (0, 19, 39, 79):
                trace.append(dict(lr=lr, step=step, calibration_mse=loss.item()))
        after = torch.cat([p.detach().flatten() for p in quantizer.parameters()])
        delta = (before - after).abs().max().item()
        if delta <= 0:
            raise RuntimeError('no actual clipping parameter update')
        with torch.no_grad():
            tune_loss = F.mse_loss(module(tuning), F.linear(tuning, layer.weight)).item()
        trace.append(dict(lr=lr, tuning_mse=tune_loss, max_parameter_update=delta))
        if tune_loss < best_loss:
            best_loss, best = tune_loss, copy.deepcopy(quantizer.state_dict())
    calibration_seconds = time.perf_counter() - start
    quantizer.load_state_dict(best)
    with torch.no_grad():
        dq = quantizer(layer.weight).detach()
        scale = quantizer.scale.detach().clone()
        zero = quantizer.round_zero_point.detach().clone()
        rtn = UniformAffineQuantizer(n_bits=4, symmetric=False, dynamic_method='per_channel',
                                     group_size=16, shape=layer.weight.shape)(layer.weight)
        blocks = layer.weight.reshape(-1, 16)
        abs_scale = (blocks.abs().amax(-1, keepdim=True) / 7).clamp(min=1e-5)
        absmax = ((blocks / abs_scale).round().clamp(-7, 7) * abs_scale).reshape_as(layer.weight)
        zero_result = quantizer(torch.zeros_like(layer.weight))
        if not torch.equal(zero_result, torch.zeros_like(zero_result)):
            raise RuntimeError('zero boundary failed')
        # 恢复真实权重对应的量化统计；零值检查不污染导出。
        dq = quantizer(layer.weight).detach()
    # 导出实际 FP32 重建张量，可直接接入既有 Linear；这不是压缩后端格式。
    checkpoint = dict(weight=dq, scale=scale, zero=zero, clipping=best,
                      format='FP32 reconstructed QDQ; not packed INT4', commit=COMMIT)
    path = out / 'reconstructed.pt'
    torch.save(checkpoint, path)
    loaded = torch.load(path, map_location='cpu', weights_only=True)
    restored = torch.nn.Linear(32, 8, bias=False).requires_grad_(False)
    with torch.no_grad():
        restored.weight.copy_(loaded['weight'])
    if not torch.equal(restored(evaluation), F.linear(evaluation, dq)):
        raise RuntimeError('reload mismatch')

    def metrics(actual, reference):
        error = actual - reference
        cosine = F.cosine_similarity(actual.flatten(), reference.flatten(), dim=0).item()
        return dict(nrmse=(error.norm() / reference.norm().clamp(min=1e-12)).item(),
                    max_abs=error.abs().max().item(), cosine=cosine)

    def timing(call):
        with torch.no_grad():
            for _ in range(10):
                call()
            samples = []
            for _ in range(50):
                begin = time.perf_counter_ns()
                call()
                samples.append((time.perf_counter_ns() - begin) / 1000)
        samples.sort()
        return dict(p50_us=samples[24], p95_us=samples[47], scope='CPU PyTorch host wall time')

    comparisons = {}
    with torch.no_grad():
        for name, x in [('heldout', evaluation), ('shifted', shifted)]:
            reference = F.linear(x, layer.weight)
            comparisons[name] = {
                'fp16_storage_fp32_accum': metrics(F.linear(x.half().float(), layer.weight.half().float()), reference),
                'absmax': metrics(F.linear(x, absmax), reference),
                'native_rtn': metrics(F.linear(x, rtn), reference),
                'native_lwc': metrics(restored(x), reference)}
    raw_codes = (blocks / scale).round() + zero
    saturated = ((raw_codes < 0) | (raw_codes > 15)).float().mean().item()
    result = dict(torch_version=torch.__version__, commit=COMMIT, shape=[64, 32, 8],
                  dtype='FP32, separate FP16 storage round-trip reference', comparisons=comparisons,
                  calibration_seconds=calibration_seconds, training_trace=trace,
                  clipped_code_fraction=saturated,
                  storage=dict(fp32_weights_bytes=layer.weight.numel()*4, fp16_weights_bytes=layer.weight.numel()*2,
                               actual_qdq_weight_bytes=dq.numel()*dq.element_size(),
                               scale_zero_bytes=(scale.numel()+zero.numel())*4,
                               actual_checkpoint_file_bytes=path.stat().st_size, packed_int4_delivered=False),
                  timings=dict(fp32=timing(lambda: layer(evaluation)),
                               qdq_reconstructed=timing(lambda: restored(evaluation)),
                               native_dynamic_qdq=timing(lambda: module(evaluation))),
                  zero_boundary=True, reload_equal=True, thor_verified=False)
    (out / 'comparison.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
    return 0


if __name__ == '__main__':
    sys.exit(main())
