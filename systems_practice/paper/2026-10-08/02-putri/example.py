"""独立单保留通道最小二乘真实权重更新，非Putri全模型复现。"""
import json
import random

def data(seed,sign):
    r=random.Random(seed);result=[]
    for _ in range(128):
        x=r.uniform(-1,1);z=sign*.8*x+r.uniform(-.05,.05);result.append((x,z))
    return result

def mse(rows,a):return sum((a*x-(x+2*z))**2 for x,z in rows)/len(rows)
cal,tune,test,shift=data(1,1),data(2,1),data(3,1),data(4,-1)
# 通道0能量大，删通道1；拟合使用校准集，ridge仅用tuning选择。
energies=[sum(row[i]**2 for row in cal) for i in range(2)]
assert energies[0]>energies[1]
h=sum(x*x for x,z in cal);xy=sum(x*(x+2*z) for x,z in cal)
candidates=[(mse(tune,xy/(h+lam)),lam,xy/(h+lam)) for lam in [0,.1,1,10]]
_,lam,updated=min(candidates)
assert abs(updated-1)>.5
assert mse(test,updated)<mse(test,1)
assert mse(shift,updated)>mse(shift,1)
# 零校准列不可求逆，明确拒绝而不是吞掉数值异常。
def solve(h,xy,lam):
    if h+lam<=0:raise ValueError('singular calibration')
    return xy/(h+lam)
try: solve(0,0,0)
except ValueError: pass
else: raise AssertionError('must reject singular case')
print(json.dumps({'kept_channel':0,'before_weight':1.,'updated_weight':updated,'lambda':lam,
                  'test_mse_before':mse(test,1),'test_mse_after':mse(test,updated),
                  'shift_mse_before':mse(shift,1),'shift_mse_after':mse(shift,updated),
                  'parameters_before':2,'parameters_after':1,
                  'scope':'independent CPU least squares, no GQA pruning/LLM/Thor run'},indent=2))
