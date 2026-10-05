"""独立正Posit解码/最近值舍入与2幂scale搜索；不是作者SerialPosit实现。"""
import itertools
import json
import math

def positive(code,n,es=1):
    if code==0:
        return 0.
    pos=n-2
    regime=(code>>pos)&1
    run=0
    while pos>=0 and ((code>>pos)&1)==regime:
        run+=1
        pos-=1
    k=run-1 if regime else -run
    pos-=1  # 跳过终止位；达到末尾时没有尾数。
    exp=0
    for _ in range(es):
        exp=(exp<<1)|(((code>>pos)&1) if pos>=0 else 0)
        pos-=1
    frac=(code&((1<<(pos+1))-1))/(1<<(pos+1)) if pos>=0 else 0.
    return 2.**(k*(2**es)+exp)*(1+frac)

def codebook(n):
    vals=[positive(c,n) for c in range(1<<(n-1))]
    return sorted(set(vals+[-x for x in vals])) # NaR排除，负码字的二补码只影响编码。

def quantize(row,n):
    levels=codebook(n)
    candidates=[]
    for exponent in range(-4,5):
        scale=2.**exponent
        q=[scale*min(levels,key=lambda y:abs(v/scale-y)) for v in row]
        candidates.append((sum((a-b)**2 for a,b in zip(row,q)),exponent,q))
    return min(candidates,key=lambda z:z[0])

assert positive(8,5)==1 and positive(4,4)==1
windows=[[.11,.24,.41,.79],[.02,.07,.13,1.7],[.001,.004,.008,.1],[.5,.75,1.,1.25]]
# 校准只决定窗口位宽，独立变动后的数据只评估，不重新选择。
errors=[[quantize(w,n)[0] for n in (4,5)] for w in windows]
configs=[c for c in itertools.product((0,1),repeat=4) if sum(c)==1]
choice=min(configs,key=lambda c:sum(errors[i][c[i]] for i in range(4)))
def loss(rows,config):
    total=0
    for i,row in enumerate(rows):
        _,exponent,_=quantize(windows[i],4+config[i])
        levels=codebook(4+config[i]);s=2.**exponent
        total+=sum((v-s*min(levels,key=lambda z:abs(v/s-z)))**2 for v in row)
    return total
shifted=[w[:] for w in windows];shifted[2]=[v*40 for v in shifted[2]]
print(json.dumps({'independent_not_author_code':True,'posit4_es1_levels':codebook(4),
 'calibration_squared_errors_4_5':errors,'upgrade_config':choice,'mean_bits':4.25,
 'calibration_loss':loss(windows,choice),'shifted_loss_frozen_config':loss(shifted,choice),
 'payload_bits_theoretical':sum((4+choice[i])*len(w) for i,w in enumerate(windows)),
 'packed_export_implemented':False},indent=2))
assert sum(choice)==1 and loss(windows,choice)<=loss(windows,(0,0,0,0))
