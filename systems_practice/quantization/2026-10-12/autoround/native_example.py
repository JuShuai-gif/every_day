#!/usr/bin/env python3
"""真实AutoRound低层API：SignSGD + asymmetric QDQ；独立编排，非完整LLM compressor。"""
import json
import math
from pathlib import Path
import statistics
import struct
import time
import torch
from auto_round.data_type.int import quant_tensor_asym
from auto_round.data_type.utils import reshape_pad_tensor_by_group_size
from auto_round.algorithms.quantization.sign_round.sign_sgd import SignSGD

ROOT = Path(__file__).resolve().parent
BUILD = ROOT / 'build'
BUILD.mkdir(exist_ok=True)
torch.set_num_threads(1)
N, K, G = 7, 35, 8

def mse(a, b):
    return (a - b).square().mean().item()

def metrics(a, b):
    d = (a-b).float()
    return {'mse': mse(a, b), 'max_abs': d.abs().max().item(),
            'nrmse': (d.square().sum() / b.square().sum().clamp_min(1e-20)).sqrt().item(),
            'cosine': torch.nn.functional.cosine_similarity(a.flatten(), b.flatten(), dim=0).item()}

def dataset(seed, count, shift=False):
    gen = torch.Generator().manual_seed(seed)
    x = torch.randn(count, K, generator=gen)
    x[:, 0] *= 0.05 if not shift else 15
    return x

def quant(w, v, lo, hi):
    # 原生API会沿每个输出通道的K方向补齐group尾部，非对称u4，FP32 scale。
    return quant_tensor_asym(w, bits=4, group_size=G, v=v, min_scale=lo,
                             max_scale=hi, scale_dtype=torch.float32)

def export_reload(qdq, scale, zp, path):
    # 自定义教学容器ARL1，不是AutoRound/GPTQ/AWQ后端格式；只承诺本文件的解码器。
    grouped, _, _ = reshape_pad_tensor_by_group_size(qdq, G)
    codes = (grouped / scale + zp).round().clamp(0, 15).to(torch.uint8).flatten().tolist()
    packed = bytes(codes[i] | (codes[i+1] << 4) for i in range(0, len(codes), 2))
    scales = scale.flatten().tolist()
    zeros = zp.flatten().to(torch.uint8).tolist()
    header = struct.pack('<4s5I', b'ARL1', N, K, G, len(codes), len(scales))
    data = header + packed + struct.pack('<%sf' % len(scales), *scales) + bytes(zeros)
    path.write_bytes(data)
    blob = path.read_bytes()
    magic, n, k, group, ncodes, nscales = struct.unpack('<4s5I', blob[:24])
    if (magic, n, k, group) != (b'ARL1', N, K, G) or len(blob) != 24+ncodes//2+5*nscales:
        raise ValueError('header/extent mismatch')
    payload = blob[24:24+ncodes//2]
    decoded = [q for byte in payload for q in [byte & 15, byte >> 4]]
    offset = 24+ncodes//2
    ds = torch.tensor(struct.unpack('<%sf' % nscales, blob[offset:offset+4*nscales])).reshape(-1, 1)
    dz = torch.tensor(list(blob[offset+4*nscales:])).reshape(-1, 1)
    restored = ((torch.tensor(decoded).reshape(-1, G) - dz) * ds).reshape(N, -1)[:, :K]
    torch.testing.assert_close(restored, qdq, atol=1e-6, rtol=1e-6)
    return restored, {'file_bytes': len(blob), 'header_bytes':24, 'packed_bytes':len(packed),
                      'scale_bytes':4*nscales, 'zero_bytes':nscales, 'fp32_weight_bytes':4*N*K,
                      'fp16_weight_bytes':2*N*K, 'endpoint_code_fraction':sum(x in (0,15) for x in codes)/len(codes)}

def cpu_time(x, w):
    for _ in range(10):
        torch.nn.functional.linear(x, w)
    samples=[]
    for _ in range(50):
        begin=time.perf_counter_ns()
        torch.nn.functional.linear(x, w)
        samples.append((time.perf_counter_ns()-begin)/1000)
    return {'p50_us':statistics.median(samples), 'p95_us':sorted(samples)[47],
            'scope':'CPU framework float32 linear, dequantization excluded, not native INT4'}

def main():
    gen=torch.Generator().manual_seed(11)
    w=torch.randn(N,K,generator=gen)*0.25
    w[0,0]=4.0
    w[1].zero_() # 全零group与尾块边界。
    calibration=dataset(21,64)
    tuning=dataset(22,48)
    evaluation=dataset(23,64)
    shifted=dataset(24,64,True)
    grouped, _, _ = reshape_pad_tensor_by_group_size(w,G)
    groups=grouped.shape[0]
    variants={}
    logs=[]
    for name, tune_range in [('round_only',False),('round_and_range',True)]:
        search_start=time.perf_counter()
        v=torch.nn.Parameter(torch.zeros_like(grouped))
        lo=torch.nn.Parameter(torch.ones(groups),requires_grad=tune_range)
        hi=torch.nn.Parameter(torch.ones(groups),requires_grad=tune_range)
        optimizer=SignSGD([v]+([lo,hi] if tune_range else []),lr=0.005)
        best=None
        best_score=math.inf
        for step in range(81):
            qdq, scale, zp=quant(w,v,lo,hi)
            # 独立调参集挑快照；最终eval在完成选型后才读取。
            with torch.no_grad():
                score=mse(tuning @ qdq.T,tuning @ w.T)
                if score<best_score:
                    best_score=score
                    best=(qdq.detach().clone(),scale.detach().clone(),zp.detach().clone())
            if step==80:
                break
            optimizer.zero_grad()
            loss=(calibration @ qdq.T-calibration @ w.T).square().mean()
            loss.backward()
            optimizer.step()
            with torch.no_grad():
                lo.clamp_(0.01,1); hi.clamp_(0.01,1)
            if step in [0,19,39,79]:
                logs.append({'variant':name,'step':step+1,'calibration_loss':loss.item(),
                             'v_l1':v.abs().sum().item(),'lo_min':lo.min().item(),'hi_min':hi.min().item()})
        if not v.abs().sum().item()>0:
            raise RuntimeError('no real parameter update')
        variants[name]={'snapshot':best,'tuning_mse':best_score,'offline_search_seconds':time.perf_counter()-search_start}
    selected=min(variants,key=lambda name:variants[name]['tuning_mse'])
    report={'selected_using_tuning_only':selected,'updates':logs,'versions':{'torch':torch.__version__},'comparison':{}}
    abs_scale=w.abs().amax(1,keepdim=True).clamp_min(1e-8)/7
    absmax=(w/abs_scale).round().clamp(-7,7)*abs_scale
    asym_rtn=quant(w,0,torch.ones(groups),torch.ones(groups))[0]
    references={'fp32':w,'fp16_storage_fp32_compute':w.half().float(),'absmax_s4':absmax,'asym_group8_rtn':asym_rtn}
    report['offline_search_seconds']={name:v['offline_search_seconds'] for name,v in variants.items()}
    for name,v in variants.items():
        decoded,storage=export_reload(*v['snapshot'],BUILD/(name+'.bin'))
        references[name]=decoded
        report.setdefault('storage',{})[name]=storage
    for name,qw in references.items():
        # 16位参考同时把A舍入到FP16；实际累加在CPU FP32进行。
        ex=evaluation.half().float() if name=='fp16_storage_fp32_compute' else evaluation
        sx=shifted.half().float() if name=='fp16_storage_fp32_compute' else shifted
        report['comparison'][name]={'eval':metrics(ex @ qw.T,evaluation @ w.T),
                                  'shifted':metrics(sx @ qw.T,shifted @ w.T),
                                  'latency':cpu_time(ex,qw)}
    # 接入已有nn.Linear：先校准其weight，再copy_解码权重；仍是浮点执行。
    layer=torch.nn.Linear(K,N,bias=False)
    with torch.no_grad(): layer.weight.copy_(variants[selected]['snapshot'][0])
    torch.testing.assert_close(layer(evaluation),evaluation @ variants[selected]['snapshot'][0].T)
    print(json.dumps(report,indent=2))

if __name__=='__main__':
    main()
