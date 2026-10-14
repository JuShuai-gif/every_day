"""独立预算分配反例：只验证硬化，不实现论文可微训练或混合GEMM。"""
import json
import math

def allocate(scores,budget,cap=5):
    if not scores or sum(max(x,0) for x in scores)==0 or not 0<=budget<=len(scores)*cap:
        raise ValueError('infeasible budget or all-zero scores')
    total=sum(max(x,0) for x in scores)
    ideal=[max(x,0)/total*budget for x in scores]
    bits=[min(cap,int(x)) for x in ideal]
    while sum(bits)<budget:
        i=max((i for i in range(len(bits)) if bits[i]<cap),key=lambda i:(ideal[i]-bits[i],-i))
        bits[i]+=1
    return ideal,bits

def main():
    ideal,bits=allocate([9,4,1,.1],8)
    floor=[int(x) for x in ideal]
    assert sum(bits)==8 and sum(floor)<8 and all(0<=b<=5 for b in bits)
    # 对角矩阵是已知SVD；仅展示0bit去掉一整个分量，不能叫作者精度复现。
    sigma=[3,2,1,.1];discard=sum(s*s for s,b in zip(sigma,bits) if b==0)
    rejects=0
    for scores,budget in [([0,0],3),([1,2],11),([],0)]:
        try:allocate(scores,budget)
        except ValueError:rejects+=1
    assert rejects==3
    print(json.dumps(dict(ideal=ideal,floor_bits=floor,floor_sum=sum(floor),capped_apportion=bits,budget=sum(bits),discarded_diagonal_energy=discard,rejected=rejects,training_updates=False,gpu_run=False),indent=2))
if __name__=='__main__':main()
