"""独立数学例：精确单向量三值拟合与行/列scale，不是RoleQ-T完整复现。"""
import itertools
import json
from pathlib import Path
import struct


def fit(v):
    if not v or max(map(abs, v)) == 0:
        return 0., [0]*len(v)
    order = sorted(range(len(v)), key=lambda i: abs(v[i]), reverse=True)
    total, best, size = 0., -1., 0
    for j, i in enumerate(order, 1):
        total += abs(v[i])
        if total*total/j > best:
            best, size = total*total/j, j
    support = set(order[:size])
    codes = [int(i in support)* (1 if x >= 0 else -1) for i, x in enumerate(v)]
    return sum(abs(v[i]) for i in support)/size, codes


def quant(w, axis):
    vectors = w if axis == 'row' else list(map(list, zip(*w)))
    fitted = [fit(v) for v in vectors]
    deq = [[s*q for q in c] for s, c in fitted]
    return (deq if axis == 'row' else list(map(list, zip(*deq)))), fitted


def pack(fitted, path):
    # 5个三进制符号合成1字节；scale实际存FP64，包含头/尾部。
    codes = [x+1 for _, q in fitted for x in q]
    payload = struct.pack('<II', len(fitted), len(codes))
    payload += b''.join(struct.pack('<d', s) for s, _ in fitted)
    packed = bytes(sum(x*3**j for j, x in enumerate(codes[i:i+5])) for i in range(0, len(codes), 5))
    payload += packed
    path.write_bytes(payload)
    raw = path.read_bytes(); count, length = struct.unpack_from('<II', raw)
    recovered = []
    for b in raw[8+8*count:]:
        for _ in range(5): recovered.append(b%3); b //= 3
    assert recovered[:length] == codes
    return len(raw)


def mse(a,b):
    return sum((x-y)**2 for r,s in zip(a,b) for x,y in zip(r,s))/(len(a)*len(a[0]))


def main():
    # 暴力枚举小向量的所有三值码，核对prefix推导而非自我复述。
    for v in [[0.,0.,0.], [1., -2., .1], [-1., -1., 1.]]:
        s,q = fit(v); error = sum((x-s*y)**2 for x,y in zip(v,q))
        oracle = float('inf')
        for c in itertools.product([-1,0,1], repeat=len(v)):
            denom = sum(x*x for x in c)
            a = max(0.,sum(x*y for x,y in zip(v,c))/denom) if denom else 0
            oracle = min(oracle,sum((x-a*y)**2 for x,y in zip(v,c)))
        assert abs(error-oracle)<1e-12
    w = [[v*s for s in [1.,3.,10.,30.]] for v in [1., .9, -1., -.9]]
    root=Path('build');root.mkdir(exist_ok=True)
    records=[]
    for label, matrix in [('writer_column_structure', w), ('transposed_reader_structure',list(map(list,zip(*w))))]:
        for axis in ['row','column']:
            deq, fitted=quant(matrix,axis)
            records.append({'case':label,'axis':axis,'weight_mse':mse(matrix,deq),
                            'file_bytes':pack(fitted,root/(label+'-'+axis+'.bin'))})
    print(json.dumps({'oracle_cases':3,'results':records,'scope':'weight reconstruction only; no rotation/GPTQ/distillation'},indent=2))

if __name__=='__main__': main()
