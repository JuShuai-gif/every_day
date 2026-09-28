"""原生 QuaRot rotation hook、ActQuantizer 与 pack_i4；单 Linear 教学接入。"""
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[2]))
from backfill_evaluation import setup,evaluate

a,torch,w,sets=setup('quarot')
sys.path.insert(0,str(a.source/'fake_quant'))
from rotation_utils import register_online_rotation
from quant_utils import ActQuantizer,pack_i4,unpack_i4
# 32 阶标准 Hadamard，独立构造，不调用未核验的 CUDA 扩展。
h=torch.ones(1,1)
while h.shape[0]<32:h=torch.cat([torch.cat([h,h],1),torch.cat([h,-h],1)],0)
q=h/(32**.5)
linear=torch.nn.Linear(32,16,bias=False)
with torch.no_grad():linear.weight.copy_(w@q)
register_online_rotation(linear,q)
with torch.no_grad():torch.testing.assert_close(linear(sets[1]),sets[1]@w.T,atol=2e-5,rtol=2e-5)
linear.rotate_handle.remove()
wr=w@q;scale=wr.abs().amax(1,keepdim=True).clamp_min(1e-8)/7
codes=(wr/scale).round().clamp(-8,7).to(torch.int8)
packed=pack_i4(codes);torch.testing.assert_close(unpack_i4(packed),codes.int(),rtol=0,atol=0)
act=ActQuantizer();act.configure(bits=4,sym=True,groupsize=-1,clip_ratio=1.0)
def infer(x):
    xr=x@q;act.find_params(xr)
    return act(xr)@(unpack_i4(packed).float()*scale).T
with torch.no_grad():before=infer(sets[2]).clone()
state={'packed':packed,'scale':scale,'rotation':q}
loaded=evaluate(a,torch,w,sets,infer,state,{'format':'signed INT4 packed weight + FP32 scales and dense FP32 rotation; activations QDQ','weight_payload_bytes':packed.numel(),'training_updates':0,'calibration':'not needed for fixed Hadamard/absmax; no GPTQ stage','comparison':'W4A4 rotation versus W4 weight-only absmax is diagnostic, not matched precision speedup'})
packed,scale,q=loaded['packed'],loaded['scale'],loaded['rotation']
with torch.no_grad():torch.testing.assert_close(infer(sets[2]),before,rtol=0,atol=0)
