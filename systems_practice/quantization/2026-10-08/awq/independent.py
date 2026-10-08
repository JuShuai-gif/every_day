"""独立AWQ启发实验，非上游API。真实u4打包；只有Python CPU GEMM计时。"""
import json
import math
from pathlib import Path
import random
import statistics
import struct
import time

K,N,G=33,7,16
rng=random.Random(17)
w=[[rng.uniform(-1,1) for _ in range(K)] for _ in range(N)]
def data(seed, shifted=False):
    r=random.Random(seed)
    return [[r.gauss(0,1)*(24 if j==(K-1 if shifted else 0) else 1) for j in range(K)] for _ in range(24)]
cal,tune,test,shift=data(101),data(102),data(103),data(104,True)

def mm(x,w): return [[sum(a*b for a,b in zip(row,col)) for col in w] for row in x]
def mse(x,y):return sum((a-b)**2 for r,s in zip(x,y) for a,b in zip(r,s))/(len(x)*len(x[0]))
def quant(w,s):
    codes=[]; metadata=[]; decoded=[];sat=0
    for row in w:
        out=[]
        for begin in range(0,K,G):
            v=[row[j]*s[j] for j in range(begin,min(begin+G,K))]
            # 有符号对称INT4以offset8存储；每个尾group独立scale。
            step=max(max(map(abs,v))/7,1e-8)
            step=struct.unpack('<f',struct.pack('<f',step))[0];metadata.append(step)
            q=[max(-7,min(7,round(z/step))) for z in v]
            sat+=sum(abs(z)==7 for z in q)
            codes.extend(z+8 for z in q)
            out.extend(qi*step/s[begin+i] for i,qi in enumerate(q))
        decoded.append(out)
    packed=bytes(codes[i]|((codes[i+1] if i+1<len(codes) else 8)<<4) for i in range(0,len(codes),2))
    assert all(((packed[i//2]>>(4*(i%2)))&15)==q for i,q in enumerate(codes))
    return decoded,packed,metadata,sat

stats=[sum(abs(row[j]) for row in cal)/len(cal) for j in range(K)]
ref_tune=mm(tune,w); candidates=[]
for r in range(20):
    s=[max(v**(r/20),1e-4) for v in stats];norm=math.sqrt(max(s)*min(s));s=[v/norm for v in s]
    s=[struct.unpack('<f',struct.pack('<f',v))[0] for v in s]
    qw,p,meta,sat=quant(w,s);candidates.append((mse(mm(tune,qw),ref_tune),r/20,s,qw,p,meta,sat))
_,ratio,s,qw,p,meta,sat=min(candidates,key=lambda z:z[0])
base=quant(w,[1]*K)[0]
fp16=[[struct.unpack('<e',struct.pack('<e',v))[0] for v in row] for row in w]
# 保存真实payload和元数据，再从文件重建全部权重。
build=Path(__file__).parent/'build';build.mkdir(exist_ok=True)
path=build/'weights.bin';path.write_bytes(p+struct.pack('<'+'f'*(len(meta)+K),*(meta+s)))
blob=path.read_bytes();v=struct.unpack('<'+'f'*(len(meta)+K),blob[len(p):]);rest=[]
for n in range(N):
    rest.append([(((blob[(n*K+j)//2]>>(4*((n*K+j)%2)))&15)-8)*v[n*((K+G-1)//G)+j//G]/v[len(meta)+j] for j in range(K)])
assert rest==qw
report={'relationship':'independent, not llm-awq execution','ratio':ratio,'codes':N*K,'saturated_endpoint_count':sat,
        'packed_bytes':len(p),'group_scale_bytes':4*len(meta),'channel_scale_bytes':4*K,'file_bytes':path.stat().st_size,
        'fp32_payload':4*N*K,'fp16_payload':2*N*K}
for name,x in [('test',test),('shifted',shift)]:
    ref=mm(x,w)
    report[name]={label:math.sqrt(mse(mm(x,ww),ref)/max(mse(ref,[[0]*N for _ in x]),1e-30)) for label,ww in [('fp16',fp16),('absmax',base),('awq_inspired',qw)]}
for label,ww in [('fp32',w),('decoded_awq',qw)]:
    for _ in range(3):mm(test,ww)
    times=[]
    for _ in range(15):
        begin=time.perf_counter()
        for __ in range(3):mm(test,ww)
        times.append((time.perf_counter()-begin)*1000/3)
    report[label+'_CPU_batch_mean_ms_p50']=statistics.median(times)
assert quant([[0]*K for _ in range(N)],[1]*K)[0]==[[0]*K for _ in range(N)]
print(json.dumps(report,indent=2))
