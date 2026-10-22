"""标准库独立数学反例；不调用PyTorch，不能算原生API执行。"""
import json
import struct
from pathlib import Path

def ema(bounds, alpha):
    if not bounds or not 0 < alpha <= 1:
        raise ValueError('bounds/alpha')
    value = bounds[0]
    for x in bounds[1:]:
        value += alpha * (x-value)
    return value

def qdq(xs,bound):
    scale=max(bound/127,1e-7)
    q=[max(-127,min(127,round(x/scale))) for x in xs]
    return [x*scale for x in q],struct.pack('<f',scale)+struct.pack('<'+'b'*len(q),*q)

cal=[12.,1.,1.,1.]
a,b=ema(cal,.5),ema(list(reversed(cal)),.5)
assert (a,b)==(2.375,6.5)
rows=[]
for name,xs in [('eval',[.1,.3,.8,1.]),('shift',[0.,3.,8.,12.])]:
    for method,bound in [('absmax',12.),('ema',a),('reversed',b)]:
        y,blob=qdq(xs,bound)
        root=Path(__file__).resolve().parent/'build';root.mkdir(exist_ok=True)
        file=root/(name+'-'+method+'.bin');file.write_bytes(blob)
        scale=struct.unpack_from('<f',file.read_bytes())[0]
        q=struct.unpack_from('<4b',file.read_bytes(),4)
        assert all(abs(v-scale*z)<1e-6 for v,z in zip(y,q))
        rows.append(dict(split=name,method=method,bound=bound,mse=sum((u-v)**2 for u,v in zip(xs,y))/4,bytes=file.stat().st_size))
assert qdq([0.]*4,0.)[0]==[0.]*4
for bounds,alpha in [([],.5),([1.],0.)]:
    try:ema(bounds,alpha)
    except ValueError:pass
    else:raise AssertionError('missing rejection')
print(json.dumps(dict(kind='independent scalar calibration-order example, not upstream API/GEMM',rows=rows,zero_and_rejections=True),indent=2))
