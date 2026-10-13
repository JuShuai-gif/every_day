"""独立合成例：共享密度响应的拟合/外推边界，并非作者模型复现。"""
import json
import math

def phi(d):
    if not 0.6 <= d <= 0.9: raise ValueError('outside validated density interval')
    return ((1-d)/0.3)**2

def fit(rows):
    return sum(phi(d)*y for d,y in rows)/sum(phi(d)**2 for d,y in rows)

def predict(a,d): return a*phi(d)

def main():
    # 固定gamma=2仅作机制演示，作者还在开发集拟合状态特征与gamma。
    truth=[0.1,0.3,0.8]
    estimates=[fit([(d,a*phi(d)) for d in [0.6,0.8]]) for a in truth]
    error=max(abs(predict(a,d)-b*phi(d)) for a,b in zip(estimates,truth) for d in [0.7,0.9])
    assert error < 1e-12
    # 符号随密度变化的QA反例不应硬套同一正密度曲线。
    qa=lambda d: 0.8-d
    qa_fit=fit([(d,qa(d)) for d in [0.6,0.8]])
    qa_error=abs(predict(qa_fit,0.9)-qa(0.9))
    assert qa_error > 0.1
    rejected=0
    for bad in [0.5,1.0,float('nan')]:
        try:phi(bad)
        except ValueError:rejected+=1
    assert rejected==3
    # 选择价值与预测误差不是同一指标，恒定优先级可能同样选中最优。
    actual={'prune':1.2,'int4':1.1,'dense':1.0}
    storage={'prune':7,'int4':4,'dense':16}
    feasible=[k for k in actual if storage[k]<=8]
    chosen=min(feasible,key=actual.get)
    result={'synthetic_holdout_max_error':error,'sign_changing_QA_error':qa_error,
            'domain_rejections':rejected,'chosen':chosen,'fixed_int4_priority_regret':actual['int4']-actual[chosen],
            'timing':'not measured','full_model_reproduced':False}
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()
