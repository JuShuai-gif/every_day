import json, math, random
random.seed(7)
def mse(a,b):
    return sum((x-y)**2 for x,y in zip(a,b))/len(a)

import itertools, statistics
# 输入是合成谱，省略真实矩阵特征分解/FARMS；只检查Hill与预算优化。
spectra=[[1,1.2,2,4,16],[1,1.2,1.4,1.6,2],[1,2,3,5,9]]
def hill(x,k):
    x=sorted(x);den=sum(math.log(v/x[-k-1]) for v in x[-k:])/k
    if den<=0:raise ValueError('degenerate tail')
    return 1+1/den
alpha=[hill(x,3) for x in spectra];med=statistics.median(alpha);variance=[2.,.8,1.2];sizes=[8,16,8];budget=96
# gamma固定为1是机制简化，不声称论文的自适应gamma。
def cost(bits):return sum((med/a)*v*2**(-2*b) for a,v,b in zip(alpha,variance,bits))
feasible=[b for b in itertools.product(range(1,5),repeat=3) if sum(n*v for n,v in zip(sizes,b))<=budget]
best=min(feasible,key=cost);assert sum(n*b for n,b in zip(sizes,best))<=budget
try:hill([1,1,1],2);raise AssertionError('not rejected')
except ValueError:pass
print(json.dumps({'alpha':alpha,'bits':best,'payload_budget_bits':budget,'used_bits':sum(n*b for n,b in zip(sizes,best)),'objective':cost(best),'uniform3_objective':cost((3,3,3)),'scope':'nominal bit budget only; no packed model or inference'},indent=2))
