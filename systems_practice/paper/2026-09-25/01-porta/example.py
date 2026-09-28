import json, math, random
random.seed(7)
def mse(a,b):
    return sum((x-y)**2 for x,y in zip(a,b))/len(a)

# 通道均值大不代表方差大：训练/校准/评估明确分开，本例只校准不训练。
cal=[[10+random.gauss(0,.01),random.gauss(0,2),random.gauss(0,.4)] for _ in range(64)]
test=[[10+random.gauss(0,.01),random.gauss(0,2),random.gauss(0,.4)] for _ in range(32)]
w=[.1,1,.3]
means=[sum(row[j] for row in cal)/len(cal) for j in range(3)]
v=[sum((row[j]-means[j])**2 for row in cal)/len(cal) for j in range(3)]
scores=[v[j]*abs(w[j]) for j in range(3)];keep=max(range(3),key=lambda j:scores[j])
mag=max(range(3),key=lambda j:abs(means[j]*w[j]))
ref=[sum(a*b for a,b in zip(w,row)) for row in test]
# 剪枝常数通道会丢失偏置，保留这个反例，不保证variance方案输出MSE最优。
errors={str(j):mse([row[j]*w[j] for row in test],ref) for j in range(3)}
assert keep==1 and mag==0
print(json.dumps({'variance':v,'scores':scores,'variance_keep':keep,'mean_magnitude_keep':mag,'heldout_mse_by_single_kept_channel':errors,'training_updates':0},indent=2))
