"""独立实现论文式9-12的选择规则；输入为合成特征/注意力，不加载VLM。"""
import json
import math

def select(features, weights, budget):
    n=len(features)
    if n==0 or len(weights)!=n or not 0<=budget<=n or any(w<0 or not math.isfinite(w) for w in weights) or sum(weights)<=0:
        raise ValueError('invalid input')
    norm=[]
    for x in features:
        d=math.sqrt(sum(v*v for v in x))
        if d==0 or not math.isfinite(d):raise ValueError('zero/nonfinite feature')
        norm.append([v/d for v in x])
    chosen=[]
    distance=[1.0]*n
    for _ in range(budget):
        j=max((i for i in range(n) if i not in chosen),key=lambda i:weights[i]*distance[i])
        chosen.append(j)
        for i in range(n):
            distance[i]=min(distance[i],max(0.0,1-sum(a*b for a,b in zip(norm[i],norm[j])))) if len(chosen)>1 else max(0.0,1-sum(a*b for a,b in zip(norm[i],norm[j])))
    return sorted(chosen)

features=[[1,0],[.999,.001],[0,1],[-1,0]]
# 两个head的最后query attention求和，归一化只改变公共因子。
heads=[[.40,.35,.20,.05],[.38,.36,.21,.05]]
w=[sum(h[i] for h in heads) for i in range(4)]
s=sum(w);w=[x/s for x in w]
chosen=select(features,w,2)
top=sorted(sorted(range(4),key=lambda i:w[i],reverse=True)[:2])
assert chosen==[0,2] and top==[0,1]
assert select(features,w,0)==[] and select(features,w,4)==[0,1,2,3]
# 偏移的真实需求集中在token1时，coverage选择仍可能漏掉必要证据。
shift_required=1
assert shift_required not in chosen and shift_required in top
rejected=0
for args in [([[0,0]],[1],1),(features,w,5),(features,[0]*4,2)]:
    try:select(*args)
    except ValueError:rejected+=1
assert rejected==3
print(json.dumps(dict(selected=chosen,topk=top,rejections=rejected,shift_failure=True,
 payload_fp16_bytes=dict(full=4*2*2,selected=2*2*2,selected_with_u32_indices=2*2*2+2*4),
 scope='independent selection only; no VLM accuracy/edge-cloud latency/author code reproduction'),indent=2))
