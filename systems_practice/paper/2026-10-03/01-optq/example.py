"""独立二维校准几何实验；穷举格点而非作者OPTQ实现。"""
import itertools,json,math
w=(0.49,0.49)
cal=[(1.,1.),(2.,2.)]  # 有意秩亏，缺失(1,-1)方向
validation=[(1.,0.),(0.,1.),(1.,-1.)]
evaluation=[(0.5,-0.5),(2.,0.),(0.,2.),(-1.,1.)]
def mse(q,data):return sum(sum(x[i]*(q[i]-w[i]) for i in range(2))**2 for x in data)/len(data)
grid=list(itertools.product((-1.,0.,1.),repeat=2));rows=[]
for lam in (0.,0.1,1.,10.,1000.):
    q=min(grid,key=lambda q:sum(sum(x[i]*(q[i]-w[i]) for i in range(2))**2 for x in cal)+lam*sum((q[i]-w[i])**2 for i in range(2)))
    rows.append({'lambda':lam,'q':q,'calibration':mse(q,cal),'validation':mse(q,validation)})
best=min(rows,key=lambda r:r['validation']);test=mse(best['q'],evaluation)
# 明确构造经验风险为零、总体风险非零的方向，不宣称检验了概率定理。
r=(1.,-1.); empirical=sum(sum(a*b for a,b in zip(x,r))**2 for x in cal)
population=sum(v*v for v in r)
assert empirical==0 and population==2 and all(math.isfinite(v['validation']) for v in rows)
print(json.dumps({'grid_results':rows,'chosen_on_validation':best,'heldout_mse':test,'nullspace_empirical':empirical,'isotropic_population':population,'not_OPTQ_replication':True},indent=2))
