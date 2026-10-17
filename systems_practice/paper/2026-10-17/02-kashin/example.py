"""依论文Algorithm1独立实现小规模数学例，DCT用O(N²)矩阵检查而非快速实现。"""
import json, math, random, struct
from pathlib import Path
rng=random.Random(17);n=32
C=[[math.sqrt((1 if k==0 else 2)/n)*math.cos(math.pi*(j+.5)*k/n) for j in range(n)] for k in range(n)]
signs=[rng.choice([-1,1]) for _ in range(n)]
def transform(x):
    freq=[sum(a*b for a,b in zip(row,x))*s for row,s in zip(C,signs)]
    return [sum(C[k][j]*freq[k] for k in range(n)) for j in range(n)]
def norm(x):return math.sqrt(sum(v*v for v in x))
w=[rng.gauss(0,1) for _ in range(n)];w[0]*=12
assert max(abs(a-b) for a,b in zip(transform(transform(w)),w))<1e-10
u=[0.0]*n;v=[0.0]*n;r=w[:];trace=[norm(r)]
for _ in range(16):
    for mode in (0,0,1,1):
        z=transform(r) if mode else r
        amount=sum(abs(a) for a in z)/n
        delta=[amount*(1 if a>0 else -1 if a<0 else 0) for a in z]
        dest=v if mode else u
        for i in range(n):dest[i]+=delta[i]
        correction=transform(delta) if mode else delta
        r=[a-b for a,b in zip(r,correction)]
        assert norm(r)<=trace[-1]+1e-10
        trace.append(norm(r))
pv=transform(v)
assert max(abs(w[i]-u[i]-pv[i]-r[i]) for i in range(n))<1e-10
# 自写四中心Lloyd后处理，不冒称作者的闭式初始化/OPTQ补偿。
def quant4(z):
    ordered=sorted(z);centers=[ordered[(2*j+1)*n//8] for j in range(4)]
    for _ in range(20):
        codes=[min(range(4),key=lambda j:abs(a-centers[j])) for a in z]
        centers=[sum(a for a,c in zip(z,codes) if c==j)/codes.count(j) if codes.count(j) else centers[j] for j in range(4)]
    codes=[min(range(4),key=lambda j:abs(a-centers[j])) for a in z]
    return codes,centers
cu,su=quant4(u);cv,sv=quant4(v)
pack=lambda codes: bytes(sum(codes[i+j]<<(2*j) for j in range(4)) for i in range(0,len(codes),4))
mask=sum((s>0)<<i for i,s in enumerate(signs))
blob=b'KSH1'+struct.pack('<II8f',n,mask,*su,*sv)+pack(cu)+pack(cv)
root=Path(__file__).parent/'build';root.mkdir(exist_ok=True);(root/'weights.bin').write_bytes(blob)
b=(root/'weights.bin').read_bytes();n2,mask2,*centers=struct.unpack('<II8f',b[4:44]);assert n2==n and mask2==mask
unpack=lambda buf:[(a>>(j*2))&3 for a in buf for j in range(4)]
a=unpack(b[44:44+n//4]);c=unpack(b[44+n//4:]);vq=transform([centers[4+k] for k in c]);wq=[centers[k]+vq[i] for i,k in enumerate(a)]
scale=max(abs(z) for z in w)/7;baseline=[max(-8,min(7,round(z/scale)))*scale for z in w]
err=lambda a: norm([x-y for x,y in zip(a,w)])/norm(w)
print(json.dumps({'initial_residual':trace[0],'final_residual':trace[-1],'factor_quant_nrmse':err(wq),'uniform4_nrmse':err(baseline),'actual_file_bytes':len(blob),'fp16_payload_bytes':2*n,'metadata_bytes':44,'performance':'not measured; dense educational DCT; not author JAX/H100 reproduction'},indent=2))
