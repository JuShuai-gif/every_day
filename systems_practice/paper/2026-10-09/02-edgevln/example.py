"""独立预算筛选示意，不是 EdgeVLN 实现。"""
candidates = [(480, 18, "int8"), (620, 14, "int4"), (900, 9, "fp16")]
fit = [x for x in candidates if x[0] <= 700 and x[1] <= 20]
assert fit[-1][2] == "int4"
print("PASS memory/latency budget selects int4 candidate")
