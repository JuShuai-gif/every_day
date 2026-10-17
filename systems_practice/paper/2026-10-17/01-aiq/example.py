"""独立二次整数算术/存储例子，不是作者GPU实现。"""
import json, math, random, struct
from pathlib import Path
rng=random.Random(17)
alpha=math.sqrt(2)
codebook=[(a,b,a+b*alpha) for a in range(-8,8) for b in range(-8,8)]
# 先量化，后精确系数乘加；两种误差不能混淆。
w=[rng.gauss(0,1) for _ in range(32)]
x=[rng.gauss(0,1) for _ in range(32)]
def encode(v):
    scale=max(abs(z) for z in v)/max(z[2] for z in codebook) if any(v) else 1.0
    pairs=[min(codebook,key=lambda c:abs(scale*c[2]-z))[:2] for z in v]
    return pairs,scale
qw,sw=encode(w);qx,sx=encode(x)
# (a+b√2)(c+d√2)=(ac+2bd)+(ad+bc)√2。
A=sum(a*c+2*b*d for (a,b),(c,d) in zip(qw,qx))
B=sum(a*d+b*c for (a,b),(c,d) in zip(qw,qx))
integer_dot=(A+B*alpha)*sw*sx
float_dot=sum((a+b*alpha)*sw*(c+d*alpha)*sx for (a,b),(c,d) in zip(qw,qx))
assert abs(integer_dot-float_dot)<1e-10
root=Path(__file__).parent/'build';root.mkdir(exist_ok=True)
blob=b'AIQ1'+struct.pack('<fI',sw,len(w))+bytes((a&15)|((b&15)<<4) for a,b in qw)
(root/'weights.bin').write_bytes(blob)
loaded=(root/'weights.bin').read_bytes();sw2,n=struct.unpack('<fI',loaded[4:12])
def signed(n):return n if n<8 else n-16
wr=[(signed(z&15)+signed(z>>4)*alpha)*sw2 for z in loaded[12:]]
assert len(wr)==n
uniform_scale=max(abs(z) for z in w)/127
ur=[max(-128,min(127,round(z/uniform_scale)))*uniform_scale for z in w]
rmse=lambda a:math.sqrt(sum((u-v)**2 for u,v in zip(a,w))/len(w))
# 固定宽度溢出必须先验检查；Python整数无溢出不能证明INT32安全。
assert 32*3*8*8 < 2**31
zero,_=encode([0.0]*32);assert all(z==(0,0) for z in zero)
print(json.dumps({'coefficient_A':A,'coefficient_B':B,'coefficient_vs_decoded_error':abs(integer_dot-float_dot),'quantized_vs_original_dot_error':abs(integer_dot-sum(a*b for a,b in zip(w,x))),'AIQ_weight_rmse':rmse(wr),'uniform8_weight_rmse':rmse(ur),'actual_file_bytes':len(blob),'fp16_weight_payload_bytes':len(w)*2,'cases':'zero + signed pack/reload + integer identity','performance':'not measured; no GPU execution'},indent=2))
