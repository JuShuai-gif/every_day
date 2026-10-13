# 2026-10-13 PTX / CUTLASS：Thor 尾块补零与 CTA 可见性

## 工业场景

机器人视觉投影 Y=A×B，代表 M=33、N=65、K=129，FP32 row-major，输出[M,N]。动态相机裁剪使K不是16倍数；目标是正确支持尾块，并减少global→寄存器→shared的中转。A/B物理行距向上取4倍数，padding故意填999。单CTA计算16×16，256线程，各线程负责一个输出，shared共2048B。只接受各维1–2048，生产应按模型约束收紧。延迟验收比较同输入同精度的GPU单次启动P50/P95，不设虚构毫秒指标。

## 概念回顾

分块矩阵乘把输入从全局内存搬到共享内存，让一个线程块重复使用同一小块。计算最后一个K块时，逻辑元素常常不足十六个；如果加载器只跳过越界元素，共享槽里可能保留上一块的数据。此时地址没有越界，内存检查也可能不报错，乘加却悄悄把旧值再次计入。因此“没有执行加载”和“向目的地址写零”是两种不同语义，尾块必须为所有将被消费的位置建立确定值。

异步拷贝把搬运交给专用路径，发起线程可以先继续执行，但调用返回并不代表共享内存已经可读。提交组描述本线程此前发起的一批拷贝；等待组只确认该线程的搬运完成，不能替其他线程建立消费许可。本例由前六十四个线程各搬两段连续向量，其余线程也会读取这些数据，所以等待后还需要线程块屏障。计算结束后再次同步，才能保证下次写槽不会覆盖尚未读完的数据。

向量化又把边界问题与对齐绑定起来。每次拷贝十六字节时，源和目的起点都必须满足相应对齐；仅检查首元素有效不够，四个浮点数中可能只有一至三个有效。本例将物理行距补齐，但只把真实有效字节数交给指令，剩余目的字节由指令补零。无效向量使用合法基地址和零字节数，不构造远离分配区的指针。同步基线逐元素加载同样的数据；异步候选只改变搬运方式，不降低精度、不删除同步。本例只有一个共享槽，等待紧邻加载，没有声称实现计算与搬运重叠。候选可能降低中转寄存器压力，也可能因小矩阵启动成本和等待开销没有收益，结论必须由目标设备对照决定。

## 知识图谱

| 耦合点 | 代码与状态 | 前置/不能混淆 |
| --- | --- | --- |
| 逻辑shape→物理stride→16B拷贝 | Shape.lda/ldb、copy16(bytes) | padding可访问不等于数学上有效 |
| 尾块掩码→补零→FMA | src-size为0/4/8/12，完整16B省略src-size | predicated skip不清除旧值 |
| 本线程完成→CTA发布→复用 | commit→wait0→barrier→FMA→barrier | async wait不是跨线程barrier |
| PTX→ptxas→SASS→ncu | [分析教程](PROFILE.md) | PTX不是机器ISA；stall位置不必是根因 |

来源是实际读取的[NVIDIA/CUTLASS v4.2.1](https://github.com/NVIDIA/cutlass/tree/v4.2.1)，BSD-3-Clause，读取日2026-10-13：[`memory_sm80.h` 的 cp_async_zfill](https://github.com/NVIDIA/cutlass/blob/v4.2.1/include/cutlass/arch/memory_sm80.h)与[`mma_multistage.h` 的 prologue/gmem_wait](https://github.com/NVIDIA/cutlass/blob/v4.2.1/include/cutlass/gemm/threadblock/mma_multistage.h)。原场景是多阶段Tensor Core GEMM；本课为**受其机制启发的独立实现**，保留补零、提交/等待与消费者同步，扩展部分向量字节数，省略CuTe布局、迭代器、多阶段、Tensor Core和融合尾处理，不能标作CUTLASS性能复现。[来源记录](source.json)。

## 编码练习

唯一必做任务，约25分钟：先运行现成基线，再在独立副本中把`copy16`的部分向量分支改成逐元素补零，保持完整16B路径；用既有216个shape比较。5分钟读合同，10分钟改加载器，5分钟检查1/15/16/17边界，5分钟解释两个屏障的职责。有Thor时使用现成性能入口；无Thor时CPU模型只辅助推导。最终候选已完整提供为`gemm_async`，`gemm_baseline`保留；不要求重新实现GEMM框架。

## 文件说明

[src/gemm.cu](src/gemm.cu)：两个kernel、RAII缓冲/事件、精度与计时；[src/contract.hpp](src/contract.hpp)：shape/输入/FP64累加参考；[src/cpu.cpp](src/cpu.cpp)：补零合同和安全失败反例；[PROFILE.md](PROFILE.md)：Thor工具链、ncu、ISA；[verification.json](verification.json)：验证边界。

固定附加阅读：[HQQ分组打包](../../quantization/2026-10-13/hqq/README.md) · [ARM20 多核计数](../../arm/2026-10-13/README.md) · [OS15 FD/file/inode](../../os/2026-10-13/README.md) · [C++17第14课 参数包求值](../../cpp17/2026-10-13/README.md) · [两篇论文](../../paper/2026-10-13/README.md)。这些都是现成示例，不新增必做任务。

## 编译与运行

从项目根目录：

```sh
sh systems_practice/daily/2026-10-13/run.sh cpu
sh systems_practice/daily/2026-10-13/run.sh sanitize
# 以下仅在Thor：CUDA 13.x且nvcc明确列出sm_110
sh systems_practice/daily/2026-10-13/run.sh thor
cd systems_practice/daily/2026-10-13
build/gemm --bench 33 65 129
build/gemm --bench 128 128 256
```

不需要CUTLASS安装；它是源码学习依据。所有CUDA编译只有`-arch=sm_110`。工具链官方参考与上板探测命令见PROFILE，不将Mac容器当CUDA设备。

## 正确性验证

216个M/N/K笛卡尔组合：1、3、15、16、17、33，输入为有正负的二进制定点可精确表示值；padding999。两kernel分别对FP64累加后转FP32参考，`abs<=1e-4+1e-4*abs(ref)`且结果有限。CPU还拒绝0/负数/2049，故意不清尾槽的K17模型必须失败。GPU验收需另外跑compute-sanitizer的memcheck和racecheck；本机模型不能证明CTA同步。非有限输入当前不作为支持合同，模型输入生产入口应拒绝NaN/Inf。

## 性能分析

固定shape/数据/数学语义，每kernel20次预热、100次采样，交替两版本顺序；CUDA事件包围单次启动，分配/H2D/D2H/CPU参考不计入，不能称请求端到端。逻辑工作量约2MNK FLOP；两版shared容量相同，改变的是每线程加载指令、活跃加载线程和中转寄存器，实际DRAM事务不能仅按源代码条数推断。主课CPU辅助不测推理性能，NPU与端到端未测。

瓶颈假设、验证指标、launch筛选、cache replay、源码关联和反汇编见[PROFILE.md](PROFILE.md)。无GPU时默认保留两版本；上板确认精度后，仅当目标工作负载P50/P95均符合预算且可重复时选择候选，否则回退baseline。

## 实际运行结果

Mac Release及ASan/UBSan：`PASS shapes=216 invalid=3 stale_tile_detected=1`。[最终文本日志](results/verified-cpu.txt)。`nvcc`、`ncu`和Thor缺失，[编译失败原文](results/thor-build-attempt.txt)及[环境](results/environment.json)已保留。CUDA编译/运行/精度、真实PTX/SASS、计数器及性能均未验证，GPU收益未填写。

## 工程注意事项

本例将行距补齐带来的输入打包成本排除于kernel计时；接入相机连续缓冲区时必须单独计量。每次copy起点16B对齐、dst不重叠、src-size范围有效；不同shape不能复用旧stride。所有CUDA API与清理状态均检查，析构只报告清理错误。主机资源在同步完成后释放。本例使用普通FP32 SIMT，不用Tensor Core；不把PTX名字中的sm80源码文件当实际执行目标。

今天固定Thor SM110，理论对照轮到Ada SM89（上次Hopper）。[Ada调优指南](https://docs.nvidia.com/cuda/ada-tuning-guide/index.html)说明FP8 Tensor Core与FP32吞吐特性；本kernel只用FP32 FMA和沿用的cp.async，没有利用FP8。支持条件与不能使用专属后缀的说明见PROFILE。

## 工业故障与面试追问

| 触发→信号 | 候选根因→最小诊断→修复/代价 |
| --- | --- |
| K17只有最后输出错 | predicated skip留下K0–15数据；比对K16/K17及毒化padding；补零，保留额外边界分支 |
| K129偶发未对齐访问 | 使用逻辑K作为行距；输出每行地址模16；显式物理stride，计入打包成本 |
| 单warp通过、多warp随机错 | 只有wait没有CTA发布；racecheck并核对加载线程/消费者；等待后屏障，不能为提速删除 |
| candidate更慢 | 小grid启动/等待或寄存器压力占主导；先无profiler计时，再查ncu；维持基线而非强行采用 |

面试追问：①skip与zfill数学区别？②为什么无效向量仍使用有效基地址？③wait_group计数属于线程还是CTA？④为什么计算后还要同步？⑤行距补齐如何进入端到端预算？⑥ncu中的stall消费者如何追到前面的加载依赖？

## 自测问题

K从128变为129，输入物理行距已经补齐，而加载器仍对最后一个16B向量读取完整长度；如果padding恰好全零，当前精度测试能否证明实现正确？请给出能区分“碰巧正确”和“满足合同”的最小输入与验证步骤。
