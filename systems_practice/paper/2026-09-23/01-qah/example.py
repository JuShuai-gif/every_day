#!/usr/bin/env python3
"""独立教学实验：结构缩减后的INT4 fake-quant学生，真实STE/KL更新；不是MXFP4实现。"""
import copy
import json
import math
import random


def softmax(z):
    m = max(z)
    e = [math.exp(v - m) for v in z]
    return [v / sum(e) for v in e]


def forward(w, x):
    return softmax([sum(a*b for a, b in zip(row, x)) for row in w])


def qdq(w, scales):
    return [[max(-7, min(7, round(v / s))) * s for v in row]
            for row, s in zip(w, scales)]


def kl(p, q):
    return sum(a * math.log(a / max(b, 1e-30)) for a, b in zip(p, q) if a > 0)


def evaluate(w, scales, data, targets, chunk=7):
    quant = qdq(w, scales) if scales else w
    total = 0.0
    for i in range(0, len(data), chunk):
        # 按样本累加再除总数；尾chunk不能与完整chunk等权平均。
        total += sum(kl(p, forward(quant, x[:4]))
                     for x, p in zip(data[i:i+chunk], targets[i:i+chunk]))
    return total / len(data)


def train(initial, scales, data, targets, steps):
    w = copy.deepcopy(initial)
    trace = []
    for step in range(steps):
        used = qdq(w, scales) if scales else w
        grad = [[0.0] * 4 for _ in range(4)]
        for x, p in zip(data, targets):
            q = forward(used, x[:4])
            for c in range(4):
                for j in range(4):
                    # 冻结量化scale；量化范围内采用STE，范围外梯度置零。
                    active = scales is None or abs(w[c][j] / scales[c]) <= 7
                    grad[c][j] += (q[c] - p[c]) * x[j] * active / len(data)
        for c in range(4):
            for j in range(4):
                w[c][j] -= 0.25 * grad[c][j]
        if step in (0, 49, steps - 1):
            trace.append({'step': step+1, 'train_kl': evaluate(w, scales, data, targets)})
    delta = max(abs(w[c][j]-initial[c][j]) for c in range(4) for j in range(4))
    if delta == 0 or not math.isfinite(delta):
        raise RuntimeError('No actual finite parameter update')
    return w, trace, delta


def main():
    rng = random.Random(923)
    teacher = [[rng.gauss(0, .6) for _ in range(6)] for _ in range(4)]
    initial = [row[:4] for row in teacher]  # 删除两个输入通道，学生16参数/教师24参数。
    def data(seed, count):
        r = random.Random(seed)
        return [[r.gauss(0, 1) for _ in range(6)] for _ in range(count)]
    train_x, validation_x, test_x = data(1, 37), data(2, 19), data(3, 41)
    original_targets = [forward(teacher, x) for x in train_x]
    recovered, recovery_trace, _ = train(initial, None, train_x, original_targets, 80)
    # 加20%固定headroom；只由训练前权重确定，不用测试误差挑scale。
    scales = [max(max(abs(v) for v in row) * 1.2 / 7, 1e-8) for row in recovered]
    before = evaluate(recovered, scales, test_x, [forward(teacher, x) for x in test_x])
    modes = {'original_teacher': original_targets,
             'recovered_teacher': [forward(recovered, x[:4]) for x in train_x],
             'hard_labels': [[float(j == max(range(4), key=lambda i: p[i])) for j in range(4)] for p in original_targets]}
    report = {'status': 'independent mechanism only', 'format': 'INT4 symmetric fake quant, FP64 Python arithmetic; NOT MXFP4 or packed storage',
              'train_validation_test': [37, 19, 41], 'teacher_student_parameters': [24,16],
              'test_kl_before': before, 'recovery_trace': recovery_trace, 'runs': {}}
    for name, targets in modes.items():
        w, trace, delta = train(recovered, scales, train_x, targets, 150)
        test_targets = [forward(teacher, x) for x in test_x]
        a = evaluate(w, scales, test_x, test_targets, 7)
        b = evaluate(w, scales, test_x, test_targets, 41)
        if abs(a-b) > 1e-12:
            raise RuntimeError('chunked KL differs')
        report['runs'][name] = {'train_trace': trace, 'max_parameter_update': delta,
                                'validation_kl': evaluate(w, scales, validation_x, [forward(teacher,x) for x in validation_x]),
                                'test_kl': a, 'chunk_vs_dense_abs': abs(a-b)}
    if kl([.25]*4, [.25]*4) != 0 or not math.isfinite(kl([1,0,0,0], [.25]*4)):
        raise RuntimeError('zero KL boundary failed')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
