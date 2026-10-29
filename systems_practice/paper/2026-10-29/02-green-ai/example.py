import json
# 以同一质量门槛比较单位请求能耗；数据是教学输入，不是论文实测。
rows=[{'method':'fp32','quality':.92,'latency_ms':40,'energy_j':8},{'method':'int8_fused','quality':.919,'latency_ms':24,'energy_j':4.5},{'method':'int4','quality':.90,'latency_ms':20,'energy_j':3.9}]
accepted=[r for r in rows if r['quality']>=.91]
for r in accepted:r['energy_per_quality']=r['energy_j']/r['quality']
print(json.dumps({'accepted':accepted},indent=2))
