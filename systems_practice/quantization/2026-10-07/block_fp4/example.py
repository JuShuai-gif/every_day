"""ModelOpt 0.35.0原生NVFP4打包/重载；CUDA目标仅Thor 11.0。"""
import argparse
import importlib.metadata
import json
from pathlib import Path
import time
import torch
from modelopt.torch.quantization.qtensor.nvfp4_tensor import NVFP4QTensor

parser=argparse.ArgumentParser()
parser.add_argument('--output', default='build/native')
a=parser.parse_args()
out=Path(a.output);out.mkdir(parents=True,exist_ok=True)
if importlib.metadata.version('nvidia-modelopt') != '0.35.0':
    raise RuntimeError('Require the read ModelOpt 0.35.0; do not silently mix APIs')
if not torch.cuda.is_available() or torch.cuda.get_device_capability(0)!=(11,0):
    raise RuntimeError('Native entry fp4_compatible queries CUDA: require Thor SM110')
torch.manual_seed(17)
# FP32参考关闭TF32，精度比较与加速后端分开。
torch.backends.cuda.matmul.allow_tf32=False
device='cuda'
w=torch.randn(32,64,device=device,dtype=torch.float16)*0.2
# 不训练、不调参；校准与评估来自互不复用的独立随机样本。
cal=torch.randn(64,64,device=device,dtype=torch.float16)
x=torch.randn(16,64,device=device,dtype=torch.float16)*0.5
g=cal.float().abs().max()/(6*448)

def quant(t,global_scale=None):
    if not torch.isfinite(t).all() or t.shape[-1]%16:
        raise ValueError('finite and K divisible by16 required for this version dequant reshape')
    if global_scale is None:
        global_scale=t.float().abs().max()/(6*448)
    global_scale=global_scale.clamp_min(1e-12)
    # 上游float8 cast不等于饱和；超出校准包络时拒绝，避免NaN导出。
    if t.float().abs().max() > 6*448*global_scale*(1+1e-6):
        raise ValueError('calibration envelope exceeded; recalibrate on separate data')
    return NVFP4QTensor.quantize(t,block_size=16,weights_scaling_factor_2=global_scale,try_tensorrt=False)

def dequant(q,s,g):
    return q.dequantize(dtype=torch.float32,scale=s,double_scale=g,block_sizes={-1:16},fast=False)
qw,sw,gw=quant(w)
qx,sx,gx=quant(x,g)
wd=dequant(qw,sw,gw);xd=dequant(qx,sx,gx)
# 此版本类实现明确使用_quantized_data；内部字段依赖被版本固定。
state={'shape':tuple(w.shape),'data':qw._quantized_data.cpu(),
       'scale_u8':sw.view(torch.uint8).cpu(),'scale_shape':tuple(sw.shape),'global':gw.cpu()}
torch.save(state,out/'weight.pt')
saved=torch.load(out/'weight.pt',weights_only=True)
reloaded=NVFP4QTensor(torch.Size(saved['shape']),torch.float16,saved['data'].to(device))
rs=saved['scale_u8'].to(device).view(torch.float8_e4m3fn).reshape(saved['scale_shape'])
rw=dequant(reloaded,rs,saved['global'].to(device))
assert torch.equal(wd,rw)
ref=x.float()@w.float().T
half=(x@w.T).float()
y=xd@rw.T
assert torch.isfinite(y).all()

def metrics(t):
    e=t-ref
    return {'nrmse':float(e.norm()/ref.norm()),'max_abs':float(e.abs().max()),
            'cosine':float(torch.nn.functional.cosine_similarity(t.flatten(),ref.flatten(),dim=0))}
# 计时只含同步的框架调用，QDQ+FP32 GEMM不是原生FP4 Tensor Core。
def bench(fn):
    for _ in range(5):fn()
    torch.cuda.synchronize();ts=[]
    for _ in range(21):
        t=time.perf_counter();fn();torch.cuda.synchronize();ts.append((time.perf_counter()-t)*1e3)
    return sorted(ts)[10]
zero=torch.zeros(1,16,device=device,dtype=torch.float16)
zq,zs,zg=quant(zero);assert torch.count_nonzero(dequant(zq,zs,zg))==0
try:quant(w[:,:63])
except ValueError:pass
else:raise AssertionError('unaligned K must reject')
try:quant(torch.full((1,16),100.,device=device,dtype=torch.float16),g)
except ValueError:pass
else:raise AssertionError('calibration envelope must reject')
def absmax(t):
    scale=t.float().abs().max().clamp_min(1e-12)/7
    return (t.float()/scale).round().clamp(-7,7)*scale

report={'torch':torch.__version__,'modelopt':'0.35.0','shape':{'x':[16,64],'w':[32,64]},
        'fp16':metrics(half),'absmax_int4_qdq':metrics(absmax(x)@absmax(w).T),'nvfp4_w4a4_qdq':metrics(y),
        'packed_weight_payload_bytes':saved['data'].numel(),
        'scale_bytes':saved['scale_u8'].numel(),'global_bytes':saved['global'].numel()*saved['global'].element_size(),
        'container_file_bytes':(out/'weight.pt').stat().st_size,
        'fp16_framework_sync_ms_p50':bench(lambda:x@w.T),
        'qdq_fp32_framework_sync_ms_p50':bench(lambda:dequant(qx,sx,gx)@dequant(qw,sw,gw).T),
        'native_fp4_gemm_executed':False,'zero_and_unaligned_boundary':True}
print(json.dumps(report,indent=2))
