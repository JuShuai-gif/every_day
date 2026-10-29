# 2026-10-29 每日量化：MXFP4 / NVFP4 分块浮点

## 方法与边界

工业场景是小 batch 视觉投影层的权重存储：FP4 码字降低带宽，但每个 block 的 scale、scale 的再量化和后端解码必须一起计入。MXFP4 风格示例使用每 16 个值一个外部 scale；NVFP4 风格示例再保存一层局部 scale。两者都不是“4 位就自动有 Tensor Core 性能”。输入 `3×37`、FP32 参考、block=16；代码本身使用一个明确的 E2M1-like 教学码本，不冒充 NVIDIA 原生码表。

## 原仓库与关系

尝试拉取 [NVIDIA Model Optimizer](https://github.com/NVIDIA/Model-Optimizer) 的 `0.35.0`，DNS 失败，原始摘要在 `results/fetch.log`；固定历史 commit `c359cb774db4daab623cddde6c7e0399a49cf7d2` 仅作为目录索引记录。GitHub 页面在 2026-10-29 访问 `config.py`、`tensor_quantizer.py`、`nvfp4_tensor.py` 时返回 cache miss，因此没有声称读过这些函数。`example.py` 是独立格式实验，不能作为上游 API 用法或完整 NVFP4 实现。

## 示例与接入

```sh
sh systems_practice/quantization/2026-10-29/block_fp4/run.sh
```

示例输出 `results/cpu.json`，保存码字、block scale 和双层 local scale 的字节预算；接入真实模型时，量化导出应替换 Linear 权重并由后端支持相同 block 轴、scale dtype 和累加语义。没有 torch、Model Optimizer、CUDA 或模型下载，本机只验证独立 codec。

## 对比与验证

结果见 `results/run.txt`。MSE、最大误差和 payload 是同一个输入上的 CPU 实测；不包含 CUDA kernel、模型精度、端到端或功耗。空输入被拒绝，离群值保留在误差中。真实 NVFP4/MXFP4 原生存储、解码、Thor SM110 编译/运行、ncu、PTX/SASS 均未验证。

## Thor SM110 计划

若后续接入 CUDA，构建必须为 `nvcc -std=c++17 -O3 -arch=sm_110`，只比较 unpack+scale 的 SIMT baseline 与 shared/tiled 候选；`ncu --set full --kernel-name regex:fp4`，`cuobjdump --dump-sass` 和 `nvdisasm` 只对真实 cubin 使用。ncu 应观察 global load、integer unpack、FP32 FMA、barrier stall 和 achieved occupancy。Thor 是唯一执行目标；Hopper/Ada/Blackwell 只作格式/指令能力对照，不能把 SM100/SM120 结果移植成 Thor 收益。

## 故障链与追问

- payload 变小但误差暴涨：scale 轴或码本不匹配；先逐 block 重构，再核对 scale dtype。
- 奇数 K 读出垃圾：尾 block 未补零或索引按字节而非码字；用 K=37/空输入回归。
- “FP4 很快”但设备更慢：解码、scale 访存和 launch 占主导；分别记录 kernel 与端到端。

面试追问：block scale 为什么不能跨所有 K？二层 scale 的存储何时抵消 FP4 节省？E2M1 与 INT4 的零点/舍入差异是什么？如何证明解码后累加精度？为什么 fake quant 不等于压缩部署？sm_110 上如何确认实际 ISA？

[验证状态](verification.json)
