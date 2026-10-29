"""小型 Thor FP8 Linear：明确检查转换是否真的发生，并与 FP16 参考比较。"""
import torch
from torchao.quantization import Float8DynamicActivationFloat8WeightConfig, quantize_

if not torch.cuda.is_available() or torch.cuda.get_device_capability() != (11, 0):
    raise RuntimeError("this example requires Jetson Thor SM110")
torch.manual_seed(1028)
model = torch.nn.Linear(64, 64, device="cuda", dtype=torch.float16).eval()
x = torch.randn(16, 64, device="cuda", dtype=torch.float16)
with torch.no_grad():
    reference = model(x)
    quantize_(model, Float8DynamicActivationFloat8WeightConfig())
    # torchao 可能跳过不满足尺寸条件的层；不能把 FP16 回退称为 FP8。
    if type(model.weight).__name__ != "Float8Tensor":
        raise RuntimeError("FP8 conversion was skipped; inspect torchao size/backend requirements")
    result = model(x)
    torch.cuda.synchronize()
    if not torch.isfinite(result).all():
        raise RuntimeError("non-finite FP8 output")
    torch.testing.assert_close(result, reference, rtol=0.2, atol=0.1)
    print(f"PASS Thor FP8 Linear shape={tuple(result.shape)} weight_type={type(model.weight).__name__} "
          f"max_abs={(result - reference).abs().max().item():.6f}")
