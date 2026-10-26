"""原生KIVI CPU pack/unpack API；attention为独立FP32重建评估，非GPU后端。"""
import argparse
import hashlib
import json
from pathlib import Path
import statistics
import sys
import time

parser = argparse.ArgumentParser()
parser.add_argument('--source', required=True)
args = parser.parse_args()
source = Path(args.source).resolve()
assert hashlib.sha256((source/'quant/new_pack.py').read_bytes()).hexdigest() == '3678af0e34a0ba18e5d80a4128acf11d4070667c800a15540a16d07253a4f75e', 'wrong source revision'
import torch
import triton
sys.path.insert(0, str(source))
from quant.new_pack import (quant_and_pack_kcache, quant_and_pack_vcache,
                            unpack_and_dequant_kcache, unpack_and_dequant_vcache)

OUT = Path(__file__).resolve().parent/'build'
OUT.mkdir(exist_ok=True)
torch.set_num_threads(1)

def attention(q, k, v):
    # 保持参考与量化后相同FP32 attention；不把重建的浮点matmul称为2位计算。
    return ((q.float() @ k.float().transpose(-1, -2))/8).softmax(-1) @ v.float()

def timed(f):
    for _ in range(20): f()
    times = []
    for _ in range(31):
        t = time.perf_counter_ns(); f(); times.append((time.perf_counter_ns()-t)/1000)
    return {'CPU_call_us_P50': statistics.median(times), 'CPU_call_us_P95': sorted(times)[29]}

def guarded_pack(k, v, group, bits):
    if bits not in (2, 4) or group <= 0 or k.shape[-2] % group or v.shape[-1] % group:
        raise ValueError('shape/group/bits contract')
    if k.shape[-2] % (32//bits) or v.shape[-1] % (32//bits):
        raise ValueError('packing multiple')
    # 上游没有零range保护：生产入口明确拒绝，不能悄悄用NaN生成码。
    kg = k.reshape(1, 2, -1, group, 64)
    vg = v.reshape(1, 2, v.shape[-2], -1, group)
    if ((kg.amax(-2)-kg.amin(-2)) == 0).any() or ((vg.amax(-1)-vg.amin(-1)) == 0).any():
        raise ValueError('constant group unsupported by upstream')
    return quant_and_pack_kcache(k.clone(), group, bits), quant_and_pack_vcache(v.clone(), group, bits)

def run(seed, residual, shift=False, export=False):
    gen = torch.Generator().manual_seed(seed)
    k = torch.randn(1, 2, 128, 64, generator=gen).half()
    v = torch.randn(1, 2, 128, 64, generator=gen).half()
    q = torch.randn(1, 2, 1, 64, generator=gen).half()
    if shift: k[..., 0] *= 12; q[..., 0] *= 6
    cut = 128-residual
    kp, vp = guarded_pack(k[:, :, :cut].contiguous(), v[:, :, :cut].contiguous(), 32, 2)
    state = {'kp': kp, 'vp': vp, 'kr': k[:, :, cut:].clone(), 'vr': v[:, :, cut:].clone()}
    if export:
        file = OUT/'cache.pt'; torch.save(state, file)
        state = torch.load(file, map_location='cpu', weights_only=True)
        payload = b''.join(t.contiguous().numpy().tobytes() for t in (*state['kp'], *state['vp'], state['kr'], state['vr']))
        (OUT/'cache.raw').write_bytes(payload)
        (OUT/'cache-layout.json').write_text(json.dumps({'bits':2,'group':32,'residual':residual,'order':['K_code','K_scale','K_min','V_code','V_scale','V_min','K_residual','V_residual'],'shapes':[list(t.shape) for t in (*state['kp'],*state['vp'],state['kr'],state['vr'])]},indent=2))
    kd = torch.cat((unpack_and_dequant_kcache(*state['kp'],32,2),state['kr']),2)
    vd = torch.cat((unpack_and_dequant_vcache(*state['vp'],32,2),state['vr']),2)
    ref = attention(q,k,v); result = attention(q,kd,vd)
    # 对称absmax只是误差基线，未声称真实压缩存储或原生低位算子。
    def absmax(x):
        s=x.float().abs().amax()/1
        return (x.float()/s).round().clamp(-1,1)*s
    baseline = attention(q,absmax(k),absmax(v))
    tensors=(*state['kp'],*state['vp'],state['kr'],state['vr'])
    report={'residual':residual,'shift':shift,'MSE':(result-ref).square().mean().item(),
            'max_abs':(result-ref).abs().max().item(),
            'NRMSE':((result-ref).norm()/ref.norm().clamp_min(1e-12)).item(),
            'cosine':torch.nn.functional.cosine_similarity(result.flatten(),ref.flatten(),dim=0).item(),
            'absmax_MSE':(baseline-ref).square().mean().item(),
            'FP16_payload_bytes':(k.numel()+v.numel())*2,
            'packed_payload_with_scale_min_residual_bytes':sum(t.numel()*t.element_size() for t in tensors),
            'reconstruction_finite':bool(torch.isfinite(result).all())}
    assert report['reconstruction_finite']
    if export:
        report.update(raw_bytes=(OUT/'cache.raw').stat().st_size, torch_container_bytes=(OUT/'cache.pt').stat().st_size,
                      layout_bytes=(OUT/'cache-layout.json').stat().st_size,
                      dense_attention=timed(lambda:attention(q,k,v)), reconstructed_attention=timed(lambda:attention(q,kd,vd)),
                      pack=timed(lambda:guarded_pack(k[:,:,:cut].contiguous(),v[:,:,:cut].contiguous(),32,2)))
    return report

# 无训练/离线校准；在线minmax统计。只用独立tune seed选择残留长度。
tuning=[run(200,r) for r in (32,64)]
choice=min(tuning,key=lambda r:r['MSE'])['residual']
evaluation=run(300,choice,export=True)
shifted=run(400,choice,True)
rejected=0
for k,v,g,b in [(torch.zeros(1,2,64,64),torch.zeros(1,2,64,64),32,2),
                 (torch.ones(1,2,63,64),torch.ones(1,2,63,64),32,2)]:
    try: guarded_pack(k,v,g,b)
    except ValueError: rejected+=1
assert rejected==2
print(json.dumps({'torch':torch.__version__,'triton':triton.__version__,'tune':tuning,'eval':evaluation,'shift':shifted,'rejected':rejected,'scope':'native CPU packing + independent attention; no Thor kernel or training'},indent=2))
