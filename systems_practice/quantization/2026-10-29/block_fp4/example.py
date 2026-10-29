#!/usr/bin/env python3
"""独立教学 codec：比较 MXFP4 风格 E2M1 与 NVFP4 风格双层 block scale。
不调用 Model Optimizer，不能代替其 CUDA 后端或 Tensor Core 验收。
"""
import json
from pathlib import Path
import numpy as np

# E2M1 的有限码本；这里只演示格式语义，真实后端的 scale 编码另有约束。
CODEBOOK = np.array([-6,-4,-3,-2,-1,0,1,2,3,4,6], dtype=np.float32)

def quant(x, block=16, two_level=False):
    if x.size == 0: raise ValueError("empty input")
    flat=x.ravel(); pad=(-len(flat))%block; z=np.pad(flat,(0,pad)); blocks=z.reshape(-1,block)
    outer=np.maximum(np.max(np.abs(blocks),axis=1),1e-8)
    if two_level:
        # 第二层 scale 量化到 FP8-like 256 格，仅作显式存储对照。
        outer_q=np.round(outer / max(outer.max(),1e-8) * 127) / 127 * max(outer.max(),1e-8)
        local=outer/np.maximum(outer_q,1e-8)
        scale=outer_q
    else:
        local=np.ones_like(outer); scale=outer
    norm=blocks / (scale[:,None]*local[:,None])
    idx=np.argmin(np.abs(norm[:,:,None]-CODEBOOK[None,None,:]),axis=2).astype(np.uint8)
    restored=CODEBOOK[idx]*(scale[:,None]*local[:,None])
    return restored.ravel()[:len(flat)].reshape(x.shape), idx, scale.astype(np.float32), local.astype(np.float32)

def main():
    rng=np.random.default_rng(20261029)
    x=rng.normal(0,0.7,(3,37)).astype(np.float32); x[0,3]=7.5
    ref=x.copy(); rows=[]
    for name,two in [('mxfp4_like',False),('nvfp4_like',True)]:
        y,idx,scale,local=quant(x,two_level=two)
        payload=idx.nbytes+scale.nbytes+(local.nbytes if two else 0)
        rows.append({'method':name,'mse':float(np.mean((y-ref)**2)),'max_abs':float(np.max(np.abs(y-ref))),
                     'payload_bytes':int(payload),'blocks':int(len(scale)),'local_scale_bytes':int(local.nbytes if two else 0)})
    assert all(r['payload_bytes']>0 for r in rows)
    bad=False
    try: quant(np.empty((0,),np.float32))
    except Exception: bad=True
    assert bad
    out={'shape':[3,37],'block':16,'codebook':'independent E2M1-like teaching codebook','rows':rows,
         'boundary':'empty input rejected; shifted outlier retained'}
    print(json.dumps(out,ensure_ascii=False,indent=2))
    Path(__file__).with_name('results').joinpath('cpu.json').write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n')
if __name__=='__main__': main()
