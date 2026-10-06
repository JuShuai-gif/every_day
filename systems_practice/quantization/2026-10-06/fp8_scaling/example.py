"""原生torchao v0.13.0 API示例；emulate是数值验证，不是FP8硬件吞吐。"""
import argparse
import copy
import json
import time
from pathlib import Path
import torch
import torchao
from torchao.float8.float8_utils import tensor_to_scale, to_fp8_saturated
from torchao.float8.float8_linear import Float8Linear
from torchao.float8.config import Float8LinearConfig

def metrics(ref, out):
    delta = out.float() - ref.float()
    return {"nrmse": (delta.norm() / ref.float().norm().clamp_min(1e-12)).item(),
            "max_abs": delta.abs().max().item(),
            "cosine": torch.nn.functional.cosine_similarity(ref.flatten().float(), out.flatten().float(), dim=0).item()}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--device', choices=['cpu', 'cuda'], default='cpu')
    args = parser.parse_args()
    if not str(torchao.__version__).startswith('0.13.0'):
        raise RuntimeError('requires reviewed torchao 0.13.0')
    if args.device == 'cuda' and torch.cuda.get_device_capability() != (11, 0):
        raise RuntimeError('CUDA execution requires Thor SM110')
    device = args.device
    # 模型权重和评估输入使用不同种子；动态缩放不训练、不挑校准参数。
    torch.manual_seed(106)
    layer = torch.nn.Linear(64, 32, bias=False, dtype=torch.float32, device=device)
    torch.manual_seed(206)
    x = torch.randn(16, 64, device=device)
    x[0] *= 40
    ref = layer(x).detach()
    fp16 = torch.nn.functional.linear(x.half(), layer.weight.half()).float()
    config = Float8LinearConfig(emulate=True)
    converted = Float8Linear.from_float(copy.deepcopy(layer), config=config)
    with torch.no_grad():
        output = converted(x)
        # 明确导出真实1字节FP8数据与FP32乘法scale，不保存为浮点QDQ数组。
        sw = tensor_to_scale(layer.weight, torch.float8_e4m3fn)
        qw = to_fp8_saturated(layer.weight * sw, torch.float8_e4m3fn)
        sx = tensor_to_scale(x, torch.float8_e4m3fn)
        qx = to_fp8_saturated(x * sx, torch.float8_e4m3fn)
        folder = Path('build'); folder.mkdir(exist_ok=True)
        torch.save({'weight': qw.cpu(), 'scale_mul': sw.cpu(), 'shape': [32, 64]}, folder/'fp8.pt')
        restored = torch.load(folder/'fp8.pt', weights_only=True)
        # 接入已有Linear的验证替换点：解码后F.linear；不是原生FP8 GEMM。
        decoded = restored['weight'].to(device).float() / restored['scale_mul'].to(device)
        reload_out = torch.nn.functional.linear(qx.float()/sx, decoded)
        assert torch.allclose(reload_out, output.float(), rtol=1e-3, atol=1e-3)
        assert torch.isfinite(converted(torch.zeros_like(x))).all()
        def sync():
            if device == 'cuda': torch.cuda.synchronize()
        for _ in range(10): converted(x)
        samples=[]
        for _ in range(31):
            sync(); start=time.perf_counter()
            converted(x)
            sync(); samples.append((time.perf_counter()-start)*1000)
    print(json.dumps({'torch': str(torch.__version__), 'torchao': str(torchao.__version__),
        'device': device, 'emulate': True, 'fp16': metrics(ref,fp16), 'fp8': metrics(ref,output),
        'export_reloaded': True, 'weight_payload_bytes': qw.numel()*qw.element_size()+sw.numel()*sw.element_size(),
        'fp32_weight_bytes': layer.weight.numel()*4, 'serialized_file_bytes': (folder/'fp8.pt').stat().st_size,
        'weight_saturation_count': int(((layer.weight*sw).abs()>448).sum()),
        'synchronized_framework_emulation_ms_p50': sorted(samples)[15]}, indent=2))
if __name__ == '__main__': main()
