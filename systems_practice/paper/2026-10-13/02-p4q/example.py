"""独立小张量：选择器QDQ副本与保留分布校准；非P4Q原生代码。"""
import json
import math
import random

def cosine(a,b):
    d=math.sqrt(sum(x*x for x in a)*sum(x*x for x in b))
    return sum(x*y for x,y in zip(a,b))/max(d,1e-15)

def qdq(row,scale):
    if scale<=0: raise ValueError('scale must be positive')
    return [max(-7,min(7,round(x/scale)))*scale for x in row]

def select(tokens,budget,quant=True):
    if not 0<=budget<=len(tokens):raise ValueError('invalid budget')
    q=[1.,0.,0.,0.]
    # 本例per-tensor signed INT4 QDQ，不宣称等同作者全部配置。
    scale=max([abs(x) for row in tokens for x in row]+[1e-8])/7
    view=[qdq(row,scale) if quant else list(row) for row in tokens]
    query=qdq(q,scale) if quant else q
    rank=sorted(range(len(tokens)),key=lambda i:(-cosine(query,view[i]),i))
    nq=int(budget*0.3);ns=int(budget*0.2);chosen=rank[:nq]
    # 合成saliency只是输入，未运行视觉塔CLS attention。
    saliency=[1/(i+1) for i in range(len(tokens))]
    for i in sorted(range(len(tokens)),key=lambda i:(-saliency[i],i)):
        if i not in chosen and len(chosen)<nq+ns:chosen.append(i)
    while len(chosen)<budget:
        pool=[i for i in range(len(tokens)) if i not in chosen]
        i=min(pool,key=lambda j:(max([cosine(view[j],view[k]) for k in chosen]+[-1.]),j))
        chosen.append(i)
    # 模拟原始FP特征转发；QDQ仅参与选择。恢复原序保留位置语义。
    return sorted(chosen)

def samples(seed,count,shift=1):
    rng=random.Random(seed)
    out=[]
    for _ in range(count):
        x=[[rng.uniform(-1,1) for _ in range(4)] for _ in range(10)]
        x[-1]=[v*12*shift for v in x[-1]]
        out.append(x)
    return out

def retained(batch):return [row for tokens in batch for i,row in enumerate(tokens) if i in select(tokens,5)]
def mse(rows,s):return sum((a-b)**2 for row in rows for a,b in zip(row,qdq(row,s)))/(len(rows)*4)
def tune(rows):
    a=max(abs(v) for row in rows for v in row)
    return min([a*r/7 for r in (0.25,0.5,0.75,1.0)],key=lambda s:mse(rows,s))
def main():
    calibration=samples(41,16);evaluation=samples(42,16);shifted=samples(43,16,3)
    dense=[r for x in calibration for r in x];keep=retained(calibration)
    sd,sk=tune(dense),tune(keep)
    sets=[select(x,5) for x in evaluation]
    assert all(len(s)==5 and len(set(s))==5 for s in sets)
    assert select(evaluation[0],0)==[] and select(evaluation[0],10)==list(range(10))
    try:select(evaluation[0],11)
    except ValueError:pass
    else:raise RuntimeError('budget accepted')
    before=[list(r) for r in evaluation[0]];select(evaluation[0],5);assert before==evaluation[0]
    result={'dense_calibration_scale':sd,'retained_calibration_scale':sk,
      'heldout_retained_mse':{'dense':mse(retained(evaluation),sd),'retained':mse(retained(evaluation),sk)},
      'shifted_retained_mse':{'dense':mse(retained(shifted),sd),'retained':mse(retained(shifted),sk)},
      'changed_support_samples':sum(select(x,5,False)!=select(x,5,True) for x in evaluation),
      'boundary':'budgets 0,10,11 + no mutation pass','packed_storage':False,'training_updates':0}
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()
