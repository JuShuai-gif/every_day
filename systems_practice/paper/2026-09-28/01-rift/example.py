#!/usr/bin/env python3
"""独立演示 Rift 的决策公式；输入是合成概率/成本，不是作者设备测量。"""
import json
import math


def choose(probability, energy_weight, table):
    if not 0 <= probability <= 1 or energy_weight < 0:
        raise ValueError('probability/lambda out of range')
    # 表中条件准确率由独立校准集估计；选择时不访问评估标签。
    return max(table, key=lambda c: probability*c['positive_accuracy'] +
               (1-probability)*c['negative_accuracy'] - energy_weight*c['cost'])


def retain(scores, threshold):
    if not scores or not all(math.isfinite(x) for x in scores):
        raise ValueError('empty/nonfinite scores')
    low, high = min(scores), max(scores)
    if high == low:
        return list(range(len(scores)))  # 信息不足时保守全留，独立工程策略。
    return [i for i, s in enumerate(scores) if (s-low)/(high-low) >= threshold]


def main():
    # 小预算擅长无目标瓦片，大预算提高正样本识别；成本单位是任意合成单位。
    table = [dict(tokens=16, cost=1, positive_accuracy=.45, negative_accuracy=.98),
             dict(tokens=64, cost=2, positive_accuracy=.85, negative_accuracy=.98),
             dict(tokens=256, cost=4, positive_accuracy=.96, negative_accuracy=.99)]
    probs = [.05, .25, .65, .95]
    selected = [choose(p, .12, table)['tokens'] for p in probs]
    monotone_checks = 0
    for p in probs:
        costs = [choose(p, lam, table)['cost'] for lam in [0, .03, .1, .3, 1]]
        assert all(a >= b for a, b in zip(costs, costs[1:]))
        monotone_checks += 1
    # 阈值在教学例中预设；labels 只用于选择完成后的误删评估。
    scores = [.1, .4, .6, .9]
    kept = retain(scores, .37)
    labels = [False, False, True, True]
    shifted_labels = [True, False, True, True]
    def recall(target):
        return sum(target[i] for i in kept) / sum(target)
    assert retain([1, 1, 1], .37) == [0, 1, 2]
    rejected = 0
    for values in [[], [float('nan')]]:
        try:
            retain(values, .37)
        except ValueError:
            rejected += 1
    assert rejected == 2
    print(json.dumps(dict(selected_tokens=selected, kept=kept, synthetic_recall=recall(labels),
                         shifted_recall=recall(shifted_labels), monotone_cases=monotone_checks,
                         rejected=rejected, real_energy_measured=False,
                         predictor_trained=False, full_paper_reproduced=False), indent=2))


if __name__ == '__main__':
    main()
