#!/usr/bin/env python3
"""独立标量机制例：固定层输入下验证RAZOR Eq2/3，非作者模型。"""
import json
import math
import random

def damage(values, weights, removed, refill_value=0., refill_weight=0.):
    if len(values)!=len(weights) or not values or any(w<0 for w in weights) or abs(sum(weights)-1)>1e-10:
        raise ValueError('normalized weights required')
    c=sum(w*f for w,f in zip(weights,values))
    wi=weights[removed]
    denominator=1-wi+refill_weight
    if denominator<=0 or refill_weight<0:
        raise ValueError('no surviving mass')
    predicted=abs(wi*(values[removed]-c)-refill_weight*(refill_value-c))/denominator
    # 独立oracle：直接重新构造存活集合，不复用残差公式。
    actual=abs(c-(sum(w*f for j,(w,f) in enumerate(zip(weights,values)) if j!=removed)+refill_weight*refill_value)/denominator)
    assert math.isclose(predicted,actual,rel_tol=1e-10,abs_tol=1e-10)
    return predicted

r=random.Random(34)
for _ in range(1000):
    v=[r.uniform(-10,10) for _ in range(4)]
    w=[r.random()+.01 for _ in v]; total=sum(w); w=[x/total for x in w]
    damage(v,w,r.randrange(4),r.uniform(-10,10),r.random())
a=[damage([8,3,10],[1/3]*3,j) for j in range(3)]
b=[damage([8,3,-10],[1/3]*3,j) for j in range(3)]
assert min(range(3),key=a.__getitem__)==0 and min(range(3),key=b.__getitem__)==1
# 新增refill恰好补偿删除残差时，局部损失为零；并非全模型不变保证。
compensated=damage([1,3],[.5,.5],0,1,.5)
assert compensated==0
try:
    damage([3],[1],0)
except ValueError:
    rejected=True
else:
    raise AssertionError('missing zero denominator rejection')
print(json.dumps({'identity_checks':1000,'same_norm_case_a':a,'same_norm_case_b':b,
 'refill_exact_compensation':compensated,'zero_mass_rejected':rejected,
 'scope':'independent CPU scalar formula; no model training, pruning export, or hardware timing'},indent=2))
