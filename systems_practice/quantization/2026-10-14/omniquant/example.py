#!/usr/bin/env python3
"""真实调用固定版本QuantLinear/LWC；训练编排和packed导出为独立教学代码。"""
import argparse
import copy
import json
import struct
import sys
import time
from pathlib import Path
import torch
import torch.nn.functional as F


def error(y, ref):
    return {'nrmse': float((y-ref).norm()/ref.norm().clamp_min(1e-12)), 'max_abs':float((y-ref).abs().max())}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--source',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
    sys.path.insert(0,str(args.source.resolve()))
    from quantize.int_linear import QuantLinear
    args.output.mkdir(parents=True,exist_ok=True)
    torch.manual_seed(14);torch.set_num_threads(1)
    linear=torch.nn.Linear(32,16,bias=False).float();linear.requires_grad_(False)
    # 四份独立样本：本例LWC是校准优化PTQ，保持预训练权重冻结。
    train,cal,tune,test=[torch.randn(n,32) for n in (64,64,32,31)]
    for x in (train,cal,tune,test):x[:,3]*=8
    best=None;best_score=float('inf');log=[]
    for lr in (.001,.01):
        q=QuantLinear(copy.deepcopy(linear),weight_quant_params=dict(n_bits=4,symmetric=False,dynamic_method='per_channel',group_size=8,lwc=True),disable_input_quant=True)
        q.set_quant_state(weight_quant=True,act_quant=False)
        with torch.no_grad():q(cal)
        params=list(q.weight_quantizer.parameters());start=[p.detach().clone() for p in params]
        opt=torch.optim.AdamW(params,lr=lr,weight_decay=0)
        for step in range(40):
            opt.zero_grad();loss=F.mse_loss(q(train),linear(train));loss.backward();opt.step()
            if step%10==0:log.append({'lr':lr,'step':step,'train_mse':loss.item()})
        delta=sum(float((p-s).norm()) for p,s in zip(params,start));assert delta>0
        with torch.no_grad():score=F.mse_loss(q(tune),linear(tune)).item()
        log.append({'lr':lr,'parameter_update_l2':delta,'tune_mse':score})
        if score<best_score:best=copy.deepcopy(q);best_score=score
    # deepcopy模块可能含非叶scale；上面先no_grad校准后选择，确保派生张量无图。
    with torch.no_grad():
        ref=linear(test);y=best(test);w=best.weight;uq=best.weight_quantizer;qd=uq(w)
        s=uq.scale.detach().clone();z=uq.round_zero_point.detach().clone()
        code=(w.reshape(-1,8)/s).round().add(z).clamp(uq.qmin,uq.qmax).to(torch.uint8).flatten()
        packed=code[::2]|(code[1::2]<<4)
        payload=bytes(packed.tolist())+b''.join(struct.pack('<f',v) for v in s.flatten().tolist())+b''.join(struct.pack('<i',int(v)) for v in z.flatten().tolist())
        target=args.output/'linear-u4.bin';target.write_bytes(payload)
        blob=target.read_bytes();count=w.numel()//2
        raw=torch.tensor(list(blob[:count]),dtype=torch.uint8)
        restored=torch.stack((raw&15,raw>>4),dim=1).flatten().reshape(-1,8).float()
        ss=torch.tensor(struct.unpack('<'+str(s.numel())+'f',blob[count:count+4*s.numel()])).reshape_as(s)
        zz=torch.tensor(struct.unpack('<'+str(z.numel())+'i',blob[count+4*s.numel():])).reshape_as(z)
        decoded=((restored-zz)*ss).reshape_as(w);assert torch.allclose(decoded,qd,atol=1e-6)
        assert torch.allclose(F.linear(test,decoded),y,atol=1e-5)
        baseline=QuantLinear(copy.deepcopy(linear),weight_quant_params=dict(n_bits=4,symmetric=False,dynamic_method='per_channel',group_size=8,lwc=False),disable_input_quant=True)
        baseline.set_quant_state(True,False)
        shifted=test.clone();shifted[:,9]*=20
        timings={}
        for name,fn in [('fp32',linear),('native_qdq',best),('decoded_fp32',lambda x:F.linear(x,decoded))]:
            for _ in range(5):fn(test)
            ts=[]
            for _ in range(30):
                t=time.perf_counter_ns();fn(test);ts.append((time.perf_counter_ns()-t)/1e6)
            timings[name]=sorted(ts)[15]
        result=dict(torch=torch.__version__,method='OmniQuant native LWC only',shape=[31,32,16],train_log=log,baseline=error(baseline(test),ref),lwc=error(y,ref),fp16=error(F.linear(test.half().float(),w.half().float()),ref),shifted=error(best(shifted),linear(shifted)),storage=dict(fp32=w.numel()*4,fp16=w.numel()*2,packed_codes=count,scales=s.numel()*4,zero_points=z.numel()*4,actual_file=target.stat().st_size),cpu_framework_ms_p50=timings,thor_verified=False)
        print(json.dumps(result,indent=2))

if __name__=='__main__':main()
