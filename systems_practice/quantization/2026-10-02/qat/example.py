"""torchao 0.13.0 native FakeQuantizedLinear QAT; CPU numeric/export example."""
import copy
import importlib.metadata
import json
from pathlib import Path
import struct
import time
import statistics
import torch
from torchao.quantization.qat.linear import FakeQuantizedLinear
from torchao.quantization.qat.fake_quantize_config import IntxFakeQuantizeConfig
assert torch.__version__.split('+')[0] == '2.8.0', 'review example before changing torch version'
assert importlib.metadata.version('torchao') == '0.13.0'
torch.manual_seed(1002)
torch.set_num_threads(1)
# 模型权重、训练、调参和测试采用分离随机流；不下载模型。
def inputs(seed, n):
    return torch.randn(n, 64, generator=torch.Generator().manual_seed(seed))
teacher = torch.nn.Linear(64, 16, bias=False).eval()
for p in teacher.parameters():
    p.requires_grad_(False)
xtrain, xval, xtest = inputs(11, 128), inputs(12, 64), inputs(13, 64)
# 动态组scale无需激活校准；训练集仅用于梯度，验证集选择学习率/checkpoint。
config = IntxFakeQuantizeConfig(dtype=torch.int8, group_size=32, is_symmetric=True,
                              is_dynamic=True, scale_precision=torch.float32,
                              zero_point_precision=torch.float32)
def new_model():
    # from_linear共享传入层的Parameter；必须deepcopy，避免改动原模型/teacher。
    layer = copy.deepcopy(teacher)
    layer.weight.requires_grad_(True)
    return FakeQuantizedLinear.from_linear(layer, activation_config=None, weight_config=config)
def mse(model, x):
    with torch.no_grad():
        return float((model(x)-teacher(x)).square().mean())
ptq = new_model()
best_weight, best_val, best_step, best_lr = ptq.weight.detach().clone(), mse(ptq, xval), 0, 0.0
updates = []
for lr in [0.001, 0.01]:
    model = new_model()
    initial = model.weight.detach().clone()
    optimizer = torch.optim.SGD(model.parameters(), lr=lr)
    target = teacher(xtrain).detach()
    for step in range(1, 81):
        optimizer.zero_grad(set_to_none=True)
        loss = (model(xtrain)-target).square().mean()
        loss.backward()
        assert torch.isfinite(model.weight.grad).all()
        optimizer.step()  # 真正修改浮点master权重，不是只打印fake-quant误差。
        score = mse(model, xval)
        if score < best_val:
            best_weight, best_val, best_step, best_lr = model.weight.detach().clone(), score, step, lr
    delta = float((model.weight-initial).abs().max())
    assert delta > 0
    updates.append({'lr': lr, 'steps': 80, 'max_master_delta': delta})
# 只存权重checkpoint，避免复制fake-quantizer缓存的非叶子Tensor。
best_model = new_model()
with torch.no_grad():
    best_model.weight.copy_(best_weight)
# 只在确定候选后触碰测试集；不承诺QAT必胜PTQ。
with torch.no_grad():
    fq = best_model.weight_fake_quantizer
    wfake = fq(best_model.weight).detach()
    scales, zeros = fq.scale.detach().reshape(16, 2), fq.zero_point.detach().reshape(16, 2)
    s = scales.repeat_interleave(32, 1)
    z = zeros.repeat_interleave(32, 1)
    codes = torch.round(wfake/s+z).clamp(-128, 127).to(torch.int8)
    wdq = (codes.float()-z)*s
    torch.testing.assert_close(wdq, wfake)
# 独立原始格式：INT8行主序+FP32组scale+FP32组zero。不是torchao原生部署格式。
header = struct.pack('<4sIII', b'QAT8', 16, 64, 32)
packed = header + struct.pack('<1024b', *codes.flatten().tolist())
packed += struct.pack('<32f', *scales.flatten().tolist()) + struct.pack('<32f', *zeros.flatten().tolist())
out = Path('build'); out.mkdir(exist_ok=True)
(out/'weights.bin').write_bytes(packed)
data = (out/'weights.bin').read_bytes()
assert struct.unpack('<4sIII', data[:16]) == (b'QAT8', 16, 64, 32)
c = torch.tensor(struct.unpack('<1024b', data[16:1040]), dtype=torch.float32).reshape(16,64)
s2 = torch.tensor(struct.unpack('<32f', data[1040:1168])).reshape(16,2).repeat_interleave(32,1)
z2 = torch.tensor(struct.unpack('<32f', data[1168:1296])).reshape(16,2).repeat_interleave(32,1)
exported = torch.nn.Linear(64,16,bias=False)
with torch.no_grad():
    exported.weight.copy_((c-z2)*s2)
    torch.testing.assert_close(exported(xtest),best_model(xtest))
def bench(model):
    with torch.no_grad():
        for _ in range(20): model(xtest)
        us=[]
        for _ in range(100):
            start=time.perf_counter_ns(); model(xtest); us.append((time.perf_counter_ns()-start)/1000)
    us.sort();return {'cpu_sync_p50_us':statistics.median(us),'cpu_sync_p95_us':us[94]}
result={'torch':torch.__version__,'torchao':importlib.metadata.version('torchao'),
 'updates':updates,'selected':{'lr':best_lr,'step':best_step,'validation_mse':best_val},
 'test_ptq_mse':mse(ptq,xtest),'test_qat_mse':mse(best_model,xtest),
 'test_export_mse':mse(exported,xtest),'fp32_weight_bytes':teacher.weight.numel()*4,
 'payload_bytes':len(data),'codes_bytes':1024,'scale_zero_bytes':256,'header_bytes':16,
 'timing_fp32':bench(teacher),'timing_dequantized_fp32':bench(exported),
 'boundary':'CPU dense float32 timing only; INT8 storage, A32, float32 accumulation; no integer kernel speed claim'}
print(json.dumps(result,indent=2))
