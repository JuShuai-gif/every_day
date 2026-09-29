"""原生SmoothQuant缩放/假量化API + 独立INT8导出；仅CPU，不下载模型。"""
import argparse
import copy
import json
import statistics
import subprocess
import sys
import time
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('--source', type=Path, required=True)
args = parser.parse_args()
repo = args.source.resolve()
if not (repo / 'smoothquant/smooth.py').is_file():
    raise SystemExit('Missing verified upstream checkout: ' + str(repo))
commit = subprocess.check_output(['git', '-C', str(repo), 'rev-parse', 'HEAD'], text=True).strip()
if subprocess.check_output(['git', '-C', str(repo), 'status', '--porcelain'], text=True).strip():
    raise SystemExit('Source checkout must be clean; review source differences before using a new revision')
sys.path.insert(0, str(repo))
import torch
import transformers
from smoothquant.smooth import smooth_ln_fcs
from smoothquant.fake_quant import W8A8Linear

root = Path(__file__).resolve().parent
(root / 'build').mkdir(exist_ok=True)
(root / 'results').mkdir(exist_ok=True)
torch.set_num_threads(1)
torch.manual_seed(31)
ln = torch.nn.LayerNorm(16).eval()
fc = torch.nn.Linear(16, 8).eval()
with torch.no_grad():
    ln.weight[0] = 12.0  # 制造LN之后的异常通道，观察难度迁移。

def samples(seed, n):
    return torch.randn(n, 16, generator=torch.Generator().manual_seed(seed))
calib, tune, evaluation = samples(101, 64), samples(202, 32), samples(303, 32)

@torch.no_grad()
def smoothed(alpha):
    norm, linear = copy.deepcopy(ln), copy.deepcopy(fc)
    scales = ln(calib).abs().amax(dim=0).clamp_min(1e-5)
    smooth_ln_fcs(norm, linear, scales, alpha=alpha)
    torch.testing.assert_close(linear(norm(tune)), fc(ln(tune)), rtol=1e-5, atol=1e-5)
    return norm, linear

@torch.no_grad()
def native_quant(linear):
    # from_float会原地量化传入权重，因此传深拷贝，保留FP32真值。
    return W8A8Linear.from_float(copy.deepcopy(linear), weight_quant='per_channel',
                                act_quant='per_token', quantize_output=False).float()

def metrics(y, ref):
    delta = (y - ref).float()
    return {'nrmse': float(delta.norm() / ref.float().norm().clamp_min(1e-12)),
            'max_abs': float(delta.abs().max()),
            'cosine': float(torch.nn.functional.cosine_similarity(y.float().flatten(), ref.float().flatten(), dim=0))}

@torch.no_grad()
def export(linear, norm):
    # 自定义真实INT8存储，不是上游torch-int部署格式。
    scale = linear.weight.abs().amax(dim=1, keepdim=True).clamp_min(1e-5) / 127
    codes = torch.round(linear.weight / scale).clamp(-127, 127).to(torch.int8)
    return {'weight': codes, 'scale': scale, 'bias': linear.bias.detach().clone(),
            'ln_weight': norm.weight.detach().clone(), 'ln_bias': norm.bias.detach().clone()}

@torch.no_grad()
def decoded_forward(state, x):
    a = torch.nn.functional.layer_norm(x, (16,), state['ln_weight'], state['ln_bias'], eps=ln.eps)
    a_scale = a.abs().amax(dim=-1, keepdim=True).clamp_min(1e-5) / 127
    q = torch.round(a / a_scale).clamp(-127, 127).to(torch.int8)
    # 明确解码为FP32 GEMM；不是原生INT8 Tensor Core。
    return torch.nn.functional.linear(q.float() * a_scale, state['weight'].float() * state['scale'], state['bias'])

@torch.no_grad()
def benchmark(fn):
    for _ in range(20): fn()
    times = []
    for _ in range(100):
        start = time.perf_counter_ns()
        fn()
        times.append((time.perf_counter_ns() - start) / 1000)
    times.sort()
    return {'p50_us': statistics.median(times), 'p95_us': times[94], 'scope': 'CPU LN+QDQ+Linear framework call; no device/kernel claim'}

with torch.no_grad():
    # 只用tune选择alpha；evaluation直到冻结后才参与误差报告。
    scores = []
    for alpha in [0.0, 0.25, 0.5, 0.75, 1.0]:
        norm, linear = smoothed(alpha)
        score = metrics(native_quant(linear)(norm(tune)), fc(ln(tune)))['nrmse']
        scores.append((score, alpha))
    alpha = min(scores)[1]
    norm, linear = smoothed(alpha)
    quant = native_quant(linear)
    baseline = native_quant(fc)
    reference = fc(ln(evaluation))
    y = quant(norm(evaluation))
    fp16 = copy.deepcopy(fc).half()(copy.deepcopy(ln).half()(evaluation.half())).float()
    state = export(linear, norm)
    artifact = root / 'build' / 'smoothquant-int8.pt'
    torch.save(state, artifact)
    loaded = torch.load(artifact, map_location='cpu', weights_only=True)
    decoded = decoded_forward(loaded, evaluation)
    torch.testing.assert_close(decoded, y, rtol=1e-5, atol=1e-5)
    for boundary in [torch.zeros(1, 16), torch.ones(1, 16)]:
        assert torch.isfinite(decoded_forward(loaded, boundary)).all()
    tensor_bytes = {k: v.numel() * v.element_size() for k, v in state.items()}
    activation = norm(evaluation)
    step = activation.abs().amax(dim=-1, keepdim=True).clamp_min(1e-5)/127
    report = {'date': '2026-09-29', 'commit_used': commit, 'torch': torch.__version__,
        'transformers': transformers.__version__, 'alpha': alpha, 'tuning_scores': scores,
        'fp16': metrics(fp16, reference), 'absmax_w8a8': metrics(baseline(ln(evaluation)), reference),
        'smoothquant_w8a8': metrics(y, reference),
        'export_reload_max_abs': float((decoded-y).abs().max()),
        'tensor_bytes': tensor_bytes, 'checkpoint_file_bytes': artifact.stat().st_size(),
        'fp32_weight_bytes': fc.weight.numel()*4,
        'native_fake_quant_weight_bytes': quant.weight.numel()*quant.weight.element_size(),
        'activation_codes_bytes': activation.numel(), 'activation_scales_bytes': step.numel()*4,
        'activation_rail_fraction': float((torch.round(activation/step).abs() >= 127).float().mean()),
        'activation_preclamp_overflow_fraction': float((torch.round(activation/step).abs() > 127).float().mean()),
        'timing_fp32': benchmark(lambda: fc(ln(evaluation))),
        'timing_absmax': benchmark(lambda: baseline(ln(evaluation))),
        'timing_smoothquant_qdq': benchmark(lambda: quant(norm(evaluation))),
        'timing_decode': benchmark(lambda: decoded_forward(loaded, evaluation)),
        'training_updates': 0, 'thor_verified': False}
print(json.dumps(report, indent=2))
# 每次新文件，避免覆盖旧实验记录。
out = root / 'results' / ('run-%d.json' % time.time_ns())
out.write_text(json.dumps(report, indent=2) + '\n')
