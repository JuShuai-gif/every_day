import json, math, random
random.seed(7)
def mse(a,b):
    return sum((x-y)**2 for x,y in zip(a,b))/len(a)

# 独立LIF轨迹反例：weight MSE与spike时序偏差不是同一优化目标。
w=[.61,.32,.14];seq=[[random.randrange(2) for _ in w] for _ in range(64)]
def spikes(ws,xs):
    u=0.;out=[]
    for x in xs:
        u=.8*u+sum(a*b for a,b in zip(ws,x));fire=int(u>=1.);out.append(fire)
        if fire:u=0.
    return out
def quant(alpha):return [alpha/3*round(3*max(-1,min(1,math.tanh(a)/alpha))) for a in w]
base=[math.tanh(v) for v in w];cal,test=seq[:32],seq[32:]
rows=[]
for alpha in [.25,.35,.45,.55,.65,.75,.85]:
    qw=quant(alpha);rows.append({'alpha':alpha,'weight_mse':mse(qw,base),'cal_spike_mismatch':sum(a!=b for a,b in zip(spikes(qw,cal),spikes(base,cal))),'test_spike_mismatch':sum(a!=b for a,b in zip(spikes(qw,test),spikes(base,test)))})
selected=min(rows,key=lambda r:(r['cal_spike_mismatch'],r['weight_mse']))
assert spikes([0,0,0],seq)==[0]*64
print(json.dumps({'sweep':rows,'selected_on_calibration':selected['alpha'],'training_updates':0,'scope':'scale sweep only; no TSC surrogate-gradient training or BIC pruning'},indent=2))
