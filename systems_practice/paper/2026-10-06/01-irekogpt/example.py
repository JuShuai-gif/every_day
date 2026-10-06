"""独立二维多宽度岭回归示例；没有PCA、Transformer或作者代码执行。"""
import random
import json

def data(seed,count,sign=1):
    r=random.Random(seed)
    return [(x:=r.gauss(0,1),sign*0.8*x+r.gauss(0,0.3)) for _ in range(count)]
def fit(rows,lam):
    # 两种前缀width=1/2共同拟合残差，正则限制相对原始权重的改动。
    a=b=c=u=v=0.0
    for x,y in rows:
        target=x+2*y
        for width in (1,2):
            z=y if width==2 else 0
            residual=target-(x+2*z)
            a+=x*x;b+=x*z;c+=z*z;u+=x*residual;v+=z*residual
    a+=lam;c+=lam;det=a*c-b*b
    if det<=1e-15:raise ValueError('singular')
    return (1+(c*u-b*v)/det,2+(a*v-b*u)/det)
def mse(rows,w,width):
    return sum((w[0]*x+(w[1]*y if width==2 else 0)-(x+2*y))**2 for x,y in rows)/len(rows)
def main():
    cal,tune,test=data(1,64),data(2,48),data(3,80)
    candidates=[(lam,fit(cal,lam)) for lam in (0.01,1,10,100)]
    lam,w=min(candidates,key=lambda v:sum(mse(tune,v[1],d) for d in (1,2)))
    assert all(abs(a-b)<1e-9 for a,b in zip(fit([(1,0),(-1,0)],1),(1,2)))
    report={}
    for label,rows in [('iid',test),('shifted',data(4,80,-1))]:
        report[label]={str(d):{'baseline':mse(rows,(1,2),d),'ridge':mse(rows,w,d)} for d in (1,2)}
    print(json.dumps({'lambda_selected_on_tune':lam,'weights':w,'results':report,
        'actual_closed_form_parameter_update':True,'full_model_reproduction':False},indent=2))
if __name__=='__main__':main()
