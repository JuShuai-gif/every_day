"""独立前缀码+长度约束例子，不是作者rANS内核，不做GPU性能宣称。"""
import itertools
import json

levels = [-3., -1., 1., 3.]
codes = ['000', '1', '01', '001']
x = [-2.8, -2.5, -0.9, 0.8, 2.5, 2.9, -1.1, 0.7]
lengths = list(map(len, codes))
budget = 16

def distortion(symbols): return sum((v-levels[s])**2 for v, s in zip(x, symbols))
def cost(symbols): return sum(lengths[s] for s in symbols)
def choose(lam):
    return tuple(min(range(4), key=lambda s: ((v-levels[s])**2+lam*lengths[s], lengths[s], s)) for v in x)

def drift(cap):
    if cap < len(x)*min(lengths): raise ValueError('infeasible stream budget')
    if cost(choose(0)) <= cap: return choose(0)
    low, high = 0., 1.
    while cost(choose(high)) > cap: high *= 2
    for _ in range(60):
        mid = (low+high)/2
        if cost(choose(mid)) > cap: low = mid
        else: high = mid
    return choose(high)

symbols = drift(budget)
bitstream = ''.join(codes[s] for s in symbols)
assert len(bitstream) <= budget
# 实际定长2字节payload；解码知道元素数，不把尾部padding当符号。
payload = int(bitstream.ljust(budget, '0'), 2).to_bytes(2, 'big')
stream = ''.join(f'{b:08b}' for b in payload)
read, word = [], ''
for ch in stream:
    word += ch
    if word in codes:
        read.append(codes.index(word)); word = ''
        if len(read) == len(x): break
assert tuple(read) == symbols
oracle = min((p for p in itertools.product(range(4), repeat=len(x)) if cost(p)<=budget), key=distortion)
assert distortion(symbols)+1e-12 >= distortion(oracle)
try: drift(7)
except ValueError: pass
else: raise AssertionError('infeasible accepted')
print(json.dumps({'nearest_bits': cost(choose(0)), 'nearest_error': distortion(choose(0)),
 'drift_bits': cost(symbols), 'drift_error': distortion(symbols), 'oracle_error': distortion(oracle),
 'actual_payload_bytes': len(payload), 'format_note': 'fixed shared codebook; count/scale metadata excluded; NOT total KV BPV',
 'status': 'PASS roundtrip/infeasible; scalar prefix-code demonstration, not D-Quant replication'}, indent=2))
