"""原生 SGDG/Cayley + QuantizeLinear；学习旋转，独立 STE 激活桥接。"""
import random
import time
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[2]))
from backfill_evaluation import setup,evaluate,qdq

a,torch,w,sets=setup('spinquant');sys.path.insert(0,str(a.source))
from train_utils.optimizer import SGDG
from train_utils.quant_linear import QuantizeLinear
random.seed(20260928)
layer=QuantizeLinear(32,16,bias=False)
with torch.no_grad():layer.weight.copy_(w)
layer.weight.requires_grad_(False)
# 未量化权重+A4，实际权重为FP32；是论文W16A4阶段的精度教学桥接。
# 最终 W4 RTN 是教学简化，不冒充上游 GPTQ 流程。
def ste(x):return x+(qdq(x)-x).detach()
start=time.perf_counter()
candidates=[]
for lr in [.01,.05]:
    q=torch.nn.Parameter(torch.eye(32));initial=q.detach().clone();opt=SGDG([q],lr=lr,stiefel=True)
    updates=0
    for step in range(80):
        opt.zero_grad();pred=layer(ste(sets[0]@q),R1=q);loss=(pred-sets[0]@w.T).square().mean();loss.backward()
        before=q.detach().clone();opt.step();updates+=int(not torch.equal(before,q.detach()))
        if step%20==0 or step==79: print({"lr":lr,"step":step,"loss":float(loss.detach()),"updates":updates})
    with torch.no_grad():score=float((layer(qdq(sets[1]@q),R1=q)-sets[1]@w.T).square().mean())
    candidates.append((score,q.detach().clone(),updates,float((q-initial).abs().max())))
score,q,updates,delta=min(candidates,key=lambda t:t[0]);assert updates>0 and delta>0
orth=float((q.T@q-torch.eye(32)).abs().max());assert orth<.01
wr=qdq(w@q)
def infer(x):return qdq(x@q)@wr.T
with torch.no_grad():before=infer(sets[2]).clone()
loaded=evaluate(a,torch,w,sets,infer,{'rotation':q,'weight_qdq':wr},{'calibration_search_seconds':time.perf_counter()-start,'native_optimizer_updates':updates,'selected_by':'separate 64-row tuning set','rotation_delta':delta,'orthogonality_max_error':orth,'format':'FP32 QDQ weights and rotation, NOT packed INT4','training_paradigm':'frozen weights, calibration reconstruction of rotation; not full QAT'})
q,wr=loaded['rotation'],loaded['weight_qdq']
with torch.no_grad():torch.testing.assert_close(infer(sets[2]),before)
