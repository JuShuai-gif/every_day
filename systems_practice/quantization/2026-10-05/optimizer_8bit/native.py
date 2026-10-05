"""原生 bitsandbytes 0.48.1 Adam8bit；不下载模型，不安装依赖。"""
import copy
import json
import pathlib
import time
import torch
import bitsandbytes as bnb

if bnb.__version__ != "0.48.1":
    raise RuntimeError("Requires reviewed bitsandbytes==0.48.1")
if not torch.cuda.is_available() or torch.cuda.get_device_capability() != (11, 0):
    raise RuntimeError("Native optimizer experiment requires Jetson Thor SM110")
torch.manual_seed(17)
device = "cuda"
root = pathlib.Path(__file__).resolve().parent
(root / "build").mkdir(exist_ok=True)
# 训练/调参/评估种子独立；不对评估集选择学习率。无需离线PTQ校准。
def data(seed, rows):
    g = torch.Generator(device=device).manual_seed(seed)
    x = torch.randn(rows, 128, generator=g, device=device)
    teacher = torch.arange(64 * 128, device=device, dtype=torch.float32).reshape(64, 128).sin() / 64
    return x, torch.nn.functional.linear(x, teacher)
train = data(101, 32)
tune = data(202, 16)
eval_data = data(303, 16)
initial = torch.nn.Linear(128, 64, bias=True, device=device)
initial_state = copy.deepcopy(initial.state_dict())
# 一个8192元素weight进入uint8路径，64元素bias验证默认4096阈值回退。
def trial(bits, lr, steps=40):
    model = torch.nn.Linear(128, 64, bias=True, device=device)
    model.load_state_dict(initial_state)
    cls = bnb.optim.Adam8bit if bits == 8 else bnb.optim.Adam32bit
    opt = cls(model.parameters(), lr=lr, betas=(0.9, 0.999), eps=1e-8,
              weight_decay=0, min_8bit_size=4096, block_wise=True)
    elapsed = []
    losses = []
    for step in range(steps):
        opt.zero_grad(set_to_none=True)
        loss = (model(train[0]) - train[1]).square().mean()
        loss.backward()
        # 单次step主机墙钟含同步/API开销；不标为单kernel耗时。
        torch.cuda.synchronize()
        begin = time.perf_counter()
        opt.step()
        torch.cuda.synchronize()
        if step >= 5:
            elapsed.append((time.perf_counter() - begin) * 1000)
        losses.append(float(loss))
    assert not torch.equal(model.weight, initial_state['weight'])
    assert torch.isfinite(model.weight).all()
    return model, opt, elapsed, losses
# 两种优化器共用32bit调参选出的lr，评估保持未见。
tuning = []
for lr in (0.003, 0.01):
    m, _, _, _ = trial(32, lr, 20)
    with torch.no_grad():
        tuning.append((float((m(tune[0])-tune[1]).square().mean()), lr))
lr = min(tuning)[1]
models, report = {}, {"lr": lr, "tuning": tuning, "versions": {"torch": torch.__version__, "bnb": bnb.__version__}}
for bits in (32, 8):
    model, opt, elapsed, losses = trial(bits, lr)
    states = list(opt.state.values())
    if bits == 8:
        assert opt.state[model.weight]['state1'].dtype == torch.uint8
        assert opt.state[model.bias]['state1'].dtype == torch.float32
    # 对实际底层storage去重，计入双状态、absmax与码本；不是模型大小估算。
    storages = {}
    dtypes = {}
    for idx, state in enumerate(states):
        for name, tensor in state.items():
            if isinstance(tensor, torch.Tensor):
                storage = tensor.untyped_storage()
                storages[(tensor.device, storage.data_ptr())] = storage.nbytes()
                dtypes[f'{idx}.{name}'] = str(tensor.dtype)
    target = root / 'build' / f'checkpoint-{bits}.pt'
    torch.save({'model': model.state_dict(), 'optimizer': opt.state_dict()}, target)
    saved = torch.load(target, map_location=device, weights_only=True)
    restored = torch.nn.Linear(128, 64, device=device)
    restored.load_state_dict(saved['model'])
    cls = bnb.optim.Adam8bit if bits == 8 else bnb.optim.Adam32bit
    restored_opt = cls(restored.parameters(), lr=lr, min_8bit_size=4096, block_wise=True)
    restored_opt.load_state_dict(saved['optimizer'])
    with torch.no_grad():
        prediction = model(eval_data[0])
        assert torch.equal(prediction, restored(eval_data[0]))
        mse = float((prediction-eval_data[1]).square().mean())
    # 断点续训一步与原优化器同一步比较，检查uint8状态重载语义。
    for mm, oo in ((model,opt),(restored,restored_opt)):
        oo.zero_grad(set_to_none=True)
        (mm(train[0])-train[1]).square().mean().backward()
        oo.step()
    torch.cuda.synchronize()
    assert torch.allclose(model.weight, restored.weight, atol=1e-6, rtol=1e-5)
    models[bits] = prediction
    elapsed.sort()
    report[str(bits)] = {'loss_first': losses[0], 'loss_last': losses[-1], 'eval_mse': mse,
                         'unique_state_storage_bytes': sum(storages.values()),
                         'checkpoint_file_bytes': target.stat().st_size, 'state_dtypes': dtypes,
                         'step_host_sync_ms_p50': elapsed[len(elapsed)//2],
                         'step_host_sync_ms_p95': elapsed[int(.95*(len(elapsed)-1))]}
report['prediction_max_abs_8_vs_32'] = float((models[8]-models[32]).abs().max())
report['prediction_nrmse_8_vs_32'] = float(((models[8]-models[32]).square().mean()/models[32].square().mean()).sqrt())
print(json.dumps(report, indent=2))
