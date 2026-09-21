#!/usr/bin/env python3
"""调用已读 AIMET commit 的原生 AdaRound，额外使用明确独立的 u4 存储容器。"""
import copy
import hashlib
import importlib.metadata
import importlib.util
import json
import math
import os
from pathlib import Path
import platform
import struct
import subprocess
import sys
import time

from packing import pack_u4, unpack_u4, self_check

COMMIT = '17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b'
BASE = Path(__file__).resolve().parent
OUT = BASE / 'build' / 'native'


def preflight():
    missing = [p for p in ('torch', 'aimet_torch', 'numpy', 'psutil')
               if importlib.util.find_spec(p) is None]
    root = os.environ.get('AIMET_SOURCE_ROOT')
    report = {'python': platform.python_version(), 'required_python': '>=3.10',
              'missing_modules': missing, 'source_root': root, 'expected_commit': COMMIT,
              'execution_device': 'cpu', 'thor_verified': False}
    print(json.dumps(report, indent=2))
    if sys.version_info < (3, 10) or missing or not root:
        raise RuntimeError('需要 Python>=3.10、AIMET/torch 依赖及 AIMET_SOURCE_ROOT；未执行安装')
    root = Path(root).resolve()
    actual = subprocess.check_output(['git', '-C', str(root), 'rev-parse', 'HEAD'], text=True).strip()
    if actual != COMMIT:
        raise RuntimeError('checkout commit differs from the reviewed commit')
    # 已安装包的关键 Python 文件须与固定 checkout 相同，避免混用新版 API。
    import aimet_torch
    package = Path(aimet_torch.__file__).resolve().parent
    for relative in ('adaround/adaround_weight.py', '_base/adaround/adaround_weight.py',
                     '_base/adaround/adaround_optimizer.py', '_base/adaround/adaround_wrapper.py',
                     '_base/adaround/adaround_loss.py'):
        repo_path = 'TrainingExtensions/torch/src/python/aimet_torch/' + relative
        source_bytes = subprocess.check_output(['git', '-C', str(root), 'show', COMMIT + ':' + repo_path])
        installed = package / relative
        if hashlib.sha256(source_bytes).digest() != hashlib.sha256(installed.read_bytes()).digest():
            raise RuntimeError('installed/source mismatch: ' + relative)
    report['installed_versions'] = {p: importlib.metadata.version(p)
                                    for p in ('torch', 'aimet-torch', 'numpy', 'psutil')}
    report['source_commit'] = actual
    return report


def main():
    environment = preflight()
    import numpy as np
    import torch
    from torch import nn
    from torch.utils.data import DataLoader
    from aimet_torch.adaround.adaround_weight import Adaround, AdaroundParameters
    from aimet_torch.common.defs import QuantScheme

    torch.set_num_threads(1)
    torch.manual_seed(2100)
    np.random.seed(2100)
    OUT.mkdir(parents=True, exist_ok=False)  # 已有结果不覆盖，重跑先换整个副本目录。
    self_check()
    (OUT / 'environment.json').write_text(json.dumps(environment, indent=2))
    n, k = 8, 33

    class Head(nn.Module):
        def __init__(self):
            super().__init__()
            self.fc = nn.Linear(k, n, bias=False)

        def forward(self, x):
            return self.fc(x)

    original = Head().eval()
    # 已有 Linear 的接入点：替换 original.fc，保持形状；不要在校准后换权重。
    with torch.no_grad():
        original.fc.weight[0].zero_()  # 零输出通道检验编码退化情形。
        original.fc.weight[:, 0].mul_(5)
    original_weights = original.fc.weight.detach().clone()

    def data(seed, rows, shift=False):
        x = torch.randn(rows, k, generator=torch.Generator().manual_seed(seed))
        x[:, 1] = 0.85 * x[:, 0] + 0.15 * x[:, 1]  # 相关特征让逐权重误差不等价于输出误差。
        if shift:
            x[:, 0] *= 4
        return x

    calibration = data(2101, 256)
    validation = data(2102, 128)
    evaluation = data(2103, 128)
    shifted = data(2104, 128, True)
    loader = DataLoader(calibration, batch_size=32, shuffle=False, num_workers=0)
    dummy = torch.zeros(2, k)

    def metrics(reference, candidate):
        reference, candidate = reference.double().reshape(-1), candidate.double().reshape(-1)
        if not torch.isfinite(candidate).all():
            raise RuntimeError('nonfinite inference output')
        diff = candidate - reference
        norm = torch.linalg.vector_norm(reference)
        denom = norm * torch.linalg.vector_norm(candidate)
        return {'nrmse': float(torch.linalg.vector_norm(diff) / norm.clamp_min(1e-30)),
                'max_abs': float(diff.abs().max()),
                'cosine': float(torch.dot(reference, candidate) / denom) if denom > 0 else None}

    def load_encoding(path):
        enc = json.loads(path.read_text())['param_encodings']['fc.weight']
        if len(enc) not in (1, n):
            raise RuntimeError('example accepts per-tensor or per-output-channel encodings only')
        for item in enc:
            if int(item['bitwidth']) != 4 or not math.isfinite(float(item['scale'])) or float(item['scale']) <= 0:
                raise RuntimeError('invalid u4 affine encoding')
        # 0.6.1 导出约定：q=round(w/scale)-offset，w_hat=(q+offset)*scale。
        scales = torch.tensor([float(e['scale']) for e in enc]).reshape(-1, 1).expand(n, 1)
        offsets = torch.tensor([int(e['offset']) for e in enc]).reshape(-1, 1).expand(n, 1)
        return enc, scales, offsets

    def grid(weights, scales, offsets):
        unbounded = torch.round(weights / scales) - offsets
        saturation = float(((unbounded < 0) | (unbounded > 15)).float().mean())
        q = unbounded.clamp(0, 15).to(torch.int64)
        decoded = (q + offsets) * scales
        return q, decoded, saturation

    candidates = []
    # 仅 validation 选正则；evaluation/shifted 绝不进入优化和参数选择。
    for index, regularizer in enumerate((0.001, 0.01)):
        torch.manual_seed(2200)
        np.random.seed(2200)
        params = AdaroundParameters(loader, num_batches=len(loader), default_num_iterations=500,
                                    default_reg_param=regularizer, default_beta_range=(20, 2),
                                    default_warm_start=0.2, forward_fn=lambda model, x: model(x))
        prefix = 'candidate_' + str(index)
        start = time.perf_counter()
        adjusted = Adaround.apply_adaround(
            copy.deepcopy(original), dummy_input=dummy, params=params, path=str(OUT),
            filename_prefix=prefix, default_param_bw=4,
            default_quant_scheme=QuantScheme.post_training_tf)
        optimization_seconds = time.perf_counter() - start
        enc, scales, offsets = load_encoding(OUT / (prefix + '.encodings'))
        # 上游最后把 soft-rounded 权重折回浮点模型；此处硬化后才作 INT4 对照。
        q, hard, saturation = grid(adjusted.fc.weight.detach(), scales, offsets)
        with torch.no_grad():
            validation_error = metrics(original(validation), nn.functional.linear(validation, hard))
        candidates.append({'model': adjusted, 'encoding': enc, 'scales': scales, 'offsets': offsets,
                           'q': q, 'hard': hard, 'saturation': saturation, 'regularizer': regularizer,
                           'optimization_seconds': optimization_seconds, 'validation': validation_error})
    best = min(candidates, key=lambda item: item['validation']['nrmse'])
    assert torch.equal(original.fc.weight.detach(), original_weights), 'reference weights changed'
    export_start = time.perf_counter()
    codes = best['q'].reshape(-1).tolist()
    payload = pack_u4(codes)
    (OUT / 'weights.u4.bin').write_bytes(payload)
    encoding_bytes = b''.join(struct.pack('<fi', float(e['scale']), int(e['offset']))
                              for e in best['encoding'])
    (OUT / 'affine.bin').write_bytes(encoding_bytes)
    metadata = {'format': 'independent-u4-low-nibble-first', 'shape': [n, k], 'bits': 4,
                'encoding_count': len(best['encoding']), 'record': 'little-endian float32 scale, int32 offset',
                'accumulation': 'decoded CPU float32 F.linear; not integer Tensor Core'}
    (OUT / 'layout.json').write_text(json.dumps(metadata, indent=2))
    export_seconds = time.perf_counter() - export_start
    reload_start = time.perf_counter()
    reloaded_codes = unpack_u4((OUT / 'weights.u4.bin').read_bytes(), n * k)
    assert reloaded_codes == codes
    records = list(struct.iter_unpack('<fi', (OUT / 'affine.bin').read_bytes()))
    reload_scale = torch.tensor([r[0] for r in records]).reshape(-1, 1).expand(n, 1)
    reload_offset = torch.tensor([r[1] for r in records]).reshape(-1, 1).expand(n, 1)
    hard = (torch.tensor(reloaded_codes).reshape(n, k) + reload_offset) * reload_scale
    torch.testing.assert_close(hard, best['hard'], rtol=0, atol=0)
    reload_seconds = time.perf_counter() - reload_start
    deployed = copy.deepcopy(original)
    with torch.no_grad():
        deployed.fc.weight.copy_(hard)  # 本地已存在模型：在此替换同名 Linear 的解码权重。
    torch.save(deployed.state_dict(), OUT / 'decoded_fp32.pt')
    loaded = Head().eval()
    loaded.load_state_dict(torch.load(OUT / 'decoded_fp32.pt', weights_only=True, map_location='cpu'))

    _, rtn, rtn_saturation = grid(original_weights, best['scales'], best['offsets'])
    scale_absmax = original_weights.abs().amax(1, keepdim=True).clamp_min(1e-12) / 7
    absmax_q = torch.round(original_weights / scale_absmax).clamp(-7, 7)
    absmax = absmax_q * scale_absmax
    absmax_payload = pack_u4((absmax_q.to(torch.int64) + 8).reshape(-1).tolist())
    (OUT / 'absmax.u4.bin').write_bytes(absmax_payload)
    (OUT / 'absmax_scale.bin').write_bytes(b''.join(struct.pack('<f', float(v)) for v in scale_absmax.flatten()))

    def benchmark(fn):
        with torch.no_grad():
            for _ in range(10):
                fn()
            durations = []
            for _ in range(50):
                begin = time.perf_counter_ns()
                fn()
                durations.append((time.perf_counter_ns() - begin) / 1000)
        durations.sort()
        return {'p50_us': durations[24], 'p95_us': durations[47], 'warmup': 10, 'samples': 50,
                'scope': 'CPU decoded F.linear, excludes optimization/packing/loading, no GPU/NPU'}

    comparisons = {}
    with torch.no_grad():
        for name, x in (('evaluation', evaluation), ('shifted', shifted), ('zero_input', torch.zeros(2, k))):
            reference = original(x)
            comparisons[name] = {label: metrics(reference, nn.functional.linear(x, w))
                                 for label, w in (('absmax_symmetric_u4', absmax), ('same_grid_rtn', rtn),
                                                  ('adaround_hard_decoded', hard))}
            half_model = copy.deepcopy(original).half()
            comparisons[name]['fp16_inputs_weights_output'] = metrics(reference, half_model(x.half()).float())
        torch.testing.assert_close(loaded(evaluation), deployed(evaluation), rtol=0, atol=0)
    report = {'method': 'native AIMET AdaRound', 'commit': COMMIT, 'device': 'cpu',
              'train_partition': 'no supervised weight training; alpha optimized on calibration seed2101',
              'validation_seed': 2102, 'evaluation_seed': 2103, 'shift_seed': 2104,
              'candidates': [{key: item[key] for key in ('regularizer', 'optimization_seconds', 'validation')}
                             for item in candidates],
              'selected_regularizer': best['regularizer'], 'comparisons': comparisons,
              'hard_rounding_changed_vs_same_grid_rtn': int((hard != rtn).sum()),
              'saturation': {'adaround_hard': best['saturation'], 'same_grid_rtn': rtn_saturation},
              'storage_bytes': {'fp32_weight_tensor': original_weights.numel() * original_weights.element_size(),
                                'fp16_weight_tensor': original_weights.numel() * 2,
                                'u4_payload': len(payload), 'affine_binary': len(encoding_bytes),
                                'layout_json': (OUT / 'layout.json').stat().st_size,
                                'decoded_fp32_checkpoint_file': (OUT / 'decoded_fp32.pt').stat().st_size,
                                'absmax_u4_payload': len(absmax_payload), 'absmax_scales': n * 4},
              'offline_export_including_file_io_seconds': export_seconds,
              'reload_decode_including_file_io_seconds': reload_seconds,
              'timing': {'fp32': benchmark(lambda: original(evaluation)),
                         'adaround_decoded_fp32': benchmark(lambda: deployed(evaluation))},
              'thor_verified': False, 'native_lowbit_kernel': False}
    (OUT / 'comparison.json').write_text(json.dumps(report, indent=2, allow_nan=False))
    print(json.dumps(report, indent=2, allow_nan=False))


if __name__ == '__main__':
    try:
        main()
    except (RuntimeError, ImportError, OSError, ValueError) as error:
        print('BLOCKED:', error, file=sys.stderr)
        sys.exit(2)
