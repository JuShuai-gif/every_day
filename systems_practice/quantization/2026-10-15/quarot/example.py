"""QuaRot原生Hadamard/量化/打包API；独立单Linear编排，不是完整模型复现。"""
import argparse
import importlib.metadata
import json
import math
from pathlib import Path
import statistics
import sys
import time

parser = argparse.ArgumentParser()
parser.add_argument('--source', required=True, help='固定commit仓库或源码快照根目录')
parser.add_argument('--output', default='build/native')
args = parser.parse_args()
sys.path.insert(0, str(Path(args.source).resolve() / 'fake_quant'))
import torch
from hadamard_utils import random_hadamard_matrix
from quant_utils import ActQuantizer, pack_i4, unpack_i4

out = Path(args.output)
out.mkdir(parents=True, exist_ok=True)
torch.set_num_threads(1)
torch.manual_seed(31015)
K, N, B = 32, 16, 31
weight = torch.randn(N, K, dtype=torch.float32)
q = random_hadamard_matrix(K, 'cpu').float()
assert torch.allclose(q.T @ q, torch.eye(K), atol=2e-6)
# 固定旋转无训练、无参数搜索。量化权重使用原生ActQuantizer逐行统计，非完整GPTQ权重路径。
def quantize(x):
    obj = ActQuantizer()
    obj.configure(bits=4, groupsize=-1, sym=True, clip_ratio=1.0)
    obj.find_params(x)
    codes, scale = obj.quantize(x)
    return codes.to(torch.int8), scale[:, :1].clone()


def export(w, name):
    codes, scales = quantize(w)
    packed = pack_i4(codes)
    assert torch.equal(unpack_i4(packed).to(torch.int8), codes)
    path = out / (name + '.pt')
    torch.save({'packed': packed, 'scales': scales, 'shape': list(w.shape)}, path)
    state = torch.load(path, map_location='cpu', weights_only=True)
    reload_w = unpack_i4(state['packed']).float() * state['scales']
    return reload_w, {'packed_bytes': packed.numel(), 'scale_bytes': scales.numel()*scales.element_size(),
                      'file_bytes': path.stat().st_size()}


w0, storage0 = export(weight, 'absmax')
wr, storager = export(weight @ q, 'rotated')
# 旋转显式保存，独立Linear没有跨层融合；其4KiB成本不能遗漏。
torch.save(q, out / 'rotation.pt')
q = torch.load(out / 'rotation.pt', map_location='cpu', weights_only=True)


def evaluate(x):
    ref = x @ weight.T
    fp16 = (x.half() @ weight.half().T).float()
    eq = (x @ q) @ (weight @ q).T
    assert torch.allclose(eq, ref, atol=2e-4, rtol=2e-4)
    def infer(rotated):
        a = x @ q if rotated else x
        codes, scale = quantize(a)
        return (codes.float() * scale) @ (wr if rotated else w0).T
    report = {}
    for name, fn in [('fp16', lambda: (x.half() @ weight.half().T).float()),
                     ('absmax_w4a4_qdq', lambda: infer(False)), ('rotation_w4a4_qdq', lambda: infer(True))]:
        y = fn()
        for _ in range(5):
            fn()
        times = []
        for _ in range(21):
            t = time.perf_counter_ns()
            fn()
            times.append((time.perf_counter_ns()-t)/1e3)
        delta = y-ref
        report[name] = {'nrmse': (delta.norm()/ref.norm().clamp_min(1e-20)).item(),
                        'max_abs': delta.abs().max().item(),
                        'cosine': torch.nn.functional.cosine_similarity(y.flatten(), ref.flatten(), dim=0).item(),
                        'cpu_framework_request_p50_us': statistics.median(times)}
    for name, a in [('plain', x), ('rotated', x @ q)]:
        codes, scale = quantize(a)
        report[name+'_endpoint_fraction'] = ((codes == -8) | (codes == 7)).float().mean().item()
    return report


x = torch.randn(B, K)
x[:, 0] *= 24
shift = torch.randn(B, K) @ q.T
shift[:, 1] *= 30
# 评估集未用于选择旋转/位宽；shift故意改变离群方向，保留任何退化。
result = {'versions': {name: importlib.metadata.version(name) for name in ['torch', 'transformers', 'numpy', 'accelerate']},
          'shape': [B,K,N], 'dtype': 'float32, explicit fp16 reference', 'in_distribution': evaluate(x),
          'shifted': evaluate(shift), 'storage': {'absmax': storage0, 'rotation': storager,
          'fp16_weight_payload_bytes': weight.numel()*2, 'rotation_payload_bytes': q.numel()*4,
          'rotation_file_bytes': (out/'rotation.pt').stat().st_size()},
          'execution': 'CPU QDQ plus floating GEMM, no low-bit kernel; weights already decoded outside timing'}
zero_codes, zero_scale = quantize(torch.zeros(1,K))
assert torch.isfinite(zero_scale).all() and not zero_codes.any()
try:
    pack_i4(torch.full((1,2),8,dtype=torch.int8))
except AssertionError:
    result['invalid_int4_rejected'] = True
else:
    raise RuntimeError('range check missing')
(out/'metrics.json').write_text(json.dumps(result, indent=2)+'\n')
print(json.dumps(result, indent=2))
