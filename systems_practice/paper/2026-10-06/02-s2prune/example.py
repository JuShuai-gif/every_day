"""独立覆盖约束+容量分配示例；不复刻作者Laplacian/ERC完整流程。"""
import json
import math

def allocate(scores,sizes,budget):
    if not scores or len(scores)!=len(sizes) or any(not math.isfinite(s) or s<0 for s in scores):
        raise ValueError('scores')
    if any(n<1 for n in sizes) or not len(scores)<=budget<=sum(sizes):raise ValueError('budget')
    counts=[1]*len(scores)
    # 简化的离散边际效用贪心；明确不同于作者largest remainder。
    while sum(counts)<budget:
        candidates=[i for i in range(len(scores)) if counts[i]<sizes[i]]
        i=max(candidates,key=lambda i:(scores[i]/counts[i],-counts[i],-i))
        counts[i]+=1
    return counts

def main():
    scores=[1,1,4,10];sizes=[4]*4
    cases=0
    for b in range(4,17):
        for s in [scores,[0]*4,[100,0,0,0]]:
            c=allocate(s,sizes,b);assert sum(c)==b and all(1<=n<=4 for n in c);cases+=1
    for b in (0,3,17):
        try:allocate(scores,sizes,b)
        except ValueError:pass
        else:raise AssertionError('bad budget')
    local_scores=[[0.1,0.2,0.4,0.3],[0.2,0.4,0.1,0.3],[1,2,3,4],[10,11,12,13]]
    budget=8;c=allocate(scores,sizes,budget)
    selected=[(g,i) for g in range(4) for i in sorted(range(4),key=lambda i:local_scores[g][i],reverse=True)[:c[g]]]
    global_top=sorted([(g,i) for g in range(4) for i in range(4)],key=lambda p:local_scores[p[0]][p[1]],reverse=True)[:budget]
    assert len(set(selected))==budget and len(set(g for g,i in selected))==4
    print(json.dumps({'cases':cases,'allocation':c,'coverage_regions':len(set(g for g,i in selected)),
        'global_top_coverage':len(set(g for g,i in global_top)),
        'retained_hidden_fp16_bytes':budget*64*2,'full_hidden_fp16_bytes':16*64*2,
        'index_int32_bytes':budget*4,'no_task_accuracy_or_kernel_speed_claim':True},indent=2))
if __name__=='__main__':main()
