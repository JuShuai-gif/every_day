# 2026-10-28 FP8 scaling：动态 scale 与 E4M3/E5M2 边界

## 方法定位
FP8 scaling 将张量除以 scale 后编码为 E4M3（权重/前向常见）或 E5M2（动态范围更大），计算后乘回 scale。算法、格式、位宽与训练范式分开：今天是 FP8 PTQ/动态缩放示例，不是 QAT，也不把 INT8 或 fake quant 当作原生 FP8 性能。torchao `Float8DynamicActivationFloat8WeightConfig` 是上游 API；`example.py` 是独立可运行小张量编码器，`native_example.py` 才是完整 torchao 调用示例。

## 源码阅读
实际阅读 [pytorch/ao](https://github.com/pytorch/ao) `v0.13.0` 的 `torchao/float8/float8_linear.py`、`config.py`、`float8_utils.py`（读取日期 2026-10-28；网页源码可达，浅克隆因 GitHub DNS 失败）。跟踪 `Float8Linear` → config dispatch → dynamic scale；Apache/BSD 文件声明按仓库 LICENSE 记录。独立示例保留 scale 计算与序列化边界，省略 torch dispatcher、distributed/FSDP 和 kernel。

## 使用与校准
输入 shape 是 1×8 FP32 小向量；scale=maxabs/448，E4M3 有限值范围通过显式裁剪。真实项目应将 calibration/tune/eval 分离，记录校准集、dtype、scale 粒度（tensor/channel/block）和 outlier。FP8 后端是否在 Thor SM110 可用必须用目标 CUDA/torchao 版本验证；本机没有 CUDA。

## 运行与结果
`sh run.sh` 实际运行标准库例子并打印 MSE、payload；`python3 native_example.py` 需要安装好的 torch/torchao/CUDA，今天未运行、未安装。结果是 CPU codec 检查，不是 Tensor Core 或端到端性能。

## 工业故障与边界
scale 过小导致溢出/饱和，表现为长尾误差；scale 过大导致小值下溢，表现为零比例升高；E4M3/E5M2 选错会改变范围/精度；动态 scale 若跨 batch 不稳定会让校准结论失效。部署前需用真实模型比较 FP16/FP8 误差、存储、kernel 与 E2E，Thor 命令固定 `sm_110`。

## 验证状态
源码阅读/示例交付/CPU 运行已分开记录在 `source.json`、`verification.json`；native torch、Thor、ncu/PTX/SASS 未验证，原因写入记录。
