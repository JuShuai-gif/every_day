# 2026-10-18 SpQR：何时值得支付稀疏离群值开销

## 方法与应用场景

第二轮SpQR，聚焦“按二阶误差保护离群权重，以及如何正确重载”。这是PTQ算法，INT4是主体格式，FP32是本例scale/zero/离群值存储与累加类型，训练更新为零；不是QAT，也不是FP4。上一课SpinQuant通过学习旋转分散困难通道，本课保留难量化元素并为其支付索引成本。

输入`X[batch,64]`、`W[16,64]`，输出`X @ W.T`；CPU torch FP32。每输出行沿K以16分组，非对称u4码0…15，`w=scale*(q-zero)`；zero默认可非整数。原生`SPQRUtil`用校准H的逆Cholesky对误差加权，逐列补偿，阈值控制稀疏保留。qq二级metadata量化在本例明确关闭，以隔离稀疏机制；不能称为论文完整3bit压缩配置。

## 原仓库与实际读过的实现

[Vahe1994/SpQR](https://github.com/Vahe1994/SpQR)，实际浅获取commit `543d10e56f921e5eeb10d5f0aaaccd30b6662d0e`，2026-10-18。首次DNS失败[source.json](source.json)，成功[source-retry.json](source-retry.json)，阅读及额外文件哈希[source-read.json](source-read.json)。根LICENSE Apache-2.0；inference文件头也标Apache，setup.cfg分类却写MIT，保留这个不一致，不能用分类覆盖许可证。

调用链：

1. [SPQRUtil.add_batch/quantize](https://github.com/Vahe1994/SpQR/blob/543d10e56f921e5eeb10d5f0aaaccd30b6662d0e/spqr_engine.py)：X积累H→加damping→Cholesky逆→组参数→逐列量化与后续误差补偿。
2. 同文件`get_leave_one_out_error`：逐个去掉权重观察重建代价，用于估计应从组统计中排除的离群权重；最终mask用加权误差阈值判断，不是简单按绝对值阈值删大数。
3. [quant_groups.py](https://github.com/Vahe1994/SpQR/blob/543d10e56f921e5eeb10d5f0aaaccd30b6662d0e/quant_groups.py) `Quantizer.configure/find_params/quantize/dequantize`：clamp/round、scale/zero和可选qq。
4. [weight_permutation.py](https://github.com/Vahe1994/SpQR/blob/543d10e56f921e5eeb10d5f0aaaccd30b6662d0e/weight_permutation.py) `get_permutation_order`：本例选择identity，避免重载时把置换位置与原列混淆。

原生API按已读版本调用；自定义导出/重载与测试是独立工程代码。`QuantizationResult.weight`是反量化FP张量，注释说明结果对象不节省内存。我们不会把它的dtype或`save_quant_dict`当成低位文件。输出稀疏值覆盖dense值，不能无条件相加：非整数zero可能使量化“零”仍是小非零。

## 如何接入我的代码

工作目录为`systems_practice/quantization/2026-10-18/spqr`：

```sh
cd systems_practice/quantization/2026-10-18/spqr
sh prepare.sh
SPQR_SOURCE=../../../.tmp/quant_sources/spqr-20261018-reproduce/source sh run.sh
```

当天已获取缓存可以直接`sh run.sh`。prepare只取源码，不安装。低层示例需torch≥2.4.0和tqdm；原requirements还包含transformers等整模型依赖，这些不由本例import。推荐独立既有Python≥3.11环境；实际Mac系统Python3.9.6缺torch，原生运行未通过。原生版本无独立包号，按commit固定。inference_lib版本0.2.0、Python≥3.11另有依赖，不能混为低层例子最低依赖。

`example.py`建立随机Linear与一个离群值，校准64样本（seed101）、调参32（102）、评估31（103）、分布变化31（104）；训练为空。对inf/0.2/0.05三个阈值分别拟合H，调参集选择满足2KiB真实文件预算的最低NRMSE候选，评估集不参与选择。bits=4、groupsize=16、damping=.01、blocksize=32、identity permutation、未量化scale/zero。保留no-outlier、FP32、FP16存储转FP32计算、signed absmax INT4对照，二者分组/zero不同，不能把差异全归因为离群处理。

接入已有`nn.Linear`时保留其原始权重作为参考，用真实业务校准输入替换`calibration`，对`SPQRUtil(your_linear)`调用add_batch和quantize；bias需原样加回，本例bias=False。`result.weight`可复制进同shape的普通Linear做数值对照；这样仍是FP32 dense执行，不会节省运行权重内存。要获得压缩驻留后端，需要单独验证格式与kernel。

## 量化前后比较

候选输出`build/*.bin`与`build/metrics.json`，实际文件格式：20B头，N×K/2个u4字节，2×N×(K/group)×4B的scale/zero，每离群权重8B（uint32索引+FP32覆盖值）。代码实际写盘/读盘，重建权重并与原生结果比较。输出FP16/FP32参考文件也实际计数；未运行前不把这些文件写成已生成。

指标包括NRMSE/max-abs/cosine、位于端点的码比例、稀疏数与文件字节、量化CPU毫秒、同输入FP32 GEMM与解码后GEMM、读文件+解码+GEMM批均值P50。端点码比例不是准确的clipping饱和率，因为上游没有导出每次补偿前被clamp的值。反量化常驻时间不含解码；含文件读取版本包含Python开销和OS cache，并非设备kernel时间。当前误差、真实文件大小和性能全部**未测**，没有用理论压缩比填表。

## Thor SM110兼容性

今日主课和此例都不执行CUDA kernel；没有用CPU替代GPU轮换。实际读[inference.py](https://github.com/Vahe1994/SpQR/blob/543d10e56f921e5eeb10d5f0aaaccd30b6662d0e/inference_lib/src/spqr_quant/inference.py) `QuantizedLinear`构造格式，以及[cuda_kernel.py](https://github.com/Vahe1994/SpQR/blob/543d10e56f921e5eeb10d5f0aaaccd30b6662d0e/inference_lib/src/spqr_quant/inference_kernels/cuda_kernel.py) JIT入口：上游参数是`-arch=native`，不能直接认定满足固定sm_110合同。其3bit、16×16二级metadata/PTCSR表示也不接受本课u4文件。未阅读/运行该库CUDA kernel内部，不声称完成后端审计。

[NVIDIA能力表](https://developer.nvidia.com/cuda/gpus)列Thor为11.0，[CUDA13.0官方说明](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-toolkit-release-notes/index.html)列SM110库支持。目标验证还需实际JetPack/L4T、driver、PyTorch构建、nvcc/ncu组合；本机缺设备和工具链，组合未核实。未来只允许将缓存中的JIT架构参数显式改为`-arch=sm_110`，并审计所有传递依赖，不能用`sm_110a`或其它GPU验收代替。无需为了此CPU算法例子执行后端构建；SpQR原生Thor部署保持backlog，需另做正确性基线、优化与ncu/PTX/SASS验收。

## 工业故障、追问与验证状态

- 导出后误差骤增→错误把稀疏覆盖值加到dense上→按mask逐元素对照`result.weight`→使用覆盖语义；回归包含非整数zero和零值离群项。
- 文件比FP16更大→阈值过低导致索引爆炸→同时记录稀疏率和metadata字节→按调参集/预算选型或回退；更低误差不是无条件更好的部署方案。
- Cholesky失败→校准秩不足/分布退化→检查H对角与有限性→合理damping并扩大独立校准集；不能用评估集补校准后仍报告独立效果。

追问：SpQR稀疏选择与按绝对值选点有何不同？H的作用是什么？为什么反量化矩阵不算压缩存储？zero非整数对导出有什么影响？阈值如何影响索引占比？调参和评估为何要分开？3bit原生后端为何不能直接读u4文件？

五状态分别为源码获取✓、实现阅读✓、示例交付✓、CPU原生运行✗（缺torch）、Thor验证✗。见[verification.json](verification.json)及[真实失败日志](results/native-attempt.txt)。没有下载模型、自动安装依赖或生成性能收益。仅重试一个旧待补项SmoothQuant获取，失败记录位于[同日记录](../smoothquant-retry-source.json)，未发现可验证缓存，未推进其阅读状态；下一方法SmoothQuant。
