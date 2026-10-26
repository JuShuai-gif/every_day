"""独立CPU反例：离线选head再保留token；不复现作者的完整校准/模型。"""
import json
import struct
from pathlib import Path

def top(scores,budget):
    if not 0<budget<=len(scores): raise ValueError('budget')
    return sorted(range(len(scores)),key=lambda i:(-scores[i],i))[:budget]

def score(heads,selected):
    return [sum(heads[h][i] for h in selected)/len(selected) for i in range(len(heads[0]))]

# 离线校准以答案span质量选择head；评估数据与校准分开。
cal=[[.45,.02,.02,.02,.04,.45],[.1,.1,.35,.3,.05,.1],[.4,.05,.05,.05,.05,.4]]
selected=top([sum(h[2:4]) for h in cal],1)
eval_heads=[[.46,.01,.02,.02,.03,.46],[.08,.1,.4,.3,.04,.08],[.44,.02,.03,.03,.04,.44]]
full_pool=top(score(eval_heads,[0,1,2]),2)
retained=top(score(eval_heads,selected),2)
assert full_pool==[0,5] and retained==[2,3]
# 真正写出保留token的FP16 K/V及uint16位置，不把Python list体积当压缩数据。
kv=[(i/10,(i+1)/10) for i in range(6)]
payload=b''.join(struct.pack('<Hee',i,*kv[i]) for i in retained)
out=Path(__file__).resolve().parent/'build';out.mkdir(exist_ok=True)
(out/'retained.dat').write_bytes(payload)
loaded=[struct.unpack('<Hee',payload[i:i+6]) for i in range(0,len(payload),6)]
assert [x[0] for x in loaded]==retained
normal_mass=sum(eval_heads[1][i] for i in retained)
shift=[.5,.03,.02,.02,.03,.4]
shift_mass=sum(shift[i] for i in retained)
assert shift_mass<normal_mass
bad=0
for b in (0,7):
    try:top([0]*6,b)
    except ValueError:bad+=1
assert bad==2
print(json.dumps({'selected_heads':selected,'all_head_tokens':full_pool,'selected_head_tokens':retained,'normal_retained_mass':normal_mass,'shift_retained_mass':shift_mass,'dense_FP16_KV_payload_bytes':24,'selected_with_indices_bytes':len(payload),'invalid_budget_rejected':bad,'scope':'independent CPU toy selection, not author calibration/GQA runtime'},indent=2))
