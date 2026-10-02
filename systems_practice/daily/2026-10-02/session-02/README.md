# 2026-10-02 GPU访存优化：带独立stride的Thor特征转置

本日正式主课。先前并发游标尚未登记产生的[量化补充](../README.md)保留原始材料，不重复推进；本课承接10月1日量化GEMM。只需完成下面一个25分钟任务。

## 工业场景

Jetson Thor视觉编码器的FP32特征 `[H,W]→[W,H]`，代表1024×2048，输入ldi=2051、输出ldo=1027。目标是保留填充区域、避免格式转换占用推理预算；不预设毫秒指标。缓冲区非重叠，1≤H/W≤8192、逻辑宽度≤stride≤16384，越界拒绝。相较9月19日转置课，本次重点是**独立输入/输出stride与异形尾块**的验收合同。

先实际读[NVIDIA/cuda-samples](https://github.com/NVIDIA/cuda-samples) master，2026-10-02，`cpp/6_Performance/transpose/transpose.cu` 的 `transposeNaive/transposeCoalesced/transposeNoBankConflicts` 及主机预热循环。[具体源码](https://github.com/NVIDIA/cuda-samples/blob/master/cpp/6_Performance/transpose/transpose.cu)。原示例侧重整tile方阵吞吐，保留分块转置与补齐机制；本例为受启发的独立实现，增加两种stride、边界、RAII与固定SM110检查，未复制其benchmark、分区重排或原平台性能。文件头为NVIDIA BSD三条款式许可；仅读取日期/分支，未锁定commit。旧`Samples/6_Performance/...`地址404后找到迁移到`cpp/`的实现。

本次于2026-10-02实际尝试[Google检索](https://www.google.com/search?q=CUDA+transpose+stride+bank+conflict+FP32+FMA+noexcept+vector+xv6+kalloc)和[知乎检索](https://www.zhihu.com/search?type=content&q=FMA%20vector%20noexcept%20kalloc)，均返回Internal Error，未读到文章正文。以下技术依据来自实际取得的GitHub实现和官方资料，不把检索摘要算源码阅读。

## 概念回顾

转置是视觉编码器把位置优先特征改成通道优先布局时常见的纯搬运算子。逻辑矩阵宽高不能代替物理行跨度：输入地址按输入跨度计算，输出地址必须换成输出跨度。两个跨度独立，即使结果数值在方阵上正确，也可能在带填充的相机缓冲区上读错数据。先规定非重叠缓冲区、正维度和合法跨度，再讨论吞吐，才能把布局错误与访存瓶颈分开。

一个线程束内的线程连续读取一行时，全局访问容易合并；如果同一批线程立即向转置后的不同输出行写入，写地址会相隔整行。共享内存分块让生产者按输入行写入片上小块，消费者交换块内坐标后再按输出行写回，使读写两端都沿连续列展开。这里的屏障建立生产完成到消费开始的顺序，尾部线程不能因为越界提前退出屏障；只对读写加条件，并证明每个有效消费者都有有效生产者。

但全局合并并不保证共享访问也高效。以单精度元素和三十二个存储体的地址模型看，三十二列的块按列读取时，不同线程落到同一个存储体的不同地址；给每行补一个元素便改变取模关系。补齐增加少量共享容量，却可能减少串行服务。它不会自动修复全局行起点的不对齐，也不保证小矩阵更快。实际采用必须保持线程数、输入、计时和缓存状态一致，先核对全部有效元素与填充哨兵，再用性能计数器区分全局事务、共享冲突和同步等待。未取得目标设备证据时，只能交付优化候选，不能把地址模型的改善写成加速倍数。

## 知识图谱

```text
FP32非重叠输入 + 独立ldi/ldo
  → threadIdx.x对应连续输入列 → global读取合并
  → tile[ty+j][tx] → 全块屏障 → tile[tx][ty+j]
  → 输出行内连续写回 → global写入合并
  → shared列读取地址 (lane*pitch+col)*4
      pitch32:同bank不同地址；pitch33:分散bank（地址模型）
前置：所有线程过屏障、有效读写配对、地址范围合法
```

合并访问讨论global事务；bank conflict讨论shared；同地址广播不是不同地址冲突；padding不是量化精度，warp同步不能替代本例跨warp块同步。

## 编码练习

**唯一25分钟任务**：阅读已经完成的`transpose_tile<1>`，把CUDA测试集合中的padding扩展为0/1/3/17并保留每行哨兵核对；记录1024×2048与33×65的三实现对照。5分钟推导`ldi/ldo`与tile坐标，10分钟扩展合同用例，10分钟运行CPU辅助与Thor命令；没有Thor时提交CPU证据和明确未运行清单，不用CPU时间替代GPU收益。

## 文件说明

- [CUDA三种实现](src/transpose.cu)、[合同与oracle](src/contract.hpp)、[CPU地址核对](src/cpu.cpp)、[构建](CMakeLists.txt)、[运行](run.sh)。
- [ncu教程与ISA分析](OPTIMIZATION.md)、[采集脚本](profile.sh)、[PTX/SASS导出](export-isa.sh)。
- [来源](source.json)、[验证](verification.json)、[实际CPU日志](results/cpu.txt)。
- 附加现成阅读：[QAT](../../../quantization/2026-10-02/qat/README.md)、[ARM10](../../../arm/2026-10-02/session-02/README.md)、[OS05](../../../os/2026-10-02/session-02/README.md)、[C++17 04](../../../cpp17/2026-10-02/session-02/README.md)、[DAMP与GSQ](../../../paper/2026-10-02/README.md)。不新增必做作业。

## 编译与运行

工作目录为仓库根目录：

```sh
cd systems_practice/daily/2026-10-02/session-02
sh run.sh cpu
sh run.sh sanitize
# 以下只在Jetson Thor的兼容Linux / JetPack环境执行
sh run.sh gpu
compute-sanitizer --tool memcheck build/gpu/transpose
compute-sanitizer --tool racecheck build/gpu/transpose
sh profile.sh
sh export-isa.sh
```

[CUDA13官方Thor说明](https://developer.nvidia.com/blog/whats-new-in-cuda-toolkit-13-0-for-jetson-thor-unified-arm-ecosystem-and-more/)核实CUDA13、JetPack7起提供Thor支持。CMake≥3.24、CUDA编译器≥13.0、C++17且`CMAKE_CUDA_ARCHITECTURES=110`；命令固定`-arch=sm_110`，运行检查CC11.0。不以任意CUDA13 wheel代替匹配L4T/驱动；到板端须记录`nvcc --version`、驱动/JetPack/功耗模式/ncu版本。Mac无工具链，当前未验证这个组合。

## 正确性验证

CPU oracle使用直接逐元素转置，另一实现核对tile换位：7种高×7种宽×2种padding×2种shared pitch=196次，另4个非法合同。GPU路径执行相同98种形状×3实现，输出全数组精确相等，包含每行-999填充。FP32仅搬运、不做算术，本例输入均有限可精确表示，预期零误差。CPU模拟不能证明屏障和GPU内存安全；必须再过Thor memcheck/racecheck和GPUoracle。

## 性能分析

三实现固定32×8线程；PAD0与PAD1仅改变shared pitch，naive与tile则隔离global写入布局。目标程序先正确性检查，再10预热+30次单kernel event采样，报P50/P95与`2*H*W*4/time`有效带宽；它不是DRAM实际字节计数。输入常驻、缓存可能热，未做轮换大工作集，也未测冷启动。H2D/D2H是同步主机调用计时，未合并为E2E。CPU地址检查无性能报告；GPU、NPU、完整推理E2E、功耗全部未测。具体ncu证据与采用条件见OPTIMIZATION。

## 实际运行结果

Mac Apple clang21 arm64：Release及ASan/UBSan实际通过196比较+4非法输入。[Release](results/cpu.txt)、[Sanitizer](results/sanitize.txt)。CUDA配置实际失败`Failed to find nvcc`，[原始输出](results/gpu.txt)；ncu缺失，[采集尝试](results/profile.txt)；ISA导出缺nvcc，[尝试](results/export-isa.txt)。GPU编译/执行/正确性/性能均未验证，未生成真实PTX/SASS，无指令周期或加速结论。

[格式化后最终Release](results/final-cpu.txt)与[最终Sanitizer](results/final-sanitize.txt)再次通过；原始日志继续保留。

## 工程注意事项

共享内存PAD1每块4224B，PAD0为4096B，增加128B是容量计算而非设备性能。负维度、过大维度先拒绝；std::size_t地址乘法避免32位中间溢出。RAII释放检查错误并终止，防止静默清理失败。接口不支持原地转置；空矩阵在host拒绝，避免零维grid。新策略只有在目标代表shape正确、P95收益稳定且无大幅小矩阵退化后才替换基线；端到端无收益时保留简单布局或在相邻算子融合转换。

## 工业故障与面试追问

1. 方阵通过、带stride图像花屏→把width当ldi或把height当ldo→用33×65与padding17哨兵核对→两个跨度显式传入；代价是地址计算但避免错误模型输入。本例安全用例已测，生产故障是待验证诊断链。
2. coalesced仍慢→共享列访问冲突或占用率变化→对照PAD0/PAD1的shared wavefront、bank conflict、kernel duration→仅当相关指标与时间同时改善才采用；单看“补齐”不能定因。
3. 尾块偶发挂起/非法读→提前return避开屏障或消费未写tile→memcheck/racecheck加非整tile回归→屏障无条件、读写各自guard，并证明坐标配对。

面试追问：为什么读合并不代表写合并？shared广播与bank冲突如何区分？为什么这个屏障不能放进guard？两个stride怎样影响全局事务？小shape为何可能不值得用shared？如何证明ncu采集的kernel与event计时是同一实例？

## 自测问题

如果输出来自一个行首额外偏移4字节、ldo=H+1的外部缓冲区，PAD1仍能消除本例的shared地址冲突，但global写入和有效带宽验收需要增加哪些合同与观测？请沿一个warp的地址推导，暂不提供答案。
