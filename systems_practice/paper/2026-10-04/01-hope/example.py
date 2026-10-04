"""独立四专家枚举，解释交互矩阵；不调用作者求解器或完整MoE。"""
import itertools
import json

calibration = [[1., 1., 0., 0.], [0., 0., 1.2, 0.], [0., 0., 0., 1.2]]
evaluation = [[0.1, 0.1, 4., 4.], [0.1, 0.1, 4., 4.]]

def matrix(rows, conditional):
    n = len(rows[0])
    f = [[0.]*n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            count = sum(r[i] != 0 and r[j] != 0 for r in rows) if conditional else len(rows)
            f[i][j] = sum(r[i]*r[j] for r in rows)/count if count else 0.
    return f

def objective(f, selected):
    return sum(f[i][j] for i in selected for j in selected)

def solve(f, count):
    if not 0 <= count <= len(f): raise ValueError('budget')
    return min(itertools.combinations(range(len(f)), count), key=lambda p: objective(f, p))

f = matrix(calibration, False)
selected = solve(f, 2)
diagonal = tuple(sorted(range(4), key=lambda i: f[i][i])[:2])
assert selected != diagonal and objective(f, selected) < objective(f, diagonal)
# 验证全样本归一化的二次型确实等于平方和平均；条件归一化不是同一目标。
assert abs(objective(f, selected)-sum(sum(r[i] for i in selected)**2 for r in calibration)/3) < 1e-12
conditional = matrix(calibration, True)
assert conditional[0][0] != f[0][0]
assert solve(f, 0) == () and solve(f, 4) == (0, 1, 2, 3)
try: solve(f, 5)
except ValueError: pass
else: raise AssertionError('invalid budget accepted')
eval_f = matrix(evaluation, False)
print(json.dumps({'selected': selected, 'diagonal': diagonal,
 'calibration_full': objective(f, selected), 'calibration_diagonal': objective(f, diagonal),
 'heldout_full': objective(eval_f, selected), 'heldout_diagonal': objective(eval_f, diagonal),
 'conditional_objective': objective(conditional, solve(conditional, 2)),
 'status': 'PASS; shifted heldout can regress; surrogate only; no model accuracy or pruning speed'}, indent=2))
