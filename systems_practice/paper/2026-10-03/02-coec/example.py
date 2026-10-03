"""独立2x2双侧旋转示例；网格搜索而非COEC的Stiefel/GCV求解器。"""
import math,json,random
rng=random.Random(23)
def mm(a,b):return [[sum(x*y for x,y in zip(row,col)) for col in zip(*b)] for row in a]
def rot(t):return [[math.cos(t),-math.sin(t)],[math.sin(t),math.cos(t)]]
def trans(a):return list(map(list,zip(*a)))
def loss(w,target,x):
    a,b=mm(w,x),mm(target,x)
    return sum((u-v)**2 for ar,br in zip(a,b) for u,v in zip(ar,br))/sum(v*v for row in b for v in row)
def data(n):return [[rng.gauss(0,1) for _ in range(n)] for _ in range(2)]
base=[[2.,0.],[0.,0.5]];target=mm(mm(rot(.4),base),rot(-.6));cal,tune,test=data(12),data(10),data(20)
angles=[i/10 for i in range(-10,11)]
l=min(angles,key=lambda a:loss(mm(rot(a),base),target,cal));one=mm(rot(l),base)
# 使用校准集拟合，两侧旋转保持奇异值；验证只用来选择是否采用。
l,r=min(((l,r) for l in angles for r in angles),key=lambda z:loss(mm(mm(rot(z[0]),base),rot(z[1])),target,cal))
two=mm(mm(rot(l),base),rot(r));selected=min([base,one,two],key=lambda w:loss(w,target,tune))
energy=lambda w:sum(v*v for row in w for v in row)
assert abs(energy(two)-energy(base))<1e-12
identity=mm(rot(l),trans(rot(l)));assert max(abs(identity[i][j]-(i==j)) for i in range(2) for j in range(2))<1e-12
# 反例：仅旋转无法恢复缺失的尺度；范数下界与任何正交选择无关。
scaled=[[3.,0.],[0.,.5]];lower=(math.sqrt(energy(scaled))-math.sqrt(energy(base)))**2
assert lower>0 and loss(two,target,test)<1e-20
print(json.dumps({'one_sided_test':loss(one,target,test),'two_sided_test':loss(two,target,test),'selected_test':loss(selected,target,test),'angles':[l,r],'preserved_frobenius_sq':energy(two),'scale_mismatch_error_lower_bound':lower,'not_full_COEC':True},indent=2))
