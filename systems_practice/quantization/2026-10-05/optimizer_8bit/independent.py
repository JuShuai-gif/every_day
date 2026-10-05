"""独立均匀8bit状态实验：真实更新/字节序列；不是bnb动态码本或原生API。"""
import array
import json
import math
import random

def pack(values, block, positive=False):
    codes = bytearray()
    scales = array.array('f')
    limit = 255 if positive else 127
    for start in range(0, len(values), block):
        vals = values[start:start+block]
        scale = max(map(abs, vals)) / limit
        scales.append(scale)
        scale = scales[-1]  # 以实际序列化FP32 scale量化。
        for v in vals:
            q = max(0 if positive else -127, min(limit, round(v/scale))) if scale else 0
            codes.append(q if positive else q+127)
    return codes, scales

def unpack(codes, scales, block, positive=False):
    return [(q if positive else q-127)*scales[i//block] for i,q in enumerate(codes)]

def train(block=None):
    rng = random.Random(3)
    target = [rng.uniform(-1,1) for _ in range(513)]
    weights = [0.] * len(target)
    m = array.array('f', weights)
    v = array.array('f', weights)
    for step in range(1, 81):
        for i in range(len(weights)):
            grad = weights[i] - target[i]
            m[i] = .9*m[i]+.1*grad
            v[i] = .999*v[i]+.001*grad*grad
            weights[i] -= .03*(m[i]/(1-.9**step))/(math.sqrt(v[i]/(1-.999**step))+1e-8)
        if block:
            cm, sm = pack(m,block)
            cv, sv = pack(v,block,True)
            m = array.array('f', unpack(cm,sm,block))
            v = array.array('f', unpack(cv,sv,block,True))
    assert any(weights) and all(map(math.isfinite,weights))
    loss = sum((a-b)**2 for a,b in zip(weights,target))/len(weights)
    size = len(cm)+len(cv)+len(sm.tobytes())+len(sv.tobytes()) if block else len(m.tobytes())+len(v.tobytes())
    return weights, loss, size

ref, ref_loss, ref_bytes = train()
report = {'independent_uniform_codec_only': True, 'actual_updates': 80, 'fp32_reference_state_payload_bytes': ref_bytes, 'reference_loss': ref_loss}
for b in (256,513):
    w,loss,size = train(b)
    report[str(b)] = {'loss':loss,'state_payload_bytes':size,'weight_max_abs_vs_reference':max(abs(a-z) for a,z in zip(w,ref))}
for n in (0,1,255,256,257,513):
    codes,scales=pack([0.]*n,256)
    assert unpack(codes,scales,256)==[0.]*n
# 同一离群值的影响是否越过量化块边界。
x=[.01]*512;x[0]=100
errors=[]
for block in (256,512):
    c,s=pack(x,block);z=unpack(c,s,block)
    errors.append(max(abs(z[i]-x[i]) for i in range(256,512)))
report['outlier_remote_block_error_256_vs_tensor']=errors
assert errors[0]<errors[1]
print(json.dumps(report,indent=2))
