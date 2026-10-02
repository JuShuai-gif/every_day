"""独立合成反例：联合选宽度/位宽，非作者NAS训练或设备性能。"""
import itertools
import json
# cost是人为无单位代价；不是毫秒。loss为构造的调参损失。
choices=[('wide',16,8.0,0.1),('narrow',16,4.0,0.3),('wide',4,3.0,0.15),('narrow',4,2.0,0.8)]
budget=3.0
joint=min((c for c in choices if c[2]<=budget),key=lambda c:c[3])
# 先在16bit选最小架构，再量化，可能丢失wide4这一组合。
sequential=next(c for c in choices if c[0]=='narrow' and c[1]==4)
assert joint[0]=='wide' and joint[3]<sequential[3]
# 论文Eq9的概率mask，与先切片补零再加权必须等价。
w=[[float(1+i*4+j) for j in range(4)] for i in range(3)]
widths_in=[2,4];widths_out=[1,3];pi=[.25,.75];po=[.6,.4]
a=[[0.]*4 for _ in range(3)]
for i,j in itertools.product(range(2),repeat=2):
    for r in range(widths_out[j]):
        for c in range(widths_in[i]):a[r][c]+=w[r][c]*pi[i]*po[j]
b=[[w[r][c]*sum(pi[i]*po[j] for i,j in itertools.product(range(2),repeat=2)
     if r<widths_out[j] and c<widths_in[i]) for c in range(4)] for r in range(3)]
assert max(abs(a[r][c]-b[r][c]) for r in range(3) for c in range(4))<1e-12
# 连续预算可满足，而argmax离散结果超限；必须再验收。
expected=.4*2+.6*4
assert expected<=3.3 and 4>3.3
print(json.dumps(dict(joint=joint,sequential=sequential,mask_equivalence=True,
    expected_cost=expected,discrete_cost=4,cost_unit='synthetic, not latency',training_updates=0)))
