#!/usr/bin/env python3
"""独立机制实验：完整二次型 + 已量化列冻结 + 剩余列的一次真实 Adam 更新。"""
import copy
import json
import math
import random


def matvec(w, x):
    return [sum(a*b for a, b in zip(row, x)) for row in w]


def loss_grad(w, ref, xs, fisher):
    grad = [[0.0]*4 for _ in range(2)]
    total = 0.0
    for x in xs:
        e = [a-b for a, b in zip(matvec(w, x), matvec(ref, x))]
        fe = matvec(fisher, e)
        total += 0.5*sum(a*b for a, b in zip(e, fe))/len(xs)
        for row in range(2):
            for col in range(4):
                grad[row][col] += fe[row]*x[col]/len(xs)
    return total, grad


def inputs(seed):
    r = random.Random(seed)
    # 固定相关通道使剩余列可能补偿先前舍入；不是模型语料。
    xs = []
    for _ in range(64):
        a, b = r.gauss(0, 1), r.gauss(0, 1)
        xs.append([a, b, a+0.2*r.gauss(0, 1), b+0.2*r.gauss(0, 1)])
    return xs


def main():
    ref = [[0.37, -0.61, 0.29, 0.83], [-0.44, 0.72, -0.38, 0.57]]
    fisher = [[2.0, 1.0], [1.0, 1.0]]  # 人工 SPD；不是从真实 NLL 求出的 Fisher。
    calib, evaluation = inputs(1), inputs(2)
    w = copy.deepcopy(ref)
    for row in w:
        for c in range(2):
            row[c] = round(row[c]/0.25)*0.25
    locked = [row[:2] for row in w]
    before, grad = loss_grad(w, ref, calib, fisher)
    # 用中心差分验证解析梯度；仅操作未锁定的列。
    max_grad_error = 0.0
    for r in range(2):
        for c in range(2, 4):
            plus, minus = copy.deepcopy(w), copy.deepcopy(w)
            plus[r][c] += 1e-6
            minus[r][c] -= 1e-6
            numerical = (loss_grad(plus, ref, calib, fisher)[0]-loss_grad(minus, ref, calib, fisher)[0])/2e-6
            max_grad_error = max(max_grad_error, abs(numerical-grad[r][c]))
    assert max_grad_error < 1e-8
    initial = copy.deepcopy(w)
    # Adam 第一步，m/v 与偏差修正明确保留；没有更新锁定列。
    for r in range(2):
        for c in range(2, 4):
            g = grad[r][c]
            m, v = 0.1*g, 0.001*g*g
            w[r][c] -= 0.025*(m/(1-0.9))/(math.sqrt(v/(1-0.999))+1e-8)
    assert [row[:2] for row in w] == locked
    assert w != initial
    after = loss_grad(w, ref, calib, fisher)[0]
    assert math.isfinite(after)
    # 两个相同欧氏范数误差，完整二次型能看见不同的交叉通道影响。
    def penalty(e):
        return 0.5*sum(a*b for a, b in zip(e, matvec(fisher, e)))
    result = {'scope':'stdlib CPU mechanism only; no GPTQ compensation, real NLL Fisher, sliding transformer window, packed GEMM or full paper reproduction',
              'calibration_loss_before':before,'calibration_loss_after':after,
              'evaluation_loss_before':loss_grad(initial, ref, evaluation, fisher)[0],
              'evaluation_loss_after':loss_grad(w, ref, evaluation, fisher)[0],
              'max_gradient_check_error':max_grad_error,'locked_columns_unchanged':True,
              'actual_updated_parameters':sum(w[r][c]!=initial[r][c] for r in range(2) for c in range(4)),
              'same_euclidean_norm_penalty':{'aligned':penalty([1,1]),'opposed':penalty([1,-1])}}
    print(json.dumps(result,indent=2))


if __name__ == '__main__':
    main()
