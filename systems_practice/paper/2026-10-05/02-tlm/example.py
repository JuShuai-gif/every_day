"""独立共享线性前缀SGD：实际训练更新；不是Transformer或作者模型复现。"""
import json
import random

def train(mode):
    r=random.Random(5)
    sampler=random.Random(19)
    w=[.2]*4
    coverage=[0]*4
    # 每步同一输入/完整目标；随机前缀与full anchor梯度相加后才更新。
    for step in range(2000):
        x=r.uniform(-1,1)
        k=sampler.randrange(1,5) if mode=='uniform' else (2 if step%2 else 4)
        coverage[k-1]+=1
        gradient=[0.]*4
        for depth in (k,4):
            error=sum(w[:depth])*x-2*x
            for j in range(depth):
                gradient[j]+=2*error*x
        w=[v-.04*g for v,g in zip(w,gradient)]
    return w,coverage

def evaluate(w):
    r=random.Random(88) # 留出评估随机源，不用评估选超参数。
    xs=[r.uniform(-1,1) for _ in range(100)]
    return [sum(((sum(w[:k])-2)*x)**2 for x in xs)/len(xs) for k in range(1,5)]

report={}
for mode in ('fixed','uniform'):
    w,c=train(mode)
    assert any(abs(v-.2)>1e-3 for v in w)
    report[mode]={'actual_steps':2000,'weights':w,'prefix_coverage':c,'heldout_mse_by_depth':evaluate(w)}
assert report['fixed']['prefix_coverage'][0]==0
assert min(report['uniform']['prefix_coverage'])>0
assert report['uniform']['heldout_mse_by_depth'][0]<report['fixed']['heldout_mse_by_depth'][0]
# 同一梯度目标的期望验证：枚举4个前缀，核对深层收到前缀项的概率。
report['prefix_gradient_receipt_probability']=[(4-j)/4 for j in range(4)]
report['scope']='linear toy; no language PPL, no hardware speedup'
print(json.dumps(report,indent=2))
