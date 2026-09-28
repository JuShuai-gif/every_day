import json, math, random
random.seed(7)
def mse(a,b):
    return sum((x-y)**2 for x,y in zip(a,b))/len(a)

import itertools
# 两维收缩映射；离散系数与W8A8是不同概念，此例只演示离散局部求解。
def f(z):return [.3*z[0]+.1*z[1]+.7,.2*z[0]+.2*z[1]-.4]
def residual(z):return [a-b for a,b in zip(f(z),z)]
z=[0.,0.];r=residual(z);eta=1e-4;p=[]
for j in range(2):
    shifted=z.copy();shifted[j]+=eta;p.append([(a-b)/eta for a,b in zip(residual(shifted),r)])
def local(a):return .5*sum((r[j]+sum(a[k]*p[k][j] for k in range(2)))**2 for j in range(2))
grid=[-1+2*i/15 for i in range(16)]
a=min(itertools.product(grid,repeat=2),key=local);new=[z[i]+a[i] for i in range(2)]
exact=.5*sum(v*v for v in residual(new));assert abs(exact-local(a))<1e-10
assert exact<.5*sum(v*v for v in r)
print(json.dumps({'coefficients':a,'local_energy':local(a),'actual_energy':exact,'initial_energy':.5*sum(v*v for v in r),'codes_enumerated':256,'training_updates':0,'scope':'one local step; no implicit backward or W8A8 training'},indent=2))
