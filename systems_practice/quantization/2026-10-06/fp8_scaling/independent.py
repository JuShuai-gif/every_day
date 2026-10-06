"""标准库E4M3FN编码与动态per-tensor缩放。独立数学实验，非torchao运行。"""
import bisect
import json
import math
import random
import struct
import time
from pathlib import Path

def decode(code):
    sign = -1 if code & 128 else 1
    e, m = (code >> 3) & 15, code & 7
    if e == 15 and m == 7: return float('nan')
    return sign * (m * 2**-9 if e == 0 else (1 + m/8) * 2**(e-7))
VALUES = [decode(c) for c in range(127)]
def encode(v):
    if not math.isfinite(v): raise ValueError('nonfinite input')
    sign = 128 if math.copysign(1, v) < 0 else 0
    v=min(abs(v),448.0); hi=bisect.bisect_left(VALUES,v)
    if hi == 0: return sign
    lo=hi-1
    # 最近偶数：相等距离时选编码尾位为0的值。
    code=min((lo,hi),key=lambda c:(abs(VALUES[c]-v),c%2))
    return sign|code

def quant(values, fixed=None):
    if not values: raise ValueError('empty tensor')
    if not all(math.isfinite(x) for x in values): raise ValueError('nonfinite input')
    scale=fixed if fixed is not None else 448/max(max(map(abs,values)),1e-12)
    packed=bytes(encode(v*scale) for v in values)
    return packed,scale,[decode(c)/scale for c in packed],sum(abs(v*scale)>448 for v in values)
def mm(a,w,m,k,n):
    return [sum(a[i*k+t]*w[j*k+t] for t in range(k)) for i in range(m) for j in range(n)]
def metrics(ref,y):
    err=sum((a-b)**2 for a,b in zip(ref,y)); den=sum(a*a for a in ref)
    dot=sum(a*b for a,b in zip(ref,y)); yn=sum(b*b for b in y)
    return {'nrmse':math.sqrt(err/max(den,1e-30)), 'max_abs':max(abs(a-b) for a,b in zip(ref,y)), 'cosine':dot/math.sqrt(max(den*yn,1e-30))}
def half(x):return struct.unpack('<e',struct.pack('<e',x))[0]
def main():
    assert decode(126)==448 and decode(1)==2**-9
    assert encode(1.0625)==56 and encode(1.1875)==58
    assert all(encode(decode(c))==c for c in range(256) if c not in (127,255))
    assert quant([0.0]*7)[2]==[0.0]*7
    for bad in ([],[float('nan')]):
        try:quant(bad)
        except ValueError:pass
        else:raise AssertionError('accepted bad input')
    m,k,n=8,33,7
    rw=random.Random(10);rc=random.Random(20);re=random.Random(30)
    w=[rw.uniform(-1,1) for _ in range(n*k)]
    calibration=[rc.gauss(0,1) for _ in range(m*k)]
    static=quant(calibration)[1] # 仅为静态absmax对照，评估集不用于挑参数。
    x=[re.gauss(0,1) for _ in range(m*k)]
    qw,sw,dw,_=quant(w)
    report={}
    for label,a in [('iid',x),('shifted',[v*30 if i<k else v for i,v in enumerate(x)])]:
        ref=mm(a,w,m,k,n)
        report[label]={'fp16':metrics(ref,mm(list(map(half,a)),list(map(half,w)),m,k,n))}
        for method,fixed in [('static_absmax',static),('dynamic_absmax',None)]:
            qa,sa,da,sat=quant(a,fixed)
            report[label][method]={**metrics(ref,mm(da,dw,m,k,n)), 'saturated':sat,
               'input_payload_bytes':len(qa)+4,'weight_payload_bytes':len(qw)+4}
    Path('build').mkdir(exist_ok=True)
    blob=struct.pack('<f',sw)+qw;Path('build/weight.fp8').write_bytes(blob)
    saved=Path('build/weight.fp8').read_bytes();rs=struct.unpack('<f',saved[:4])[0]
    assert max(abs(decode(c)/rs-v) for c,v in zip(saved[4:],dw))<1e-6
    samples=[]
    for _ in range(5):quant(x)
    for _ in range(31):
        t=time.perf_counter();quant(x);samples.append((time.perf_counter()-t)*1e6)
    print(json.dumps({'independent_only':True,'shape':[m,k,n],'weight_fp32_bytes':len(w)*4,
       'weight_fp16_bytes':len(w)*2,'weight_fp8_actual_file_bytes':len(saved),
       'cpu_python_quantize_us_p50':sorted(samples)[15], 'results':report,'codec_roundtrips':254},indent=2))
if __name__=='__main__':main()
