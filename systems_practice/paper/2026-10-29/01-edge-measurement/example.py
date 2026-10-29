import json
# 仅示范论文所强调的 Pareto 选择：延迟、能耗、质量必须同表比较。
points=[{'name':'jetson','latency_ms':42.0,'energy_j':5.1,'quality':0.91},{'name':'server_gpu','latency_ms':18.0,'energy_j':11.0,'quality':0.93},{'name':'cpu','latency_ms':120.0,'energy_j':18.0,'quality':0.90}]
front=[]
for p in points:
 if not any(q['latency_ms']<=p['latency_ms'] and q['energy_j']<=p['energy_j'] and q['quality']>=p['quality'] and q!=p for q in points): front.append(p)
print(json.dumps({'points':points,'pareto':front},indent=2))
