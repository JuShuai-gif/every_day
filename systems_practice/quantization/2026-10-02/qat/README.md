# 2026-10-02：QAT的真实权重更新、checkpoint选择与导出合同

本日唯一正式量化方法，承接10月1日calibration；本日早先生成的[calibration材料](../calibration/README.md)只保留为补充，不重复推进。原生例子已交付，**本机缺torch未执行**；不能把主课补充里的独立C++QAT当成本例原生API运行。

## 方法与应用场景

给已有视觉动作头`Linear(64,16,bias=False)`做W8A32 QAT：训练时FP32 master weight，前向插入组INT8量化/反量化，梯度通过上游fake-quant训练机制，SGD实际更新master。QAT是训练范式，不是位格式；本例格式为每行group32有符号INT8，激活FP32，反量化后FP32乘加，没有原生INT8 Tensor Core计算。

与absmax PTQ不同，PTQ只选范围再固定映射；QAT让权重适应映射误差。不能承诺训练一定改善独立测试误差。本例使用动态权重组scale，范围学习关闭，未对激活做校准；训练、选择学习率/checkpoint、最终测试三个随机流分开。模型种子1002，训练128×64(seed11)、验证64×64(seed12)、测试64×64(seed13)，均CPU FP32。训练80步×两个学习率，不能把验证集梯度训练或测试集调参混进结果。

## 原仓库与实际读过的实现

真实尝试浅克隆[pytorch/ao](https://github.com/pytorch/ao)失败：DNS无法解析github.com，未发现可验证QAT缓存；原始[source.json](source.json)保持获取事实。随后通过网页实际读**v0.13.0**：

- [linear.py](https://github.com/pytorch/ao/blob/v0.13.0/torchao/quantization/qat/linear.py)：`FakeQuantizedLinear.from_linear/forward/to_linear`，from_linear直接共享Parameter，to_linear恢复浮点层，**不是低位打包导出**。
- [fake_quantize_config.py](https://github.com/pytorch/ao/blob/v0.13.0/torchao/quantization/qat/fake_quantize_config.py)：`IntxFakeQuantizeConfig`参数；[fake_quantizer.py](https://github.com/pytorch/ao/blob/v0.13.0/torchao/quantization/qat/fake_quantizer.py)：`IntxFakeQuantizer.forward/_per_channel_or_group_forward`及动态scale/zero缓存。调用链：已有Linear→from_linear→权重fake quantizer→组qparams/QDQ→float linear→反向→SGD。
- [release v0.13.0](https://github.com/pytorch/ao/releases/tag/v0.13.0)确认缩写commit **e318546**，发布说明测试torch2.8.0导入；完整hash链接访问Internal Error，**完整commit及真正commit永久链接仍待补**。本例固定torch2.8.0+torchao0.13.0是基于该tag阅读的环境合同，并非本机安装验证。
- tag LICENSE原始URL失败，网页仅外壳；[main LICENSE](https://github.com/pytorch/ao/blob/main/LICENSE)正文实际读到BSD三条款。不能用main证明tag逐字相同；tag许可核验待补。没有拷贝上游源码。

关系：原样调用上游类/API；训练/评估编排与raw INT8导出是独立教学代码；没有声称调用了上游原生量化后端convert。量化API更名/迁移未发现，仓库仍是pytorch/ao。阅读日期2026-10-02，[阅读记录](source-read.json)。

## 如何接入已有代码

```sh
cd systems_practice/quantization/2026-10-02/qat
sh run.sh
```

先决条件Python及用户自行准备的上述两个版本；本任务不安装。完整[example.py](example.py)从两个已读模块路径import；本地clone有需求时，在仓库根目录手动运行`python3 systems_practice/quantization/fetch_source.py --help`并按工具参数重试，不能把失败缓存加PYTHONPATH冒充完整安装。当前示例不编译CUDA扩展，不提供未核实Thor wheel安装命令。

接入位置为`new_model()`中的原`nn.Linear`：先deepcopy用户层，避免from_linear的参数共享修改teacher；更大本地模型按命名模块逐个替换，实际shape须能分group32，校验dtype/bias再扩展。程序保存最佳master权重快照，不deepcopy带图的fake quant缓存；最后新建模块加载权重。

导出前从上游fake quantizer取最终权重QDQ、scale、zero，恢复`q=round(w_fake/s+z)`并clamp至[-128,127]；校验反量化等价。`build/weights.bin`是**独立原始格式**：16字节header、1024字节int8 codes、128字节FP32 scale、128字节FP32 zero，总1296B（按格式计算，尚未实际写出）。重读后恢复`(q-z)*s`的FP32层并核对输出。不是torch.save、不是torchao部署格式，也不是把float tensor称为8-bit存储。二进制留忽略build，不提交。

## 量化前后比较

原生运行因`ModuleNotFoundError: torch`在导入处结束，[原始日志](results/native.txt)。权重误差/输出MSE、实际payload文件长度、master更新量、选择的checkpoint和CPU时间目前全部**未测**；1296B与FP32权重4096B只是格式预期，不冒充已导出文件。运行成功后自动报告PTQ/QAT/export在同一test输入上的MSE以及独立test比较，若最佳仍为step0必须照实保留。程序断言每个训练候选确实有非零master更新，但本机未执行该断言。

计时20预热+100采样，比较FP32 teacher与解包后FP32 dense层，仅CPU同步调用P50/P95；反量化在计时外，不能称为INT8 kernel提速或含导出的端到端性能。要测真实低位加速必须接入支持的backend并单独测packing、传输、kernel和模型E2E。

## Thor SM110与优化

本例原生API只请求CPU，torchao v0.13.0在Thor上的wheel/extension兼容性未核实，不能从CUDA13支持Thor推出旧torch二进制也支持。所有未来CUDA扩展只能设置`TORCH_CUDA_ARCH_LIST=11.0`并以匹配JetPack7/CUDA13环境实际编译验证；该值不是已经验证的后端命令。本期GPU kernel材料由[正式主课](../../../daily/2026-10-02/session-02/README.md)提供：naive/PAD0/PAD1、ncu、sm_110 ISA导出与Ampere对照；它是转置kernel，不是本例QAT GEMM后端。没有量化Tensor Core吞吐数据。

## 故障诊断、迁移与追问

1. 训练后teacher也变了→from_linear共享Parameter→比较teacher权重hash/克隆前后→先deepcopy用户模块再转换；不可让参考跟着候选漂移。
2. fake quant变准，导出变差→scale/zero/布局或舍入不一致→先核对单组QDQ与codes反量化，再核对层输出→格式携带metadata并固定group/dtype；不能把to_linear当低位导出。
3. 验证误差低、测试退化→样本太少或checkpoint过拟合→固定分区、报告PTQ及step0→回滚而不强行宣称QAT有效。

迁移验收要有真实训练更新、独立测试、不下载模型的最小例子、导出重载一致性和目标后端支持证据。无数值改善可保留PTQ；训练成本与真实设备收益一起判断。

追问：QAT与INT8格式有何区别？STE保留什么近似？动态权重scale与激活校准是否相同？为什么to_linear不代表打包？何时该保留step0？导出后为什么不能沿用fake quant的性能数字？

## 验证与待补

源码获取失败；网页实现已读；原生例子已交付；CPU运行失败；Thor未验证，分别记录于[verification.json](verification.json)。完整commit、tag许可证、CPU训练/导出和Thor后端进入backlog。今日额外只重试旧AWQ一次，见[原始重试](../awq-retry-source.json)；不因量化受阻跳过其他栏目。
