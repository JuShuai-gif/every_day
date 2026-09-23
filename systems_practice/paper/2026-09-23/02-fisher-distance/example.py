#!/usr/bin/env python3
"""独立Bernoulli模型：精确标签期望Fisher，比较坐标路径RMS与长度积分。"""
import json
import math
import random


def probability(w, x):
    z = sum(a*b for a, b in zip(w, x))
    return 1 / (1 + math.exp(-z))


def fisher(w, xs, k):
    # 对模型预测标签分布取期望；不是把观测标签梯度平方当作同一个量。
    return sum(probability(w,x) * (1-probability(w,x)) * x[k]**2 for x in xs) / len(xs)


def scores(w, xs, k, points):
    if points < 2:
        raise ValueError('path requires >=2 nodes')
    fs = []
    for j in range(points):
        probe = w.copy()
        probe[k] *= 1 - j / (points - 1)
        fs.append(fisher(probe, xs, k))
    # 论文Eq3.7取mean后开方；积分梯形法对sqrt(F)积分，两者不能混同。
    rms = abs(w[k]) * math.sqrt(sum(fs) / points)
    length = abs(w[k]) * (sum(math.sqrt(f) for f in fs[1:-1]) + .5*(math.sqrt(fs[0])+math.sqrt(fs[-1]))) / (points-1)
    return rms, length


def mean_kl(w, pruned, xs):
    out = 0.0
    for x in xs:
        p, q = probability(w,x), probability(pruned,x)
        out += p*math.log(p/q)+(1-p)*math.log((1-p)/(1-q))
    return out / len(xs)


def main():
    def data(seed, count):
        r = random.Random(seed)
        return [[r.gauss(0,1)*s for s in (0.15,3,1)] for _ in range(count)]
    xs, test = data(11,64), data(22,128)
    w = [1.5, .2, -.7]
    f = [fisher(w,xs,k) for k in range(3)]
    rows = []
    for k in range(3):
        for points in (3,9,33):
            a, b = scores(w,xs,k,points)
            rows.append({'coordinate':k,'nodes':points,'paper_rms':a,'trapezoid_length':b})
    # 有限差分对两种标签的log概率求导，再按预测分布平均，应等于解析Fisher。
    h = 1e-5
    worst = 0
    for x in xs[:8]:
        p = probability(w,x)
        for k in range(3):
            plus, minus = w.copy(), w.copy()
            plus[k] += h
            minus[k] -= h
            pp, pm = probability(plus,x), probability(minus,x)
            g1 = (math.log(pp)-math.log(pm))/(2*h)
            g0 = (math.log(1-pp)-math.log(1-pm))/(2*h)
            fd = p*g1*g1+(1-p)*g0*g0
            worst = max(worst, abs(fd - p*(1-p)*x[k]**2))
    if worst > 1e-7:
        raise RuntimeError('Fisher gradient check failed')
    methods = {'magnitude':[abs(v) for v in w], 'fisher_only':f,
               'one_shot':[abs(v)*math.sqrt(z) for v,z in zip(w,f)],
               'coordinate_path':[scores(w,xs,k,9)[0] for k in range(3)]}
    comparisons = {}
    for name, values in methods.items():
        k = min(range(3), key=lambda i: values[i])
        pruned = w.copy()
        pruned[k] = 0.0
        comparisons[name] = {'scores':values,'removed_coordinate':k,'heldout_kl':mean_kl(w,pruned,test)}
    zero = w.copy()
    zero[0] = 0
    if scores(zero,xs,0,9) != (0,0):
        raise RuntimeError('zero coordinate failed')
    try:
        scores(w,xs,0,1)
    except ValueError:
        pass
    else:
        raise RuntimeError('invalid path length accepted')
    print(json.dumps({'status':'independent mechanism only; no network retraining or sparse kernel',
                      'calibration_test_shapes':[[64,3],[128,3]],'gradient_max_abs':worst,
                      'path_comparison':rows,'pruning':comparisons,'boundary_checks':'PASS'},indent=2))


if __name__ == '__main__':
    main()
