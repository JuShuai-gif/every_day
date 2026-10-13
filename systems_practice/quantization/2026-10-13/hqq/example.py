"""调用固定版本HQQ；默认CPU，原生打包与解码，不冒充低位GEMM。"""
import copy
import json
import math
from pathlib import Path
import statistics
import time
import torch
from hqq.core.quantize import Quantizer, HQQLinear, BaseQuantizeConfig, HQQBackend

OUT = Path(__file__).resolve().parent / 'build'
OUT.mkdir(exist_ok=True)
torch.manual_seed(1310)
torch.set_num_threads(1)
W = torch.randn(32, 64, dtype=torch.float32) * 0.2
W[:, 0] *= 8
# 无激活校准或训练；评估输入从未参与权重近端优化。
X = torch.randn(32, 64)
Xshift = X.clone()
Xshift[:, 0] *= 12

def metrics(got, ref):
    d = got.double() - ref.double()
    den = ref.double().square().sum()
    cosine = torch.nn.functional.cosine_similarity(got.flatten().double(), ref.flatten().double(), dim=0)
    return {'nrmse': math.sqrt(float(d.square().sum() / den.clamp_min(1e-30))),
            'max_abs': float(d.abs().max()), 'cosine': float(cosine)}

def latency(fn):
    for _ in range(10): fn()
    samples = []
    for _ in range(50):
        begin = time.perf_counter_ns()
        fn()
        samples.append((time.perf_counter_ns() - begin) / 1000)
    return {'cpu_sync_host_us_p50': statistics.median(samples), 'samples': 50}

def byte_count(x):
    if isinstance(x, torch.Tensor): return x.numel() * x.element_size()
    if isinstance(x, dict): return sum(byte_count(v) for v in x.values())
    return 0

@torch.inference_mode()
def main():
    result = {'torch': torch.__version__, 'device': 'cpu', 'shape_W': list(W.shape), 'shape_X': list(X.shape), 'rows': []}
    torch.save(W, OUT / 'fp32.pt')
    result['fp32'] = {'payload_bytes': byte_count(W), 'file_bytes': (OUT / 'fp32.pt').stat().st_size,
                     **latency(lambda: X @ W.T)}
    result['fp16_reference'] = metrics((X.half() @ W.half().T).float(), X @ W.T)
    # 独立absmax基线为数值QDQ，不算真实压缩导出。
    grouped = W.reshape(-1, 32)
    scale = grouped.abs().amax(1, keepdim=True).clamp_min(1e-8) / 7
    q = (grouped / scale).round().clamp(-7, 7)
    wa = (q * scale).reshape_as(W)
    result['absmax_qdq_only'] = metrics(X @ wa.T, X @ W.T)
    for group in (32, 64):
        for optimize in (False, True):
            begin = time.perf_counter_ns()
            packed, meta = Quantizer.quantize(W, nbits=4, group_size=group, axis=1,
                optimize=optimize, round_zero=True, bitpack=True, device='cpu')
            meta['compute_dtype'] = torch.float32
            quant_us = (time.perf_counter_ns() - begin) / 1000
            wr = Quantizer.dequantize(packed, meta)
            assert packed.dtype == torch.uint8 and packed.numel() * 2 == W.numel()
            # torch容器保存真实uint8数据及scale/zero；另报容器头开销。
            path = OUT / ('g%d-opt%d.pt' % (group, optimize))
            torch.save({'packed': packed, 'meta': meta}, path)
            loaded = torch.load(path, weights_only=False, map_location='cpu')  # 仅加载本程序刚写入的本地文件
            torch.testing.assert_close(Quantizer.dequantize(loaded['packed'], loaded['meta']), wr, rtol=0, atol=0)
            codes = Quantizer.unpack[meta['packing']](packed, dtype=torch.float32)
            result['rows'].append({'group': group, 'optimize': optimize, 'quantize_cpu_us': quant_us,
                'packed_bytes': byte_count(packed), 'scale_zero_bytes': byte_count(meta),
                'file_bytes': path.stat().st_size, 'endpoint_fraction': float(((codes == 0) | (codes == 15)).float().mean()),
                'eval': metrics(X @ wr.T, X @ W.T), 'shift': metrics(Xshift @ wr.T, Xshift @ W.T),
                'decode': latency(lambda: Quantizer.dequantize(packed, meta)),
                'decode_plus_matmul': latency(lambda: X @ Quantizer.dequantize(packed, meta).T)})
    zero, meta = Quantizer.quantize(torch.zeros(32, 64), nbits=4, group_size=32, axis=1, device='cpu')
    meta['compute_dtype'] = torch.float32
    assert torch.count_nonzero(Quantizer.dequantize(zero, meta)) == 0
    try:
        Quantizer.quantize(W, group_size=31, device='cpu')
    except AssertionError:
        result['invalid_group_rejected'] = True
    else:
        raise RuntimeError('nondivisible group accepted')
    # 已有模型接入点：model.proj = replacement；保留原层以对照。
    layer = torch.nn.Linear(64, 32, bias=False)
    layer.weight.copy_(W)
    HQQLinear.set_backend(HQQBackend.PYTORCH)
    config = BaseQuantizeConfig(nbits=4, group_size=32, axis=1)
    replacement = HQQLinear(layer, config, del_orig=False, compute_dtype=torch.float32, device='cpu')
    state_path = OUT / 'linear.pt'
    torch.save(replacement.state_dict(), state_path)
    restored = HQQLinear(None, config, initialize=False, compute_dtype=torch.float32, device='cpu')
    restored.load_state_dict(copy.deepcopy(torch.load(state_path, weights_only=False, map_location='cpu')))
    torch.testing.assert_close(replacement(X), restored(X), rtol=0, atol=0)
    result['linear_reload'] = metrics(restored(X), layer(X))
    print(json.dumps(result, indent=2))
    (OUT / 'measurements.json').write_text(json.dumps(result, indent=2) + '\n')

if __name__ == '__main__': main()
