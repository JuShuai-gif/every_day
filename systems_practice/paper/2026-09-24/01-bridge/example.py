import json, math, random
random.seed(7)
def mse(a,b):
    return sum((x-y)**2 for x,y in zip(a,b))/len(a)

# 独立机制例子：过剪后按校准输出误差逐个恢复原权重；没有RL或微调。
w=[.2,1.2,-.7,.1,.6,-.9]; x=[[random.gauss(0,1)*(j+1) for j in range(6)] for _ in range(96)]
def pred(ws,xs):return [sum(a*b for a,b in zip(ws,row)) for row in xs]
cal,test=x[:64],x[64:]; target=pred(w,cal); sparse=[0.0]*6; path=[]
for budget in range(6):
    candidates=[]
    for j in range(6):
        if sparse[j]==0:
            v=sparse.copy();v[j]=w[j];candidates.append((mse(pred(v,cal),target),j,v))
    score,j,sparse=min(candidates);path.append({'restored':j,'kept':budget+1,'cal_mse':score,'heldout_mse':mse(pred(sparse,test),pred(w,test))})
assert path[-1]['heldout_mse']==0 and all(path[i]['cal_mse']<=path[i-1]['cal_mse'] for i in range(1,6))
print(json.dumps({'path':path,'training_updates':0,'scope':'greedy restoration only; not BRIDGE policy'},indent=2))
