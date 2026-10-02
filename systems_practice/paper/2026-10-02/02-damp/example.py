"""独立误差脉冲/预算模型；不是DAMP量化器、真实模型或GPU kernel。"""
import json
import math
energy=[4.,1.,.1,.05]
retention=[.1,.99,.8,.5]
tau=1e-3

def risk(e,a):
    if e<0 or not 0<=a<=1:
        raise ValueError('invalid energy/retention')
    return e/max(1-a*a,tau)

scores=[risk(e,a) for e,a in zip(energy,retention)]
protect_energy=max(range(4),key=energy.__getitem__)
protect_risk=max(range(4),key=scores.__getitem__)
assert protect_energy==0 and protect_risk==1
# 对独立单次误差注入，直接传播3000步，核对未截断的几何能量。
observed=[]
for e,a in zip(energy,retention):
    x=math.sqrt(e);total=0.
    for _ in range(3000):
        total+=x*x;x*=a
    expected=e/(1-a*a)
    assert math.isclose(total,expected,rel_tol=1e-12)
    observed.append(total)
remaining=lambda p:sum(scores[i] for i in range(4) if i!=p)
assert remaining(protect_risk)==min(remaining(i) for i in range(4))
# 共同衰减相当于相同比例，GDN同一head内不会改变排序。
common=[risk(e,.9) for e in energy]
assert max(range(4),key=common.__getitem__)==protect_energy
assert risk(1.,1.)==1000 and risk(0.,1.)==0
try:
    risk(1.,1.1)
except ValueError:
    pass
else:
    raise AssertionError('invalid retention accepted')
print(json.dumps(dict(injection_energy=energy,retention=retention,risk=scores,finite_impulse_energy=observed,
                     protect_energy=protect_energy,protect_risk=protect_risk,
                     remaining_energy_only=remaining(protect_energy),remaining_risk=remaining(protect_risk),
                     common_decay_and_unit_boundary='PASS',scope='CPU scalar proxy; no measured compression or model accuracy'),indent=2))
