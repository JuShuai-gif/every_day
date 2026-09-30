# 2026-09-30 PTX / CUTLASS：Thor 双缓冲 GEMM 与槽位复用

## 工业场景

机器人视觉编码器向控制头投影一小批特征：A[M,K]、B[K,N]均为连续row-major FP32，C=A×B。代表输入M=32、N=64、K=129，K尾块刻意非16整倍数；允许M/N=1..512、K=1..2048。权重常驻的kernel延迟和含传输的请求区间分开。目标固定Jetson AGX Thor SM110；候选用于理解流水与正确性，**不是生产级Tensor Core GEMM**，不替代cuBLAS/CUTLASS完整实现。

## 概念回顾

异步拷贝的价值来自把下一块数据的搬运放进当前块计算期间，而不是把同步加载换一个指令名字。这里每个线程块负责十六行乘十六列输出，线程先搬运一项左矩阵和一项右矩阵到共享内存，再依次执行十六次浮点乘加。同步基线只有一个槽，装载、消费和复用串行发生；最终候选使用两个槽，计算当前槽时向另一个槽预取。矩阵尾部仍必须补零，不能把无效加载简单跳过，否则上轮数据会进入下一轮累加。

这个流水与共享存储的所有权紧密耦合。拷贝提交只形成当前线程的操作组，不保证数据已经抵达，也不代表其他线程已经完成自己的拷贝。等待操作保证本线程提交的拷贝完成，随后线程块屏障才能让跨线程消费者共同进入计算。计算结束还必须满足消费后复用的屏障约束：快线程不能在慢线程仍读取旧槽时覆盖它。完成可见性与消费后复用是两个方向的约束，删掉任意一个都可能产生随调度变化的错误，普通主机数学模拟无法证明这些约束成立。

双缓冲没有减少矩阵的数学工作量，也没有自动减少全局加载字节数。它增加共享内存占用、地址计算和流水启动排空成本；短维度没有足够计算覆盖搬运时可能更慢。拷贝按四字节对齐，尾部传入合法源地址并用有效字节数控制补零。输出仍按同一顺序累加并对独立双精度参考检查。性能结论必须来自目标设备上的公平对照，分析等待、共享加载和乘加依赖时还要区分消费者停顿与真正产生延迟的上游加载，不能由一条指令名称推断固定周期或收益。

## 知识图谱

| 机制 | 代码连接 | 前置与易混点 |
| --- | --- | --- |
| global→shared异步组 | copy4→issue→commit_group→await_tile | 4B对齐、合法地址、src-size尾部；提交不等于完成 |
| CTA可见性/消费后复用 | wait_group 0→syncthreads→FMA→syncthreads | 每线程等待不能单独证明其他warp数据可见；最后屏障保护读者 |
| 双槽轮转 | slot=tile&1，next=slot^1 | 只有旧槽消费结束才能复用；K=1/16/17/33覆盖启动/尾部/循环 |
| 编译链路 | CUDA C++→PTX→ptxas→SASS | inline PTX是真实源代码；当前无编译产物，PTX不是机器码 |

实际先读[NVIDIA/CUTLASS](https://github.com/NVIDIA/cutlass)，main分支，2026-09-30：
[arch/memory_sm80.h](https://github.com/NVIDIA/cutlass/blob/main/include/cutlass/arch/memory_sm80.h)的cp_async_zfill、cp_async_fence、cp_async_wait；
[gemm/threadblock/mma_multistage.h](https://github.com/NVIDIA/cutlass/blob/main/include/cutlass/gemm/threadblock/mma_multistage.h)的MmaMultistage::prologue、gmem_wait、advance_smem_read_stage/write_stage、copy_tiles_and_advance和gemm_iters排空。许可证BSD-3-Clause，精确commit待补。原场景是多级Tensor Core GEMM；本课为**受机制启发的独立实现**，保留提交/等待/CTA同步/槽位所有权，省略迭代器模板、warp MMA和多级流水，不复制源码或声称复现CUTLASS性能。[来源记录](source.json)。Google/知乎检索未取得可核验正文，错误单列；不把搜索摘要当阅读。

## 编码练习

唯一25分钟任务：给`gemm_async2`增加**关闭预取的运行选项**，保持两个槽和所有屏障，只把下一tile的`issue`移到当前tile计算后。5分钟画槽位表，10分钟增加变体，5分钟跑尾部检查，5分钟在Thor比较；Mac先完成编译可用部分与槽位数学验证，GPU验收留到目标机。

现成交付：`gemm_sync`为正确性基线，`gemm_async2`为最终优化候选与默认profile对象。完整候选已实现，不需要用户从TODO补出主功能。两者相同16×16 CTA、FP32 FMA顺序、输入和容限。候选的假设是搬运与计算重叠，收益尚未验证。

| 时段（示意） | slot0 | slot1 |
| --- | --- | --- |
| prologue | 拷tile0→wait→CTA可见 | 空 |
| tile0计算 | 读tile0 | 拷tile1，与计算重叠 |
| 消费屏障/等待 | 已释放 | tile1可读 |
| tile1计算 | 拷tile2 | 读tile1 |

## 文件说明

- [src/gemm.cu](src/gemm.cu)：同步/双缓冲kernels、RAII、sweep/bench/profile入口。
- [src/cpu_check.cpp](src/cpu_check.cpp)、[contract.hpp](src/contract.hpp)：独立oracle与槽位数学；不模拟GPU内存序。
- [profile.sh](profile.sh)、[export-isa.sh](export-isa.sh)、[性能/ISA教程](OPTIMIZATION.md)。
- 每日附加现成材料：[LLM.int8](../../quantization/2026-09-30/llm_int8/README.md) · [ARM08自动向量化](../../arm/2026-09-30/README.md) · [OS03退出与回收](../../os/2026-09-30/README.md) · [C++17 02寿命与RAII](../../cpp17/2026-09-30/README.md) · [两篇论文](../../paper/2026-09-30/README.md)。

## 编译与运行

从本课目录执行；不安装依赖：

```sh
sh run.sh cpu
sh run.sh san
# 以下仅在Thor上：
sh run.sh gpu
compute-sanitizer --tool memcheck ./build/gemm sweep
compute-sanitizer --tool racecheck ./build/gemm sweep
compute-sanitizer --tool synccheck ./build/gemm sweep
sh profile.sh sync
sh profile.sh async2
sh export-isa.sh
```

工程基线CUDA13.0+，`nvcc -std=c++17 -O3 -lineinfo -arch=sm_110`，设备运行时校验CC11.0。官方[JetPack7.0归档](https://developer.nvidia.com/embedded/jetpack/downloads/archive-7.0)核实Thor/T5000、L4T38.2/38.2.1、Ubuntu24.04、CUDA13.0.0；[CUDA13工具说明](https://developer.nvidia.com/blog/whats-new-and-important-in-cuda-toolkit-13-0/)核实Nsight Compute2025.3。实际板上驱动版本、ncu权限和SDK组合未验，不能由文档支持推断本程序已可部署。记录命令见优化教程。

## 正确性验证

CPU对M/N边界{1,15,16,17,33/35}、K={1,15,16,17,31,32,33,65}的200个shape逐一比较两种槽位模型，共400组；每次shared模型先污染NaN再补零。另测5非法shape、全零和手算2×3乘3×2。GPU sweep相同400对照，每个输出先填NaN字节，独立double oracle，容限`1e-4+1e-4*|ref|`且拒绝非有限值。GPU测试尚未运行；GPU屏障、inline PTX编译和竞态仍待验。

## 性能分析

每个满tile理论8192 FLOPs，A/B读取2048B，不含C写回和跨CTA重复；tile级计算强度4 FLOP/B，只是逻辑计数而非DRAM测量。同步shared=2048B，双槽=4096B。K129有9个tile，尾块仍执行16步FMA，因此对小shape浪费显著。对代表shape只发8个CTA，可能不足以占满设备；这本身就是Small-M场景的现实限制。

程序20次预热，101次单kernel CUDA event样本；另测H2D+kernel+D2H+wait主机区间，分配和CPUoracle不在计时内。主机数组为pageable，驱动暂存/同步成本计入该区间；它不是完整机器人E2E。固定输入/频率/热状态，先无profiler对照，再定位潜在等待。无GPU、NPU或端到端实测数据；CPU只测正确性。详细操作见[OPTIMIZATION.md](OPTIMIZATION.md)。

## 实际运行结果

Mac arm64 Apple clang21：Release、ASan/UBSan均通过400组和边界，见[cpu](results/cpu.txt)、[sanitize](results/sanitize.txt)。格式化后[Release复验](results/final-run.txt)与[Sanitizer复验](results/final-sanitize.txt)仍通过。GPU构建、ncu采集、ISA导出实际尝试均exit127，分别缺nvcc/ncu；[原始尝试](results/tool-attempts.json)与[验证范围](results/verification.json)。无真实PTX/SASS编译产物、设备误差、耗时或加速比。

## 工程注意事项

所有API调用检查错误，析构报告释放失败；对象不可复制。正常路径在资源析构前同步stream；发生设备错误时仍尝试RAII清理，但不保证CUDA上下文可继续服务。全CTA都执行屏障，越界线程只对写输出加谓词，不能提前return。仅处理有限FP32、连续布局、无C/A/B别名；不支持转置、任意stride或beta*C。

本次架构对照选择**Hopper SM90的bulk/TMA搬运**，重点与Thor沿用的非bulk cp.async比较；其他架构只作原理对照，所有执行目标仍sm_110。新指令不会自动使这个小tile更快，条件和限制见优化文档。发布前必须完成目标编译、三个sanitizer、代表shape与长期负载、应用E2E回归；不满足延迟/资源预算时保留sync或使用经验证库算子。

## 工业故障与面试追问

| 触发→现象 | 原因/辨别证据 | 修复与回归 |
| --- | --- | --- |
| K=17/33才错，整块正确 | 无效拷贝只跳过导致旧shared残值；污染输出/尾槽并查src-size | 无效项明确补零；所有尾部shape回归 |
| 压力下间歇错，单步调试不复现 | 读者未结束便复用或仅wait无CTA屏障；racecheck/synccheck加重复压力 | 恢复消费屏障与完成后CTA同步，不能靠额外主机同步掩盖 |
| async2变慢 | K短、CTA少、shared/指令成本大；无profiler时间+ncu资源/调度证据区分 | 按shape选回退；不可用减少容限或换精度制造收益 |

面试追问：1. commit和wait分别改变什么？2. wait后为什么还需CTA屏障？3. 为什么消费结束的屏障不同于数据到达屏障？4. 怎样证明尾部指针合法？5. profiler的long scoreboard采样点为何可能不是根因？6. 两倍shared为什么不等于两倍速度？

## 自测问题

若把双缓冲主循环末尾的消费屏障删除，但保留所有`wait_group 0`和其后的CTA屏障，在当前代码结构与未来把预取提前的结构中，分别需要证明哪些读写顺序才能判断是否安全？只给出推理与所需证据，不直接运行一个竞态版本作为正确性证明。
