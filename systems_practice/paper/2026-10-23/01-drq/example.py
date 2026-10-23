"""论文式(5)在单输出/C=I上的独立穷举，不是作者完整DRQ。"""
import itertools
import json
from pathlib import Path
import random
import struct
w=(.49,.49)
cal=[(1,1),(-1,-1)]
tune=[(1,-1),(-1,1)]
rng=random.Random(23)
eval_x=[(rng.gauss(0,1),rng.gauss(0,1)) for _ in range(31)]
shift=[(x,-x) for x,_ in eval_x]
def loss(q,xs):
    return sum(sum((qi-wi)*xi for qi,wi,xi in zip(q,w,x))**2 for x in xs)/len(xs)
def robust(q,alpha):
    # 单输出时最大特征值=误差向量模长平方，C=I（beta=1）。
    return loss(q,cal)+alpha*sum((a-b)**2 for a,b in zip(q,w))
grid=list(itertools.product(range(4),repeat=2))
rec=min(grid,key=lambda q:loss(q,cal))
choices=[(a,min(grid,key=lambda q:robust(q,a))) for a in [0,64]]
alpha,q=min(choices,key=lambda aq:loss(aq[1],tune))
assert loss(rec,cal)<loss(q,cal) and loss(rec,shift)>loss(q,shift)
assert robust(q,alpha)<=robust(rec,alpha)
# 真实两位码：第一码在最低两位，scale/zero point固定。
root=Path('build');root.mkdir(exist_ok=True)
p=root/'codes.bin';p.write_bytes(struct.pack('<fB',1.0,0)+bytes([q[0]|q[1]<<2]))
b=p.read_bytes();assert (b[5]&3,(b[5]>>2)&3)==q
print(json.dumps({'rec_codes':rec,'robust_codes':q,'alpha_selected_on_tune':alpha,
    'calibration':[loss(rec,cal),loss(q,cal)],'eval':[loss(rec,eval_x),loss(q,eval_x)],
    'shift':[loss(rec,shift),loss(q,shift)],'robust_objective':[robust(rec,alpha),robust(q,alpha)],
    'file_bytes':p.stat().st_size,'fp16_weight_payload_bytes':4,
    'limitation':'large alpha; no paper reconstruction-increase guard, no model or device run'},indent=2))
