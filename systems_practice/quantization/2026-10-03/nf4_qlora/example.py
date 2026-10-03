"""原生bitsandbytes NF4 API + 独立低秩适配；不下载模型、不自动安装。"""
import argparse
import importlib.metadata
import json
from pathlib import Path
import statistics
import time
import torch
import torch.nn.functional as F
import bitsandbytes as bnb
from bitsandbytes.functional import QuantState

def metrics(y, ref):
    a, b = y.float().flatten(), ref.float().flatten()
    return {'nrmse': float((a-b).norm()/b.norm().clamp_min(1e-12)),
            'max_abs': float((a-b).abs().max()), 'cosine': float(F.cosine_similarity(a,b,dim=0))}

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--device', choices=['cpu','cuda'], default='cpu'); args=ap.parse_args()
    assert importlib.metadata.version('bitsandbytes') == '0.48.1', 'use audited bitsandbytes 0.48.1'
    if args.device == 'cuda':
        assert torch.cuda.get_device_capability() == (11,0), 'Thor SM110 only'
    torch.manual_seed(17); device=torch.device(args.device)
    # FP32权重避免CPU half算子限制；另列FP16参考，不冒充W4A16内核性能。
    w=torch.randn(32,128,device=device)/8
    train=torch.randn(64,128,device=device); tune=torch.randn(32,128,device=device); test=torch.randn(48,128,device=device)
    ref=F.linear(test,w); half=F.linear(test.half(),w.half()).float()
    scale=w.abs().amax(dim=1,keepdim=True)/7
    qi=(w/scale).round().clamp(-7,7).to(torch.int8)
    # absmax INT4基线真实打包，独立于上游NF4格式。
    nib=(qi.to(torch.int16)&15).flatten().to(torch.uint8)
    packed_i=nib[::2]|(nib[1::2]<<4)
    decoded=torch.stack((packed_i&15,packed_i>>4),dim=1).flatten().to(torch.int16)
    decoded=torch.where(decoded>=8,decoded-16,decoded).reshape_as(w).float()*scale
    comparisons={'fp16':metrics(half,ref),'absmax_int4':metrics(F.linear(test,decoded),ref)}
    reports=[]; output=Path(__file__).resolve().parent/'build';output.mkdir(exist_ok=True)
    for nested in (False,True):
        q,state=bnb.functional.quantize_nf4(w,blocksize=64,compress_statistics=nested)
        dq=bnb.functional.dequantize_nf4(q,quant_state=state)
        assert q.dtype==torch.uint8 and q.numel()==w.numel()//2
        # 导出packed码与完整QuantState；省略scale会使重载错误。
        state_dict=state.as_dict(packed=True)
        path=output/f'nf4-{nested}.pt';torch.save({'q':q.cpu(),'state':{k:v.cpu() for k,v in state_dict.items()}},path)
        blob=torch.load(path,map_location=device,weights_only=True)
        restored=QuantState.from_dict(blob['state'],device=device)
        reloaded=bnb.functional.dequantize_nf4(blob['q'],quant_state=restored)
        torch.testing.assert_close(dq,reloaded,rtol=0,atol=0)
        # 冻结量化主干；训练FP32低秩A/B，不更新4位code，这是LoRA式适配而非QAT。
        a=torch.nn.Parameter(torch.randn(4,128,device=device)*0.01); b=torch.nn.Parameter(torch.zeros(32,4,device=device))
        optim=torch.optim.SGD([a,b],lr=0.1); initial=a.detach().clone(); logs=[]; best=None; best_loss=float('inf')
        for step in range(81):
            with torch.no_grad():
                score=float(F.mse_loss(F.linear(tune,dq)+F.linear(F.linear(tune,a),b),F.linear(tune,w)))
                if score<best_loss: best_loss=score;best=(a.detach().clone(),b.detach().clone(),step)
            if step==80: break
            optim.zero_grad(); pred=F.linear(train,dq)+F.linear(F.linear(train,a),b)
            loss=F.mse_loss(pred,F.linear(train,w));loss.backward();optim.step()
            if step%20==0: logs.append({'step':step,'train_loss':float(loss),'tune_loss':score})
        aa,bb,chosen=best
        assert float(b.detach().norm())>0 and float((a.detach()-initial).norm())>0
        torch.save({'A':aa.cpu(),'B':bb.cpu()},output/f'adapter-{nested}.pt')
        adapter=torch.load(output/f'adapter-{nested}.pt',map_location=device,weights_only=True)
        final=F.linear(test,reloaded)+F.linear(F.linear(test,adapter['A']),adapter['B'])
        def sync():
            if device.type=='cuda': torch.cuda.synchronize()
        def measure(fn):
            samples=[]
            for i in range(-20,100):
                sync();start=time.perf_counter();fn();sync()
                if i>=0:samples.append((time.perf_counter()-start)*1e6)
            return {'p50_us':statistics.median(samples),'p95_us':sorted(samples)[94]}
        tensor_bytes=q.numel()*q.element_size()+sum(v.numel()*v.element_size() for v in state_dict.values())
        reports.append({'double_quant':nested,'nf4':metrics(F.linear(test,dq),ref),'adapted':metrics(final,ref),'chosen_step':chosen,'updates':80,'training':logs,'payload_with_metadata_bytes':tensor_bytes,'file_bytes':path.stat().st_size,'adapter_bytes':4*(aa.numel()+bb.numel()),'fp32_bytes':w.numel()*4,'fp16_bytes':w.numel()*2,'absmax_int4_bytes':packed_i.numel()+scale.numel()*4,'dense_fp32_framework':measure(lambda:F.linear(test,w)),'decode_plus_dense_framework':measure(lambda:F.linear(test,bnb.functional.dequantize_nf4(q,quant_state=state)))})
    # 全零block边界，原生API实际拒绝不支持blocksize时错误自然上抛。
    z=torch.zeros(64,device=device);zq,zs=bnb.functional.quantize_nf4(z,blocksize=64);torch.testing.assert_close(bnb.functional.dequantize_nf4(zq,zs),z)
    print(json.dumps({'torch':torch.__version__,'bnb':bnb.__version__,'device':str(device),'comparison':comparisons,'reports':reports,'boundary_zero_passed':True,'timing_scope':'synchronized framework call; decode+dense is not fused native low-bit GEMM'},indent=2))
if __name__=='__main__':main()
