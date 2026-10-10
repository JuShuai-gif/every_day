"""独立的 trust-region 裁剪示意，不是论文实现。"""
g, radius = 9.0, 2.0
step = max(-radius, min(radius, g))
assert step == 2.0
print("PASS gradient=9.0 clipped_step=2.0")
