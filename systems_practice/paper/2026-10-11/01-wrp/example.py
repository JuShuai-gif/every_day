"""独立实现论文输出空间Gram子机制；不实现完整WRP剪枝。"""
import json
import math


def gram(w):
    if not w or not w[0] or any(len(row) != len(w[0]) for row in w):
        raise ValueError('nonempty rectangular matrix required')
    mean = [sum(col) / len(w) for col in zip(*w)]
    centered = [[v - mean[j] for j, v in enumerate(row)] for row in w]
    return [[sum(a*b for a, b in zip(x, y)) for y in centered] for x in centered]


def similarity(a, b):
    ga, gb = gram(a), gram(b)
    if len(ga) != len(gb):
        raise ValueError('output hidden dimensions differ')
    x, y = sum(ga, []), sum(gb, [])
    return sum(a*b for a, b in zip(x, y)) / (math.sqrt(sum(a*a for a in x)*sum(b*b for b in y)) + 1e-12)


def linear(w, x):
    return [sum(a*b for a, b in zip(row, x)) for row in w]


w = [[1., 2., -1.], [3., 0., 2.], [-2., 1., 4.]]
permuted = [[row[2], row[0], row[1]] for row in w]
score = similarity(w, permuted)
assert abs(score-1) < 1e-10
# 输入未做对应置换：高权重相似度不证明该层在实际输入上可删。
x = [1., 0., 0.]
error = sum((a-b)**2 for a, b in zip(linear(w, x), linear(permuted, x)))
assert error > 0
assert similarity([[0.,0.],[0.,0.]], [[0.,0.],[0.,0.]]) == 0
try:
    gram([])
    raise AssertionError('empty accepted')
except ValueError:
    pass
print(json.dumps({'cka_column_permutation': score, 'unpermuted_input_output_squared_error': error,
                  'zero_gram_similarity': 0, 'empty_rejected': True,
                  'scope': 'CPU algebra only; no model pruning, training, timing or device result'}, indent=2))
