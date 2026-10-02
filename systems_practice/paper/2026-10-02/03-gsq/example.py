"""Independent Gumbel relaxation + real logit/scale updates, not full GSQ."""
import json
import math
import random
import struct
GRID = [-2., -1., 0., 1.]
W = [-1.1, -0.6, 0.18, 0.8]
rng = random.Random(1002)
logits = [[-2*(v-w)**2 for v in GRID] for w in W]
scale = 0.8

def objective(ls, s, noise, tau):
    if tau <= 0: raise ValueError('positive temperature required')
    total=0.; gl=[]; gs=0.
    for row, target, g in zip(ls,W,noise):
        a=[(v+n)/tau for v,n in zip(row,g)]; m=max(a)
        p=[math.exp(v-m) for v in a]; z=sum(p);p=[v/z for v in p]
        soft=sum(v*q for v,q in zip(GRID,p)); err=s*soft-target
        total+=err*err/len(W)
        gl.append([2*err*s*q*(v-soft)/(tau*len(W)) for v,q in zip(GRID,p)])
        gs+=2*err*soft/len(W)
    return total,gl,gs
noise=[[-math.log(-math.log(rng.uniform(1e-6,1-1e-6))) for _ in GRID] for _ in W]
loss,grad,sg=objective(logits,scale,noise,1.)
eps=1e-5; max_error=0.
# 固定同一份噪声验证导数，重采样噪声会让有限差分失去意义。
for i in range(4):
    for j in range(4):
        logits[i][j]+=eps; plus=objective(logits,scale,noise,1.)[0]
        logits[i][j]-=2*eps; minus=objective(logits,scale,noise,1.)[0]
        logits[i][j]+=eps
        max_error=max(max_error,abs((plus-minus)/(2*eps)-grad[i][j]))
fd=(objective(logits,scale+eps,noise,1.)[0]-objective(logits,scale-eps,noise,1.)[0])/(2*eps)
assert max_error<1e-8 and abs(fd-sg)<1e-8
initial=[r[:] for r in logits]; s0=scale
for step in range(600):
    tau=max(.15,1-step/700)
    noise=[[-math.log(-math.log(rng.uniform(1e-6,1-1e-6))) for _ in GRID] for _ in W]
    _,gl,gs=objective(logits,scale,noise,tau)
    for i in range(4):
        for j in range(4): logits[i][j]-=.05*gl[i][j]
    scale-=.05*gs
assert any(abs(logits[i][j]-initial[i][j])>1e-6 for i in range(4) for j in range(4))
codes=[max(range(4),key=lambda j:row[j]) for row in logits]
packed=bytes([sum(v<<(2*i) for i,v in enumerate(codes))])+struct.pack('<f',scale)
restored_codes=[(packed[0]>>(2*i))&3 for i in range(4)]
s=struct.unpack('<f',packed[1:])[0]
assert restored_codes==codes
hard_mse=sum((s*GRID[q]-w)**2 for q,w in zip(codes,W))/4
try: objective(logits,scale,noise,0)
except ValueError: pass
else: raise AssertionError('temperature not rejected')
print(json.dumps({'steps':600,'initial_scale':s0,'final_scale':scale,
 'finite_difference_max_error':max_error,'hard_codes':codes,'hard_mse':hard_mse,
 'payload_bytes':len(packed),'fp32_weights_bytes':16,
 'boundary':'four weights only; stochastic soft training and real 2-bit packing; no model reconstruction or native kernel'},indent=2))
