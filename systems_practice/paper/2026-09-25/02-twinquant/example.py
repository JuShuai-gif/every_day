import json, math, random
random.seed(7)
def mse(a,b):
    return sum((x-y)**2 for x,y in zip(a,b))/len(a)

# 独立2x2分解：G对低秩两因子做反向缩放，浮点乘积相同，QDQ后不同。
u=[4.,.3];v=[.2,1.7];r=[[.11,-.14],[.23,.19]]
cal=[[random.gauss(0,1),random.gauss(0,1)] for _ in range(64)]
test=[[random.gauss(0,1),random.gauss(0,1)] for _ in range(32)]
def quant(values):
    scale=max(max(map(abs,values))/7,1e-12)
    return [round(max(-7,min(7,a/scale)))*scale for a in values]
def mat(g,quantized):
    a=[z*g for z in u];b=[z/g for z in v];flat=[z for row in r for z in row]
    # 共享量化组使两个分支的range耦合；为教学选择，不是论文完整分组。
    if quantized:
        packed=quant(a+b+flat);a,b,flat=packed[:2],packed[2:4],packed[4:]
    return [[a[i]*b[j]+flat[i*2+j] for j in range(2)] for i in range(2)]
def out(m,xs):return [sum(row[k]*m[k][j] for k in range(2)) for row in xs for j in range(2)]
base=mat(1,False)
for g in [.25,.5,1,2,4]:assert mse(out(mat(g,False),test),out(base,test))<1e-25
scores=[(mse(out(mat(g,True),cal),out(base,cal)),g) for g in [.25,.5,1,2,4]]
_,g=min(scores)
print(json.dumps({'selected_G':g,'calibration_scores':scores,'test_mse_baseline':mse(out(mat(1,True),test),out(base,test)),'test_mse_scaled':mse(out(mat(g,True),test),out(base,test)),'training_updates':0,'scope':'grid search; no manifold optimizer, no SVD or CUDA'},indent=2))
