"""独立二维delta递推与融合scale合同，非NVFP4编码器/作者模型。"""
import json
import math

def impulse(alternating, steps=256):
    e=[1.,1.]
    for t in range(steps):
        k=[1.,0.] if (not alternating or t%2==0) else [0.,1.]
        dot=sum(a*b for a,b in zip(e,k))
        e=[.999*a-.2*ki*dot for a,ki in zip(e,k)]
    return math.sqrt(sum(a*a for a in e))

# 两支linear原始全局scale不同，合并后必须重标局部scale。
global_scales=[2.,5.];local_scales=[.25,.5];codes=[3.,-2.]
reference=[g*l*q for g,l,q in zip(global_scales,local_scales,codes)]
fused=max(global_scales)
wrong=[fused*l*q for l,q in zip(local_scales,codes)]
fixed=[fused*(l*g/fused)*q for g,l,q in zip(global_scales,local_scales,codes)]
assert reference==fixed and reference!=wrong
assert impulse(True)<1e-10 and impulse(False)>.7
# 直接向alpha加噪，可能越过稳定边界；与扰动门的前激活不同。
unstable=1.001**1000
assert unstable>2
print(json.dumps({'alternating_key_impulse_norm':impulse(True),'fixed_key_impulse_norm':impulse(False),
                  'reference':reference,'bad_fused':wrong,'fixed_fused':fixed,
                  'uncontrolled_alpha_growth':unstable,
                  'scope':'Python CPU algebra only; no NVFP4/LLM/Thor execution'},indent=2))
