# 2026-10-25 CUDA Kernel：Thor RMSNorm 的 warp 归约与寄存器寿命

## 工业场景

机器人视觉编码器输出的短行特征需要 RMS 归一化，随后送入动作头。本课只负责 `Y[r,c]=X[r,c]/sqrt(mean(X[r,:]^2)+epsilon)`，不含可学习 gamma；输入 FP32，行数1–4096、列数1–1024，输入stride可大于列数，输出连续。代表形状257×513，刻意覆盖不完整CTA与非32倍数列。工程约束是禁止读到行padding、零行有限输出、输出误差有界，并在Thor上用实测决定是否采用候选。无完整机器人模型、任务精度或截止时延保证。

今天独立建档，复用10月24日未完成草稿的代码起点并重新阅读源码、测试；未覆盖草稿，也未倒填昨日交付。

## 概念回顾

RMSNorm先对每行平方求和，再用均方加稳定项的平方根倒数缩放原始输入。这里不减均值，也不含可学习增益，因此不能把它直接当成完整层归一化。基线让一个线程块负责一行，线程分段累加到共享内存，通过树形归约和线程块屏障发布总和，最后重新读取输入写出结果。它容易解释和检查，但每轮屏障与第二次加载都可能增加短行的固定开销；这些只是待测假设，缓存命中可能已经降低重读成本。

优化候选把一行交给一个完整线程束，每个线程保存间隔三十二个元素的输入，在寄存器中累计平方和。五次蝶形交换把局部和传播给所有参与线程，再直接使用保存的值写出结果。列尾不足时必须填零，不能让某些线程提前退出后仍要求完整掩码交换；行数不足时则允许整个线程束一起退出。寄存器交换的同步只覆盖参与线程的该次操作，不是任意共享内存通信的通用屏障。

归约拓扑与资源寿命紧密耦合。缓存输入把第二次全局加载换成每线程最多三十二个浮点值的活跃期，可能提高寄存器用量、减少驻留线程束，甚至发生局部内存溢出。小行还可能为固定展开支付额外指令。因此去掉共享内存不等于更快，必须比较相同形状、数据、数学定义、误差阈值与计时范围。浮点加法不满足结合律，双精度参考用于检查数值，不能要求两种归约逐位相同。本机模型只检查索引和求和拓扑，线程束同步、编译器分配和设备收益仍要由目标设备证明。

## 知识图谱

```text
工业输入合同(rows/cols/stride/有限范围)
  → 一CTA一行(shared发布+barrier) → FP64独立oracle
  → 一warp一行(尾部零值+完整mask)
      → shfl.sync寄存器交换 → 输入缓存活跃期
      → registers/spill/occupancy → ncu与未附加profiler的事件计时
```

前置：warp为32线程；同一行只被一个warp处理；FP32输入绝对值≤128；epsilon在[1e-8,1]。不能混淆 RMS 与 LayerNorm、warp与CTA、PTX与SASS、批均值P95与单请求尾延迟。

## 编码练习

唯一25分钟任务：在已写好的 `rms_warp` 中观察 `values[32]` 与完整掩码，尝试将固定展开改为按cols选择更短的编译期容量（保留基线与当前候选），复用现有100个用例，记录寄存器和同shape事件时间。5分钟阅读合同，10分钟改一个容量分派，5分钟边界检查，5分钟Thor采集或记录工具缺口。Mac可运行辅助检查，GPU部分仍是必备目标材料。

默认运行两版；`rms_warp` 是最终交付的优化候选，尚不作为生产默认。基线每行128线程、512B shared、一次发布加七轮barrier；候选四warp/CTA、五次shuffle，无shared归约。候选逻辑输入读取一遍，基线两遍；不能将逻辑读取量当作DRAM流量。

源码研究先于今日实现整理：[NVIDIA/apex](https://github.com/NVIDIA/apex)，master，读取2026-10-25；具体 [layer_norm_cuda_kernel.cu](https://github.com/NVIDIA/apex/blob/master/csrc/layer_norm_cuda_kernel.cu) 的 `cuRMSOnlineSum`、`cuChanRMSOnlineSum`、`cuWelfordMuSigma2` 的RMS分支、`cuApplyLayerNorm_`、`cuApplyRMSNorm`。原项目为PyTorch混合精度训练/推理，包含跨warp归约、gamma和反向。此处是受启发的独立C++17前向实现，只保留平方和/尺度与参与线程合同，增加stride、独立oracle，省略autograd、多dtype和仿射。BSD三条款许可证已读；无整段源码复制。分支读取日期可追溯但不等于固定commit，见[source.json](source.json)。

## 文件说明

[src/rmsnorm.cu](src/rmsnorm.cu) GPU两版与RAII驱动；[src/reference.hpp](src/reference.hpp) 合同/FP64参考/CPU拓扑；[src/cpu_check.cpp](src/cpu_check.cpp) 边界；[build.sh](build.sh)、[run.sh](run.sh)、[profile.sh](profile.sh)、[export-isa.sh](export-isa.sh)。

现成附加栏目：[NF4双重量化状态](../../quantization/2026-10-25/nf4_qlora/README.md) · [ARM项目01：pack4的归约轴](../../arm/2026-10-25/README.md) · [OS24：异步租约](../../os/2026-10-25/README.md) · [C++17第23课：共享锁与快照寿命](../../cpp17/2026-10-25/README.md) · [P2P与SPHQuant两篇论文](../../paper/2026-10-25/README.md)。它们不增加必做编码题。

## 编译与运行

在仓库根目录执行：

```sh
sh systems_practice/daily/2026-10-25/run.sh cpu
sh systems_practice/daily/2026-10-25/run.sh sanitize
# 以下只在Jetson Thor执行，构建固定-arch=sm_110
sh systems_practice/daily/2026-10-25/run.sh thor
cd systems_practice/daily/2026-10-25
compute-sanitizer --tool memcheck ./build/rmsnorm
compute-sanitizer --tool synccheck ./build/rmsnorm
compute-sanitizer --tool racecheck ./build/rmsnorm
./build/rmsnorm 257 513 both
sh profile.sh
sh export-isa.sh
```

本机Apple clang21/C++17可编CPU。NVIDIA [CUDA13 nvcc目标表](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-compiler-driver-nvcc/index.html)列出普通sm_110；当前[JetPack下载说明](https://developer.nvidia.com/embedded/jetpack/downloads)列出7.2.1/L4T39.2.1/CUDA13.2.2。它是文档兼容参考，不是用户实板版本。部署前记录 `/etc/nv_tegra_release`、`nvcc --version`、`ncu --version`、程序打印的CC/driver/runtime；驱动与ncu实板组合未核验。禁止换成其他SM或专属后缀。

## 正确性验证

CPU的100组合覆盖rows=1/3/4/5/17、cols=1/3/31/32/33/127/128/129/513/1024、全零/确定性混合符号，stride=cols+3填999哨兵；6次拒绝覆盖零行、超长列、坏stride、零epsilon、NaN、越界数值。误差规则 `abs<=3e-5+3e-5*abs(ref)`。GPU驱动对两版同样逐元素核验，并检查每次launch和同步。设备和事件RAII禁止复制，清理失败也报告。CPU不模拟并发，不能据此判定GPU无race。

## 性能分析

事件区间只有同stream内100次kernel，20次预热后31个批均值，P50索引15/P95索引29；不含分配、H2D、D2H和CPU排队。生产E2E必须另量采集至控制输出，不能使用本课事件时间代替。至少扫rows=1/17/257、cols=33/513/1024；交替运行base/warp顺序，固定功耗/温度状态，重复独立进程后决定保留或回退。

[PROFILING.md](PROFILING.md)提供可操作的定位→筛选→采集→源码关联教程、ISA热点和Thor/Turing理论对照。没有ncu结果，当前所有瓶颈和收益均为假设。

## 实际运行结果

本机Release与ASan/UBSan：100组合、6拒绝通过，最大绝对误差2.38419e-7。原始结果在[results/cpu-initial.txt](results/cpu-initial.txt)及[results/sanitize-initial.txt](results/sanitize-initial.txt)，格式化后的复验另存。真实Thor构建失败为 `nvcc: command not found`，见[results/thor-initial.txt](results/thor-initial.txt)。GPU编译/执行/性能、PTX/SASS、ncu均未验证；没有生成或编造SASS，没有GPU/NPU/E2E性能数字。[完整状态](verification.json)。

## 工程注意事项

epsilon改变数学合同，应同时传给参考和两版kernel；当前运行固定1e-5。有限输入检查位于宿主，未来接模型设备张量时需入口合同或独立检查。stride不是cols，不能对未证实对齐的数据强转float4。较长行超出1024会被拒绝，不能静默截断。最后不足四行由整warp退出，不绕过本warp的部分参与者。代码中手写PTX是实际候选源码，只有nvcc成功后才能称为已编译指令。

## 工业故障与面试追问

1. cols=33才错→部分lane提前return或读padding→对照31/32/33、跑synccheck与memcheck→尾部填零且完整warp参与；代价是无效lane仍执行归约。
2. 数值正确却更慢→寄存器活跃期增加、spill或小行展开成本→ptxas/LaunchStats加local流量与非profiler时间→缩短容量或回退基线；不能仅凭occupancy下降认定根因。
3. 热运行P95漂移→功耗/时钟、其他进程或重放缓存差异→记录tegrastats、隔离进程、无profiler复验→在部署预算内选kernel，而非固定一个微基准赢家。这些为诊断案例，非实板已观测故障。

追问：①RMSNorm为何不减均值？②完整mask与列尾如何同时成立？③shuffle为何不能替代任意内存栅栏？④寄存器缓存为何可能产生local流量？⑤怎样区分依赖等待与访存事务不足？⑥如何证明更换归约树没有改变误差合同？

## 自测问题

同一候选在rows=1、cols=33时慢于基线，在rows=257、cols=513时快于基线，而且两者都没有spill；你会采集哪些相互区分的证据，决定按shape分派还是保留统一实现？
