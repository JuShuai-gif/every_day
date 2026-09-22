#!/usr/bin/env python3
"""调用 AutoRound v0.9.0 原生低层 API；驱动循环和 u4 容器由本练习编写。"""
import copy
import importlib.util
import json
import os
from pathlib import Path
import platform
import struct
import subprocess
import sys
import time

COMMIT = '8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1'
BASE = Path(__file__).resolve().parent


def preflight():
    failures = []
    if sys.version_info < (3, 10):
        failures.append('Python >=3.10 required; actual=' + platform.python_version())
    for name in ('torch', 'auto_round', 'transformers', 'numpy'):
        if importlib.util.find_spec(name) is None:
            failures.append('missing package: ' + name)
    repo = Path(os.environ.get('AUTOROUND_SOURCE', str(BASE / 'build/missing-checkout')))
    if not (repo / '.git').exists():
        failures.append('missing pinned checkout; set AUTOROUND_SOURCE')
    else:
        head = subprocess.check_output(['git', '-C', str(repo), 'rev-parse', 'HEAD'], text=True).strip()
        if head != COMMIT:
            failures.append('checkout commit mismatch: ' + head)
    if failures:
        print(json.dumps({'status': 'blocked', 'errors': failures}, ensure_ascii=False, indent=2))
        return None
    return repo.resolve()


def main():
    repo = preflight()
    if repo is None:
        return 2
    import torch
    import torch.nn.functional as F
    import auto_round
    from auto_round.data_type.int import quant_tensor_asym
    from auto_round.sign_sgd import SignSGD
    # 验证安装的实际核心源码与已读 commit 相同；不接受同名不同版本的函数。
    installed = Path(auto_round.__file__).resolve().parent
    for rel in ('data_type/int.py', 'data_type/utils.py', 'sign_sgd.py'):
        expected = subprocess.check_output(['git', '-C', str(repo), 'show', COMMIT + ':auto_round/' + rel])
        if (installed / rel).read_bytes() != expected:
            raise RuntimeError('installed core source mismatch: ' + rel)
    torch.set_num_threads(1)
    torch.manual_seed(73)
    n, k, group = 8, 33, 16
    ng = (k + group - 1) // group
    # frozen Linear 权重；更新的是舍入偏置/范围参数，不是原模型的任务训练。
    layer = torch.nn.Linear(k, n, bias=False).float().eval()
    layer.requires_grad_(False)
    with torch.no_grad():
        layer.weight[0].zero_()
        layer.weight[1, 0] = 2.0
    w = layer.weight.detach().clone()

    def data(seed, count, shift=False):
        x = torch.randn(count, k, generator=torch.Generator().manual_seed(seed))
        x[:, 0] *= 4.0 if not shift else 0.2
        x[:, -1] *= 0.2 if not shift else 8.0
        return x

    calibration, validation, evaluation, shifted = data(1, 128), data(2, 64), data(3, 64), data(4, 64, True)

    def qdq(params):
        return quant_tensor_asym(w, bits=4, group_size=group, v=params['v'],
                                 min_scale=params['lo'], max_scale=params['hi'],
                                 scale_dtype=torch.float32, q_scale_thresh=1e-8)

    def initial():
        return {'v': torch.nn.Parameter(torch.zeros(n * ng, group)),
                'lo': torch.nn.Parameter(torch.ones(n * ng)),
                'hi': torch.nn.Parameter(torch.ones(n * ng))}

    history = []
    candidates = []
    start = time.perf_counter()
    # 只在 calibration 上更新；只用 validation 选学习率；evaluation 从不参与选择。
    for lr in (0.005, 0.02):
        params = initial()
        initial_values = {key: value.detach().clone() for key, value in params.items()}
        optimizer = SignSGD(params.values(), lr=lr, momentum=0)
        for step in range(100):
            optimizer.zero_grad()
            with torch.no_grad():
                params['lo'].clamp_(0, 1)
                params['hi'].clamp_(0, 1)
            qw, _, _ = qdq(params)
            loss = F.mse_loss(F.linear(calibration, qw), F.linear(calibration, w))
            if not torch.isfinite(loss):
                raise RuntimeError('nonfinite calibration loss')
            loss.backward()
            optimizer.step()  # 原生 SignSGD 真正执行 param -= lr * sign(grad)。
            if step in (0, 49, 99):
                history.append({'lr': lr, 'step': step, 'calibration_mse_before_update': loss.item()})
        with torch.no_grad():
            params['lo'].clamp_(0, 1)
            params['hi'].clamp_(0, 1)
            frozen = {key: value.detach().clone() for key, value in params.items()}
            changed = sum((frozen[key] != initial_values[key]).sum().item() for key in frozen)
            if changed == 0:
                raise RuntimeError('no actual parameter updates')
            qw, _, _ = qdq(frozen)
            val_mse = F.mse_loss(F.linear(validation, qw), F.linear(validation, w)).item()
            candidates.append((val_mse, lr, frozen, changed))
    candidates.sort(key=lambda item: item[0])
    val_mse, lr, best, changed = candidates[0]
    tune_seconds = time.perf_counter() - start
    with torch.no_grad():
        qw, scales, zp = qdq(best)
        rtn, _, _ = qdq(initial())
        s = scales.reshape(n, ng).repeat_interleave(group, dim=1)[:, :k]
        z = zp.reshape(n, ng).repeat_interleave(group, dim=1)[:, :k]
        codes = torch.round(qw / s + z).to(torch.int64)
        if not ((codes >= 0) & (codes <= 15)).all():
            raise RuntimeError('u4 range')
        # 两个 logical codes/byte，低 nibble 在前；尾组 scales 仍保留。
        values = codes.flatten().tolist()
        packed = bytes(values[i] | ((values[i+1] if i+1 < len(values) else 0) << 4)
                       for i in range(0, len(values), 2))
        meta = struct.pack('<4sIII', b'ARU4', n, k, group)
        meta += struct.pack('<' + 'f' * scales.numel(), *scales.flatten().tolist())
        zbytes = bytes(int(x) for x in zp.flatten().tolist())
        blob = meta + zbytes + packed
        out = BASE / 'build'
        out.mkdir(exist_ok=True)
        path = out / 'linear.u4'
        path.write_bytes(blob)
        # 真正从磁盘字节恢复；不从原 float 权重取巧。
        raw = path.read_bytes()
        magic, rn, rk, rg = struct.unpack('<4sIII', raw[:16])
        assert (magic, rn, rk, rg) == (b'ARU4', n, k, group)
        rs = torch.tensor(struct.unpack('<'+'f'*(n*ng),raw[16:16+4*n*ng])).reshape(n,ng)
        rz = torch.tensor(list(raw[16+4*n*ng:16+5*n*ng])).reshape(n,ng)
        body = raw[16+5*n*ng:]
        decoded_codes = [((body[i//2] >> (4*(i%2))) & 15) for i in range(n*k)]
        decoded = (torch.tensor(decoded_codes).reshape(n,k)-rz.repeat_interleave(group,1)[:,:k]) * rs.repeat_interleave(group,1)[:,:k]
        torch.testing.assert_close(decoded,qw,rtol=1e-6,atol=1e-6)
        torch.testing.assert_close(decoded[0],torch.zeros(k),rtol=0,atol=0)
        # 明确 absmax 是独立基线，使用对称 -7..7 per-row INT4 网格。
        abs_s = w.abs().amax(1,keepdim=True).clamp_min(1e-8)/7
        abs_w = (w/abs_s).round().clamp(-7,7)*abs_s
        errors = {}
        for split, x in (('evaluation', evaluation), ('shifted', shifted)):
            ref = F.linear(x,w)
            for name, weight in (('FP32', w), ('FP16_reference', w.half()), ('absmax', abs_w),
                                 ('native_RTN', rtn), ('native_AutoRound', decoded)):
                # A16 路径先量化到 FP16，再扩回 FP32 做参考累加，不宣称 native FP16 GEMM。
                xx = x.half().float() if name in ('FP16_reference','native_AutoRound','native_RTN','absmax') else x
                yy = F.linear(xx,weight.float())
                diff = yy-ref
                errors[split+'/'+name] = {'nrmse': (diff.norm()/ref.norm().clamp_min(1e-12)).item(),
                                          'max_abs': diff.abs().max().item(),
                                          'cosine': F.cosine_similarity(yy.flatten(),ref.flatten(),dim=0).item()}
        # CPU 单线程已解码 F.linear 耗时，与低位 GEMM/量化调参耗时分开。
        def bench(weight):
            x = evaluation.half().float()
            for _ in range(10):
                F.linear(x,weight)
            samples=[]
            for _ in range(30):
                t=time.perf_counter_ns()
                F.linear(x,weight)
                samples.append((time.perf_counter_ns()-t)/1000)
            samples.sort()
            return {'p50_us':samples[14],'p95_us':samples[28]}
        result = {'status':'native_cpu_passed', 'torch':torch.__version__, 'commit':COMMIT,
                  'shape':{'X':[64,k],'W':[n,k]}, 'dtype':'CPU FP32 qdq and accumulation; A16 rounded inputs for deployment comparisons',
                  'lr':lr,'validation_mse':val_mse,'actual_changed_parameters':changed,
                  'tuning_seconds':tune_seconds,'training_log':history,'errors':errors,
                  'storage':{'FP32_weight_bytes':w.numel()*4,'FP16_weight_bytes':w.numel()*2,
                             'u4_weight_bytes':len(packed),'scales_bytes':scales.numel()*4,
                             'zero_points_bytes':len(zbytes),'header_bytes':16,'file_bytes':len(raw)},
                  'endpoint_code_fraction':((codes==0)|(codes==15)).float().mean().item(),
                  'clipped_fraction':None,'clipped_fraction_note':'endpoint occupation is not pre-clamp saturation; not instrumented',
                  'cpu_decoded_linear':{'FP32':bench(w),'AutoRound':bench(decoded)},'thor_verified':False}
        print(json.dumps(result,ensure_ascii=False,indent=2))
        (BASE/'results/native-result.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    return 0


if __name__ == '__main__':
    sys.exit(main())
