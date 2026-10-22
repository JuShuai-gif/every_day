"""原生PyTorch观察器 + 独立INT8导出/INT32参考推理；只运行CPU，无模型下载。"""
import json
import math
import pathlib
import statistics
import struct
import time

import torch
from torch.ao.quantization.observer import MinMaxObserver, MovingAverageMinMaxObserver

EXPECTED = '37f56e48ce431907080585a595c437f9edb23411'
if torch.version.git_version != EXPECTED:
    raise RuntimeError(f'Use audited PyTorch source build {EXPECTED}; got {torch.__version__} / {torch.version.git_version}')
torch.set_num_threads(1)
torch.manual_seed(22)
OUT = pathlib.Path(__file__).resolve().parent / 'build'
OUT.mkdir(exist_ok=True)
K, N = 17, 7
weight = torch.randn(N, K, dtype=torch.float32) * 0.2
# 校准/调参/评估分别产生，评估从不进入观察器或选择alpha。
calibration = [torch.randn(8, K) * (6.0 if i == 0 else 1.0) for i in range(8)]
tune = torch.randn(32, K)
evaluate = torch.randn(31, K)
shift = torch.randn(31, K) * 5


def observer(alpha=None):
    args = dict(dtype=torch.qint8, qscheme=torch.per_tensor_symmetric,
                quant_min=-127, quant_max=127)
    if alpha is None:
        return MinMaxObserver(**args)
    return MovingAverageMinMaxObserver(averaging_constant=alpha, **args)


def calibrate(alpha=None, reverse=False):
    ob = observer(alpha)
    for x in (list(reversed(calibration)) if reverse else calibration):
        if not torch.isfinite(x).all():
            raise ValueError('nonfinite calibration data')
        ob(x)
    scale, zero = ob.calculate_qparams()
    assert zero.item() == 0 and scale.item() > 0
    return float(scale.item())


# per-output-channel权重scale；独立计算，不冒充本课观察器提供自动模型转换。
ws = weight.abs().amax(dim=1).clamp_min(1e-12) / 127
wq = torch.round(weight / ws[:, None]).clamp(-127, 127).to(torch.int8)


def infer(x, scale, q=wq, scales=ws):
    aq = torch.round(x / scale).clamp(-127, 127).to(torch.int8)
    # 真正INT8存储，但计算显式扩宽为INT32，不是原生INT8 Tensor Core。
    accum = aq.to(torch.int32) @ q.to(torch.int32).T
    return accum.float() * (scale * scales), aq


def error(x, scale):
    ref = x @ weight.T
    y, aq = infer(x, scale)
    e = y - ref
    return dict(nrmse=float(e.norm() / ref.norm().clamp_min(1e-12)),
                max_abs=float(e.abs().max()),
                cosine=float(torch.nn.functional.cosine_similarity(y.flatten(), ref.flatten(), dim=0)),
                saturation=float((x.abs() > scale * 127).float().mean()))


def bench(fn):
    for _ in range(5):
        fn()
    batches = []
    for _ in range(9):
        start = time.perf_counter_ns()
        for _ in range(30):
            fn()
        batches.append((time.perf_counter_ns()-start)/30/1000)
    return statistics.median(batches)


candidates = {a:calibrate(a) for a in [0.01, 0.1, 0.5]}
best = min(candidates, key=lambda a:error(tune,candidates[a])['nrmse'])
scale = candidates[best]
# 导出格式: magic/K/N + activation-scale + N个weight-scale + N*K真实int8。
blob = struct.pack('<4sII', b'EMA1', K, N) + struct.pack('<f', scale)
blob += struct.pack('<'+'f'*N, *ws.tolist()) + struct.pack('<'+'b'*(N*K), *wq.flatten().tolist())
file = OUT/'linear.bin'
file.write_bytes(blob)
data = file.read_bytes()
magic,k,n = struct.unpack_from('<4sII',data)
assert (magic,k,n)==(b'EMA1',K,N) and len(data)==16+4*N+N*K
loaded_scale = struct.unpack_from('<f',data,12)[0]
loaded_ws = torch.tensor(struct.unpack_from('<'+'f'*N,data,16))
loaded_q = torch.tensor(struct.unpack_from('<'+'b'*(N*K),data,16+4*N),dtype=torch.int8).reshape(N,K)
y,_ = infer(evaluate,scale)
y2,_ = infer(evaluate,loaded_scale,loaded_q,loaded_ws)
assert torch.allclose(y,y2,atol=1e-6,rtol=1e-6)
assert torch.count_nonzero(infer(torch.zeros(1,K),scale)[0])==0
empty = observer(0.1); empty(torch.empty(0)); assert torch.isinf(empty.min_val)
zero = observer(0.1); zero(torch.zeros(2,K)); zs,_=zero.calculate_qparams(); assert torch.isfinite(zs).all() and (zs>0).all()
assert 127*127*K < 2**31
records = {label:{'scale':s,'eval':error(evaluate,s),'shift':error(shift,s)} for label,s in
           [('absmax',calibrate()),('ema',scale),('ema_reversed',calibrate(best,True))]}
result = dict(torch=torch.__version__,commit=torch.version.git_version,selected_alpha=best,
              records=records,storage=dict(payload_i8=N*K,weight_scales=4*N,activation_scale=4,header=12,
                                          serialized_bytes=file.stat().st_size,fp16_weight_bytes=2*N*K,fp32_weight_bytes=4*N*K),
              fp16_storage_fp32_compute_nrmse=float(((evaluate.half().float()@weight.half().float().T)-(evaluate@weight.T)).norm()/(evaluate@weight.T).norm()),
              cpu_batch_mean_p50_us=dict(fp32=bench(lambda:evaluate@weight.T),int32_reference_including_quant=bench(lambda:infer(evaluate,scale))),
              checks='zero/empty/export-reload/INT32-bound', training='none; PTQ',thor_verified=False)
print(json.dumps(result,indent=2))
