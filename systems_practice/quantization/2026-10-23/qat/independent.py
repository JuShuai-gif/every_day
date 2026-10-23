"""标准库独立QAT机制例，绝不冒充TorchAO调用或原生INT4执行。"""
import json
import math
from pathlib import Path
import random
import statistics
import struct
import time

W=[[.11,.39,-.65,1.04],[-.82,.27,.51,.96]]
def data(seed,n):
    r=random.Random(seed)
    return [[r.gauss(0,1) for _ in range(4)] for _ in range(n)]
train,cal,tune,test=[data(s,n) for s,n in [(1,64),(2,32),(3,32),(4,31)]]
scale=[max(map(abs,row))/7 for row in W]
# 固定FP32导出scale，训练/重载共用，避免精度不一致。
scale=list(struct.unpack('<2f',struct.pack('<2f',*scale)))
def codes(w):return [[max(-8,min(7,round(v/s))) for v in row] for row,s in zip(w,scale)]
def decode(q):return [[v*s for v in row] for row,s in zip(q,scale)]
def linear(x,w):return [[sum(a*b for a,b in zip(row,ww)) for ww in w] for row in x]
def mse(x,w):
    y,ref=linear(x,w),linear(x,W)
    return sum((a-b)**2 for row,rr in zip(y,ref) for a,b in zip(row,rr))/(2*len(x))
base=decode(codes(W));candidates=[]
for lr in (.01,.05):
    w=[row[:] for row in W];history=[]
    for step in range(160):
        dq=decode(codes(w)); y,ref=linear(train,dq),linear(train,W)
        grad=[[0.0]*4 for _ in range(2)]
        for x,yy,rr in zip(train,y,ref):
            for j in range(2):
                for k in range(4):grad[j][k]+=(yy[j]-rr[j])*x[k]/len(train)
        # round STE=1；clamp的掩码检查round后的值，边界包含等号。
        for j in range(2):
            for k in range(4):
                if -8 <= round(w[j][k]/scale[j]) <= 7:w[j][k]-=lr*grad[j][k]
        if step in (0,79,159):history.append([step,mse(train,decode(codes(w)))])
    candidates.append((mse(tune,decode(codes(w))),lr,w,history))
_,lr,w,history=min(candidates,key=lambda x:x[0])
assert any(w[j][k]!=W[j][k] for j in range(2) for k in range(4))
q=sum(codes(w),[]);packed=bytes((q[i]&15)|((q[i+1]&15)<<4) for i in range(0,8,2))
root=Path(__file__).parent/'build';root.mkdir(exist_ok=True)
p=root/'independent.bin';p.write_bytes(struct.pack('<4sII2f',b'Q4S1',2,4,*scale)+packed)
blob=p.read_bytes();restored=[]
for b in blob[20:]:
    for v in (b&15,b>>4):restored.append(v-16 if v>=8 else v)
assert restored==q and len(blob)==24
final=decode([restored[:4],restored[4:]])
shift=[row[:] for row in test]
for row in shift:row[0]*=12
half=lambda v:struct.unpack('<e',struct.pack('<e',v))[0]
fp16=[[half(v) for v in row] for row in W]
def metrics(x, ww):
    y=sum(linear(x,ww),[]);ref=sum(linear(x,W),[]);d=[a-b for a,b in zip(y,ref)]
    norm=math.sqrt(sum(v*v for v in ref));ynorm=math.sqrt(sum(v*v for v in y))
    return {'nrmse':math.sqrt(sum(v*v for v in d))/max(norm,1e-12),
            'max_abs':max(map(abs,d)), 'cosine':sum(a*b for a,b in zip(y,ref))/max(norm*ynorm,1e-12)}
results={}
for name,x in [('eval',test),('shift',shift),('zero',[[0.0]*4])]:
    results[name]={'absmax_mse':mse(x,base),'qat_mse':mse(x,final),'qat_metrics':metrics(x,final),'absmax_metrics':metrics(x,base),
                  'fp16_storage_fp64_accum_mse':mse(x,fp16)}
for _ in range(10):linear(test,final)
samples=[]
for _ in range(31):
    t=time.perf_counter_ns();linear(test,final);samples.append((time.perf_counter_ns()-t)/1000)
print(json.dumps({'implementation':'independent stdlib, FP64 arithmetic, not TorchAO',
    'split_rows':[64,32,32,31],'calibration_note':'weight-only scale from original W; cal held out and unused',
    'steps_per_candidate':160,'clamped_weight_fraction':sum(not -8<=round(v/scale[j])<=7 for j,row in enumerate(w) for v in row)/8,'weight_max_delta':max(abs(w[j][k]-W[j][k]) for j in range(2) for k in range(4)),'lr':lr,'history':history,'results':results,
    'bytes':{'u4':4,'scale':8,'header':12,'file':len(blob),'fp16_payload':16},
    'cpu_decoded_gemm_p50_us':statistics.median(samples),'thor_verified':False},indent=2))
