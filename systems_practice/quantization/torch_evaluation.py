"""量化课程的 PyTorch 精度、模型重载与框架级耗时对照；C++ 实验可选。"""
import json
import os
from pathlib import Path
import time


def evaluate_torch(directory, original, quantized, rtn, scales, zeros, evaluation,
                   shifted, group_size, offset_convention=False):
    import torch
    import torch.nn.functional as F

    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    device = original.device

    def metrics(reference, candidate):
        a, b = reference.double().flatten(), candidate.double().flatten()
        if not torch.isfinite(a).all() or not torch.isfinite(b).all():
            raise RuntimeError('nonfinite evaluation output')
        error = b - a
        norm_a, norm_b = a.norm(), b.norm()
        return {'nrmse': float(error.norm() / norm_a.clamp_min(1e-30)),
                'max_abs': float(error.abs().max()),
                'cosine': float(torch.dot(a, b) / (norm_a * norm_b))
                if norm_a > 0 and norm_b > 0 else None}

    def synchronize():
        if device.type == 'cuda':
            torch.cuda.synchronize(device)

    def benchmark(x, weight):
        # 框架调用的同步主机耗时，包含分配/调度；不是单个硬件 kernel 时间。
        for _ in range(10):
            F.linear(x, weight)
        synchronize()
        samples = []
        for _ in range(50):
            synchronize()
            begin = time.perf_counter_ns()
            result = F.linear(x, weight)
            synchronize()
            samples.append((time.perf_counter_ns() - begin) / 1000)
        if not torch.isfinite(result).all():
            raise RuntimeError('nonfinite benchmark output')
        samples.sort()
        return {'p50_us': samples[24], 'p95_us': samples[47], 'warmup': 10, 'samples': 50}

    with torch.no_grad():
        w = original.detach().float()
        q = quantized.detach().float()
        nearest = rtn.detach().float()
        if w.ndim != 2 or q.shape != w.shape or nearest.shape != w.shape:
            raise ValueError('expected matching [output, input] weight matrices')
        # 这是框架 FP32 重建检查点，不能把文件大小当作 INT4 压缩率。
        checkpoint = directory / 'torch-reconstructed.pt'
        torch.save({'weight': q.cpu(), 'scales': scales.detach().cpu(),
                    'zeros_or_offsets': zeros.detach().cpu(), 'group_size': group_size,
                    'offset_convention': offset_convention}, checkpoint)
        reloaded = torch.load(checkpoint, map_location=device, weights_only=True)
        torch.testing.assert_close(reloaded['weight'], q, rtol=0, atol=0)
        layer = torch.nn.Linear(w.shape[1], w.shape[0], bias=False, device=device).float().eval()
        layer.weight.copy_(reloaded['weight'])
        torch.testing.assert_close(layer(evaluation.float()), F.linear(evaluation.float(), q),
                                   rtol=0, atol=0)
        # absmax 是独立算法基线；用张量表达公式，不作为底层位布局/指令实现。
        step = w.abs().amax(dim=1, keepdim=True).clamp_min(1e-12) / 7
        absmax = (w / step).round().clamp(-7, 7) * step
        weights = {'fp16_storage_fp32_operator': w.half().float(),
                   'independent_absmax': absmax, 'upstream_rtn': nearest,
                   'native_quantized_reconstruction': reloaded['weight']}
        comparisons = {}
        for label, inputs in (('evaluation', evaluation), ('shifted', shifted),
                              ('zero_input', torch.zeros_like(evaluation))):
            x = inputs.float()
            reference = F.linear(x, w)
            x16 = x.half().float()
            comparisons[label] = {name: metrics(reference, F.linear(x16, weight))
                                  for name, weight in weights.items()}
        x = evaluation.half().float()
        report = {'status': 'torch_evaluation_passed', 'torch': torch.__version__,
                  'device': str(device), 'comparisons': comparisons,
                  'reconstructed_checkpoint_bytes': checkpoint.stat().st_size,
                  'checkpoint_format': 'torch FP32 reconstruction with metadata; not packed INT4',
                  'framework_timing': {name: benchmark(x, weight)
                                       for name, weight in (('fp32_reference', w),
                                                            ('quantized_reconstruction', reloaded['weight']))},
                  'timing_scope': 'synchronized host F.linear wall time; includes allocation/dispatch, excludes calibration/export/reload; not isolated kernel time',
                  'precision_scope': 'FP16-rounded comparison inputs/storage promoted to FP32 operators; accumulation implementation depends on PyTorch backend',
                  'full_model_task_accuracy_verified': False,
                  'packed_lowbit_kernel_verified': False}
        # 只有显式选择 native-cpp 才附加物理布局与独立 CPU 内核实验。
        if os.environ.get('QUANT_WITH_CPP') == '1':
            from native_bridge import evaluate_cpp
            report['optional_cpp_experiment'] = evaluate_cpp(
                directory, original, quantized, rtn, scales, zeros, evaluation,
                shifted, group_size, offset_convention)
        (directory / 'torch-result.json').write_text(json.dumps(report, ensure_ascii=False,
                                                               indent=2, allow_nan=False) + '\n')
        return report
