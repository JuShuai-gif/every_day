#!/usr/bin/env python3
"""独立的小型 Lloyd 实验：相同分布、相同4bit/向量，非作者 MMD-VQ 实现。"""
import itertools
import json
import math
import random


def squared(a, b):
    return sum((x-y)**2 for x, y in zip(a, b))


def nearest(x, centers):
    return min(range(len(centers)), key=lambda i: squared(x, centers[i]))


def fit(data, initial, steps=30):
    centers = [list(c) for c in initial]
    changes = 0
    for _ in range(steps):
        groups = [[] for _ in centers]
        for x in data:
            groups[nearest(x, centers)].append(x)
        newer = []
        for old, group in zip(centers, groups):
            # 空簇保留旧中心，避免除零；只用训练数据更新码本。
            new = [sum(x[j] for x in group)/len(group) for j in range(len(old))] if group else old
            changes += squared(old, new) > 1e-20
            newer.append(new)
        centers = newer
    return centers, changes


def sample(seed, n):
    rng = random.Random(seed)
    result = []
    for _ in range(n):
        t = rng.uniform(-2, 2)
        result.append([t + rng.gauss(0, .05), .8*t + rng.gauss(0, .05),
                       -.9*t + rng.gauss(0, .05), 1.1*t + rng.gauss(0, .05)])
    return result


def main():
    train, test = sample(928, 256), sample(929, 128)
    # SQ 每维2中心；PQ 每2维4中心；VQ 每4维16中心，均4bit/向量。
    sq = [fit([[x[j]] for x in train], [[-1], [1]])[0] for j in range(4)]
    sq_full = [list(itertools.chain.from_iterable(c)) for c in itertools.product(*sq)]
    pq = []
    for j in (0, 2):
        init = [a+b for a, b in itertools.product(sq[j], sq[j+1])]
        pq.append(fit([x[j:j+2] for x in train], init)[0])
    pq_full = [a+b for a, b in itertools.product(*pq)]
    # 从 PQ 可表达解开始；全向量更新在训练集上不会增加目标。
    vq, updates = fit(train, pq_full)
    def evaluate(data, centers):
        indexes = [nearest(x, centers) for x in data]
        return dict(mse_per_vector=sum(squared(x, centers[i]) for x, i in zip(data, indexes))/len(data),
                    utilization=len(set(indexes))/len(centers))
    result = {name: dict(train=evaluate(train, code), heldout=evaluate(test, code))
              for name, code in [('SQ', sq_full), ('PQ', pq_full), ('VQ', vq)]}
    assert result['VQ']['train']['mse_per_vector'] <= result['PQ']['train']['mse_per_vector'] + 1e-12
    assert result['PQ']['train']['mse_per_vector'] <= result['SQ']['train']['mse_per_vector'] + 1e-12
    assert updates > 0
    zero, _ = fit([[0, 0]]*8, [[0, 0], [1, 1]])
    assert evaluate([[0, 0]], zero)['mse_per_vector'] == 0
    result.update(bits_per_vector=math.log2(16), heldout_nominal_bits=128*4,
                  codebook_float_count=dict(SQ=8, PQ=16, VQ=64), vq_center_updates=updates,
                  serialized_packed_stream=False, zero_empty_cluster_check=True,
                  full_paper_reproduced=False)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
