> 2026-10-02并发游标纠正：本页是补充材料，不计本日正式课程、不增加必做作业；请从[正式GPU访存优化](session-02/README.md)开始。旧源码、来源与日志全部保留。

# 2026-10-02 量化 GEMM：真实打包与分组累加边界

## 工业场景

机器人视觉编码器末端 Linear：A[32,65] × W[65,19] → Y[32,19]，全部row-major，权重常驻Thor SM110。K=65同时暴露16元素tile尾、32元素group尾及INT4奇数nibble。研究两个耦合机制：低位物理布局与group内累加/组间缩放。代码允许矩阵单维1..4096；只接收有限输入，非有限数和FP16激活溢出报错。工程验收分成编码布局、单层重建、GPU正确性和部署时延四关。

## 概念回顾

低位矩阵乘首先是数据合同问题。四位权重不能用浮点数组代替：两个有符号整数装进一个字节，读取时按逻辑下标选半字节并符号扩展。奇数元素数的最后一个高半字节是填充，不能当成下一行的有效元素。本例整张矩阵连续打包，行宽为奇数时相邻两行共享一个字节；布局、索引和量化分组必须分别描述。八位激活也真实保存整数，十六位激活使用半精度位模式，解码后以单精度累加。

物理压缩与缩放粒度紧密耦合。每列权重沿归约维每三十二项共享一个尺度，整批整数激活使用校准后冻结的尺度。组内先以整数累加，组结束才把部分和转成浮点并乘两个尺度，再合并各组。如果把全部归约做完后只乘最后一组尺度，矩阵形状仍正确，结果却系统性错误。分块优化把一组拆为两块，共享内存复用解码数据，但部分和必须跨块保留，跨组归零；边界线程也要参加屏障，不能为跳过输出而提前退出。

量化误差与算子正确性是两种验收。未量化的激活除以通道缩放、权重乘以相同缩放，在数学上等价，但舍入后不保证更好。离群通道另存半精度残差会增加存储和计算。校准集只估计统计，调参集选择裁剪和检查点，评估集只报告结果；量化感知训练必须实际更新主权重，前向仍经过舍入和裁剪。即使训练确实执行，调参集也可能选择初始检查点。最后，压缩存储不等于原生低位矩阵指令，本例是标量整数乘加的GPU实现，其共享内存版本只是优化候选，收益要由目标设备上的公平测量决定。

## 知识图谱

| 层次 | 本例连接 | 必须维持的合同 |
| --- | --- | --- |
| 物理格式 | Packed::set/get → CUDA code<4/8> | INT4低nibble在前，二补码，逻辑边界而非分配边界 |
| 数学分组 | kGroup=32 → partial → scale[g,n] | INT32组内、FP32组间；32×127²=516128，不溢出INT32 |
| tile所有权 | quant_tiled 8×16输出，K tile=16 | 装载→CTA屏障→消费→CTA屏障；每组两块 |
| 离线与在线 | fit/calibrate/qat → prepare → kernel | 训练/校准/调参/评估seed分别101/202/303/404 |
| 指令与硬件 | bfe.s32 → 编译器机器码；SIMT MAC | 并非INT4 Tensor Core；Thor实机尚未验收 |

源码先读：2026-10-02实际读取[NVIDIA/CUTLASS](https://github.com/NVIDIA/cutlass) main的[NumericArrayConverter<half_t,int4b_t>](https://github.com/NVIDIA/cutlass/blob/main/include/cutlass/numeric_conversion.h)，`to_reg→packed_convert→convert`用寄存器位变换批量恢复半精度值，许可证BSD-3-Clause。原场景为混合精度GEMM的数据转换；这里只保留真实打包、符号与解码边界，使用简单bfe，不复制其位技巧或模板系统。另读[SmoothQuant smooth_ln_fcs](https://github.com/mit-han-lab/smoothquant/blob/main/smoothquant/smooth.py)：原版把scale融合到LayerNorm/Linear；这里显式预处理A，省略整模型融合。均是**受启发的独立教学实现**，不是上游复现；精确commit未取到，以读取日期/main记录。原生PyTorch校准接口见每日量化栏目。详见[source.json](source.json)。

代码承接10月1日未归档草稿，复制到新日期后重新审阅、修正并运行；旧目录不改，旧输出没有复用为今日证据。Google/知乎检索尝试与失败记录见来源文件，不引用未读文章结论。

## 编码练习

唯一25分钟任务：将K tile从16改为8，**保持group=32不变**，让同组四个tile共用累加器。5分钟画group/tile状态，10分钟修改共享装载与循环，5分钟检查K=1/15/16/17/31/32/33/65，5分钟在Thor测同口径结果。Mac可先完成现成CPU检查，但不能验收CUDA同步。这里已经交付完整baseline及默认最终候选tiled，不留主功能TODO。

`quant_baseline`每个输出重复全局读取/解码；`quant_tiled`把每块A[8,16]与W[16,16]解码后共享。满tile的逻辑解码次数由128×16×2=4096降到128+256=384，属于源码工作量模型，不是DRAM事务实测；INT4邻居可能重复读同一字节，真实流量看ncu。代价是1536B共享存储、每tile两次CTA屏障、边界填零与更多索引。小M/K可能退化。

## 文件说明

- [quant.hpp](src/quant.hpp)：真实INT4/8与FP16编码、scale、五种方法、手写STE更新和部署tensor存储统计。
- [main.cpp](src/main.cpp)：CPU布局/数值oracle、20组对照与训练日志；C++是供CUDA共用的物理格式参考，非上游量化API。
- [quant_gemm.cu](src/quant_gemm.cu)：FP32、四种位宽baseline/tiled、RAII、GPU检查、基准与profile入口。
- [OPTIMIZATION.md](OPTIMIZATION.md)：ncu、ISA、Thor/Turing对照；[verification.json](verification.json)：独立状态。
- [HistogramObserver原生示例](../../quantization/2026-10-02/calibration/README.md)：今日深入的校准方法，与主课合并阅读；Python/PyTorch算法入口，不增加作业。
- 现成附加课：[ARM09](../../arm/2026-10-02/README.md) · [OS04](../../os/2026-10-02/README.md) · [C++17 03](../../cpp17/2026-10-02/README.md) · [两篇论文](../../paper/2026-10-02/README.md)。

## 编译与运行

从本课目录执行，不安装依赖或下载模型：

```sh
sh run.sh cpu
sh run.sh sanitize
# 以下只在Jetson Thor执行
sh run.sh gpu --check
compute-sanitizer --tool memcheck build/gpu/quant_gpu --check
compute-sanitizer --tool racecheck build/gpu/quant_gpu --check
compute-sanitizer --tool synccheck build/gpu/quant_gpu --check
build/gpu/quant_gpu
sh profile.sh W4A4 outlier baseline
sh profile.sh W4A4 outlier tiled
sh export-isa.sh
```

本机Apple clang 21/C++17已运行。CUDA构建固定110，编译守卫1100、运行时CC=11.0；不允许其他后缀。NVIDIA[Thor CUDA13说明](https://developer.nvidia.com/blog/whats-new-in-cuda-toolkit-13-0-for-jetson-thor-unified-arm-ecosystem-and-more/)确认JetPack7.0的CUDA13.0基线；板端仍须记录实际JetPack/L4T、driver、nvcc、ptxas和ncu版本，并通过设备查询。网页工具链支持不等于当前机器已部署可用。

## 正确性验证

INT4取值[-7,7]，INT8[-127,127]，零点0，半值远离零；FP16转换为ties-to-even，二者不能混淆。W尺度为每K组每输出列FP32，A4/A8尺度为校准全集统计的单一FP32。A16指IEEE FP16位存储、解码后FP32乘加，非BF16。W4A4/W8A8每组整数MAC后乘sA×sW；W4A16/W8A16每组float×int后乘sW。离群top2依据**校准激活幅值**选通道，主路径置零，另加FP16 A/W残差。

五种方法：absmax；固定alpha=.5等价缩放；独立validation选择alpha/裁剪；额外拆离群通道；固定量化器、FP32 master、STE投影梯度40步。QAT每步重新round/clip/pack，训练目标是原FP32 Linear，checkpoint只按validation选择。没有从eval挑参数。分布变化测试把未校准通道4放大30倍，只报告风险。

CPU检查有限half全位模式往返、ties-even常数、INT4/8全部对称码、非法逻辑下标、负维度、10种K尾部×6种组合、零值、独立先解码再GEMM、未量化缩放等价。手算两组输入得到42，错误全局scale法得到330。GPU逐输出对CPU量化oracle检查`1e-3 + 1e-4*abs(ref)`，先以NaN污染输出；量化NRMSE对原FP32单列，不拿大容限掩盖kernel错误。

## 性能分析

CPU日志的packed GEMM p50含解码、host算术与输出分配，不含在线prepare；3次预热20次采样。FP16参考是先round到half再展开FP32运算，绝非CPU原生FP16吞吐。`input_weight_bytes`的FP16行是该表示的tensor预算，不是展开后的进程常驻内存。

GPU提供20次预热100次CUDA event单kernel；另100次host `prepare+H2D+kernel+D2H+wait`（权重已驻留，不含校准/QAT/首次分配）。基线/候选使用相同输入、格式、方法、误差阈值、stream与采样；profile仅定位，不用于速度结论。NPU未涉及，无NPU数据。当前缺设备，全部GPU/端到端数字留空。

## 实际运行结果

[CPU原始记录](results/cpu.txt)和[ASan/UBSan](results/sanitize.txt)均通过；20组真实结果与160行TRAIN在日志。W4A4的NRMSE：absmax **0.227618**，固定缩放0.113882，调参0.107533，离群拆分0.019703；加入QAT后validation选step0，**没有额外收益**。四格式均发生40步真实master更新，但全都回退初始checkpoint，不能写训练改善精度。

W4A4离群方案部署tensor总计2362B（权重含残差694B、metadata500B、输入含残差1168B），FP16 A/W表示预算6630B；不含训练master、分配器、输出、CUDA缓存。shifted NRMSE从absmax 0.185886变为离群方案0.639042，说明校准覆盖不足可能抵消精度收益。CPU scalar低位实现比FP32更慢的日志也完整保留；不作GPU推断。

[CUDA配置](results/gpu.txt)因缺nvcc失败；[ncu](results/ncu.txt)、[ISA](results/isa.txt)退出127。没有真实GPU PTX/SASS产物，inline PTX仅是已写源代码。

## 工程注意事项

矩阵tensor格式不等于Tensor Core格式，INT4不等于FP4。当前kernel是SIMT标量MAC，没有原生低位Tensor Core性能。group=32和tile=16分别是量化粒度与搬运粒度，不能一起随意改。离群、scale、残差复制必须纳入存储/在线耗时；推理不能携带训练master假称已压缩。原生PyTorch示例与C++使用不同对称端点/舍入约定，不能直接交换字节而忽略格式元数据。

迁移验收：固定设备CC/SDK→通过mem/race/sync检查→20组合与尾部检查→记录时钟功率和输入→裸跑同口径计时→ncu解释瓶颈→分布变化与长期负载→选择部署或回退。当前仅完成host格式/数值关，GPU收益、热稳定、功耗均待验。

## 工业故障与面试追问

1. K跨32后误差突增→怀疑scale混用→用两组42手算反例定位→组末flush、跨tile保留→回归31/32/33。代价为每组浮点缩放，不能删除。
2. 仅N奇数且行数多时出错→怀疑按行填充与整矩阵打包不一致→打印首尾nibble逻辑下标→统一扁平索引→回归N=1/17/19，不执行越界来证明。
3. shared优化偶发挂起→检查尾线程提前return或覆盖未消费tile→Thor synccheck/racecheck→无效线程补零并参与两次屏障→小M/K单独测退化。
4. 校准误差低、线上误差高→统计饱和与新通道分布→重做具有代表性的calib/tune并冻结版本→保留heldout与shift，不用评估反调参数。

追问：①INT4符号扩展如何验证？②group尺度为什么不能提出整个K求和？③A16的“16”约束存储还是累加？④消费者屏障与装载屏障各保护谁？⑤QAT更新了但选step0意味着什么？⑥怎样证明性能来自解码复用而非误差合同变化？

## 自测问题

保持同一group scale不变时，把K tile从16改为8，哪些累加器、尾部填零与同步边界必须保持，怎样设计一个能同时抓住跨tile丢和与跨group错误缩放的最小输入？
