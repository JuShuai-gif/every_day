"""独立标准库NVFP4数值/存储实验，非原仓库执行，非低位算力基准。"""
import json,math,random,struct,time
from pathlib import Path
V=[0,.5,1,1.5,2,3,4,6]
def e4(b):
    e=(b>>3)&15;m=b&7
    return math.ldexp(m,-9) if e==0 else math.ldexp(1+m/8,e-7)
E=[e4(b) for b in range(127)]
def nearest(x,vs):return min(range(len(vs)),key=lambda i:(abs(x-vs[i]),i%2,i))
def quant(rows,global_scale=None):
    if not rows or not rows[0] or any(len(r)!=len(rows[0]) for r in rows):raise ValueError('shape')
    n=len(rows[0]);k=(n+15)//16*16
    if any(not math.isfinite(v) for r in rows for v in r):raise ValueError('nonfinite')
    # 文件用FP32全局scale，所以计算也用同一个舍入后的值。
    g=global_scale or max(abs(v) for r in rows for v in r)/(6*448) or 1.0
    g=struct.unpack('<f',struct.pack('<f',g))[0]
    if not math.isfinite(g) or g<=0:raise ValueError('scale')
    packed=bytearray();scales=bytearray();saturated=0
    for row in rows:
        pad=row+[0.]*(k-n);codes=[]
        for start in range(0,k,16):
            block=pad[start:start+16]
            s=max(abs(v) for v in block)/(6*g)
            b=nearest(s or 1.,E);s=E[b]
            # 极小块scale下溢为零时显式用最小subnormal，拒绝0/0。
            if s==0:b=1;s=E[b]
            scales.append(b)
            for v in block:
                z=v/(s*g);saturated+=abs(z)>6
                c=nearest(abs(z),V)|(8 if z<0 else 0);codes.append(c)
        packed.extend(codes[i]|(codes[i+1]<<4) for i in range(0,k,2))
    return {'n':len(rows),'k':n,'padded_k':k,'g':g,'data':packed,'scales':scales,'saturated':saturated}
def decode(q):
    rows=[];k=q['padded_k']
    for r in range(q['n']):
        row=[]
        for j in range(k):
            b=q['data'][r*k//2+j//2];c=(b>>(4*(j%2)))&15
            s=E[q['scales'][r*k//16+j//16]]*q['g']
            row.append((-1 if c&8 else 1)*V[c&7]*s)
        rows.append(row[:q['k']])
    return rows
def mat(a,w):return [[sum(x*y for x,y in zip(row,col)) for col in w] for row in a]
def metrics(y,ref):
    a=sum(y,[]);b=sum(ref,[]);err=[x-z for x,z in zip(a,b)]
    return {'nrmse':math.sqrt(sum(e*e for e in err)/sum(z*z for z in b)),
            'max_abs':max(map(abs,err)), 'cosine':sum(x*z for x,z in zip(a,b))/math.sqrt(sum(x*x for x in a)*sum(z*z for z in b))}
def half(rows):return [[struct.unpack('<e',struct.pack('<e',v))[0] for v in row] for row in rows]
def uniform(rows):
    s=max(abs(v) for r in rows for v in r)/7 or 1
    return [[max(-7,min(7,round(v/s)))*s for v in r] for r in rows]
rng=random.Random(3)
w=[[rng.gauss(0,.2)*(10 if j%16==0 else 1) for j in range(65)] for _ in range(17)]
cal=[[rng.gauss(0,1) for _ in range(65)] for _ in range(64)]
x=[[rng.gauss(0,1) for _ in range(65)] for _ in range(8)]
g=max(abs(v) for r in cal for v in r)/(6*448)
qw=quant(w);qx=quant(x,g);wd=decode(qw);xd=decode(qx)
ref=mat(x,w)
result={'shape':{'x':[8,65],'w':[17,65]},'fp16':metrics(mat(half(x),half(w)),ref),
        'absmax_int4_qdq':metrics(mat(uniform(x),uniform(w)),ref),
        'independent_nvfp4_qdq':metrics(mat(xd,wd),ref)}
shift=[[v*4 for v in row] for row in x];qs=quant(shift,g)
result['shifted_frozen_activation_scale']=metrics(mat(decode(qs),wd),mat(shift,w))
result['saturation_counts']={'w':qw['saturated'],'x':qx['saturated'],'shifted':qs['saturated']}
# 小格式仅是教学容器；保存后重建并核对，包含shape而非虚报纯payload。
build=Path(__file__).parent/'build';build.mkdir(exist_ok=True)
blob=struct.pack('<4sIIIf',b'N4T1',qw['n'],qw['k'],qw['padded_k'],qw['g'])+qw['data']+qw['scales']
(build/'weight.bin').write_bytes(blob)
magic,n,k,pad,gg=struct.unpack('<4sIIIf',blob[:20]);assert magic==b'N4T1'
reload={'n':n,'k':k,'padded_k':pad,'g':gg,'data':blob[20:20+n*pad//2],'scales':blob[20+n*pad//2:]}
assert decode(reload)==wd
result['storage']={'fp16_unpadded':17*65*2,'packed_padded':len(qw['data']),'scale':len(qw['scales']),'header':20,'actual_file':(build/'weight.bin').stat().st_size}
for fn in [lambda:mat(x,w),lambda:mat(decode(qx),decode(qw))]:
    for _ in range(3):fn()
    samples=[]
    for _ in range(11):
        t=time.perf_counter();fn();samples.append((time.perf_counter()-t)*1e3)
    result.setdefault('python_cpu_batch_ms_p50',[]).append(sorted(samples)[5])
for size in [1,15,16,17,31,32,33]:
    z=quant([[0.]*size]);assert decode(z)==[[0.]*size]
assert nearest(.75,V)==2 and nearest(3.5,V)==6
for bad in [[],[[]],[[float('nan')]],[[1],[1,2]]]:
    try:quant(bad)
    except ValueError:pass
    else:raise AssertionError('reject')
result['checks']='PASS reload,7 zero/tail shapes,4 invalid, ties-even'
result['scope']='independent Python CPU QDQ+matmul; no upstream/native GPU run'
print(json.dumps(result,indent=2))
