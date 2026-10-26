"""独立CPU实验：分区softmax正确合并；不实现TQ3/FP8或作者runtime。"""
import json
import math

def partial(scores, values):
    if not scores or len(scores) != len(values): raise ValueError('nonempty matching partition required')
    m=max(scores); weights=[math.exp(s-m) for s in scores]; total=sum(weights)
    return m,total,sum(w*v for w,v in zip(weights,values))/total

def merge(states):
    m=max(s[0] for s in states)
    w=[math.exp(s[0]-m)*s[1] for s in states]
    return sum(a*s[2] for a,s in zip(w,states))/sum(w)

# 分区最大值相差很大：简单平均局部输出会错误地赋予低分区一半权重。
scores=[1000.,1001.,-1000.,-999.]; values=[1.,3.,-20.,-40.]
a=partial(scores[:2],values[:2]); b=partial(scores[2:],values[2:])
ref=partial(scores,values)[2]; merged=merge([a,b]); naive=(a[2]+b[2])/2
assert abs(ref-merged)<1e-12 and abs(ref-naive)>1
worst=0
for split in (1,2,3):
    for shift in (0,1234,-1234):
        shifted=[s+shift for s in scores]
        actual=merge([partial(shifted[:split],values[:split]),partial(shifted[split:],values[split:])])
        worst=max(worst,abs(actual-ref)); assert abs(actual-ref)<1e-12
try: partial([],[])
except ValueError: rejected=True
assert rejected
print(json.dumps({'reference':ref,'stable_merge':merged,'naive_average':naive,'worst_error_9_cases':worst,'empty_rejected':True,'scope':'Python CPU arithmetic only; no codec, model, training or GPU timing'},indent=2))
