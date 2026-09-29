"""独立机制实验：训练W、D，退火到线性后合并；不是作者Transformer复现。"""
import math
import random

def matvec(a, x): return [sum(v*t for v,t in zip(row,x)) for row in a]
def mm(a,b): return [[sum(a[i][k]*b[k][j] for k in range(2)) for j in range(2)] for i in range(2)]
def data(seed):
    r = random.Random(seed)
    return [[r.uniform(-1,1) for _ in range(2)] for _ in range(32)]
p = [[.5,0],[0,.5]]
w = [[0.,0.],[0.,0.]]
d = [[1.,0.],[0.,1.]]
target = [[.8,-.2],[.3,.7]]
train, evaluation = data(17), data(91)
def combined(): return [[p[i][j]+w[i][j] for j in range(2)] for i in range(2)]
def forward(x, alpha):
    h = matvec(combined(), x)
    a = [alpha*max(0,v)+(1-alpha)*v for v in h]
    return matvec(d,a), h, a
def loss(xs,alpha):
    return sum(sum((a-b)**2 for a,b in zip(forward(x,alpha)[0],matvec(target,x))) for x in xs)/len(xs)
initial = loss(evaluation,0)
for step in range(240):
    alpha = step/20 if step<20 else (.5*(1+math.cos(math.pi*(step-20)/180)) if step<200 else 0.)
    gw,gd = [[0.,0.],[0.,0.]], [[0.,0.],[0.,0.]]
    for x in train:
        y,h,a = forward(x,alpha)
        e = [2*(y[i]-matvec(target,x)[i])/len(train) for i in range(2)]
        gh = [sum(d[i][j]*e[i] for i in range(2)) * ((1-alpha)+alpha*(h[j]>0)) for j in range(2)]
        for i in range(2):
            for j in range(2):
                gd[i][j] += e[i]*a[j]
                gw[i][j] += gh[i]*x[j]
    # 实际梯度更新辅助参数；P冻结，评估集不参与训练。
    for i in range(2):
        for j in range(2):
            w[i][j] -= .08*gw[i][j]
            d[i][j] -= .08*gd[i][j]
    if step in [0,19,199,239]: print('step',step,'alpha',round(alpha,6),'train_loss',loss(train,alpha))
merged = mm(d,combined())
err = max(abs(a-b) for x in evaluation for a,b in zip(matvec(merged,x),forward(x,0)[0]))
nonlinear_gap = max(abs(a-b) for x in evaluation for a,b in zip(matvec(merged,x),forward(x,1)[0]))
assert err < 1e-12 and nonlinear_gap > 1e-4
assert loss(evaluation,0) < initial
print('PASS initial_eval',initial,'final_eval',loss(evaluation,0),'merge_max_abs',err,'alpha1_merge_gap',nonlinear_gap)
print('240 actual updates; FP64 Python arithmetic; no model/board performance claim')
