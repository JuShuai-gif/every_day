import json, math, random
random.seed(7)
def mse(a,b):
    return sum((x-y)**2 for x,y in zip(a,b))/len(a)

# 关系距离不识别整体旋转，teacher anchor补充绝对语义方向。
t=[[1.,0.],[0.,1.],[-1.,0.],[0.,-1.]];s=[[-y,x] for x,y in t]
def dot(a,b):return sum(x*y for x,y in zip(a,b))
def distances(x):return [math.sqrt(sum((a-b)**2 for a,b in zip(x[i],x[j]))) for i in range(len(x)) for j in range(i)]
def nce(x,y):
    logits=[[dot(a,b) for b in y] for a in x]
    def ce(rows):return sum(-row[i]+math.log(sum(math.exp(v) for v in row)) for i,row in enumerate(rows))/len(rows)
    return .5*(ce(logits)+ce(list(map(list,zip(*logits)))))
rel=mse(distances(s),distances(t));rot=nce(s,t);aligned=nce(t,t)
assert rel==0 and rot>aligned
print(json.dumps({'distance_mse_rotated':rel,'teacher_anchored_nce_rotated':rot,'teacher_anchored_nce_aligned':aligned,'training_updates':0,'scope':'loss invariance counterexample; no QAT or cross-attention training'},indent=2))
