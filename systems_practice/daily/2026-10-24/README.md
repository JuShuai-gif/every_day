# 2026-10-24 CUDA Kernel：RMSNorm 的 warp 归约与寄存器驻留

本次首次北京时间日期命令返回 2026-10-24；跨日交付及最终验证发生于 2026-10-25，不额外消耗25日游标。执行目标始终 **Jetson Thor SM110**。

## 工业场景

机器人视觉编码器的小批量 token 在进入 Linear 前做 RMSNorm。输入 FP32 `[rows,stride]`，有效列 `cols`，输出紧凑 `[rows,cols]`；无 gamma/bias、无原地覆盖。练习限制 rows=1..4096、cols=1..1024、stride=cols..2048、有效输入有限且绝对值≤128，epsilon=1e-5。代表形状257×513，故意含列尾和不足四行尾块。目标是在相同精度合同下降低重复读取和 CTA 同步成本；没有实测时不设虚构时延目标。

## 概念回顾

RMSNorm把每一行的平方均值加上正数再取倒平方根，最后逐元素缩放。归约轴决定哪些元素共享同一个系数，因此线程映射首先是正确性问题。基线让一个线程块处理一行，线程各自累加部分和，经过共享内存树形归约，再重新读取输入写出结果。每一级屏障既要求参与线程到达，也保证下一层看到上一层写入；不能让尾列线程提前返回，否则其他线程可能永远等不到屏障。填零参与与不参与归约不是一回事。

候选把一行交给一个线程束，每个通道按步长三十二读取，暂存自己的输入，再用五次异或交换合并部分和。所有通道必须执行相同的交换指令，即使它没有有效列也要贡献零。尾部整行不存在时，整个线程束可以一起退出。交换寄存器并不等于为任意共享内存访问建立同步；本候选恰好不依赖共享内存。平方求和的浮点结合顺序改变，所以与双精度参考比较应使用明确的绝对与相对误差，而非逐位相同。

输入驻留减少源码中的重复加载，却延长了寄存器活跃区间。编译器可能把数组展开为寄存器，也可能溢出到局部内存；更多寄存器还可能降低驻留线程束数量。小行数时并行度不足，小列数时固定数组和指令开销也可能抵消收益。基线的第二次读取可能命中缓存，所以不能把两次源码读取直接解释成两倍外部显存流量。应把缓存命中、寄存器数、局部内存访问和等待原因一起看。

主机提交、设备执行、数据搬运是不同边界。事件包围一批内核再除以次数给出批均值，可能包含提交间隙，不是逐次请求尾延迟。先验证数值，再在相同输入、编译选项与热身条件下比较，并单独采集分析器报告，才能判断优化是否值得进入部署路径。

## 知识图谱

```text
有效列/行stride → 每行平方和 → 双精度oracle与容差
                       ├ CTA/shared树 → 屏障参与 + 第二次输入读取
                       └ warp/shuffle → 全32lane参与 + values寄存器驻留
                                              ↓
                                寄存器/溢出/occupancy → 实测取舍
CPU准备 → H2D → GPU kernel → D2H → 服务完成（各边界单列）
```

前置：CUDA grid/block/warp、IEEE浮点、RAII。不能混淆源码load次数与DRAM事务、warp交换与通用内存栅栏、GPU事件批均值与端到端P95。

先实际阅读 [llama.cpp norm.cu](https://github.com/ggml-org/llama.cpp/blob/master/ggml/src/ggml-cuda/norm.cu) 的 `rms_norm_f32` → `rms_norm_f32_dispatch` → `rms_norm_f32_cuda`（master，读取2026-10-24～25，文件blob SHA `3f0ea6f2a474edef78ea0858d38739d5461f8faf`；不是commit SHA）。原场景为ggml张量归一化，MIT许可；源码有标量、float4缓存与对齐/stride派发。本例是**独立启发实现**，保留行归约/缓存复用/尾部条件，省略多维张量、float4和通用派发；没有复制或宣称复现整个ggml kernel。详见[source.json](source.json)。

## 编码练习

唯一必做任务，25分钟：在已提供的 `rms_warp` 中沿着“载入并填零→平方和→五次交换→写回”检查每一步，临时把尾列处理改为提前return，推导为什么不满足mask合同，然后恢复正确实现并运行100个用例。建议5分钟读oracle、10分钟跟踪33列/5行、10分钟运行及在Thor比较基线与最终候选。Mac只能做同一任务的数值辅助检查；GPU实现与验收仍在待办中。

## 文件说明

- [reference.hpp](src/reference.hpp)、[cpu_check.cpp](src/cpu_check.cpp)：double oracle、输入合同和CPU数值/索引辅助。
- [rmsnorm.cu](src/rmsnorm.cu)：正确性基线 `rms_base`、最终优化候选 `rms_warp`、RAII设备内存/事件、warmup与公平计时。
- [GPU_GUIDE.md](GPU_GUIDE.md)、[profile.sh](profile.sh)：ncu筛选、采集、源码关联、ISA与架构对照。
- [NF4嵌套量化](../../quantization/2026-10-24/nf4_qlora/README.md) · [ARM集成例](../../arm/2026-10-24/README.md) · [OS24](../../os/2026-10-24/README.md) · [C++17第23课](../../cpp17/2026-10-24/README.md) · [两篇论文](../../paper/2026-10-24/README.md)。均为现成附加材料。

## 编译与运行

从仓库根目录执行，无安装步骤：

```sh
sh systems_practice/daily/2026-10-24/run.sh cpu
sh systems_practice/daily/2026-10-24/run.sh sanitize
# 下列只在已配置CUDA13+的Thor上执行：
sh systems_practice/daily/2026-10-24/run.sh thor
sh systems_practice/daily/2026-10-24/profile.sh
```

C++17；主机Clang；GPU `nvcc -std=c++17 -O3 -lineinfo --fmad=false -arch=sm_110`。已查 [CUDA13.0 nvcc目标列表](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-compiler-driver-nvcc/index.html) 和 [Thor官方CUDA指南](https://docs.nvidia.com/jetson/agx-thor-devkit/user-guide/latest/setup_cuda.html)：普通sm_110、设备能力11.0有官方工具链支持。实际JetPack/L4T/driver/ncu版本组合必须板端记录，不能凭Mac证明。代码运行时拒绝其他compute capability。

## 正确性验证

5种行数×10种列数×零/随机输入，共100例，含1/31/32/33/127/128/129/513/1024列及1/3/4/5/17行。输入行padding为999，若索引误读容易暴露；oracle用double累加，输出比较 `abs_error <= 3e-5 + 3e-5*abs(reference)`。CPU另外拒绝零行、超长列、短stride、零epsilon、NaN、越界幅值，共6类。GPU驱动运行同100例并逐一比较两个实现；GPU结果尚未得到。CPU shuffle顺序模型只验证数值/索引，不证明CUDA编译、参与mask或调度正确。

## 性能分析

基线每行一CTA128线程；候选每CTA4行、每warp缓存32个float。先分别验证，再对同一257×513输入做20次热身、31批×100次事件计时。打印P50/P95为**每批事件区间除100后的分布**，不是单次kernel尾延迟。H2D/D2H、分配、CPU预处理不在计时中；默认流、同编译选项、不启用fast-math。分别以base/warp运行可避免采集到另一实现；交换运行顺序、固定功耗/温度状态，报告批间波动。分析器开销下的结果不能与正常事件数据混用。

源码逻辑流量基线约12×rows×cols字节、候选约8×rows×cols字节，仅是算法读写量，不是DRAM实测。`values[32]`的溢出可能增加流量；小rows启动受限、小cols空槽多时可能无收益。最终接受条件：全部精度用例通过，在部署shape分布上正常运行改善且P95无不可接受退化，ncu证据能解释原因。当前无GPU性能数字；CPU/GPU/NPU/端到端均不得互相替代。

## 实际运行结果

Mac Release与ASan/UBSan辅助检查：100例、6拒绝，max_abs=2.38419e-7，通过。最终原始日志见[verified-cpu.txt](results/verified-cpu.txt)、[verified-sanitize.txt](results/verified-sanitize.txt)。[Thor实际尝试](results/thor-attempt.txt)因nvcc缺失失败。手写PTX已提供；编译器PTX、SASS、GPU正确性、寄存器/occupancy、ncu和加速收益均未验证。[verification.json](verification.json)分别记录状态。

## 工程注意事项

输入/输出不别名，限制形状避免固定寄存器数组越界；扩大cols必须重新设计派发。FP32与gamma省略是教学合同，不可直接替换混合精度生产RMSNorm。CUDA每次API和launch错误检查，异步执行错误通过同步暴露，RAII析构记录清理错误；正常返回前所有工作已完成。候选保持`--fmad=false`便于公平数值比较，部署若改融合策略需重验精度与性能。源实现采用float4不代表这里未对齐的stride可安全照搬。

## 工业故障与面试追问

以下是可复现条件/排障假设，不是已发生的Thor生产事故。

| 触发→信号 | 根因与最小诊断 | 修复/取舍 |
| --- | --- | --- |
| cols=33时尾lane提前return→结果漂移或未定义行为 | 全mask引用未参与lane；检查每条shfl前的控制流 | 无效列填0，整warp参加；只允许整行warp退出 |
| cols=1024候选更慢→local事务/长scoreboard上升 | 缓存数组溢出或occupancy下降；ptxas寄存器/栈、ncu local和stall交叉验证 | 分档派发、减少缓存或保留基线，不能只看源码load少 |
| 小rows速度抖动→事件批均值/端到端趋势不同 | 主机提交间隙、频率或热状态；分开记录CPU与GPU时间 | 控制运行环境，后续再评估图提交，当前不推断GPU瓶颈 |

面试追问：①epsilon为何放在sqrt内？②full mask要求哪些lane参与？③shuffle为什么不能替代shared同步？④不同求和顺序如何制定容差？⑤寄存器缓存为何可能比重新加载慢？⑥如何区分launch、缓存命中与DRAM瓶颈？

## 自测问题

唯一无答案自测：若把输入扩展为 `[5,513]` 的非连续行视图，候选最后一个block只有一行有效，哪些线程可以提前退出、哪些必须填零参与，且你要用哪三项独立证据判断它既正确又比基线更适合实际部署？
