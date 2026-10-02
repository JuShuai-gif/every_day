"""独立2维OBS闭式更新，验证论文paired Hessian项；非作者SparseGPT。"""
import json

def hessian(x0,x1,alpha):
    assert len(x0)==len(x1) and all(len(x)==2 for x in x0+x1)
    h=[[0.,0.],[0.,0.]]
    for a,b in zip(x0,x1):
        for i in range(2):
            for j in range(2):h[i][j]+=a[i]*a[j]+b[i]*b[j]+2*alpha*(a[i]-b[i])*(a[j]-b[j])
    return h

def inverse(h):
    det=h[0][0]*h[1][1]-h[0][1]*h[1][0]
    if det<=1e-12:raise ValueError('singular Hessian; damping/data coverage required')
    return [[h[1][1]/det,-h[0][1]/det],[-h[1][0]/det,h[0][0]/det]]

def dot(a,b):return sum(x*y for x,y in zip(a,b))
x0=[[1.,1.],[2.,0.],[1.,-1.]];x1=[[-1.,1.],[-2.,0.],[-1.,-1.]];w=[.5,1.]
rows=[]
for alpha in [0,1]:
    h=hessian(x0,x1,alpha);inv=inverse(h)
    scores=[w[p]**2/(2*inv[p][p]) for p in range(2)];p=min(range(2),key=lambda p:scores[p])
    delta=[-w[p]*inv[i][p]/inv[p][p] for i in range(2)]
    pruned=[w[i]+delta[i] for i in range(2)];assert abs(pruned[p])<1e-12
    quadratic=.5*dot(delta,[dot(row,delta) for row in h])
    explicit=sum(.5*(dot(delta,a)**2+dot(delta,b)**2)+alpha*dot(delta,[a[i]-b[i] for i in range(2)])**2 for a,b in zip(x0,x1))
    assert abs(explicit-quadratic)<1e-12 and abs(quadratic-scores[p])<1e-12
    rows.append(dict(alpha=alpha,H=h,scores=scores,pruned_index=p,weights=pruned,objective=explicit))
assert rows[0]['pruned_index']!=rows[1]['pruned_index']
assert hessian(x0,x0,0)==hessian(x0,x0,1)
try:inverse([[0.,0.],[0.,0.]])
except ValueError:pass
else:raise AssertionError('singular not rejected')
print(json.dumps(dict(cases=rows,objective_identity=True,singular_rejected=True,
    interpretation='preserves paired response differences, not guaranteed social fairness')))
