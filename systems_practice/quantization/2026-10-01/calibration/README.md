# 2026-10-01 校准感知缩放：HistogramObserver 的误差搜索

## 方法与应用场景

承接LLM.int8离群处理，本日独立游标深入一个方法：PyTorch HistogramObserver的直方图范围搜索。在工业投影层中，极少数激活极值会拉宽absmax范围；把分布压成直方图后可搜索更小区间，以截断误差换取主体分辨率。桶越多不保证输出GEMM误差越小，观察器优化的是输入分布重建，权重方向会改变下游敏感性。

算法为校准期PTQ，格式为有符号INT8、W8A8；不是FP8、QAT或训练范式。A按全张量对称scale、范围[-128,127]；W按输出通道absmax、范围[-127,127]。API的零点参与解码，最近偶数舍入；计算路径为INT8存储→FP32解码→FP32矩阵乘。不存在原生INT8累加器性能声明。主课的四位SIMT合同是另一实现，不能把本API结果写成主课算法实测。

## 原仓库与实际读过的实现

[PyTorch](https://github.com/pytorch/pytorch)，v2.8.0，commit `ba56102387ef21a3b04b357e5b183d48f0afefc7`，读取2026-10-01。已实际读[observer.py](https://github.com/pytorch/pytorch/blob/ba56102387ef21a3b04b357e5b183d48f0afefc7/torch/ao/quantization/observer.py)中的HistogramObserver.__init__/forward/_compute_quantization_error/_non_linear_param_search/calculate_qparams，以及基类_calculate_qparams；[fake_quantize.py](https://github.com/pytorch/pytorch/blob/ba56102387ef21a3b04b357e5b183d48f0afefc7/torch/ao/quantization/fake_quantize.py)的FakeQuantize.__init__/forward和开关；[LICENSE](https://github.com/pytorch/pytorch/blob/ba56102387ef21a3b04b357e5b183d48f0afefc7/LICENSE)为BSD风格主许可并含第三方声明。

调用链：FakeQuantize(x)→observer更新histogram/min/max→calculate_qparams搜索区间→冻结observer→原生fake_quantize算子。`dst_nbins`由dtype位数确定，不应仅改quant_min/max就宣称同一搜索实现了合适的INT4桶误差模型。源码采用非线性搜索；它不等价于“直接去掉固定百分位”。

[获取记录](source.json)保留实际浅克隆DNS失败、null commit及零文件；[网页阅读记录](source-read.json)单独记录固定版本。未发现可验证本地缓存。真实调用上游API，导出/评估包装为本课原创；没有复制完整第三方代码。仓库仍为pytorch/pytorch，未发现本方法迁移；ao后续演进不改变本次锁定版本。

## 如何接入我的代码

工作目录EveryDay根，需已具备Python≥3.10和PyTorch2.8.0 CPU包；本机Python3.9且缺torch，未安装任何包。更换版本须重新核对API。完整入口：

```sh
sh systems_practice/quantization/2026-10-01/calibration/run.sh
python3 systems_practice/quantization/fetch_source.py calibration --record systems_practice/quantization/2026-10-01/calibration/source-retry.json
```

源码恢复后在忽略缓存中固定上述commit再审查；脚本使用已安装包，并打印`torch.version.git_version`。输入FP32 A[128,65]校准，tune/eval各[32,65]，W[19,65]；种子101/202/303/404各司其职。第0通道放大12倍；shift仅将评估第4通道再放大30倍用于退化检查，不能反过来挑参数。

`example.py`已有全部步骤：分批16行收集统计；冻结观察器；用tune输出MSE从256/1024/2048桶挑一个；评估minmax和最终histogram；真实INT8权重及scale/zero_point导出至忽略的build/linear.pt；weights_only重载并检查解码推理相等。无需下载模型，无训练更新。将`w`替换为既有`Linear.weight.detach().float()`，将calib/tune/evaluation替换为该层分别采样的输入，注意PyTorch权重为[N,K]，若有bias要在参考与解码输出中同时加回。先在副本执行，当前例子不修改原模型模块。

## 量化前后比较

| 项目 | 对照与当前状态 |
| --- | --- |
| 精度 | FP32参考、FP16存储扩展参考、minmax、histogram；NRMSE/max_abs/cosine/saturation，因torch缺失均未实测 |
| 存储 | 使用numel×element_size统计码、scale、zero_point；另测.pt文件实际字节，包含序列化开销；未执行 |
| 性能 | 单CPU线程20预热100样本，QDQ+FP32Linear P50/P95；没有INT8kernel/GPU/NPU数据 |
| 边界 | 空输入后全零校准、冻结scale不变、导出重载一致；代码已交付，未运行 |

不要用INT8 payload理论字节冒充实际序列化大小，也不能把QDQ的FP32输出内存省略后称整条推理压缩。较小范围可能减少平均误差却损伤极少数关键通道。配合主课可检查group32的真实布局，但不共享不兼容的对称范围/舍入合同。

## Thor SM110 与优化

本API例子强制CPU张量，未引入GPU kernel。算法可生成scale不意味着Thor存在对应部署后端。[主课](../../../daily/2026-10-01/README.md)提供四种格式的Thor SM110基线/候选、ncu和ISA命令；数据合同需要显式适配。若构建任何CUDA扩展，编译架构只能110/`sm_110`，CUDA13.0参考基线；PyTorch2.8.0发行包和扩展在Thor上的可用性尚未验证，不提供未经核实的安装组合。

## 验证与待补

[verification.json](verification.json)区分拉取false、网页实现阅读true、示例交付true、CPU执行false、Thor验证false；[原始失败](results/native-initial.txt)为ModuleNotFoundError: torch。只重试了一个旧待补AWQ，其DNS失败保留在上一级记录。下一方法QAT，本日材料交付不等于算法性能验收完成。

故障链一：部署输入分布漂移→饱和上升→冻结区间失配→用独立采样和分层误差定位→重新校准并重新评估，不能污染测试集。故障链二：更改到4bit后效果异常→检查dtype与dst_nbins→搜索误差模型未随目标码数对应→选择专门低位实现并重建oracle，代价是重新校准和后端验证。

迁移验收：固定版本与git哈希；核对shape/权重方向/舍入；确认observer冻结；码/scale/zero_point往返一致；校准、tune和eval隔离；实际后端逐层精度与E2E再验收。追问：1.输入MSE为何不保证输出MSE？2.histogram如何改变搜索成本？3.冻结哪个开关？4.真实INT8存储为何仍用FP32计算？5.桶数为何只能在tune上选择？6.shift饱和但平均误差不大能否上线？
