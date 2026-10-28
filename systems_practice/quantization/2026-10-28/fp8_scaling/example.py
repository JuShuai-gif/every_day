import math, struct

def e4m3(x):
    # 独立教学编码：有限值、无 NaN；不是 torchao kernel。
    if x == 0: return 0
    s=1 if x<0 else 0; x=abs(x); e=max(-6,min(7,int(math.floor(math.log(x,2)))))
    m=round((x/(2**e)-1)*8); m=max(0,min(7,m)); return (s<<7)|((e+7)<<3)|m

def decode(q):
    if q==0:return 0.0
    s=-1 if q&128 else 1; e=((q>>3)&15)-7; m=q&7
    return s*(1+m/8)*(2**e)

def run():
    x=[-3.2,-1.0,-.2,0,.15,.9,2.7,12.0]
    scale=max(abs(v) for v in x)/448.0
    q=[e4m3(v/scale) for v in x]; y=[decode(a)*scale for a in q]
    mse=sum((a-b)**2 for a,b in zip(x,y))/len(x)
    print(f"fp8_e4m3 scale={scale:.9g} mse={mse:.9g} payload={len(q)}B+4B scale")
    assert math.isfinite(mse) and q[3]==0
if __name__=='__main__': run()
