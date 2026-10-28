# 需要 torch/torchao；不在本机安装依赖。
import torch
from torchao.quantization import quantize_, Float8DynamicActivationFloat8WeightConfig
model = torch.nn.Linear(16, 8).cuda()
quantize_(model, Float8DynamicActivationFloat8WeightConfig())
y = model(torch.randn(2, 16, device="cuda", dtype=torch.float16))
print(y.shape)
