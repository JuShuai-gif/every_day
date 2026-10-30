"""原生AWQ helper/API使用；需已审计的checkout和可导入的CUDA扩展，不伪造CPU后端。"""
import copy
import json
import os
from pathlib import Path
import subprocess
import sys
import time

root = Path(os.environ['AWQ_ROOT']).resolve()
commit = subprocess.check_output(['git', '-C', str(root), 'rev-parse', 'HEAD'], text=True).strip()
assert commit == 'd6e797a42b9ef7778de8ee2352116e0f48a78d61', commit
sys.path.insert(0, str(root))
import torch
from awq.quantize.auto_scale import get_act_scale, scale_ln_fcs
from awq.quantize.quantizer import pseudo_quantize_tensor
from awq.quantize.qmodule import WQLinear

def err(x, ref):
    d = x.float() - ref.float()
    return {'nrmse': (d.norm() / ref.float().norm().clamp_min(1e-12)).item(), 'max_abs': d.abs().max().item()}

@torch.no_grad()
def main():
    torch.manual_seed(17)
    K, N, G = 128, 128, 128
    ln = torch.nn.LayerNorm(K).eval()
    fc = torch.nn.Linear(K, N, bias=False).eval()
    ln.weight[0] = 24
    def data(seed, count):
        return torch.randn(count, K, generator=torch.Generator().manual_seed(seed))
    calibration, tuning, test = data(101, 32), data(102, 32), data(103, 16)
    # 无训练；统计只看校准集，ratio选择只看调参集，评估不回流。
    acts = get_act_scale(ln(calibration))
    ref_tune = fc(ln(tuning))
    candidates = []
    for i in range(20):
        s = acts.pow(i / 20).clamp_min(1e-4)
        s /= (s.max() * s.min()).sqrt()
        wq = pseudo_quantize_tensor(fc.weight * s, n_bit=4, zero_point=True, q_group_size=G)
        score = ((torch.nn.functional.linear(ln(tuning) / s, wq)-ref_tune)**2).mean().item()
        candidates.append((score, i / 20, s))
    _, ratio, scales = min(candidates, key=lambda t: t[0])
    lnq, fcq = copy.deepcopy(ln), copy.deepcopy(fc)
    scale_ln_fcs(lnq, [fcq], scales)
    ref32 = fc(ln(test))
    assert torch.allclose(fcq(lnq(test)), ref32, atol=1e-5, rtol=1e-5)
    fp16 = copy.deepcopy(fc).half()(copy.deepcopy(ln).half()(test.half()))
    # 上游对称分支有未定义min_val，不调用；absmax是显式独立基线。
    w = fc.weight
    abs_scale = w.abs().amax(1, keepdim=True).clamp_min(1e-5)/7
    abs_out = torch.nn.functional.linear(ln(test), (w/abs_scale).round().clamp(-7,7)*abs_scale)
    # 真实WQLinear要求FP16，并带padding后的scale/zero metadata。
    lnq, fcq = lnq.half(), fcq.half()
    fcq.weight.data, step, zero = pseudo_quantize_tensor(fcq.weight.data, n_bit=4, zero_point=True, q_group_size=G, get_scale_zp=True)
    packed = WQLinear.from_linear(fcq, 4, G, False, step, zero)
    build = Path(__file__).parent/'build'; build.mkdir(exist_ok=True)
    target = build/'native.pt'
    torch.save({'ln':lnq.state_dict(), 'packed':packed.state_dict(), 'ratio':ratio}, target)
    state = torch.load(target, map_location='cpu', weights_only=True)
    restored = WQLinear.from_linear(fcq, 4, G, True)
    restored.load_state_dict(state['packed'])
    lnq.load_state_dict(state['ln'])
    stats = {'ratio':ratio, 'fp16':err(fp16,ref32), 'absmax_qdq':err(abs_out,ref32),
             'awq_qdq':err(fcq(lnq(test.half())),ref32),
             'tensor_payload_bytes':sum(t.numel()*t.element_size() for t in packed.state_dict().values()),
             'serialized_file_bytes':target.stat().st_size,
             'fp16_linear_payload_bytes':fc.weight.numel()*2, 'thor_verified':False}
    if os.environ.get('THOR') == '1':
        assert torch.cuda.get_device_capability() == (11,0), 'execution target must be Thor SM110'
        restored, lnq, xt = restored.cuda(), lnq.cuda(), test.half().cuda()
        qdq = fcq.cuda()(lnq(xt)); actual = restored(lnq(xt))
        assert torch.allclose(actual, qdq, atol=.1, rtol=.03), err(actual, qdq)
        # 同一输入与LN+Linear边界，分别预热、多次同步计时；不是单kernel时间。
        base_ln, base_fc = copy.deepcopy(ln).half().cuda(), copy.deepcopy(fc).half().cuda()
        def measure(call):
            for _ in range(10): call()
            torch.cuda.synchronize()
            samples=[]
            for _ in range(21):
                start=time.perf_counter()
                for _ in range(50): call()
                torch.cuda.synchronize()
                samples.append((time.perf_counter()-start)*1000/50)
            samples.sort()
            return {'p50_ms':samples[10], 'p95_ms':samples[19]}
        stats['synchronized_host_LN_plus_Linear']={
            'fp16':measure(lambda: base_fc(base_ln(xt))),
            'packed_awq':measure(lambda: restored(lnq(xt)))}
        stats['native_output']=err(actual.cpu(),ref32)
        stats['thor_verified']=True
    print(json.dumps(stats, indent=2))

if __name__ == '__main__':
    main()
