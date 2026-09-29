"""论文式(3)/(4)的独立小回归：尺度更新+引导离散候选+真实损失接纳。"""
import random
import struct
codebook = [-1.,-.3,.1,1.]
z, scale = [1,2], [1.,1.]
teacher = [.7,-.7]
rng = random.Random(7)
def data(seed):
    r=random.Random(seed)
    return [[r.uniform(-1,1) for _ in range(2)] for _ in range(32)]
train, evaluation = data(10),data(99)
def weights(code): return [scale[i]*codebook[code[i]] for i in range(2)]
def loss(code, xs):
    w=weights(code)
    return sum(sum(x[i]*(w[i]-teacher[i]) for i in range(2))**2 for x in xs)/len(xs)
def gradient(code):
    w=weights(code)
    return [sum(2*x[i]*sum(x[j]*(w[j]-teacher[j]) for j in range(2)) for x in train)/len(train) for i in range(2)]
initial=loss(z,evaluation)
changes=0
for step in range(80):
    gw=gradient(z)
    # 固定码更新scale并投影为正；不使用heldout调参。
    scale=[max(.01,scale[i]-.08*gw[i]*codebook[z[i]]) for i in range(2)]
    gw=gradient(z)
    direction=[-1 if g>0 else 1 for g in gw]
    nxt=[max(0,min(3,z[i]+direction[i])) for i in range(2)]
    effective=[scale[i]*abs(codebook[nxt[i]]-codebook[z[i]]) for i in range(2)]
    gz=[gw[i]*effective[i] for i in range(2)]
    # 验证一次相邻码移动的一阶项；这不保证真实非线性损失下降。
    lhs=sum(gz[i]*(nxt[i]-z[i]) for i in range(2))
    rhs=sum(gw[i]*(weights(nxt)[i]-weights(z)[i]) for i in range(2))
    assert abs(lhs-rhs)<1e-12
    candidates=[z[:]]
    for _ in range(8):
        candidates.append([nxt[i] if rng.random()<min(.9,2*abs(gz[i])) else z[i] for i in range(2)])
    previous=loss(z,train)
    selected=min(candidates,key=lambda q:loss(q,train))
    assert loss(selected,train)<=previous+1e-15
    changes += selected!=z
    z=selected
    if step in [0,19,79]:print('step',step,'codes',z,'scale',scale,'train_loss',loss(z,train))
# 真正2bit打包仅作教学：不是NF4、INT4或MXFP4兼容格式。
packed=bytes([z[0] | (z[1]<<2)])
assert [packed[0]&3,(packed[0]>>2)&3]==z
assert changes>0 and loss(z,evaluation)<initial
metadata=struct.pack('<6f',*(codebook+scale))
print('PASS changes',changes,'initial_eval',initial,'final_eval',loss(z,evaluation),
      'code_bytes',len(packed),'metadata_bytes',len(metadata))
print('80 scale updates; guided local Bernoulli candidates, not author sampler; no low-bit kernel speed claim')
