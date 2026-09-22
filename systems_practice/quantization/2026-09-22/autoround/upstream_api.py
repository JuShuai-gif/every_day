#!/usr/bin/env python3
"""原生量化算法与 PyTorch 评估主流程；底层 C++ 实验可选。"""
import importlib.util
import json
import os
from pathlib import Path
import platform
import subprocess
import sys
import time

COMMIT = '8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1'
BASE = Path(__file__).resolve().parent
sys.path.insert(0, str(BASE.parents[1]))
from torch_evaluation import evaluate_torch


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
        evaluation_report = evaluate_torch(BASE / 'build', w, qw, rtn, scales, zp, evaluation, shifted, group)
        result = {'status': 'native_api_and_torch_evaluation_passed', 'torch': torch.__version__, 'commit': COMMIT,
                  'lr': lr, 'validation_mse': val_mse, 'actual_changed_parameters': changed,
                  'tuning_seconds': tune_seconds, 'training_log': history,
                  'torch_evaluation': evaluation_report, 'thor_verified': False}
        print(json.dumps(result, ensure_ascii=False, indent=2))
        (BASE / 'results/native-result.json').write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n')
    return 0


if __name__ == '__main__':
    sys.exit(main())
