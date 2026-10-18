"""独立近似码本实验；保留1个小数guard bit的整数shift-add，不是ASIC/Thor复现。"""
import json
import math
from pathlib import Path
import random
import struct


def levels(kind):
    if kind == 'pot': return [0.]+[2.**e for e in range(7)]
    if kind == 'exact': return [0.]+[2.**(e/2) for e in range(7)]
    return [0.]+[(1.5 if e%2 else 1.)*2**(e//2) for e in range(7)]


def quant(v, scale, grid):
    if scale <= 0: raise ValueError('scale must be positive')
    return [(8 if x<0 else 0) | min(range(8), key=lambda m:abs(abs(x)/scale-grid[m])) for x in v]


def decode(codes,scale,grid):
    return [(-1 if c&8 else 1)*scale*grid[c&7] for c in codes]


def shift_dot(codes,x,scale):
    acc2=0
    for c,a in zip(codes,x):
        m=c&7
        if not m: continue
        e=m-1
        # 用两倍累加器保留.5，不让负数右移的舍入冒充精确1.5乘法。
        term=(3*a if e%2 else 2*a) << (e//2)
        acc2 += -term if c&8 else term
    return acc2*scale/2


def mse(v,w): return sum((a-b)**2 for a,b in zip(v,w))/len(v)

def main():
    rng=random.Random(18)
    weight=[rng.gauss(0,1) for _ in range(64)]
    train=[] # PTQ无训练更新；不构造虚假训练过程。
    calibration=[[rng.randint(-7,7) for _ in weight] for _ in range(32)]
    evaluation=[[rng.randint(-7,7) for _ in weight] for _ in range(31)]
    shifted=[[x*4 if i==0 else x for i,x in enumerate(row)] for row in evaluation]
    root=Path('build');root.mkdir(exist_ok=True)
    report=[]
    for name in ['pot','exact_then_replace','approx_grid']:
        fit_grid=levels('pot' if name=='pot' else 'exact' if name=='exact_then_replace' else 'approx')
        runtime_grid=levels('pot' if name=='pot' else 'approx')
        def output_loss(scale):
            codes=quant(weight,scale,fit_grid); dq=decode(codes,scale,fit_grid)
            return sum((sum(x*w for x,w in zip(row,weight))-sum(x*w for x,w in zip(row,dq)))**2 for row in calibration)/len(calibration)
        scale=min([.025+i*.005 for i in range(96)],key=output_loss)
        codes=quant(weight,scale,fit_grid)
        payload=struct.pack('<dI',scale,len(codes))+bytes(codes[i]|codes[i+1]<<4 for i in range(0,len(codes),2))
        path=root/(name+'.bin');path.write_bytes(payload);raw=path.read_bytes()
        s,n=struct.unpack_from('<dI',raw); recovered=[c for b in raw[12:] for c in [b&15,b>>4]][:n]
        assert recovered==codes and s==scale
        dq=decode(recovered,s,runtime_grid)
        def output_mse(rows):
            ref=[sum(x*w for x,w in zip(row,weight)) for row in rows]
            act=[sum(x*w for x,w in zip(row,dq)) for row in rows]
            return mse(ref,act)
        if name!='pot':
            for row in evaluation:
                assert abs(shift_dot(codes,row,scale)-sum(x*w for x,w in zip(row,dq)))<1e-10
        report.append({'method':name,'scale':scale,'weight_mse':mse(weight,dq),'evaluation_mse':output_mse(evaluation),
                       'shifted_mse':output_mse(shifted),'file_bytes':len(raw)})
    assert quant([0,0],1,levels('approx'))==[0,0]
    try: quant([1],0,levels('approx'))
    except ValueError: pass
    else: raise AssertionError('zero scale not rejected')
    print(json.dumps({'results':report,'integer_shift_dot_cases':62,'negative_odd_demo':{'x':-3,'naive_x_plus_shift':-3+(-3>>1),'guard_bit_exact':-4.5},'scope':'CPU numerical experiment; no speed or gate-count measurement'},indent=2))

if __name__=='__main__':main()
