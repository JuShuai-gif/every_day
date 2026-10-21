"""独立4维例子：Hadamard等价性、校准能量scale、真实u2打包；非AutoRound复现。"""
import json
import math
from pathlib import Path
import random
import struct


def h(x):
    assert len(x) == 4
    a, b, c, d = x
    return [(a+b+c+d)/2, (a-b+c-d)/2, (a+b-c-d)/2, (a-b-c+d)/2]


def dot(x, w): return [sum(a*b for a, b in zip(x, row)) for row in w]
def mse(y, ref): return sum((a-b)**2 for a,b in zip(y,ref))/len(y)


def encode(w):
    codes, metadata, restored = [], [], []
    for row in w:
        lo, hi = min(row), max(row)
        s = (hi-lo)/3 if hi > lo else 1.0
        # 存储端先round到FP32；导出重载语义完全一致。
        s, lo = struct.unpack('<ff', struct.pack('<ff', s, lo))
        q = [min(3, max(0, round((v-lo)/s))) for v in row]
        codes.extend(q); metadata.extend([s,lo]); restored.append([v*s+lo for v in q])
    packed = bytes(sum(codes[i+j] << (2*j) for j in range(4)) for i in range(0,len(codes),4))
    return restored, struct.pack('<6f', *metadata)+packed


def main():
    r = random.Random(20); w = [[r.uniform(-1,1) for _ in range(4)] for _ in range(3)]
    def data(seed, n, shifted=False):
        r = random.Random(seed); result=[]
        for _ in range(n):
            latent = [r.gauss(0, 5 if j == (1 if shifted else 0) else .2) for j in range(4)]
            result.append(h(latent))
        return result
    cal, tune, evaluation, shifted = data(1,64), data(2,32), data(3,31), data(4,31,True)
    energies=[sum(h(x)[j]**2 for x in cal)/len(cal) for j in range(4)]
    rho=[v/sum(energies) for v in energies]
    def candidate(alpha):
        d=[(1+4*v)**alpha for v in rho]
        d=list(struct.unpack('<4f',struct.pack('<4f',*d)))
        wr=[[a*b for a,b in zip(h(row),d)] for row in w]
        qr,blob=encode(wr)
        def run(x): return dot([a/b for a,b in zip(h(x),d)],qr)
        err=max(abs(a-b) for x in evaluation for a,b in zip(dot(x,w),dot([a/b for a,b in zip(h(x),d)],wr)))
        assert err<1e-12
        return run,struct.pack('<4f',*d)+blob,err
    candidates={a:candidate(a) for a in [0,.25,.5,1]}
    score={a:sum(mse(fn(x),dot(x,w)) for x in tune)/len(tune) for a,(fn,_,_) in candidates.items()}
    selected=min(score,key=score.get); fn,blob,err=candidates[selected]
    out=Path(__file__).parent/'build';out.mkdir(exist_ok=True);path=out/'u2.bin';path.write_bytes(blob)
    saved=path.read_bytes();d=struct.unpack('<4f',saved[:16]);meta=struct.unpack('<6f',saved[16:40]);packed=saved[40:]
    reload_w=[[((packed[i]>>(2*j))&3)*meta[2*i]+meta[2*i+1] for j in range(4)] for i in range(3)]
    for x in evaluation: assert max(abs(a-b) for a,b in zip(fn(x),dot([a/b for a,b in zip(h(x),d)],reload_w)))==0
    base,_=encode(w)
    results={}
    for name,data_ in [('eval',evaluation),('shift',shifted)]:
        results[name]={'absminmax_u2':sum(mse(dot(x,base),dot(x,w)) for x in data_)/len(data_),
                       'rotation_only':sum(mse(candidates[0][0](x),dot(x,w)) for x in data_)/len(data_),
                       'selected':sum(mse(fn(x),dot(x,w)) for x in data_)/len(data_)}
    assert encode([[0.0]*4]*3)[0]==[[0.0]*4]*3
    print(json.dumps({'rho':rho,'tune_mse':score,'selected_alpha':selected,'equivalence_max_abs':err,
                      'results':results,'actual_file_bytes':path.stat().st_size,'fp16_weight_payload_bytes':24,
                      'training_steps':0,'packed_reload_equal':True,'scope':'u2 minmax RTN, FP64 host MAC; not AutoRound/native lowbit'},indent=2))

if __name__=='__main__': main()
