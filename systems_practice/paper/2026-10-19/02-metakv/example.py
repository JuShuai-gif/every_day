"""独立选择器实验；输入全为合成预测/观测，不训练LightGBM，不运行LLM。"""
import json
import math

def select(rows, latency, memory, source_rule=False):
    if latency<=0 or memory<=0 or not rows: raise ValueError("positive budgets and candidates required")
    if any(not all(math.isfinite(r[k]) and r[k]>=0 for k in ("l","m","p")) or r["p"]>1 for r in rows): raise ValueError("invalid prediction")
    valid=[r for r in rows if r["l"]<=latency and r["m"]<=memory]
    if valid:
        baseline=[r for r in valid if r["family"]=="fp16"]
        if baseline: return baseline[0],True
        # 每个方法先保留最温和压缩，再比较正确概率。
        per={}
        for r in valid:
            if r["family"] not in per or r["rank"]<per[r["family"]]["rank"]: per[r["family"]]=r
        return max(per.values(),key=lambda r:r["p"]),True
    def violation(r):
        a,b=r["l"]/latency,r["m"]/memory
        return max(a-1,0)+max(b-1,0) if source_rule else a+b
    return min(rows,key=lambda r:(violation(r),-r["p"])),False

def main():
    rows=[dict(name="fp16",family="fp16",rank=0,l=2.,m=4.,p=.9),dict(name="q8",family="quant",rank=0,l=3.,m=2.,p=.8),dict(name="q4",family="quant",rank=1,l=2.8,m=1.,p=.85),dict(name="evict",family="evict",rank=0,l=1.,m=2.5,p=.7)]
    a,ok=select(rows,4,5); assert a["name"]=="fp16" and ok
    b,ok=select(rows,4,2); assert b["name"]=="q8" and ok
    # 论文sum ratio与仓库clipped excess不是同一规则，构造确定的选择翻转。
    mismatch=[dict(name="A",family="q",rank=0,l=1.8,m=.1,p=.5),dict(name="B",family="e",rank=0,l=1.1,m=1.1,p=.5)]
    paper,pok=select(mismatch,1,1); source,sok=select(mismatch,1,1,True)
    assert paper["name"]=="A" and source["name"]=="B" and not pok and not sok
    # 预测可行不代表真实可行；这里实际延迟是合成反例，绝非实测毫秒。
    predicted=dict(name="drift",family="quant",rank=0,l=.9,m=.9,p=.95)
    chosen,feasible=select([predicted],1,1); actual_l,actual_m,correct=1.2,.9,True
    csr=int(correct and actual_l<=1 and actual_m<=1); assert feasible and csr==0
    rejects=0
    for candidates,l,m in [([],1,1),(rows,0,1),([dict(predicted,l=float("nan"))],1,1)]:
        try: select(candidates,l,m)
        except ValueError: rejects+=1
    assert rejects==3
    print(json.dumps({"baseline_priority":a["name"],"least_compressed_per_method":b["name"],"no_feasible_paper":paper["name"],"no_feasible_source":source["name"],"drift_predicted_feasible":feasible,"synthetic_actual_CSR":csr,"rejections":rejects,"scope":"synthetic selection only; no compression/predictor training/device timing"},indent=2))
if __name__=="__main__": main()
