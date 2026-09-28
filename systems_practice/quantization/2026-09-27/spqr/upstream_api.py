"""SpQR 原生小 Linear PTQ：Hessian、离群点、二级量化元数据。"""
import sys
import time
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[2]))
from backfill_evaluation import setup,evaluate

a,torch,w,sets=setup('spqr');sys.path.insert(0,str(a.source))
from spqr_engine import SPQRUtil
start=time.perf_counter()
candidates=[]
for threshold in [1.0,4.0,float('inf')]:
    layer=torch.nn.Linear(32,16,bias=False)
    with torch.no_grad():layer.weight.copy_(w)
    utility=SPQRUtil(layer);utility.add_batch(sets[0])
    result=utility.quantize(bits=4,groupsize=16,blocksize=32,percdamp=.01,outlier_relative_threshold=threshold,permutation_order='identity',keep_H=False,verbose=False,save_quantization=True,qq_scale_bits=4,qq_zero_bits=4,qq_groupsize=16)
    score=float((sets[1]@result.weight.T-sets[1]@w.T).square().mean())
    candidates.append((score,threshold,result))
score,threshold,result=min(candidates,key=lambda t:t[0]);wr=result.weight.detach()
def infer(x):return x@wr.T
with torch.no_grad():before=infer(sets[2]).clone()
loaded=evaluate(a,torch,w,sets,infer,{'weight_qdq':wr,'native_quantization':result.save_quant_dict},{'calibration_search_seconds':time.perf_counter()-start,'threshold':str(threshold),'outliers':int(result.unstructured_outlier_mask.sum()),'training_updates':0,'format':'upstream int8 codes for 4-bit values + sparse outliers + scales/zeros; not memory-optimized packed deployment','packed_backend':'not invoked; Thor compatibility pending'})
wr=loaded['weight_qdq']
with torch.no_grad():torch.testing.assert_close(infer(sets[2]),before)
