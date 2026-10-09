# 2026-10-09 GPTQ：二阶误差补偿、阻尼与 W4A16 部署边界

## 方法与应用场景

给边缘视觉语言模型的 `Linear(64,16)` 做 W4A16 PTQ。权重逐输出通道、每 32 个输入列一组，4-bit 非对称整数 `q=round(w/scale)+zero`；激活保持 FP16/FP32，累加也不降为 INT4。GPTQ 与 absmax 的差异是校准输入构成 Hessian 近似 `H`，逐列量化后用 `H^{-1}` 的误差反馈更新未量化列；`percdamp` 用于奇异/病态统计。它不是 QAT：没有 optimizer、没有参数更新。

## 原仓库与实际读过的实现

实际读取 [IST-DASLab/gptq](https://github.com/IST-DASLab/gptq) commit `2d65066eeb06a5c9ff5184d8cebdf33662c67faf`（MIT）：`gptq.py:GPTQ.add_batch` 做输入展平与 `H += X Xᵀ`，`GPTQ.fasterquant` 处理 dead column、damping、Cholesky、block 内/跨 block 误差反馈；`quant.py:Quantizer.find_params` 计算 scale/zero，`Quant3Linear.pack/forward` 是 3-bit 单 token CUDA 扩展路线；`opt.py:opt_sequential → opt_pack3` 串起 hook、量化与打包。永久路径、许可证和调用链见 [source-read.json](source-read.json)。这是原生 API 调用示例，不改编其算法；课程中小 Linear 和数据拆分是独立教学输入。浅克隆失败事实保留于 [source.json](source.json)，不声称本地已获取。

## 如何接入我的代码

Thor 上将固定 commit 检出到不提交的目录，设置 `GPTQ_SOURCE=/path/to/gptq` 后运行 `./run.sh`。脚本要求 torch CUDA 能报告 capability `(11,0)`：校准 128×64 只用于 `add_batch`，validation 64×64 在 `{0.01,0.10}` 中选择阻尼，evaluation 64×64 只做最终 NRMSE。接入真实模型时，由 `opt_sequential` 对每层 forward hook 收集校准统计，再在 `opt_pack3` 替换 Linear；上游 `Quant3Linear` 明确只支持单 token 及特定打包，不能将本课 QDQ 输出当作该 CUDA extension 的性能。

## 量化前后比较

同一 evaluation 输入上比较 FP32 reference 与选择后的 W4A16 QDQ，脚本输出 NRMSE；导出规模为 16×64×4/8 = 512 B codes，加 16×2 个 group scale/zero（具体 dtype/序列化应由实际运行记录），FP32 为 4096 B。当前没有真实运行结果、吞吐或延迟；校准/选择/推理时间与 packed kernel 时间必须分开记录。失败反例：H 的零对角列由上游置为 1 并把对应权重置零，若生产输入后来激活该列，精度可能退化。

## Thor SM110 与优化

上游 `fasterquant` 在末尾无条件 `torch.cuda.synchronize()`，源版本不能作为 CPU 成功运行。设置 `TORCH_CUDA_ARCH_LIST=11.0` 只是构建提示，不证明 PyTorch 或 `quant_cuda` 支持 Thor。实际 kernel 才能用 `ncu --set full --kernel-name regex:vecquant3matmul ./...`；导出 `cuobjdump --dump-ptx` 与 `--dump-sass` 仅对 SM110 已编译产物有效。该旧扩展是 3-bit SIMT 单-token 路线，不能伪称 W4 Tensor Core。对照 Ampere：其低位路径/工具链支持不能推断 SM110；本课唯一执行目标仍是 Thor。

## 验证与待补

源码获取失败、实现阅读成功、示例已交付，原生 API/CPU/Thor 均未运行，详见 [verification.json](verification.json)。缺少目标设备、CUDA、torch/transformers；没有虚构误差、SASS、指令周期或性能。
