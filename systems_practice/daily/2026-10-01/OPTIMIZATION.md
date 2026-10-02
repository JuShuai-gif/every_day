# Thor SM110 分组GEMM：验证优化假设

基线`quant_baseline`每线程产生一个输出，直接读packed A/W；最终候选`quant_tiled`保持同一model与量化误差，在8×16 CTA里一次解码供行/列复用。32项group分两次16项载入。每tile只需128个A和256个W逻辑解码，基线128输出×16项需要4096次输入/权重逻辑解码；这是源码工作量模型，不是DRAM事务或加速比，编译器/Caches会改变实际成本。共享数组1536字节、128线程，实际register/occupancy待测。尾线程填零并参与两个barrier，不跨组整数累加。

## 现场兼容检查

```sh
nvcc --version
ptxas --version
ncu --version
nvidia-smi
cat /etc/nv_tegra_release
sh systems_practice/daily/2026-10-01/run.sh gpu --check
compute-sanitizer --tool memcheck systems_practice/daily/2026-10-01/build/gpu/quant_gpu --check
compute-sanitizer --tool racecheck systems_practice/daily/2026-10-01/build/gpu/quant_gpu --check
compute-sanitizer --tool synccheck systems_practice/daily/2026-10-01/build/gpu/quant_gpu --check
```

JetPack7.0/CUDA13.0是已核实参考基线；[官方JetPack7.0归档](https://developer.nvidia.com/embedded/jetpack/downloads/archive-7.0)列出对应组件版本。现场驱动版本及ncu设备支持须由工具实际确认，权限不足保留ERR_NVGPUCTRPERM，不自动更改系统设置。

## ncu从定位到源码

先不挂分析器运行默认20组对照，找实际耗时大的格式/方法。`--profile`只在20次预热之后开启cudaProfilerStart/Stop，范围里一个选定kernel。运行：

```sh
sh systems_practice/daily/2026-10-01/profile.sh W4A4 outlier baseline
sh systems_practice/daily/2026-10-01/profile.sh W4A4 outlier tiled
```

脚本先用`--list-sections`/`--query-metrics`保存本机支持项，再用demangled kernel正则与`--launch-count 1 --profile-from-start off`筛选。七组section中：SpeedOfLight/MemoryWorkloadAnalysis检验带宽与事务；LaunchStats/Occupancy检查register/shared/活跃warp；SchedulerStats/WarpStateStats检验发射与等待；SourceCounters定位动态指令。若某section不支持脚本明确退出，不把空报告当采集成功。细指标名从保存的metrics.txt选，不照搬其他GPU后缀。

用脚本输出的`ncu-ui .../report.ncu-rep`打开；选择同一template实例，进入Source页关联CUDA/PTX/SASS（`-lineinfo`已开）。对照packed字节load、bfe符号提取、shared load/store、barrier、组内整数MAC与跨组浮点转换。global事务下降但barrier/short scoreboard上升只支持“改变瓶颈”，不证明变快；long scoreboard的消费者不一定是根因。看寄存器活跃期和eligible warps，不以occupancy单指标决策。replay/cache控制改变条件，最终收益只用无profiler的相同热态计时。

## PTX/SASS与热点

```sh
sh systems_practice/daily/2026-10-01/export-isa.sh
```

脚本固定`nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx`，对相同构建产物执行`cuobjdump --dump-ptx/--dump-sass`并存源码/二进制SHA256、版本和配置，二进制及ncu报告留忽略的build/。如使用nvdisasm，先以`nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --cubin src/quant_gemm.cu -o build/gemm.cubin`生成本目标cubin，再`nvdisasm -g build/gemm.cubin > build/gemm.sass.txt`，工作目录本课。

本课源码中真实inline PTX为`bfe.s32`，长度4，偏移0或4，恢复INT4符号。它是手写虚拟ISA，不是已生成SASS。无nvcc所以本次没有PTX/SASS文本。待分析的热点是byte load→bit extraction→shared写→barrier→依赖MAC→scale恢复；SASS可能合并位操作或使用不同机器指令。指令周期、吞吐、依赖等待和执行次数要分开，不报告未经设备测量的周期数。

## 本轮架构对照：Thor与Turing

昨天比较Hopper，本轮换Turing（仅理论，不构建SM75）。依据[PTX target说明](https://docs.nvidia.com/cuda/parallel-thread-execution/#ptx-module-directives-target)与[dp4a条件](https://docs.nvidia.com/cuda/parallel-thread-execution/#integer-arithmetic-instructions-dp4a)。

| 特性 | 支持与约束 | 本课适用性 |
| --- | --- | --- |
| Turing SM75 sub-byte wmma、ldmatrix | PTX6.3引入相关SM75特性；warp协作、规定矩阵shape/layout和类型；不是任意标量INT4循环 | 不使用；packed逻辑布局不是MMA fragment，不能直接替换MAC |
| dp4a | PTX5.0、SM61+；每个32位寄存器装4个字节，INT32累加；从Pascal沿用，并非Turing/Thor独有 | 可将INT4解码成INT8后尝试，但不是原生INT4 Tensor Core；本课未启用 |
| Thor baseline SM110 | PTX9.0目标名，CUDA13.0基线；bfe/SIMT/CTA机制沿用 | 本课唯一目标，未启用架构后缀专属矩阵操作 |

本例选择SIMT是为了把group/尾部语义隔离，不能将本例计时作为低位Tensor Core吞吐。若今后接CUTLASS/native MMA，须重新核实Thor类型、shape、布局、编译目标和后端支持，保留现有oracle。

补充核查（实际2026-10-02，归档仍属本期）：[PTX tcgen05.mma.sp目标条件](https://docs.nvidia.com/cuda/parallel-thread-execution/#tcgen05-mma-sp)展示新一代Tensor Memory、异步发射及稀疏metadata机制。与Turing的warp协作wmma不同，它由单线程发射矩阵操作；INT8和部分低位块缩放形式列出的Thor目标是专属后缀sm_110a，部分形式为sm_110f，均不能从普通sm_110目标直接推定可用。本课不编写这些专属指令或切换目标。即使group也叫32，软件INT4分组scale并不自动等于硬件MX/NV格式。该差异解释了为何保留SIMT候选而不宣称原生低位Tensor Core加速。
