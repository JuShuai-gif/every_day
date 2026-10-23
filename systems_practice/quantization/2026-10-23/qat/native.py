"""已核对TorchAO原生FakeQuantizedLinear；导出是本课自定义u4，不是后端convert。"""
import argparse
import copy
import json
import os
from pathlib import Path
import statistics
import struct
import subprocess
import sys
import time

COMMIT = "9e9dca96d42cf05985aeaf0afe5546d9d002b337"

def main():
    if sys.version_info < (3, 10):
        raise RuntimeError("Python >=3.10 required for this source; no dependencies installed")
    import torch
    import torchao
    from torchao.quantization.qat.linear import FakeQuantizedLinear
    from torchao.quantization.qat.fake_quantize_config import IntxFakeQuantizeConfig
    parser = argparse.ArgumentParser()
    parser.add_argument('--out', type=Path, default=Path('build/native'))
    args = parser.parse_args()
    root = Path(os.environ['TORCHAO_SOURCE']).resolve()
    actual = subprocess.check_output(['git', '-C', str(root), 'rev-parse', 'HEAD'], text=True).strip()
    if actual != COMMIT or root not in Path(torchao.__file__).resolve().parents:
        raise RuntimeError('Use the exact audited editable/source checkout')
    args.out.mkdir(parents=True, exist_ok=True)
    torch.set_num_threads(1)
    torch.manual_seed(23)
    teacher = torch.nn.Linear(16, 8, bias=False).float()
    # 四个独立种子；训练更新只看train，超参只看tune，eval最后使用。
    def data(seed, n):
        return torch.randn(n, 16, generator=torch.Generator().manual_seed(seed))
    train, cal, tune, test = data(1,64), data(2,32), data(3,32), data(4,31)
    shifted = test.clone(); shifted[:, 0] *= 12
    config = IntxFakeQuantizeConfig(torch.int32, group_size=8,
        quant_min=-8, quant_max=7, is_symmetric=True, is_dynamic=False)
    baseline = FakeQuantizedLinear.from_linear(copy.deepcopy(teacher), weight_config=config)
    with torch.no_grad():
        baseline(cal)  # 仅首次初始化权重scale；没有激活observer，cal不优化权重。
    initial = baseline.weight.detach().clone()
    candidates=[]
    for lr in (0.01, 0.05):
        model=copy.deepcopy(baseline)
        optimizer=torch.optim.SGD(model.parameters(), lr=lr)
        target=teacher(train).detach()
        history=[]
        for step in range(80):
            optimizer.zero_grad()
            loss=(model(train)-target).square().mean()
            loss.backward()
            assert model.weight.grad is not None and torch.isfinite(model.weight.grad).all()
            optimizer.step()
            if step in (0,39,79): history.append([step,float(loss.detach())])
        assert not torch.equal(initial,model.weight)
        with torch.no_grad(): score=float((model(tune)-teacher(tune)).square().mean())
        candidates.append((score,lr,model,history))
    _,lr,model,history=min(candidates,key=lambda v:v[0])
    fq=model.weight_fake_quantizer
    scales=fq.scale.detach().float().reshape(8,2)
    zp=fq.zero_point.detach().reshape(8,2)
    assert torch.count_nonzero(zp)==0
    w=model.weight.detach().reshape(8,2,8)
    codes=torch.round(w/scales[:,:,None]).clamp(-8,7).to(torch.int8).flatten().tolist()
    packed=bytes((codes[i]&15)|((codes[i+1]&15)<<4) for i in range(0,len(codes),2))
    header=struct.pack('<4sIII',b'Q4W1',8,16,8)
    blob=header+struct.pack('<16f',*scales.flatten().tolist())+packed
    path=args.out/'weights.bin';path.write_bytes(blob)
    loaded=path.read_bytes();magic,n,k,g=struct.unpack('<4sIII',loaded[:16]);assert (magic,n,k,g)==(b'Q4W1',8,16,8)
    restored=[]
    for byte in loaded[80:]:
        for q in (byte&15,byte>>4):restored.append(q-16 if q>=8 else q)
    assert restored==codes
    decoded=torch.tensor(restored).reshape(8,2,8)*torch.tensor(struct.unpack('<16f',loaded[16:80])).reshape(8,2,1)
    decoded=decoded.reshape(8,16)
    def metric(y,ref):
        d=(y-ref).float()
        return {'mse':float(d.square().mean()),'nrmse':float(d.norm()/ref.norm().clamp_min(1e-12)),
                'max_abs':float(d.abs().max()),'cosine':float(torch.nn.functional.cosine_similarity(y.flatten(),ref.flatten(),dim=0))}
    report={}
    with torch.no_grad():
        for name,x in [('eval',test),('shift',shifted),('zero',torch.zeros(1,16))]:
            ref=teacher(x)
            exported=torch.nn.functional.linear(x,decoded)
            torch.testing.assert_close(exported,model(x),rtol=1e-5,atol=1e-6)
            fp16=(x.half()@teacher.weight.detach().half().T).float()
            report[name]={'fp16':metric(fp16,ref),'ptq':metric(baseline(x),ref),'qat':metric(exported,ref)}
        def timing(fn):
            for _ in range(10):fn()
            samples=[]
            for _ in range(31):
                t=time.perf_counter_ns();fn();samples.append((time.perf_counter_ns()-t)/1000)
            return statistics.median(samples)
        timings={'fp32_us':timing(lambda:teacher(test)),
                 'decoded_fp32_us':timing(lambda:torch.nn.functional.linear(test,decoded)),
                 'fake_quant_us':timing(lambda:model(test))}
    try:
        FakeQuantizedLinear(17,8,weight_config=config)
        raise AssertionError('tail group was not rejected')
    except ValueError: pass
    report.update(commit=actual,torch=torch.__version__,torchao=getattr(torchao,'__version__','unknown'),
        lr=lr,updates_per_candidate=80,clamped_weight_fraction=float(((torch.round(w/scales[:,:,None]) < -8) | (torch.round(w/scales[:,:,None]) > 7)).float().mean()),history=history,weight_delta=float((model.weight.detach()-initial).abs().max()),
        bytes={'file':path.stat().st_size,'u4':len(packed),'scale':64,'header':16,'fp16_weight_payload':256,
               'training_fp32_weight':512},cpu_timing=timings,
        scope='CPU floating GEMM, custom packed export/reload; no lowbit kernel or Thor claim')
    (args.out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))

if __name__=='__main__':main()
