"""独立防御性回归：同一输入比较发布前后阈值行为，不构造后门。"""
import json, math
# 已冻结scale；两个权重落进同一个量化格子，数值接近不保证边界行为相同。
scale=.5
q=lambda w:round(w/scale)*scale
weights=[.76,1.24]
assert q(weights[0])==q(weights[1])==1.
x=[.25,.5,.75,1.,1.25]
threshold=1.1
rows=[]
for w in weights:
    before=[w*v for v in x];after=[q(w)*v for v in x]
    changed=[i for i,(a,b) in enumerate(zip(before,after)) if (a>=threshold)!=(b>=threshold)]
    bound=[abs(a-b) for a,b in zip(before,after)]
    # 只有误差严格小于决策间距才保证本次阈值不变。
    certified=[i for i,(a,e) in enumerate(zip(before,bound)) if e<abs(a-threshold)]
    assert all(i not in changed for i in certified)
    rows.append({'weight':w,'quantized':q(w),'changed_indices':changed,'certified_indices':certified,
                 'max_abs':max(bound)})
assert rows[0]['changed_indices'] and rows[1]['changed_indices']
print(json.dumps({'results':rows,'checks':'PASS frozen quantizer cell and margin gate',
                  'scope':'no training, no attack model, no author artifact replication'},indent=2))
