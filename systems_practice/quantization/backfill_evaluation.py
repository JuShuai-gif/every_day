"""补课共用小张量验收；不是任何原仓库的量化算法。"""
import argparse
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import time


def setup(method):
    parser = argparse.ArgumentParser()
    parser.add_argument('--source', required=True)
    parser.add_argument('--out', default='build/native')
    args = parser.parse_args()
    args.source = Path(args.source).resolve()
    args.out = Path(args.out)
    args.out.mkdir(parents=True, exist_ok=True)
    missing = [x for x in ['torch'] if importlib.util.find_spec(x) is None]
    if not args.source.is_dir():
        missing.append('upstream checkout')
    report = {'method': method, 'python': sys.version, 'missing': missing,
              'source': str(args.source), 'native_run': False}
    (args.out / 'environment.json').write_text(json.dumps(report, indent=2))
    if missing:
        print(json.dumps(report, indent=2))
        raise SystemExit(2)
    import torch
    torch.manual_seed(20260928)
    torch.set_num_threads(1)
    report['torch'] = torch.__version__
    report['commit'] = subprocess.check_output(
        ['git', '-C', str(args.source), 'rev-parse', 'HEAD'], text=True).strip()
    dirty = subprocess.check_output(
        ['git', '-C', str(args.source), 'status', '--porcelain'], text=True)
    if dirty:
        raise RuntimeError('Use a clean source checkout for reproducibility')
    if method == 'quarot' and report['commit'] != '5008669b08c1f11f9b64d52d16fddd47ca754c5a':
        raise RuntimeError('QuaRot must match the source-read.json commit')
    (args.out / 'environment.json').write_text(json.dumps(report, indent=2))
    weight = torch.randn(16, 32) * .15
    weight[:, 0] *= 12
    sets = [torch.randn(n, 32) for n in [128, 64, 64, 64]]
    sets[-1][:, 0] *= 4
    return args, torch, weight, sets


def qdq(tensor):
    scale = tensor.detach().abs().amax(-1, keepdim=True).clamp_min(1e-8) / 7
    codes = (tensor / scale).round().clamp(-8, 7)
    return codes * scale


def storage(value):
    if isinstance(value, dict):
        return sum(storage(v) for v in value.values())
    if isinstance(value, (list, tuple)):
        return sum(storage(v) for v in value)
    if hasattr(value, 'is_sparse') and value.is_sparse:
        sparse = value.coalesce()
        return storage(sparse.indices()) + storage(sparse.values())
    return value.numel() * value.element_size() if hasattr(value, 'numel') else 0


def evaluate(args, torch, weight, sets, infer, state, extra):
    # 校准/调参集不混入最终 heldout 和 shifted 测量。
    records = {}
    with torch.no_grad():
        for label, x in zip(['heldout', 'shifted'], sets[2:]):
            reference = x @ weight.T
            branches = {
                'fp32': lambda z: z @ weight.T,
                'fp16_storage': lambda z: z.half().float() @ weight.half().float().T,
                'absmax_w4a32': lambda z: z @ qdq(weight).T,
                'absmax_w4a4': lambda z: qdq(z) @ qdq(weight).T,
                'native_method': infer,
            }
            records[label] = {}
            for name, function in branches.items():
                output = function(x)
                assert output.shape == reference.shape and torch.isfinite(output).all()
                error = output - reference
                times = []
                for _ in range(20):
                    function(x)
                for _ in range(100):
                    start = time.perf_counter_ns()
                    function(x)
                    times.append((time.perf_counter_ns() - start) / 1000)
                times.sort()
                records[label][name] = {
                    'mse': float(error.square().mean()),
                    'nrmse': float(error.norm() / reference.norm().clamp_min(1e-12)),
                    'max_abs': float(error.abs().max()),
                    'cosine': float(torch.nn.functional.cosine_similarity(
                        output.reshape(1, -1), reference.reshape(1, -1))),
                    'cpu_framework_us_p50': times[49], 'p95': times[94],
                }
        assert torch.isfinite(infer(torch.zeros(3, 32))).all()
        # 原仓库形状失败也要明确传播，而不是悄悄广播产生错误输出。
        try:
            infer(torch.zeros(3, 31))
        except (RuntimeError, ValueError, AssertionError):
            pass
        else:
            raise AssertionError('Expected a shape mismatch')
    # 只重载本脚本创建的张量字典；字节数含scale、旋转和稀疏索引。
    torch.save(state, args.out / 'state.pt')
    restored = torch.load(args.out / 'state.pt', map_location='cpu', weights_only=True)
    scale = weight.abs().amax(-1, keepdim=True).clamp_min(1e-8) / 7
    rounded = (weight / scale).round()
    report = {
        'results': records, 'state_tensor_bytes': storage(state),
        'checkpoint_file_bytes': (args.out / 'state.pt').stat().st_size(),
        'fp32_weight_bytes': storage(weight), 'fp16_weight_bytes': weight.numel() * 2,
        'fp32_activation_bytes': storage(sets[2]),
        'fp16_activation_bytes': sets[2].numel() * 2,
        'absmax_clipped_fraction': float(((rounded < -8) | (rounded > 7)).float().mean()),
        'absmax_code_endpoint_fraction': float(((rounded == -8) | (rounded == 7)).float().mean()),
        'extra': extra, 'backend': 'CPU FP32 framework; not native low-bit Tensor Core',
        'timing_scope': 'Each callable includes rotation/QDQ/unpack when present; no low-bit kernel speed comparison',
    }
    (args.out / 'comparison.json').write_text(json.dumps(report, indent=2))
    print(json.dumps(report, indent=2))
    return restored
