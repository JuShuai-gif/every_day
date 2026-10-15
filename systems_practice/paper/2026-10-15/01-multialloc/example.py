"""独立预算枚举：人工profile，不是作者的校准、量化后端或模型评估。"""
import itertools
import json
from pathlib import Path

# 两层，每层16token、KV各4维；预算同时包含位宽主体、保留FP16、索引和scale/zero。
def memory(bits, kept):
    return ((16-kept)*8*bits+7)//8 + kept*8*2 + kept*5 + 32


def solve(budget, profile, token_profile):
    candidates = []
    for bits in itertools.product([2,4], repeat=2):
        for keep in itertools.product([0,1,2], repeat=2):
            used = sum(memory(b,k) for b,k in zip(bits,keep))
            if used <= budget:
                loss = sum(profile[i][bits[i]] + token_profile[i][keep[i]] for i in range(2))
                candidates.append((loss, used, bits, keep))
    if not candidates:
        raise ValueError('infeasible budget')
    return min(candidates), candidates


cal = [{2:12,4:1},{2:3,4:1}]
tokens = [[12,2,0],[4,2,0]]
best, candidates = solve(224, cal, tokens)
assert best[1] <= 224
# 硬预算若漏算scale/zero和index，会错将不可行方案放行。
naive_payload = sum(16*8*b//8 for b in (4,4))
actual = sum(memory(4,2) for _ in range(2))
assert naive_payload <= 224 < actual
# 固定策略送到独立变化profile，观察排名变化；不重新用评估profile选已部署策略。
shift = [{2:2,4:1},{2:20,4:1}]
shift_tokens = [[1,.5,0],[12,2,0]]
def score(policy, p, t):
    return sum(p[i][policy[2][i]]+t[i][policy[3][i]] for i in range(2))
shift_oracle, _ = solve(224, shift, shift_tokens)
try:
    solve(1, cal, tokens)
except ValueError:
    rejected = True
else:
    raise AssertionError('infeasible accepted')
result = {'selected_calibration_policy': best, 'feasible_candidates': len(candidates),
          'shift_score_of_frozen_policy': score(best,shift,shift_tokens),
          'shift_oracle_only_for_diagnosis': shift_oracle,
          'payload_only_bytes': naive_payload, 'full_example_bytes': actual,
          'budget_bytes':224,'infeasible_rejected':rejected,
          'scope':'Analytical toy storage model and synthetic profiles; no packed KV file/model/kernel run'}
print(json.dumps(result,indent=2))
