"""独立两维残差示例：BI的尺度盲点与实际projector梯度更新，不是VLM复现。"""
import json
import math
import random

def mat(m, x): return [sum(a*b for a,b in zip(row,x)) for row in m]
def bi(x,y):
    nx=math.sqrt(sum(v*v for v in x)); ny=math.sqrt(sum(v*v for v in y))
    if nx==0 or ny==0: raise ValueError("zero norm excluded")
    return 1-sum(a*b for a,b in zip(x,y))/(nx*ny)
def target(x): return [2*x[0]+0.4*x[1], -0.2*x[0]+2*x[1]]
def student(p,x):
    z=mat(p,x)
    return [z[0]+0.2*z[1],-0.1*z[0]+z[1]]
def loss(p,data): return sum(sum((a-b)**2 for a,b in zip(student(p,x),target(x))) for x in data)/(2*len(data))
def main():
    rng=random.Random(19)
    cal=[[rng.uniform(-1,1) for _ in range(2)] for _ in range(32)]
    train=[[rng.uniform(-1,1) for _ in range(2)] for _ in range(64)]
    test=[[rng.uniform(-1,1) for _ in range(2)] for _ in range(31)]
    scores=[sum(bi(x,[2*v for v in x]) for x in cal)/len(cal),sum(bi([2*v for v in x],target(x)) for x in cal)/len(cal)]
    assert min(range(2),key=lambda i:scores[i])==0
    p=[[1.,0.],[0.,1.]]; before=loss(p,test); trace=[]
    # 被删除的第一块是2I。只更新projector，严格不用test挑步数或学习率。
    for step in range(200):
        grad=[[0.,0.],[0.,0.]]
        for x in train:
            pred=student(p,x); y=target(x); e=[pred[i]-y[i] for i in range(2)]
            dz=[e[0]-0.1*e[1],0.2*e[0]+e[1]]
            for i in range(2):
                for j in range(2): grad[i][j]+=dz[i]*x[j]/len(train)
        for i in range(2):
            for j in range(2): p[i][j]-=0.2*grad[i][j]
        if step in (0,9,49,199): trace.append([step+1,loss(p,train)])
    after=loss(p,test); assert after<before and p!=[[1.,0.],[0.,1.]]
    rejected=False
    try: bi([0.,0.],[1.,0.])
    except ValueError: rejected=True
    assert rejected
    print(json.dumps({"bi_scores":scores,"removed_layer":0,"eval_mse_before":before,"eval_mse_after":after,"actual_steps":200,"train_loss_trace":trace,"projector":p,"zero_norm_rejected":True,"scope":"synthetic CPU mechanism; no task accuracy/hardware performance"},indent=2))
if __name__=="__main__": main()
