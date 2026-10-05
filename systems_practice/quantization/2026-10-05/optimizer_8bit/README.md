# 2026-10-05 每日量化：Adam8bit的分块优化器状态

## 方法与应用场景

边缘模型小规模适配训练时，FP32参数之外Adam还保留一阶矩m、二阶矩v。本期深入bitsandbytes的**分块动态码本状态量化**，不量化模型权重或激活，不称W8A8。算法是decode→FP32更新→重估块最大值→encode；格式是uint8码本索引＋FP32 absmax＋256项码本，位宽8，范式是正常梯度训练中的状态压缩，不是PTQ/QAT或fake quant。

核心更新为`m=β1*m+(1−β1)*g`、`v=β2*v+(1−β2)*g²`；用偏置修正矩更新参数后重新量化状态。m可正负，v非负，所以码本不同。每块独立范围隔离离群值；量化误差会进入下一步，某步v误差接近零可能放大除法，不能只检查单次状态MSE。上游block size 256是本期0.48.1实际实现，不当作所有版本/所有量化函数常数。

## 原仓库与实际读过的实现

仓库https://github.com/bitsandbytes-foundation/bitsandbytes，MIT，tag0.48.1；[发布对应commit](https://github.com/bitsandbytes-foundation/bitsandbytes/commit/7e16503e403de460d4ed7dfd6c90a656628f5149)，读取2026-10-05。

- [optim/adam.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/optim/adam.py)：`Adam8bit/Adam32bit.__init__`。Adam8bit内部硬编码8，**不要传optim_bits=8**，此版本仅接受签名默认32作为兼容占位；amsgrad=True拒绝。
- [optim/optimizer.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/optim/optimizer.py)：`Optimizer2State.init_state/update_step`，不足min_8bit_size回退FP32，双uint8状态、qmap、256块absmax分配与分派。
- [functional.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/functional.py)：`optimizer_update_8bit_blockwise`先检查GPU对象，调用torch.ops；不能承诺此路径可在Mac CPU运行。
- [csrc/kernels.cu](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/csrc/kernels.cu)：`kOptimizerStatic8bit2StateBlockwise`，实际阅读decode、矩更新、absmax归约/广播及ADAM float/half/bfloat16实例，非整文件审计。

调用链：`Adam8bit(model.parameters) → step → init_state → update_step → functional → torch.ops → CUDA状态更新`。保留块范围与量化对象区别；[native.py](native.py)原样调用上游API，未修改上游代码。[independent.py](independent.py)是独立均匀码本Adam机制实验；[codec.cu](src/codec.cu)是独立均匀signed8编码热点，不是完整Adam、不兼容原动态码本，不将它的耗时冒充Adam或Tensor Core性能。

实际浅克隆失败，`source.json`保持获取事实；随后网页阅读单独记录[source-web.json](source-web.json)。无可验证源码缓存，今日只重试一个旧AWQ，仍DNS失败。CMakeLists原文多次访问失败，原生扩展构建完整兼容审计进入backlog，不编造已经通过。

## 如何接入我的代码

原生依赖从pyproject核实：Python≥3.9、torch≥2.3且<3、numpy≥1.17、packaging≥20.9，固定bnb0.48.1。选定Thor上的兼容PyTorch CUDA13构建，记录实际版本；依赖范围不等于每个组合已验证。本机Python3.9.6缺torch，无自动安装。

工作目录为本课程目录。源码准备（需要联网环境，保留在忽略缓存，不下载模型）：

```sh
# 从仓库根目录；今日拉取已失败，此命令用于之后重试，选择新的记录文件。
python3 systems_practice/quantization/fetch_source.py optimizer_8bit --record systems_practice/quantization/2026-10-05/optimizer_8bit/results/source-retry.json
# 在已获得的bitsandbytes源码目录固定阅读版本。
git checkout --detach 7e16503e403de460d4ed7dfd6c90a656628f5149
```

已准备好依赖后，从仓库根运行：

```sh
sh systems_practice/quantization/2026-10-05/optimizer_8bit/run.sh native
sh systems_practice/quantization/2026-10-05/optimizer_8bit/run.sh independent
```

原生随机Linear(128,64)，weight FP32[64,128]8192元素、bias[64]；训练X[32,128]、独立调参/评估X[16,128]，FP32 contiguous；目标由固定线性teacher生成。以Adam32bit在调参集选0.003/0.01中一个lr，再两条路径从同初始权重训练40步；两者都用β=(0.9,0.999)、eps=1e−8、weight_decay=0、min_8bit_size=4096、block_wise=True。没有PTQ校准集，这里的独立tune集仅选学习率，eval不参与选择。

检查实际weight状态uint8、bias状态FP32，比较输出NRMSE/最大误差和任务MSE、实际底层storage字节与checkpoint字节。导出build/checkpoint-{8,32}.pt包含模型及优化器，重载后比较推理输出，再续训一步验证状态恢复。不存在“导出8bit推理模型”：推理仍使用FP32 Linear，优化器状态只在继续训练需要。接入已有模型时只替换optimizer构造，保留parameters、loss.backward与step流程，不把Linear换成Linear8bitLt。

## 量化前后比较

原生结果未验证，不能填估计性能。独立实验实际80步更新、513参数；无独立调参、学习率固定，目标是合成二次损失，不能称任务精度或heldout泛化评估。

| 独立状态方案 | 状态payload | 最终合成损失 | 对FP32轨迹最大参数差 |
| --- | --- | --- | --- |
| FP32存储矩参考 | 4104B（实际array payload） | 3.45707e−5 | 0 |
| 均匀8bit，block256 | 1050B（真实bytearray＋float32 scale） | 3.43742e−5 | 0.0165731 |
| 均匀8bit，全513块 | 1034B | 0.163834 | 8.26060 |

block256的真实payload含1026B双状态、24B scale；不计Python对象头/临时解码list，峰值内存并未减少到1050B。原生状态还需要动态码本，不能照搬上述字节。全块反例保留说明量化误差在v分母与时间递推中的风险。全零/空/1/255/256/257/513长度通过，离群值100与0.01的异块误差256分块约1.48e−10、整块0.01。[最终输出](results/independent-final.txt)；[首轮输出](results/independent.txt)保留为历史，首轮矩用Python双精度list，最终改为真实FP32 array存储。所有Python算式仍以宿主浮点执行，不能称全FP32算术或原生kernel。未测CPU速度；原生step墙钟含同步、API与所有更新kernel，不能标成单kernel。

## Thor SM110 与优化

固定所有编译/运行到Thor 11.0：`nvcc -arch=sm_110`，运行时检查capability=(11,0)。[CUDA13官方说明](https://developer.nvidia.com/blog/whats-new-and-important-in-cuda-toolkit-13-0/)核实JetPack7.0/Thor支持；[PTX目标表](https://docs.nvidia.com/cuda/parallel-thread-execution/#target)核实sm_110在PTX9.0引入。今天读到最新版手册9.4，不能把其新指令全部当作CUDA13.0可用；本例只用基础标量转换/共享内存/屏障。

CPU主主题不变，本栏目另交付完整编码热点基线和最终候选，[OPTIMIZATION.md](OPTIMIZATION.md)含公平对照、ncu教程、ISA热点与Thor/Ampere原理对照。原项目aarch64 wheel/driver/ncu版本组合和源码CMake支持仍需Thor验证。不得仅凭软件声称“CUDA13”就认定sm_110代码实际存在；用cuobjdump检查已装库目标，再运行最小例子。没有使用其他执行架构或专属后缀。

## 验证与待补

[verification.json](verification.json)：源码拉取否、实现阅读是、原生示例交付是、CPU原生运行否、Thor验证否。独立数学实验通过不改变原生状态。缺torch、nvcc、ncu的[日志](results/)分别保留；无真实编译PTX/SASS，没有周期/收益数字。下一独立方法FP8 scaling；今日方法的获取、原生运行、扩展构建、Thor数值/性能仍在backlog。

故障链：①小模型不省状态内存→检查state1.dtype与numel→默认阈值回退→不要为了“看见压缩”盲目调小阈值，先衡量码本/scale开销；②训练突然发散→先比同梯度的m/v恢复值、v近零频率与参数增量→缩小块或保留敏感状态FP32，代价为内存；本课独立反例不证明原生必然发散。③resume后轨迹变了→检查uint8/scale/codebook重载和param对应→对照续训一步再长跑，不能只测权重推理相等。

追问：量化优化器为何不等于W8A8？m/v为何需要不同码本？小参数为什么回退？scale与码本如何计费？状态误差如何影响下步分母？恢复推理相等能证明断点续训正确吗？
