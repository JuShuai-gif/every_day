"""原生KIVI低层API调用；不是独立复刻，也不调用自动下载。"""
import argparse
import json
import math
from pathlib import Path
import statistics
import subprocess
import sys
import time

PIN = '876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6'
p = argparse.ArgumentParser()
p.add_argument('--repo', required=True)
p.add_argument('--device', choices=['cpu', 'cuda'], default='cpu')
a = p.parse_args()
repo = Path(a.repo).resolve()
if subprocess.check_output(['git', '-C', str(repo), 'rev-parse', 'HEAD'], text=True).strip() != PIN:
    raise SystemExit('KIVI checkout commit mismatch')
sys.path.insert(0, str(repo))
import torch
from quant.new_pack import (quant_and_pack_kcache, quant_and_pack_vcache,
                           unpack_and_dequant_kcache, unpack_and_dequant_vcache)
if a.device == 'cuda' and torch.cuda.get_device_capability() != (11, 0):
    raise SystemExit('only Thor SM110 is authorized')
torch.manual_seed(20261004)
# KV量化在解码时在线统计；本例没有训练/校准/调参，只用固定参数评估。
k = torch.randn(1, 2, 96, 32, device=a.device, dtype=torch.float16)
v = torch.randn_like(k)
q = torch.randn(1, 2, 1, 32, device=a.device, dtype=torch.float16)
k[..., 0] *= 8  # 固定离群通道，不用评估结果选参数。
group, bits, residual = 32, 2, 32

def validate(x, key):
    z = x.reshape(1, 2, -1, group, 32) if key else x.reshape(1, 2, x.shape[2], -1, group)
    dim = -2 if key else -1
    if torch.any(z.amax(dim=dim) == z.amin(dim=dim)):
        raise ValueError('upstream minmax has no zero-range guard; reject constant group')

def encode():
    prefix = k.shape[2] - residual
    kp, vp = k[:, :, :prefix].contiguous(), v[:, :, :prefix].contiguous()
    validate(kp, True); validate(vp, False)
    return (*quant_and_pack_kcache(kp, group, bits),
            *quant_and_pack_vcache(vp, group, bits),
            k[:, :, prefix:].clone(), v[:, :, prefix:].clone())

def restore(state):
    kc, ks, km, vc, vs, vm, kr, vr = state
    return (torch.cat((unpack_and_dequant_kcache(kc, ks, km, group, bits), kr), dim=2),
            torch.cat((unpack_and_dequant_vcache(vc, vs, vm, group, bits), vr), dim=2))

def attention(kk, vv):
    # 统一FP32乘加/softmax评估量化误差，不把解码后float计算叫低位kernel。
    score = q.float() @ kk.float().transpose(-1, -2) / math.sqrt(32)
    return torch.softmax(score, dim=-1) @ vv.float()

def measure(fn):
    def sync():
        if a.device == 'cuda': torch.cuda.synchronize()
    for _ in range(10): fn()
    samples = []
    for _ in range(31):
        sync(); t = time.perf_counter(); fn(); sync()
        samples.append((time.perf_counter()-t)*1000)
    return {'p50_ms': statistics.median(samples), 'p95_ms': sorted(samples)[29]}

state = encode()
root = Path(__file__).resolve().parent
(root/'build').mkdir(exist_ok=True)
# 临时导出是实际int32打包+FP16 metadata+FP16残留，放忽略目录。
path = root/'build/native-cache.pt'
torch.save({'state': state, 'bits': bits, 'group': group, 'residual': residual}, path)
loaded = torch.load(path, map_location=a.device, weights_only=True)
kk, vv = restore(loaded['state'])
ref, out = attention(k, v), attention(kk, vv)
assert torch.isfinite(out).all()
assert all(torch.equal(x, y) for x, y in zip(state, loaded['state']))
constant_rejected = False
try: validate(torch.zeros_like(k[:, :, :64]), True)
except ValueError: constant_rejected = True
assert constant_rejected
metrics = {'torch': torch.__version__, 'device': a.device,
 'reference': 'FP16 KV, FP32 accumulation/softmax',
 'nrmse': ((out-ref).square().sum()/ref.square().sum()).sqrt().item(),
 'max_abs': (out-ref).abs().max().item(),
 'fp16_kv_bytes': (k.numel()+v.numel())*2,
 'packed_tensor_bytes': sum(t.numel()*t.element_size() for t in state),
 'archive_bytes': path.stat().st_size,
 'reference_attention': measure(lambda: attention(k, v)),
 'decode_plus_attention': measure(lambda: attention(*restore(state))),
 'online_pack': measure(encode), 'constant_group_rejected': constant_rejected,
 'timing_boundary': 'synchronized host framework call; NOT single GPU kernel or model E2E'}
print(json.dumps(metrics, indent=2))
