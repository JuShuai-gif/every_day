# 2026-10-03 GPU 体系结构：短行归约的warp映射与同步域

## 工业场景

双相机视觉编码器每帧产生394个token，对每行129维FP32特征计算能量 `y[r]=Σ x[r,c]²`，供异常监测使用。实际存储行跨度136，padding填9000防止误读。目标为Jetson AGX Thor SM110，输出394个FP32，不改变模型阈值或输入精度。目标是降低该阶段延迟；只有板端结果能决定是否采用优化。较长行1025/8192作为可能退化的对照。

## 概念回顾

短行归约的核心问题是如何把一行数据分配给线程，以及这些线程在哪里交换中间结果。一行交给一个线程块时，线程跨步读取连续元素，把局部平方和写进共享内存，再通过屏障推进加法树。相邻线程的全局读取容易合并，但短行只给每个线程很少工作，跨线程束屏障与中间存储可能比有效计算更突出。把一行缩到一个线程束，可以在寄存器之间交换局部和，并让一个线程块同时承接多行，从而改变每个输出的同步成本和网格规模。

这一映射必须和参与线程集合一起推导。最后一行不足三十二个元素时，没有元素的线程仍应贡献零并参加交换，不能先退出再让其他线程读取它的寄存器。本例每个线程束负责完整一行，尾部不足四行的线程束也保持完整参与，只禁止最终越界写出。线程束交换只传递寄存器值，并不自动发布任意共享内存写入；跨线程束的数据依赖仍需要相应同步。浮点加法树改变还会改变舍入路径，因此正确性使用独立双精度参考和统一容限，而不要求两个版本逐位相同。

减少屏障不必然降低延迟。每行使用更少线程后，每个线程承担更长的累加依赖，网格也可能变小，能够同时推进的工作不足。寄存器、共享内存、线程块上限共同限制驻留数量；理论驻留率只是资源上界，不等于实际发射效率。应先记录内核资源与可用线程束，再对照屏障等待、就绪线程束和访存指标解释变化。短行、长行及少量行必须分别验收，保留无收益情形。主机参考仅检查索引和数值，不能证明设备同步正确，也不能替代目标机器上的内核与端到端计时。

## 知识图谱

`[rows,cols,stride] → 连续lane读取 → 每lane FMA → 同步域 → 输出唯一写者 → SM驻留/调度 → 请求延迟`。

| 子点 | 代码连接 | 前置及边界 |
| --- | --- | --- |
| 主机制：行到warp/CTA映射 | `energy_cta`与`energy_warp` | CTA128；warp32；行数不是CTA数 |
| 耦合机制：参与集合与资源 | `warp_sum`、全mask、occupancy查询 | 越界元素为零；理论occupancy不代表有效吞吐 |
| 数值与布局 | stride、FP64 oracle、统一误差 | padding不是有效输入；FMA和加法树会影响舍入 |

## 编码练习

唯一25分钟任务：把已提供的四行/CTA候选改为八行/CTA（256线程），保持每行32线程，新增rows=7/8/9和cols=31/33的覆盖；先运行CPU合同，再在Thor用同口径基准和ncu决定是否采用。5分钟推导行号，10分钟修改及边界，10分钟验证/记录。Mac上先完成合同与生成代码，GPU验收保留待办。

已提供完整基线与最终优化候选，默认无参数比较两者；不把待验证候选称作已提速。最终候选消除跨warp共享树，不减少输出或必要的参与线程。详细公平实验及指令说明见[优化与分析](OPTIMIZATION.md)。

## 文件说明

- [CUDA基线/候选](src/energy.cu)、[明确手写PTX与RAII](src/gpu_support.hpp)、[CPU合同](src/contract.hpp)、[CPU测试](src/cpu.cpp)。
- [来源记录](source.json)、[验证记录](verification.json)、[真实日志](results/cpu.txt)。
- 附加现成材料：[NF4/QLoRA](../../quantization/2026-10-03/nf4_qlora/README.md)、[ARM11](../../arm/2026-10-03/README.md)、[OS06](../../os/2026-10-03/README.md)、[C++17 05](../../cpp17/2026-10-03/README.md)、[两篇论文](../../paper/2026-10-03/README.md)。不增加必做作业。

源码关系：实际阅读[PyTorch v2.8.0 Reduce.cuh](https://github.com/pytorch/pytorch/blob/v2.8.0/aten/src/ATen/native/cuda/Reduce.cuh)，`ReduceOp::thread_reduce_impl → block_x_reduce`与维度映射，读取日2026-10-03。原场景是通用TensorIterator归约；保留分层归约/参与约束，省略类型分派、多CTA归并与任意stride。这里是受启发的独立实现，未复制上游代码；PyTorch LICENSE BSD式许可正文已读。先尝试NVIDIA cuda-samples当前/历史reduction路径，出现Cache miss/404，未声称读到该实现。Google/知乎相关检索访问失败，详见来源记录。

## 编译与运行

工作目录为本课，C++17，AppleClang21实际验证。Mac：

```sh
sh run.sh cpu
sh run.sh sanitize
```

Thor Linux：以官方JetPack7.0/L4T38.2、CUDA13为已核实的历史支持基线，实际板端驱动/ncu版本另验，不宣称这是最新版本。参考[官方发布说明](https://forums.developer.nvidia.com/t/jetpack-7-0-jetson-linux-38-2-for-nvidia-jetson-thor-is-now-live/343127)。

```sh
nvcc --version
cat /etc/nv_tegra_release
nvidia-smi
sh run.sh gpu
compute-sanitizer --tool memcheck build/gpu/energy
compute-sanitizer --tool synccheck build/gpu/energy
```

CMake强制110且要求CUDA13+；程序拒绝非11.0设备。具体安装组合以板端SDK支持为准；不自动安装。

## 正确性验证

CPU共216次宽度32/128归约模拟；rows覆盖1/3/4/5/31/394，cols覆盖1/7/31/32/33/127/128/129/1025，padding0/7；逐元素访问次数为1，比较FP64 oracle。4个非法Shape和全零输入通过。相对/绝对组合容限 `2e-5*max(1,gold)`，排除NaN。

GPU完整测试单独运行，同样有尾行/尾列与padding污染检测，输出先置NaN字节。CPU没有执行CUDA树屏障，只有compute-sanitizer和设备结果可以验收该部分。输入合同为有限小幅FP32，不承诺平方溢出时仍有限。

## 性能分析

内核event采样20预热+100次；传输+kernel+等待另用墙钟20预热+100次，分配、生成、比较排除。逻辑流量每次 `4*rows*cols+4*rows` 字节，不等于DRAM实测流量；读取padding所需传输额外计入E2E。没有NPU数据；CPU合同不测速度。[教程](OPTIMIZATION.md)连接每个假设和计数器，不以指令条数猜周期。

## 实际运行结果

Release、ASan/UBSan均通过216对照、4拒绝、全零检查。CUDA配置实际失败：`Failed to find nvcc`，[原始日志](results/gpu.txt)。ncu/cuobjdump也不存在，[环境记录](results/environment.json)。GPU编译、运行、精度、性能、功耗均未验证；未生成真实PTX/SASS。仅手写PTX源码已交付，禁止作为编译成功证据。

## 工程注意事项

本次架构对照轮换为Hopper：TMA与线程块cluster可处理更大协作域，但本课短行无跨CTA复用，不引入它们。Thor执行仍严格sm_110。[PTX规范](https://docs.nvidia.com/cuda/parallel-thread-execution/)和[Hopper指南](https://docs.nvidia.com/cuda/hopper-tuning-guide/index.html)支持条件见分析文件。

采用条件：设备正确性、同步检查通过，代表短/长行和热稳态下独立基准不回退，请求预算也改善。只降低kernel时间却增加排队/布局成本时回滚。所有CUDA分配、event及析构状态均检查，清理错误报告后终止。没有设置全局缓存/时钟/驱动选项。

## 工业故障与面试追问

| 触发/信号 | 根因候选与最小诊断 | 修复及回归 |
| --- | --- | --- |
| 非32倍cols偶发能量异常 | lane提前return导致被读取的lane未参与；synccheck+cols31/33 | 零贡献全warp参加；单独禁止越界写 |
| stride扩展后能量巨大 | 行地址按cols而非stride，读入9000；比对首个坏行 | 保留物理跨度；padding0/7对照 |
| 无屏障版长行更慢 | 单lane链变长或网格不足；检查eligible warp/SM利用率及源码依赖 | 按形状保留CTA分派，不能盲目限制寄存器 |

追问：1. warp和CTA何时需要不同同步？2. 全mask为何需要尾lane贡献零？3. occupancy API输出是否是实际驻留？4. FMA处long scoreboard是否说明FMA延迟长？5. 如何区分短网格和访存瓶颈？6. 为何相同字节量仍可能性能不同？

## 自测问题

rows从394缩到3、cols从129增长到8192，四行/CTA候选仍正确却可能变慢：你会提出哪两个可区分的调度/依赖假设，并用哪些设备证据决定是否恢复一行/CTA？
