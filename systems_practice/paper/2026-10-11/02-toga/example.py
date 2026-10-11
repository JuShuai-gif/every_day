"""独立枚举联合剪枝/位宽预算；不冒充论文hypernetwork训练。"""
import itertools
import json
import math

weights = [0.32, 0.91, -0.48, 0.19]
# 调参和评估分开；小线性模型每个输入通道决定保留与位宽。
calibration = [[1.,0.,0.,0.],[0.,1.,0.,0.],[0.,0.,1.,0.],[0.,0.,0.,1.]]
evaluation = [[1.,1.,0.,0.],[0.,1.,2.,0.],[0.,0.,1.,3.]]
shifted = [[0.,0.,0.,20.]]

def quantize(w, bits):
    if bits == 0:
        return 0.
    qmax = 2**(bits-1)-1
    return round(w*qmax)/qmax  # 固定共同range [-1,1]，仅作预算反例。

def mse(bits, data):
    return sum(sum(x*(quantize(w,b)-w) for x,w,b in zip(row,weights,bits))**2 for row in data)/len(data)

def budget_penalty(actual, target):
    if actual <= 0 or target <= 0:
        raise ValueError('log budget requires positive arguments')
    return abs(math.log(actual/target))

budget = 12
feasible = [b for b in itertools.product((0,2,4,8), repeat=4) if 0 < sum(b) <= budget]
best = min(feasible, key=lambda b:(mse(b,calibration), sum(b), b))
# 顺序法先按幅值删除最小通道，再选满足同预算的均匀位宽。
sequential = (4,4,4,0)
assert sum(best) <= budget and sum(sequential) <= budget
assert mse(best,calibration) <= mse(sequential,calibration)
try:
    budget_penalty(0,budget)
    raise AssertionError('zero accepted')
except ValueError:
    pass
print(json.dumps({'joint_bits': best, 'sequential_bits': sequential,
                  'logical_bits_excluding_metadata': [sum(best),sum(sequential)],
                  'calibration_mse': [mse(best,calibration),mse(sequential,calibration)],
                  'heldout_mse': [mse(best,evaluation),mse(sequential,evaluation)],
                  'shifted_mse': [mse(best,shifted),mse(sequential,shifted)],
                  'zero_budget_rejected': True,
                  'scope': 'exhaustive CPU numerical model; no packing, training updates, CUDA kernel or task accuracy'},indent=2))
