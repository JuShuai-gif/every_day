"""独立有限候选风险表反例；不是作者LLM剪枝/训练实现。"""
import itertools
import json


def response(r, delta):
    top = max(r)
    slack = [top - v for v in r]
    return max(d - s for d, s in zip(delta, slack))


def main():
    # 两个世界给同样行均值，却反转候选的worst-group顺序。
    worlds = [[[4,0,0,0], [1,1,1,1]], [[1,1,1,1], [4,0,0,0]]]
    means = [[sum(row)/4 for row in world] for world in worlds]
    winners = [min(range(2), key=lambda i: max(world[i])) for world in worlds]
    assert means[0] == means[1] and winners == [1,0]
    # 当前最差组可能切换；直接恒等式验证slack而非仅看当前最大风险。
    checks = 0
    for r in itertools.product(range(3), repeat=3):
        for d in itertools.product([-1, 0, 1], repeat=3):
            measured = max(a+b for a,b in zip(r,d)) - max(r)
            assert response(r,d) == measured
            checks += 1
    # 各单元最大值之和会高估同一组的整mask风险。
    units = [[3,0], [0,3]]
    separable = sum(max(u) for u in units)
    mask_risk = max(sum(u[g] for u in units) for g in range(2))
    assert separable == 6 and mask_risk == 3
    # 预先分开的选择/评估表；此为构造数据，无估计统计或真实模型结论。
    tune = [[0.4,1.0],[0.8,0.8]]
    heldout = [[0.5,1.4],[0.9,0.85]]
    selected = min(range(2), key=lambda i: max(tune[i]))
    print(json.dumps({"pooled_observations":means,"opposite_winners":winners,
                      "slack_identity_checks":checks,"separable_upper_bound":separable,
                      "complete_mask_worst":mask_risk,"selected_on_tune":selected,
                      "heldout_risk":max(heldout[selected]),"training_updates":0,
                      "scope":"synthetic risk tables, no LLM inference or speedup"},indent=2))

if __name__ == '__main__':
    main()
