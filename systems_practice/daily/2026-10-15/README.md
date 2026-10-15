# 2026-10-15 GPU访存优化：Thor SM110 转置的合并访问与bank映射

## 工业场景

机器人视觉编码器把行优先 `[tokens=1537, channels=769]` FP32 特征变为 `[channels,tokens]`，输入 stride=772、输出 stride=1540，供后续算子消费。只做无损置换，不归一化、不改精度、不原地覆盖。目标是减少布局转换的设备时间，且不能让尾块污染下一请求。代码默认最终候选 `transpose_tile<1>`，收益尚未在Thor验证。

## 概念回顾

转置的数学工作量很小，性能却取决于同一条访存指令中各个线程的地址。行优先输入中，相邻线程沿列读取连续浮点数，能够合并请求；直接把这些数写到转置后的行，相邻线程的目标地址便相差一个输出行跨度。字节总量没有增加，但有效载荷可能分散到许多内存事务，不能只看理论带宽判断效率。共享内存提供一次线程间的数据交换：先按输入方向装入方形块，整个线程块到达屏障，再交换块坐标和局部坐标，使输出写入也连续。

全局访问合并以后，共享内存本身仍可能串行化。以三十二个四字节bank的地址模型分析，三十二列的浮点块按列读取时，各线程访问不同字却落在同一bank；这与读取同一地址的广播不同。把物理行长增加到三十三，列地址的bank编号随线程递增，能消除这组标量访问的冲突。增加的一列只改变物理布局，不增加逻辑输出。该结论依赖元素大小、访问宽度和线程映射，不能直接套到半精度向量访问或矩阵指令。

尾块让正确性和性能紧密耦合。输入加载和输出写入分别判界，但线程不能在屏障前提前返回；每个有效输出读取的共享位置必须存在有效生产者。跨度还必须用元素数而非字节表示，指针运算采用足够宽的整数。基准保留直接版、未填充版和填充版，分别检验全局事务与共享冲突的假设。事件测到的设备区间、主机传输请求耗时和完整视觉流水线延迟是不同指标；缺少设备时，索引模型只能证明映射，不能证明同步、生成指令或优化收益。

## 知识图谱

`FP32行布局/stride → warp各lane地址 → 全局sector利用率 → shared转置 → bank映射 → CTA屏障 → 输出合同`。

| 耦合点 | 代码 | 前提/不可混淆 |
| --- | --- | --- |
| 全局合并与线程交换 | `transpose_direct` / `transpose_tile` | 相同输出；逻辑字节≠DRAM实际字节 |
| bank行距与同步 | `tile[32][32+PAD]` / `bar.sync 0` | 独立FP32字；bank冲突≠数据竞争 |
| 尾块与stride | 两处独立谓词 | 屏障全CTA参与；pitch单位为float元素 |

## 编码练习

唯一必做任务，约25分钟：5分钟按lane推导direct写地址；10分钟把未填充tile切成PAD=1并解释多出的128B；5分钟运行边界检查；5分钟按分析指南填写设备证据。完整三版已提供，可先隐藏最终候选再实现。Mac先运行索引合同；完整CUDA验收必须在Thor继续。

来源：实际读取 [NVIDIA/cuda-samples v13.0 transpose.cu](https://github.com/NVIDIA/cuda-samples/blob/v13.0/Samples/6_Performance/transpose/transpose.cu)，2026-10-15，函数 `transposeNaive/transposeCoalesced/transposeNoBankConflicts`。原场景为方阵整tile性能示例；此处**改编kernel映射**，保留合并、padding和块屏障，加入矩形、stride、尾块与RAII，移除SDK helper/对角调度。BSD-3-Clause版权见 [NOTICE](NOTICE.txt)，日期/哈希见 [source.json](source.json)。CPU模型与宿主验证框架为独立实现。

## 文件说明

- [CUDA](src/transpose.cu)、[合同](src/contract.hpp)、[CPU索引检查](src/cpu_check.cpp)、[分析指南](PROFILING.md)、[验证](verification.json)。
- 今日现成附加阅读：[QuaRot](../../quantization/2026-10-15/quarot/README.md)、[ARM22小Batch复用](../../arm/2026-10-15/README.md)、[OS17提交与恢复](../../os/2026-10-15/README.md)、[CPP16 invoke/apply](../../cpp17/2026-10-15/README.md)、[MultiAlloc/误差反馈论文](../../paper/2026-10-15/README.md)。这些不增加必做作业。

## 编译与运行

工作目录为本README所在目录；C++17，Mac clang++；Thor使用支持sm_110的CUDA 13+，精确板端SDK组合待核实。

```sh
sh run.sh cpu
sh run.sh sanitize
# 以下仅在Jetson Thor执行
sh run.sh thor
compute-sanitizer --tool memcheck ./build/transpose check
compute-sanitizer --tool racecheck ./build/transpose check
compute-sanitizer --tool synccheck ./build/transpose check
```

所有CUDA构建仅 `-arch=sm_110`，运行时拒绝非11.0设备。零尺寸CPU合同为空操作；GPU辅助函数零尺寸不发射。非零上限16384，缓冲区分离，不支持原地/重叠。

## 正确性验证

CPU独立oracle逐元素写 `B[c*ldB+r]=A[r*ldA+c]`；模型按tile装入再读出，对98种尺寸/stride比对，包含0/1/31/32/33/65及输出padding哨兵；3项无效输入拒绝。CUDA的150个mode/shape组合必须逐位等于oracle且padding保持-999。输入为可精确表示有限float；未覆盖NaN载荷位模式。CPU模型不模拟线程调度，CUDA racecheck/synccheck未运行。事件计时后传回结果复查。

## 性能分析

详见 [PROFILING](PROFILING.md)。对照相同shape、输入、输出、预热10次；21批×100 launches，报告**每批kernel均值的P50/P95**，不是请求尾延迟。日志的kernel_batch_mean是同流CUDA事件批区间摊销，可能包含主机发射导致的流空隙，不能当作每个kernel独占执行时间。逻辑带宽为 `8*rows*cols/time`，不含padding；单独21次请求计pageable H2D+kernel+D2H同步，不含分配/生成，不是完整推理E2E。CPU/NPU性能不进入此表。

| 版本 | 假设及代价 | Thor实测 |
| --- | --- | --- |
| direct | 输入合并、输出跨行；无shared/屏障 | 未验证 |
| tile PAD0 | 双向合并；4096B shared、列bank冲突 | 未验证 |
| tile PAD1最终候选 | 双向合并；4224B shared、增加128B | 未验证 |

小张量可能被启动/屏障主导；GPU缓存命中可让逻辑带宽超过DRAM标称，不能据此声称DRAM超频。若下游能直接消费原布局，省掉转换是另一个接口方案，需保持端到端合同再比较。

## 实际运行结果

Mac CPU索引98组、非法输入3组及ASan/UBSan通过：[CPU](results/cpu.txt)、[Sanitizer](results/sanitize.txt)。解析bank模型得到未填充1个bank、填充32个bank，仅地址推导。缺nvcc/ncu/NVIDIA设备；CUDA编译、GPU正确性/性能、PTX/SASS生成和分析均**未验证**，原始尝试见 [环境](results/environment.txt)。没有填写GPU收益数字。

## 工程注意事项

`cudaMalloc/cudaMemcpy/launch/event/sync/free/destroy`均检查，析构失败输出诊断。kernel接口仅接收经过检查的shape，RAII缓冲区禁止复制。设备支持、驱动/JetPack/L4T/ncu记录和权限检查见分析指南。理论架构对照本次从Turing轮到**Ampere**；执行目标仍Thor。

## 工业故障与面试追问

1. 非32倍尺寸偶发卡死：首先检查尾线程是否在barrier前return，用synccheck辨别同步问题；保留全部线程到屏障，只谓词化搬运，回归1/31/33尺寸。当前为待验故障路径，不称设备实测。
2. PAD0→PAD1无收益：可能冲突减少但启动/DRAM占主导；对比shared excessive wavefront与未附加profiler事件时间，再测大小shape；无收益时保留较简单路径，不能删必要同步。
3. 矩形输出错位但方阵通过：检查交换后的行/列及独立stride；CPU哨兵区分写越界和映射错误，禁止以分配padding掩盖错读。

追问：①为什么读合并不代表写合并？②32/33行距的bank集合如何推导？③广播与冲突有什么区别？④有效消费者如何找到尾块生产者？⑤增加shared可能怎样影响占用率？⑥为何stall采样位置不一定是根因？

## 自测问题

若把输入改为每线程一次读取两个FP16、输出仍保持相同转置语义，你会如何重新推导共享地址、bank访问与尾块合同，并设计能区分“全局事务改善”和“共享冲突改变”的公平实验？
