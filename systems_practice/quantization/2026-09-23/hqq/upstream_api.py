#!/usr/bin/env python3
"""调用固定HQQ源码；用PyTorch评估算法、原生压缩状态和CPU框架耗时。"""
import copy
import datetime
import importlib.util
import json
import os
from pathlib import Path
import platform
import subprocess
import sys
import time

BASE = Path(__file__).resolve().parent
COMMIT = 'd88a488ec8aa2d58362ef2038a52bca862db2e74'


def preflight():
    errors = []
    repo = Path(os.environ.get('HQQ_SOURCE', str(BASE / 'build/missing-checkout'))).resolve()
    if sys.version_info < (3, 10):
        errors.append('Example environment requires Python >=3.10; actual=' + platform.python_version())
    for name in ('torch', 'numpy', 'termcolor'):
        if importlib.util.find_spec(name) is None:
            errors.append('missing package: ' + name)
    if not (repo / '.git').exists():
        errors.append('missing pinned checkout; set HQQ_SOURCE')
    else:
        head = subprocess.check_output(['git', '-C', str(repo), 'rev-parse', 'HEAD'], text=True).strip()
        if head != COMMIT:
            errors.append('checkout must be ' + COMMIT + '; actual=' + head)
        for rel in ('hqq/core/quantize.py', 'hqq/core/optimize.py', 'hqq/core/bitpack.py', 'hqq/core/utils.py'):
            path = repo / rel
            expected = subprocess.check_output(['git', '-C', str(repo), 'show', COMMIT + ':' + rel])
            if not path.exists() or path.read_bytes() != expected:
                errors.append('missing or modified checkout source: ' + rel)
    if errors:
        print(json.dumps({'status': 'blocked', 'errors': errors}, ensure_ascii=False, indent=2))
        return None
    sys.path.insert(0, str(repo))
    return repo


def main():
    repo = preflight()
    if repo is None:
        return 2
    import torch
    import torch.nn.functional as F
    from hqq.core.quantize import HQQLinear, HQQBackend, BaseQuantizeConfig
    import hqq.core.quantize as implementation
    if Path(implementation.__file__).resolve() != repo / 'hqq/core/quantize.py':
        raise RuntimeError('Imported HQQ does not match pinned checkout')
    torch.set_num_threads(1)
    HQQLinear.set_backend(HQQBackend.PYTORCH_FORWARD)
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    result_dir = BASE / 'results' / ('run-' + stamp)
    result_dir.mkdir(parents=True, exist_ok=False)
    artifact_dir = BASE / 'build' / stamp
    artifact_dir.mkdir(parents=True, exist_ok=False)

    def rand(shape, seed):
        return torch.randn(shape, generator=torch.Generator().manual_seed(seed))

    def metrics(ref, value):
        ref, value = ref.float(), value.float()
        if not torch.isfinite(value).all():
            raise RuntimeError('non-finite output')
        delta = value - ref
        nr = torch.linalg.vector_norm(ref)
        nv = torch.linalg.vector_norm(value)
        return {'nrmse': float(torch.linalg.vector_norm(delta) / nr.clamp_min(1e-12)),
                'max_abs': float(delta.abs().max()),
                'cosine': float((ref * value).sum() / (nr * nv).clamp_min(1e-12)) if nr > 0 and nv > 0 else None}

    def timing(fn):
        with torch.inference_mode():
            for _ in range(10):
                fn()
            samples = []
            for _ in range(50):
                start = time.perf_counter_ns()
                output = fn()
                samples.append((time.perf_counter_ns() - start) / 1000)
            if not torch.isfinite(output).all():
                raise RuntimeError('timed result non-finite')
        samples.sort()
        return {'p50_us': samples[24], 'p95_us': samples[47], 'samples_us': samples,
                'boundary': 'synchronous CPU PyTorch call, 1 thread; includes dequantization for HQQ; excludes save/load, quantization and input creation'}

    comparisons = []
    with torch.inference_mode():
        # HQQ不需要激活校准集；不把评估输入偷偷用于调scale或挑group_size。
        for case in ('normal', 'outlier', 'zero'):
            w = rand((16, 64), 701) * 0.2
            if case == 'outlier':
                w[:, 3] *= 25
            if case == 'zero':
                w.zero_()
            layer = torch.nn.Linear(64, 16, bias=False)
            layer.weight.copy_(w)
            cfg = BaseQuantizeConfig(nbits=4, group_size=16, axis=1,
                                     quant_zero=False, quant_scale=False, offload_meta=False)
            start = time.perf_counter_ns()
            quant = HQQLinear(copy.deepcopy(layer), cfg, compute_dtype=torch.float32,
                              device='cpu', del_orig=True)
            quant_us = (time.perf_counter_ns() - start) / 1000
            rtn_cfg = copy.deepcopy(cfg)
            rtn_cfg['weight_quant_params']['optimize'] = False
            rtn = HQQLinear(copy.deepcopy(layer), rtn_cfg, compute_dtype=torch.float32,
                            device='cpu', del_orig=True)
            wr = quant.dequantize()
            codes = quant.unpack(dtype=torch.uint8)
            if tuple(wr.shape) != (16, 64) or codes.min() < 0 or codes.max() > 15:
                raise RuntimeError('shape/code range invalid')
            if quant.W_q.dtype != torch.uint8 or quant.W_q.numel() != w.numel() // 2:
                raise RuntimeError('not a real packed INT4 payload')

            # 序列化上游state_dict，重建HQQLinear；模型二进制仅写忽略的build。
            state = {k: v.detach().cpu().clone() if torch.is_tensor(v) else v
                     for k, v in quant.state_dict().items()}
            payload = artifact_dir / (case + '.pt')
            torch.save(state, payload)
            recovered = HQQLinear(None, cfg, compute_dtype=torch.float32,
                                  device='cpu', initialize=False)
            recovered.load_state_dict(torch.load(payload, map_location='cpu', weights_only=True))
            tensors = {k: v.numel() * v.element_size() for k, v in state.items() if torch.is_tensor(v)}
            # 独立absmax参考与HQQ-RTN/HQQ保持相同16元素分组。
            grouped = w.reshape(-1, 16)
            scale = grouped.abs().amax(dim=1, keepdim=True) / 7
            scale = torch.where(scale == 0, torch.ones_like(scale), scale)
            wa = (grouped / scale).round().clamp(-7, 7).mul(scale).reshape_as(w)
            entry = {'case': case, 'quantize_cpu_us': quant_us,
                     'weight_error': metrics(w, wr), 'packed_weight_bytes': quant.W_q.numel() * quant.W_q.element_size(),
                     'state_tensor_bytes': tensors, 'state_tensor_total_bytes': sum(tensors.values()),
                     'checkpoint_file_bytes': payload.stat().st_size, 'fp32_weight_bytes': w.numel() * 4,
                     'fp16_weight_bytes': w.numel() * 2,
                     'code_endpoint_fraction_not_clipping_rate': float(((codes == 0) | (codes == 15)).float().mean()),
                     'evaluations': {}}
            for split, seed, shift in [('heldout', 1701, 1.0), ('shifted', 2701, 4.0), ('zero_input', 3701, 0.0)]:
                x = rand((8, 64), seed) * shift
                ref = F.linear(x, w)
                actual = quant(x)
                torch.testing.assert_close(actual, recovered(x), rtol=0, atol=0)
                torch.testing.assert_close(actual, F.linear(x, wr), rtol=1e-5, atol=1e-6)
                # 模型替换入口：现有Sequential/MLP中的一个Linear直接替换成quant。
                model = torch.nn.Sequential(recovered)
                torch.testing.assert_close(model(x), actual, rtol=0, atol=0)
                entry['evaluations'][split] = {
                    'fp16_reference': metrics(ref, F.linear(x.half(), w.half()).float()),
                    'absmax_qdq': metrics(ref, F.linear(x, wa)),
                    'upstream_rtn': metrics(ref, rtn(x)), 'hqq': metrics(ref, actual),
                    'hqq_w4a16_reconstructed_reference': metrics(ref, F.linear(x.half(), wr.half()).float())}
            x = rand((8, 64), 1701)
            entry['timing'] = {'fp32': timing(lambda: layer(x)),
                               'fp16': timing(lambda: F.linear(x.half(), w.half())),
                               'rtn': timing(lambda: rtn(x)), 'hqq': timing(lambda: quant(x))}
            # FP16计时明确包含cast；另给预转换的公平算子边界。
            xh, wh = x.half(), w.half()
            entry['timing']['fp16_preconverted'] = timing(lambda: F.linear(xh, wh))
            comparisons.append(entry)
        # 上游分组要求无法整除时应失败；无静默padding掩盖错误。
        bad = torch.nn.Linear(63, 15, bias=False)
        try:
            HQQLinear(bad, cfg, compute_dtype=torch.float32, device='cpu')
        except AssertionError:
            invalid_rejected = True
        else:
            raise RuntimeError('Expected invalid group shape rejection')
    report = {'commit': COMMIT, 'torch': torch.__version__, 'python': platform.python_version(),
              'platform': platform.platform(), 'source': str(repo), 'device': 'cpu',
              'native_compute_dtype': 'FP32 (W4A32 dequantize+matmul)',
              'hqq_training_updates': False, 'activation_calibration': 'not used by this method',
              'tuning': 'fixed a priori, no eval-based selection', 'invalid_shape_rejected': invalid_rejected,
              'thor_verified': False, 'comparisons': comparisons}
    (result_dir / 'comparison.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0


if __name__ == '__main__':
    sys.exit(main())
