"""PyTorch 2.8.0原生HistogramObserver；CPU算法路径，不使用量化设备kernel。"""
import json
import statistics
import time
from pathlib import Path
import torch
from torch.ao.quantization.observer import HistogramObserver, MinMaxObserver
from torch.ao.quantization.fake_quantize import FakeQuantize

if torch.__version__.split('+')[0] != '2.8.0':
    raise SystemExit('Use reviewed PyTorch 2.8.0; review implementation before changing version')
torch.set_num_threads(1)
root = Path(__file__).resolve().parent
out = root / 'build'
out.mkdir(exist_ok=True)

def samples(seed, rows):
    x = torch.randn(rows, 65, generator=torch.Generator().manual_seed(seed))
    x[:, 0] *= 12
    return x

# 仅calib更新统计；tune选观察器桶数；eval/shift仅最终报告。
calib, tune, evaluation = samples(101, 128), samples(202, 32), samples(303, 32)
shift = evaluation.clone()
shift[:, 4] *= 30
w = torch.randn(19, 65, generator=torch.Generator().manual_seed(404)) * .2
wscale = w.abs().amax(dim=1, keepdim=True).clamp_min(1e-8) / 127
wcode = (w / wscale).round().clamp(-127, 127).to(torch.int8)
wd = wcode.float() * wscale

def fit(kind, bins=2048):
    kw = dict(observer=kind, dtype=torch.qint8, qscheme=torch.per_tensor_symmetric,
              quant_min=-128, quant_max=127)
    if kind is HistogramObserver:
        kw['bins'] = bins
    fq = FakeQuantize(**kw)
    fq.disable_fake_quant()  # 校准只收集统计，不改变数据。
    for x in calib.split(16):
        fq(x)
    fq.disable_observer()
    fq.enable_fake_quant()   # 冻结scale后再用于调参和评估。
    return fq

def metrics(y, ref):
    d = y.float() - ref
    return dict(nrmse=float(d.norm() / ref.norm().clamp_min(1e-12)),
                max_abs=float(d.abs().max()),
                cosine=float(torch.nn.functional.cosine_similarity(y.flatten(), ref.flatten(), dim=0)))

def timing(fn):
    for _ in range(20): fn()
    us=[]
    for _ in range(100):
        t=time.perf_counter_ns();fn();us.append((time.perf_counter_ns()-t)/1000)
    return dict(p50_us=statistics.median(us), p95_us=sorted(us)[94],
                boundary='CPU framework QDQ + FP32 Linear, not native INT8 kernel')

with torch.no_grad():
    hist_candidates=[(b,fit(HistogramObserver,b)) for b in (256,1024,2048)]
    selected_bins, selected = min(hist_candidates,key=lambda v:float(((v[1](tune)@wd.T)-(tune@w.T)).square().mean()))
    baseline=fit(MinMaxObserver)
    results=[]
    for name,fq in [('minmax',baseline),('histogram',selected)]:
        frozen=fq.scale.clone()
        row=dict(method=name,scale=float(fq.scale),zero_point=int(fq.zero_point))
        for label,x in [('evaluation',evaluation),('shifted',shift)]:
            q=(x/fq.scale+fq.zero_point).round().clamp(-128,127).to(torch.int8)
            decoded=(q.float()-fq.zero_point)*fq.scale
            torch.testing.assert_close(decoded,fq(x))
            row[label]=metrics(decoded@wd.T,x@w.T)
            raw=x/fq.scale+fq.zero_point
            row[label]['saturation']=float(((raw < -128)|(raw > 127)).float().mean())
        assert torch.equal(frozen,fq.scale)
        row['timing']=timing(lambda:fq(evaluation)@wd.T)
        results.append(row)
    # 自定义真实INT8导出，不冒充torch.quantized.Linear或Thor部署格式。
    state=dict(weight=wcode, weight_scale=wscale, activation_scale=selected.scale.clone(),
               activation_zero_point=selected.zero_point.clone())
    path=out/'linear.pt';torch.save(state,path);loaded=torch.load(path,weights_only=True)
    def inference(x):
        q=(x/loaded['activation_scale']+loaded['activation_zero_point']).round().clamp(-128,127).to(torch.int8)
        xd=(q.float()-loaded['activation_zero_point'])*loaded['activation_scale']
        return xd@(loaded['weight'].float()*loaded['weight_scale']).T
    torch.testing.assert_close(inference(evaluation),selected(evaluation)@wd.T)
    # 空输入不更新，零值校准得到有限正scale。
    zero=HistogramObserver(dtype=torch.qint8,qscheme=torch.per_tensor_symmetric)
    zero(torch.empty(0));zero(torch.zeros(4));zs,_=zero.calculate_qparams();assert bool(torch.isfinite(zs).all() and (zs>0).all())
    report=dict(torch=torch.__version__,commit=torch.version.git_version,selected_bins=selected_bins,results=results,
                fp16_reference=metrics(evaluation.half().float()@w.half().float().T,evaluation@w.T),
                packed_weight_bytes=wcode.numel()*wcode.element_size(),
                metadata_bytes=sum(t.numel()*t.element_size() for k,t in state.items() if k!='weight'),
                packed_activation_bytes=evaluation.numel(),serialized_bytes=path.stat().st_size,
                fp32_tensor_bytes=(w.numel()+evaluation.numel())*4,
                fp16_tensor_bytes=(w.numel()+evaluation.numel())*2,
                cpu_only=True,thor_verified=False)
    print(json.dumps(report,indent=2))
