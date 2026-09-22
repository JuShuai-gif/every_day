#!/usr/bin/env python3
"""独立标准库实验：有界容量分配、Hamilton取整与物理专家/路由同步裁剪。"""
import json
import math
import random
import struct


def js(p, q):
    if len(p) != len(q) or not p or min(p+q) < 0:
        raise ValueError('invalid distributions')
    if not math.isclose(sum(p), 1) or not math.isclose(sum(q), 1):
        raise ValueError('distributions must sum to one')
    m = [(a+b)/2 for a,b in zip(p,q)]
    def kl(x):
        return sum(a*math.log2(a/b) for a,b in zip(x,m) if a)
    return (kl(p)+kl(q))/2


def allocate(scores, budget, experts=6, active=2):
    layers=len(scores)
    if not layers or any(not math.isfinite(x) or x < 0 for x in scores):
        raise ValueError('invalid score')
    if not layers*active <= budget <= layers*experts:
        raise ValueError('impossible capacity budget')
    c=[float(active)]*layers
    left=float(budget-layers*active)
    while left > 1e-10:
        free=[i for i in range(layers) if c[i] < experts-1e-10]
        total=sum(scores[i] for i in free)
        # 论文未定义全零分歧；本例独立选择均分，保证预算守恒。
        increments={i:left*(scores[i]/total if total else 1/len(free)) for i in free}
        used=0.0
        for i in free:
            add=min(experts-c[i],increments[i])
            c[i]+=add
            used+=add
        if used <= 0:
            raise RuntimeError('capacity allocator stalled')
        left-=used
    integer=[int(math.floor(x+1e-10)) for x in c]
    remaining=budget-sum(integer)
    order=sorted(range(layers),key=lambda i:(-(c[i]-integer[i]),i))
    for i in order:
        if remaining and integer[i] < experts:
            integer[i]+=1
            remaining-=1
    assert remaining == 0 and sum(integer) == budget
    assert all(active <= x <= experts for x in integer)
    return integer


def infer(experts, router, x, active=2):
    logits=[sum(a*b for a,b in zip(row,x)) for row in router]
    selected=sorted(range(len(logits)),key=lambda i:(-logits[i],i))[:active]
    mx=max(logits[i] for i in selected)
    weights=[math.exp(logits[i]-mx) for i in selected]
    den=sum(weights)
    return sum(w/den*sum(a*b for a,b in zip(experts[i],x)) for w,i in zip(weights,selected))


def main():
    english=[[1/6]*6 for _ in range(3)]
    target=[[.5,.2,.1,.1,.05,.05],[.2,.2,.2,.15,.15,.1],[.7,.1,.05,.05,.05,.05]]
    scores=[js(a,b) for a,b in zip(english,target)]
    capacities=allocate(scores,12)
    # 饱和再分配、全零分歧、总预算两端及所有整数预算。
    for s in (scores,[0,0,0],[100,0,0],[1,1,1]):
        for budget in range(6,19):
            allocate(s,budget)
    for budget in (5,19):
        try:
            allocate(scores,budget)
        except ValueError:
            pass
        else:
            raise AssertionError('invalid budget accepted')
    assert js([1,0],[0,1]) == 1 and js([1,0],[1,0]) == 0
    rng=random.Random(9)
    weights=[[[rng.uniform(-1,1) for _ in range(2)] for _ in range(6)] for _ in range(3)]
    router=[[[rng.uniform(-1,1) for _ in range(2)] for _ in range(6)] for _ in range(3)]
    ids=[sorted(range(6),key=lambda i:(-target[l][i],i))[:capacities[l]] for l in range(3)]
    kept=[[weights[l][i] for i in ids[l]] for l in range(3)]
    routes=[[router[l][i] for i in ids[l]] for l in range(3)]
    # 同步裁剪 router 和 expert，验证新编号对应原编号。
    for l in range(3):
        for new, old in enumerate(ids[l]):
            assert kept[l][new] == weights[l][old] and routes[l][new] == router[l][old]
    def payload(a,b):
        flat=[v for data in (a,b) for layer in data for row in layer for v in row]
        return struct.pack('<'+'f'*len(flat),*flat)
    full_blob, pruned_blob=payload(weights,router),payload(kept,routes)
    # 真实 FP32 payload，不是 MXFP4，也不包含模型配置/元数据。
    assert len(pruned_blob) == sum(capacities)*4*4
    r=random.Random(91)
    xs=[[r.gauss(0,1),r.gauss(0,1)] for _ in range(64)]
    mse=sum((infer(weights[l],router[l],x)-infer(kept[l],routes[l],x))**2
            for l in range(3) for x in xs)/(3*len(xs))
    print(json.dumps({'scope':'independent scalar CPU example; no recovery SFT, MXFP4, language metric, or hardware speedup',
                      'js_scores':scores,'capacities':capacities,'retained_original_ids':ids,
                      'full_fp32_payload_bytes':len(full_blob),'pruned_fp32_payload_bytes':len(pruned_blob),
                      'active_experts_per_token_before_after':[2,2],'synthetic_output_mse':mse,
                      'capacity_cases_passed':52,'invalid_budgets_rejected':2},indent=2))


if __name__ == '__main__':
    main()
