"""独立二次目标示例：非作者SparseGPT实现，不代表社会偏差评估。"""
import json

def hessian(pairs, alpha):
    h = [[0.1, 0.0], [0.0, 0.1]]  # damping避免秩亏
    for x, y in pairs:
        d = [a-b for a,b in zip(x,y)]
        for i in range(2):
            for j in range(2):
                h[i][j] += x[i]*x[j]+y[i]*y[j]+2*alpha*d[i]*d[j]
    return h

def invert(h):
    det=h[0][0]*h[1][1]-h[0][1]*h[1][0]
    if det <= 0:
        raise ValueError('positive definite Hessian required')
    return [[h[1][1]/det,-h[0][1]/det],[-h[1][0]/det,h[0][0]/det]]

def loss(d,h):
    return sum(d[i]*h[i][j]*d[j] for i in range(2) for j in range(2))/2

pairs=[([1.,2.],[1.,-2.]),([2.,1.],[2.,-1.])]
w=[1.,0.8]
rows=[]
for alpha in [0.,1.]:
    h=hessian(pairs,alpha); inv=invert(h)
    scores=[w[i]**2/(2*inv[i][i]) for i in range(2)]
    p=min(range(2),key=lambda i:scores[i])
    delta=[-w[p]*inv[i][p]/inv[p][p] for i in range(2)]
    assert abs(w[p]+delta[p])<1e-12
    assert abs(loss(delta,h)-scores[p])<1e-12
    # 沿保留维扰动，验证约束解确为此二次目标最小值。
    for shift in [-1.,-.1,.1,1.]:
        other=delta.copy();other[1-p]+=shift
        assert loss(other,h)>loss(delta,h)
    rows.append(dict(alpha=alpha,hessian=h,scores=scores,pruned=p,objective=loss(delta,h)))
assert rows[0]['pruned']!=rows[1]['pruned']
assert hessian([([1.,2.],[1.,2.])],0)==hessian([([1.,2.],[1.,2.])],1)
try:
    invert([[0.,0.],[0.,0.]])
except ValueError:
    pass
else:
    raise AssertionError('singular input accepted')
print(json.dumps(dict(results=rows,identical_pair_and_singular_checks='PASS',scope='CPU independent 2D quadratic model'),indent=2))
