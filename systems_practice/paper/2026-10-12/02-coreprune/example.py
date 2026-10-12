#!/usr/bin/env python3
"""独立固定attention机制例；集合边际不等于单点重要性，无作者API调用。"""
import itertools
import json
import math

# 额外text token永远保留，确保初始virtual deletion不会删除全部attention mass。
weights=[.12,.18,.15,.20,.35]
values=[-3.,1.,4.,-2.,.7]
c=sum(a*v for a,v in zip(weights,values))

def distortion(deleted):
    mass=sum(weights[i] for i in deleted)
    if mass>=1-1e-12:
        raise ValueError('zero surviving attention mass')
    residual=sum(weights[i]*(values[i]-c) for i in deleted)
    predicted=abs(residual)/(1-mass)
    direct=sum(weights[i]*values[i] for i in range(5) if i not in deleted)/(1-mass)
    assert math.isclose(predicted,abs(direct-c),abs_tol=1e-12)
    return predicted

def rescue(deleted, i):
    return distortion(deleted)-distortion(deleted-{i})

def reverse_greedy(keep):
    deleted=set(range(4))
    for _ in range(keep):
        best=max(sorted(deleted),key=lambda i:rescue(deleted,i))
        deleted.remove(best)
    return sorted(set(range(4))-deleted),distortion(deleted)

all_cases=[]
for n in range(5):
    for combo in itertools.combinations(range(4),n):
        all_cases.append(distortion(set(combo)))
static_keep=sorted(range(4),key=lambda i:distortion({i}),reverse=True)[:2]
static_error=distortion(set(range(4))-set(static_keep))
conditional_keep,conditional_error=reverse_greedy(2)
opt_error,opt_deleted=min((distortion(set(s)),s) for s in itertools.combinations(range(4),2))
# 保留不保证单调改善的反例：两个残差互相抵消，救回一个反而增加扰动。
negative_marginals=[(sorted(s),i,rescue(s,i)) for s in [set(x) for x in itertools.combinations(range(4),2)] for i in s if rescue(s,i)<0]
assert negative_marginals
try: distortion(set(range(5)))
except ValueError: rejected=True
else: raise AssertionError('denominator guard')
print(json.dumps({'subset_identities':len(all_cases),'static_keep':static_keep,'static_error':static_error,
 'conditional_keep':conditional_keep,'conditional_error':conditional_error,'exhaustive_optimum':opt_error,
 'negative_rescue_marginals':negative_marginals,'all_removed_rejected':rejected,
 'scope':'one head/receiver, fixed attention, B=1 rescue; no depth refresh or full model reproduction'},indent=2))
