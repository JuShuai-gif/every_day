"""独立简化QAD：固定INT4 scale、真实STE更新与稀疏教师概率质量；非作者训练复现。"""
import json
import math
import random


def softmax(z):
    e = [math.exp(v - max(z)) for v in z]
    return [v / sum(e) for v in e]


def quant(w):
    # 固定scale避免把scale优化混入本课；实际前向使用量化后值。
    return [[max(-7, min(7, round(v / 0.125))) * 0.125 for v in row] for row in w]


def logits(x, w):
    return [sum(a * b for a, b in zip(x, row)) for row in w]


def sparse_loss_grad(z, teacher):
    p = softmax(z)
    ids = sorted(range(3), key=lambda i: teacher[i], reverse=True)[:2]
    target = [teacher[i] if i in ids else 0 for i in range(3)]
    mass = sum(target)
    return -sum(t * math.log(q) for t, q in zip(target, p)), [mass * q - t for q, t in zip(p, target)]


def main():
    teacher_w = [[0.68, -0.3], [-0.25, 0.61], [0.1, -0.2]]
    def data(seed, n):
        r = random.Random(seed)
        return [[r.uniform(-2, 2), r.uniform(-2, 2)] for _ in range(n)]
    train, evaluation = data(11, 64), data(12, 31)
    teacher = lambda x: softmax(logits(x, teacher_w))
    # 检查稀疏CE梯度。STE本身是代理梯度，不拿离散前向作有限差分证明。
    z = [0.2, -0.4, 0.6]; target = teacher([1, 0.3]); loss, grad = sparse_loss_grad(z, target)
    for i in range(3):
        plus, minus = z[:], z[:]; plus[i] += 1e-6; minus[i] -= 1e-6
        finite = (sparse_loss_grad(plus, target)[0] - sparse_loss_grad(minus, target)[0]) / 2e-6
        assert abs(finite - grad[i]) < 1e-8
    w = [[0.0, 0.0] for _ in range(3)]
    def kl(weights):
        total = 0
        for x in evaluation:
            t, p = teacher(x), softmax(logits(x, quant(weights)))
            total += sum(a * math.log(a / b) for a, b in zip(t, p))
        return total / len(evaluation)
    before = kl(w)
    trace = []
    for step in range(160):
        q = quant(w); g = [[0.0, 0.0] for _ in range(3)]; mean = 0
        for x in train:
            loss, dz = sparse_loss_grad(logits(x, q), teacher(x)); mean += loss / len(train)
            for i in range(3):
                for j in range(2): g[i][j] += dz[i] * x[j] / len(train)
        for i in range(3):
            for j in range(2): w[i][j] -= 0.12 * g[i][j]  # identity STE，真实更新浮点主权重。
        if step % 40 == 0 or step == 159: trace.append([step + 1, mean])
    assert any(v != 0 for row in w for v in row)
    mass = sum(sorted(target, reverse=True)[:2])
    print(json.dumps({"steps": 160, "finite_difference_pass": True, "teacher_top2_mass": mass,
                      "eval_kl_before": before, "eval_kl_after": kl(w), "trace_train_loss": trace,
                      "latent_weights": w, "quantized_weights": quant(w),
                      "scope": "CPU arithmetic; fake-quant STE, no packed backend or model reproduction"}, indent=2))

if __name__ == "__main__": main()
