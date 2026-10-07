"""独立线性回归实验：初始化与总训练预算；不是作者LLM复现。"""
import json, random
rng=random.Random(5)
# 预训练/重训练/调参/评估明确分离，最后一项永不参与选择。
def data(n):
    rows=[]
    for _ in range(n):
        x=[rng.gauss(0,1),rng.gauss(0,.15),rng.gauss(0,1)]
        rows.append((x,2*x[0]-.8*x[1]+.02*x[2]))
    return rows
pre,train,tune,test=[data(n) for n in [100,100,60,80]]
def loss(w,rows):return sum((sum(a*b for a,b in zip(w,x))-y)**2 for x,y in rows)/len(rows)
def fit(w,rows,steps,lr,mask):
    w=w[:]
    for _ in range(steps):
        grad=[0.]*3
        for x,y in rows:
            e=sum(a*b for a,b in zip(w,x))-y
            for j in range(3):grad[j]+=2*e*x[j]/len(rows)
        for j in range(3):w[j]=(w[j]-lr*grad[j]) if mask[j] else 0.
    return w
parent=fit([0.,0.,0.],pre,200,.1,[1,1,1])
mask=[1,1,0];pruned=[v*m for v,m in zip(parent,mask)]
rows=[]
for name,start,steps in [('pruned_retrain',pruned,40),('scratch_equal_retrain',[0.,0.,0.],40),('scratch_total_steps',[0.,0.,0.],240)]:
    # 独立调参选择学习率；计数只是全批梯度步，不等价LLM tokens或FLOPs。
    candidates=[fit(start,train,steps,lr,mask) for lr in [.03,.1,.2]]
    selected=min(candidates,key=lambda w:loss(w,tune))
    rows.append({'name':name,'steps':steps,'test_mse':loss(selected,test),'weights':selected})
assert any(abs(a-b)>1e-8 for a,b in zip(parent,[0,0,0]))
assert all(r['weights'][2]==0 for r in rows)
print(json.dumps({'parent_steps':200,'parent':parent,'results':rows,
                  'checks':'PASS real updates, fixed mask, independent tune/test',
                  'caution':'equal steps is a toy budget, not compute/token equivalence; parent cost remains 200'},indent=2))
