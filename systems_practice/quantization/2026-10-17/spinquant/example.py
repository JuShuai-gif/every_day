"""原生SGDG/QuantizeLinear/量化器单层示例；不是完整Llama SpinQuant复现。"""
import json
import os
from pathlib import Path
import random
import struct
import sys
import time
import statistics

root = Path(os.environ['SPINQUANT_ROOT']).resolve()
sys.path.insert(0, str(root))
import torch
from train_utils.optimizer import SGDG
from train_utils.quant_linear import QuantizeLinear
from utils.quant_utils import ActQuantizer, WeightQuantizer

torch.set_num_threads(1)
torch.manual_seed(17)
random.seed(17)
out = Path(__file__).parent / 'build'
out.mkdir(exist_ok=True)
K, N = 32, 16
layer = QuantizeLinear(K, N, bias=False).float().cpu()
with torch.no_grad():
    layer.weight[:, 0] *= 12
layer.weight.requires_grad_(False)
w = layer.weight.detach().clone()
wq = WeightQuantizer()
wq.configure(4, perchannel=True, sym=True, mse=False, weight_groupsize=-1)
layer.quantizer = wq
aq = ActQuantizer()
aq.configure(bits=4, groupsize=-1, sym=True, clip_ratio=1.0)
# 四个独立分区；动态per-token scale不需要离线激活校准，cal只检查合同。
train, cal, tune, evaluation = [torch.randn(n, K) for n in (64, 32, 32, 31)]
assert len({x.data_ptr() for x in (train, cal, tune, evaluation)}) == 4

def forward(x, r):
    xr = x @ r
    aq.find_params(xr.detach())
    return layer(aq(xr), R1=r)

def mse(x, r):
    return ((forward(x, r) - x @ w.T) ** 2).mean()

identity = torch.eye(K)
initial, _ = torch.linalg.qr(torch.randn(K, K))
r = torch.nn.Parameter(initial.clone())
opt = SGDG([r], lr=0.01, momentum=0, stiefel=True)
trace = []
best_r = r.detach().clone()
with torch.no_grad():
    best_score = float(mse(tune, r))
for step in range(80):
    opt.zero_grad()
    loss = mse(train, r)
    loss.backward()
    opt.step()  # 真正更新旋转参数；预训练权重冻结。
    if step % 10 == 9:
        with torch.no_grad():
            score = float(mse(tune, r))
            trace.append({'step': step+1, 'train_mse': float(loss), 'tune_mse': score})
            if score < best_score:
                best_score, best_r = score, r.detach().clone()
update = float((r.detach()-initial).abs().max())
assert update > 0
r = best_r
orth_error = float((r.T @ r - identity).abs().max())
assert orth_error < 5e-3
# 未量化等价性；旋转误差必须与量化误差分开。
equivalence = float(((cal@r)@(w@r).T-cal@w.T).abs().max())
wr = (w.double() @ r.double()).float()
wq.find_params(wr)
qdq, q, scale = wq.fake_quantize(wr)
assert q is not None
# 自定义有符号二补码u4存储，非ExecuTorch格式；完整保存旋转和FP32 scale。
codes = [int(v) & 15 for v in q.reshape(-1).tolist()]
payload = bytes(codes[i] | (codes[i+1]<<4) for i in range(0, len(codes), 2))
scales = scale.reshape(-1).tolist()
blob = b'SPQ1' + struct.pack('<II', K, N) + payload + struct.pack('<'+str(N)+'f', *scales) + struct.pack('<'+str(K*K)+'f', *r.reshape(-1).tolist())
path = out/'packed.bin'
path.write_bytes(blob)
b = path.read_bytes()
assert b[:4] == b'SPQ1' and struct.unpack('<II', b[4:12]) == (K,N)
values=[]
for code in b[12:12+K*N//2]:
    for nibble in (code&15, code>>4):
        values.append(nibble if nibble<8 else nibble-16)
start=12+K*N//2
s2=torch.tensor(struct.unpack('<'+str(N)+'f',b[start:start+N*4])).reshape(N,1)
r2=torch.tensor(struct.unpack('<'+str(K*K)+'f',b[start+N*4:])).reshape(K,K)
w2=torch.tensor(values).reshape(N,K)*s2
assert torch.equal(w2,qdq) and torch.equal(r2,r)

def deployed(x):
    # 解包权重在计时前已完成；含在线旋转、动态激活QDQ和FP32 GEMM。
    xr=x@r2
    aq.find_params(xr)
    return aq(xr)@w2.T

def metrics(y, ref):
    diff=(y-ref).double()
    return {'nrmse': float(diff.norm()/ref.double().norm().clamp_min(1e-12)),
            'max_abs': float(diff.abs().max()),
            'cosine': float(torch.nn.functional.cosine_similarity(y.flatten().double(),ref.flatten().double(),dim=0))}

def timing(fn):
    for _ in range(10): fn()
    samples=[]
    for _ in range(31):
        t=time.perf_counter()
        for _ in range(20): fn()
        samples.append((time.perf_counter()-t)*1e6/20)
    return statistics.median(samples)

with torch.no_grad():
    result={}
    for name,x in [('eval',evaluation),('shift',evaluation*torch.linspace(0.1,8,K)),('zero',torch.zeros(1,K))]:
        ref=x@w.T
        result[name]={
          'fp16_storage_fp32_compute': metrics(x.half().float()@w.half().float().T,ref),
          'absmax_w4a4': metrics(forward(x,identity),ref),
          'random_rotation_w4a4': metrics(forward(x,initial),ref),
          'learned_export_w4a4': metrics(deployed(x),ref)}
    assert torch.allclose(deployed(evaluation),forward(evaluation,r),atol=1e-4,rtol=1e-4)
    result['cpu_batch_mean_p50_us']={'fp32_linear':timing(lambda:evaluation@w.T),'rot_dynamic_qdq_fp32_linear':timing(lambda:deployed(evaluation))}
result.update(trace=trace, max_rotation_update=update, orthogonality_max=orth_error, unquantized_equivalence_max=equivalence,
              storage={'actual_file_bytes':path.stat().st_size,'packed_weight_bytes':len(payload),'scale_bytes':N*4,'rotation_bytes':K*K*4,'fp16_weight_bytes':K*N*2},
              torch_version=torch.__version__, target='CPU; no native low-bit kernel measured')
print(json.dumps(result,indent=2))
