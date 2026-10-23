"""独立2维残差小网：真实删除块与Pareto，未实现作者贝叶斯优化。"""
import itertools
import json
import math
from pathlib import Path
import random
import statistics
import struct
import time
blocks=[[[.12,-.07],[.03,.09]],[[.02,.01],[-.04,.02]],[[.15,.05],[-.03,.13]]]
def data(seed):
    r=random.Random(seed);return [[r.uniform(-1,1),r.uniform(-1,1)] for _ in range(31)]
cal,tune,test=data(1),data(2),data(3)
def run(x,bs):
    for w in bs:x=[x[j]+math.tanh(sum(x[k]*w[j][k] for k in range(2))) for j in range(2)]
    z=max(x);e=[math.exp(a-z) for a in x];return [a/sum(e) for a in e]
def kl(bs,xs):
    total=0
    for x in xs:
        p,q=run(x,blocks),run(x,bs)
        total+=sum(a*math.log(a/b) for a,b in zip(p,q))
    return total/len(xs)
candidates=[]
for mask in itertools.product([0,1],repeat=3):
    bs=[b for b,keep in zip(blocks,mask) if keep]
    candidates.append({'mask':mask,'params':len(bs)*4,'cal_kl':kl(bs,cal),'blocks':bs})
front=[c for c in candidates if not any(d['params']<=c['params'] and d['cal_kl']<=c['cal_kl'] and
      (d['params']<c['params'] or d['cal_kl']<c['cal_kl']) for d in candidates)]
# 固定8参数内存预算，只用tune挑方案。参数量不是延迟替身。
chosen=min((c for c in front if c['params']<=8),key=lambda c:kl(c['blocks'],tune))
assert chosen['params']<=8 and len(chosen['blocks'])<len(blocks)
root=Path('build');root.mkdir(exist_ok=True)
mask=chosen['mask'];payload=[v for b in chosen['blocks'] for row in b for v in row]
p=root/'pruned.bin';p.write_bytes(bytes([sum(v<<i for i,v in enumerate(mask))])+struct.pack('<'+'f'*len(payload),*payload))
b=p.read_bytes();vals=struct.unpack('<'+'f'*len(payload),b[1:]);loaded=[[[vals[i],vals[i+1]],[vals[i+2],vals[i+3]]] for i in range(0,len(vals),4)]
assert max(abs(a-b) for x in test for a,b in zip(run(x,loaded),run(x,chosen['blocks'])))<1e-6
assert run([0.,0.],[])==[.5,.5]
def timing(bs):
    for _ in range(10):[run(x,bs) for x in test]
    samples=[]
    for _ in range(31):
        t=time.perf_counter_ns();[run(x,bs) for x in test];samples.append((time.perf_counter_ns()-t)/1000)
    return statistics.median(samples)
print(json.dumps({'front':[{k:v for k,v in c.items() if k!='blocks'} for c in front],
 'chosen':mask,'test_kl':kl(loaded,test),'file_bytes':p.stat().st_size,'full_fp32_payload_bytes':48,
 'cpu_batch31_p50_us':{'full':timing(blocks),'pruned':timing(loaded)},
 'scope':'Python CPU synthetic residual network; not attention, BO, LLM or board benchmark'},indent=2))
