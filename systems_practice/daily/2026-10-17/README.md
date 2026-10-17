# 2026-10-17 GPU 体系结构：Thor 行能量归约的依赖链与寄存器预算

## 工业场景

Jetson AGX Thor 上相机编码器产生 `[rows, cols]` FP32 特征，输出每行平方和。代表输入4096×4097，行跨度4100；限制 rows≤65535、cols≤65536、stride≤65540。契约为有限、幅值可控的输入，示例生成范围[-1.5625,1.5625]，非有限输入不在目标合同内。目标是降低门控计算延迟且不改变结果语义；尚未设定未经业务测量的硬时限。与上一课转置的区别：本课保持访存映射，研究线程内部依赖与驻留资源。

## 概念回顾

相机特征进入异常检测前，常按行计算平方和，作为归一化或质量门控的输入。今天固定一个 warp 处理一行，lane 按三十二步跨度读取连续通道。相邻 lane 访问相邻元素，先保证访存合并；每个线程在寄存器中完成局部累加，最后用五轮 shuffle 合并结果。输入行不足三十二的整数倍时，越界通道贡献零，但对应线程仍参与归约。尾行则由整个 warp 一起退出。这把数据边界与同步参与者边界分开，避免只让有效元素对应的线程执行全掩码交换。

主机制是指令级并行。基线每个线程反复更新一个累加器，后一条乘加必须等待前一结果。候选把通道按四个相隔三十二的位置分给四个累加器，使调度器有机会在一条链等待时发射另一条链。四条链结束后再合并，读入数据、平方和定义与输出数量不变。它不保证四倍速度：短行没有足够工作，额外合并反而可能增加成本；长行若已受内存带宽限制，算术依赖也未必是首要瓶颈。

耦合机制是寄存器分配与驻留资源。更多活跃值可能提高每线程寄存器需求，减少同时驻留的 warp，甚至产生局部内存溢出。因此不能把 occupancy 百分比或寄存器个数单独当成优劣结论。应联合查看真实编译资源、可发射 warp、依赖停顿与内存事务，再用未附加分析器的同口径计时判断。浮点加法的组合顺序发生变化，正确性须对双精度参考设置容限，不能要求逐位相同。Mac 只检查索引、覆盖与数值合同；GPU 调度、同步和性能必须留给 Thor 实测。

## 知识图谱

```mermaid
flowchart LR
  A[有限FP32 行和stride合同] --> B[32 lane连续加载]
  B --> C[U=1 单累加依赖]
  B --> D[U=4 四条独立依赖]
  D --> E[活跃寄存器增加可能降低驻留]
  C --> F[全warp shuffle归约]
  D --> F
  E --> G[ptxas资源与ncu调度证据]
  F --> H[双精度oracle及浮点容限]
  G --> I[不挂分析器的同输入复测]
```

前置：warp、FP32 FMA、字节stride、RAII。指令延迟≠发射吞吐；occupancy≠利用率；PTX≠SASS；CPU索引检查≠设备同步验证。本kernel无需shared或跨warp同步。

## 编码练习

唯一必做任务（25分钟）：从已给的 `row_energy<1>` 推导四累加器版，核对 `base += 32*U` 和 `col=base+32*u` 的精确覆盖；运行CPU检查，比较两版对尾部的处理。5分钟读合同，12分钟阅读/调整候选，8分钟跑边界并写下采用条件。完整最终候选为 `row_energy<4>`；默认执行两版，设备测量前不宣称更快。不要删掉零贡献lane的shuffle。

已先实际读 [NVIDIA/cuda-samples v13.0 reduction_kernel.cu](https://github.com/NVIDIA/cuda-samples/blob/v13.0/Samples/2_Concepts_and_Techniques/reduction/reduction_kernel.cu) 的 `reduce6/reduce7/warpReduceSum`：原场景是数组多块归约，保留线程多元素累加及warp交换思想。本课为独立启发实现，改成一warp一行和多累加器，不复制多块完成协议、动态共享内存和多类型派发。仓库BSD-3-Clause，读取日期2026-10-17，文件哈希及失败记录见[source.json](source.json)。源码可达是在首次DNS失败后重试取得，并非只读首页。

## 文件说明

- [CUDA基线及候选](src/energy.cu)、[合同](src/contract.hpp)、[CPU索引检查](src/cpu_check.cpp)。
- [ncu、ISA及架构对照](GPU_ANALYSIS.md)、[验证](verification.json)、[实际日志](results/release.txt)。
- 现成附加阅读：[SpinQuant](../../quantization/2026-10-17/spinquant/README.md) · [ARM23解码融合](../../arm/2026-10-17/README.md) · [OS18请求完成](../../os/2026-10-17/README.md) · [C++17第17课](../../cpp17/2026-10-17/README.md) · [两篇论文](../../paper/2026-10-17/README.md)。不新增必做作业。

## 编译与运行

在仓库根目录：

```sh
sh systems_practice/daily/2026-10-17/run.sh cpu
# 以下仅Thor板端执行，CUDA13+且nvcc列出sm_110
sh systems_practice/daily/2026-10-17/run.sh gpu
```

所有CUDA编译为C++17、`-O3 -lineinfo -arch=sm_110`。程序查询计算能力并拒绝非11.0设备；`gpu`路径完整覆盖多组尾长和代表输入。Apple clang21仅编译CPU。未安装依赖。板端JetPack/L4T/驱动/ncu确切组合仍需实际采集，详见GPU分析。

## 正确性验证

CPU共110个shape组合，逐元素访问计数必须恰为1；逐行对双精度oracle验证两版。覆盖rows1/3/4/5/17、cols1/31/32/33/127/128/129/1023/4097/65536等、padding0/3、全零和4种拒绝。误差标准 `abs≤1e-5+3e-5*reference`。Release和ASan/UBSan通过。CPU树归约只验证lane0数值，不能验证PTX参与者约束。

Thor运行必须再用Compute Sanitizer memcheck/synccheck验证，检查每个输出和错误返回；本机没有CUDA工具链，未编译/执行GPU代码。

## 性能分析

理论有效读取4×rows×cols字节，输出4×rows字节；计算约2×rows×cols FLOP。理论算术强度接近0.5 FLOP/B，不含padding、缓存或事务放大。U4不减少逻辑数据量，试图缩短局部依赖链；必须先排除带宽饱和、短行启动成本。不能从此模型推出实测速度。

两版各预热10次，21批×50 launch，CUDA event报告每批均值P50/P95；这是GPU stream区间，可能含launch间隙，不是单请求P95。另测3次预热后21次预分配H2D→kernel→同步D2H主机区间，不含分配、输入生成、模型其他算子。版本顺序固定，建议板端交替顺序复测排除热/频率影响。CPU/NPU没有本课性能指标，未把参考检查计时为GPU结果。

## 实际运行结果

Mac：`PASS shapes=110 two_mappings exact_coverage zero rejected=4`，Release与Sanitizer日志均保留。GPU编译、GPU正确性、ncu、PTX/SASS和速度全部未验证：nvcc/ncu不在PATH且无NVIDIA设备。没有SASS或虚构周期数。格式化用原仓库脚本及配置的当日文件镜像，以保护用户现有修改及源码缓存。

## 工程注意事项

设备buffer/event由不可复制RAII对象管理，分配和每次API调用检查状态；析构清理错误记录到stderr。所有输出拷贝完成后才销毁buffer。输入stride按元素计，寻址提升到size_t。`fmaf`可改变与普通乘加的舍入，容限与finite检查必须保留。

优化候选不使用架构专属后缀指令；本次理论对照轮到Hopper，上一期Ampere。`setmaxnreg`的后缀和warpgroup限制使其不适合直接塞进本课默认sm_110目标，见分析。输出中动态资源查询属于板端待采集证据。

## 工业故障与面试追问

1. cols33/129偶发错值：可能漏尾或mask错误。先核对访问计数，再跑synccheck，检查是否按元素而非warp提前return；修复为边界加载贡献零、全warp参与。代价为短行空lane。
2. U4长行更慢：可能寄存器驻留下降、spill或带宽已饱和。先对比ptxas local/register和ncu eligible/stall，再看实际时间；出现spill或收益不稳定则回滚U1，不能靠压低寄存器上限强行达标。
3. event变快但业务变慢：先分开H2D/D2H和排队，确认输入布局转换和同步；本示例不涵盖模型整体，只有完整请求追踪才支持部署结论。以上是可检验故障链，不是已观察的Thor事故。

面试追问：①同warp连续访问为何仍可能stall？②四累加器如何改变依赖图？③尾元素和尾warp为何使用不同条件？④寄存器多为何不一定慢？⑤PTX看不到spill能证明SASS无spill吗？⑥如何区分event批均值和请求尾延迟？

## 自测问题

同一Thor上，U4的寄存器数上升、理论occupancy下降，但4097通道快于U1，33通道却变慢；你会采集哪三组证据区分依赖隐藏、带宽和启动成本，并据此制定派发规则？
