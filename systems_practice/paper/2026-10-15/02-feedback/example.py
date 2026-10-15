"""独立二维联合旋转/反馈例；固定trace噪声假设不保证有限格逐样本误差。"""
import json
import math

H = (4.,1.)
c,s = math.sqrt(2/3),math.sqrt(1/3)
g = math.sqrt(2)/2
# R=[[c,s],[-s,c]], R H R^T=[[3,-sqrt2],[-sqrt2,2]]。
def quant(v):
    return min(.5,max(-1.,round(v/.5)*.5))

def plain(w):
    e=[quant(w[i])-w[i] for i in range(2)]
    return sum(H[i]*e[i]**2 for i in range(2))

def joint(w):
    z=[c*w[0]+s*w[1],-s*w[0]+c*w[1]]
    q0=quant(z[0])-z[0]
    b1=z[1]+g*q0
    q1=quant(b1)-b1
    ez=[q0,g*q0+q1]
    assert abs(ez[1]-(quant(b1)-z[1]))<1e-12
    e=[c*ez[0]-s*ez[1],s*ez[0]+c*ez[1]]
    return sum(H[i]*e[i]**2 for i in range(2)),b1 < -1 or b1 > .5

trace_plain=sum(H)
trace_joint=3-2*math.sqrt(2)*g+2*g*g+2
bound=2*math.sqrt(H[0]*H[1])
assert abs(trace_joint-bound)<1e-12 and trace_joint<trace_plain
better=worse=equal=saturations=0
example=None
for i in range(-19,20):
    for j in range(-19,20):
        w=[i/20,j/20]
        a=plain(w);b,sat=joint(w)
        saturations+=int(sat)
        if b < a-1e-12:
            better+=1
        elif b > a+1e-12:
            worse+=1
            if example is None:
                example={'w':w,'plain_error':a,'joint_error':b,'feedback_overload':sat}
        else:
            equal+=1
assert better and worse and saturations and better+worse+equal==1521
print(json.dumps({'g':g,'trace_plain':trace_plain,'trace_joint':trace_joint,'trace_bound':bound,
                  'better':better,'worse':worse,'equal':equal,'feedback_overloads':saturations,
                  'counterexample':example,'scope':'fixed-grid PTQ mechanism; no QAT/model/native backend'},indent=2))
