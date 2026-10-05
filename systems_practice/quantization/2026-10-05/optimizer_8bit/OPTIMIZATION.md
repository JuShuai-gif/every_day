# Thor SM110：分块状态编码热点的基线与最终候选

本文件研究**独立均匀signed8编码器**，目的是观察块归约/scale发布；不是bitsandbytes动态码本，不是Adam整体实现，不是低位Tensor Core。输入finite FP32[N]，分块256，输出int8[N]及FP32[ceil(N/256)]，q=clamp(round_even(x/scale),−127,127)，scale=absmax/127，零块q=0。测试输入避免未定义非有限转换；生产应在上游拒绝NaN/inf。

## 基线到候选

`codec_baseline`每线程为自己的输出扫描256元素；`codec_optimized`每线程加载一个值，shared tree用8轮max归约广播scale，再编码。256线程整CTA参与barrier，越界lane以0填充后参与，禁止tail提前return。末尾条件只保护最终输出。每个满块逻辑加载从256×256项降到256项，但缓存复用会使真实DRAM流量差距小很多；候选新增shared读写、9次barrier与寄存器活跃期。小N可能被启动开销和屏障吞噬，未实测不保证更快。

完整程序比较两变体q逐字节相同、scale对独立CPU最大值、反量化误差≤0.501scale+1e−6，覆盖0/1/255/256/257/4099与全零，输出先毒化−128。20次预热、101个单kernel CUDA-event样本，均值不代替P50/P95；排除分配/拷贝，计时不得冒充E2E。原生native.py另测同步step墙钟。

## 构建、运行、诊断与采集

在Thor课程目录：

```sh
nvcc --version
ptxas --version
ncu --version
cat /etc/nv_tegra_release
nvidia-smi
sh build.sh
./build/codec
compute-sanitizer --tool memcheck ./build/codec
compute-sanitizer --tool synccheck ./build/codec
sh profile.sh
sh export-isa.sh
```

记录JetPack/L4T、driver、CUDA、ncu、编译flags；查询失败如实保存，不能把没有计数器当0。build.sh固定SM110，程序拒绝其他capability。本机上述工具缺失，gpu/profile/isa日志exit127。

先`ncu --list-sections`与`ncu --query-metrics`，本机没有工具因此未声称某metric实际可用。选安装版本提供的SpeedOfLight、MemoryWorkloadAnalysis、LaunchStats、Occupancy、SchedulerStats、WarpStateStats、SourceCounters；profile.sh用full收集可用全集，若权限受限则记录并缩到支持section。按`regex:codec_(baseline|optimized)`筛选，`--profile-from-start off`仅捕获程序API范围，预热和边界测试在范围外，`--launch-count 1`每个独立报告采一个launch。

```sh
ncu --import build/codec-1.ncu-rep --page details
ncu --import build/codec-1.ncu-rep --page source
ncu-ui build/codec-1.ncu-rep
```

GUI Source页定位codec函数，关联CUDA行/PTX/SASS；`-lineinfo`已在构建开启。筛选同N/同variant/同block，不要混入测试或训练kernel。replay和cache控制会改变执行条件，最终收益以未附加profiler的event计时为准。[CLI依据](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)。

## ISA与热点证据怎样解释

当前唯一真实PTX源码是`encode`内`cvt.rni.s32.f32`，表示浮点到整数的nearest-even舍入；它是手写inline PTX，**未汇编/运行，不是生成SASS**。export-isa.sh把nvcc真实PTX、cuobjdump真实SASS/resource写到忽略build。获取后记录版本、sm_110和hash，再摘录结果到新日志，不创建伪造占位.sass。

潜在热点：基线256次load/max的循环与依赖链；候选shared归约的load→max→store→barrier；scale除法→整数转换→int8存储。看执行指令数是否下降、内存sector/缓存命中、shared/寄存器占用、active warps和barrier/scoreboard stall，才判断瓶颈转移。stall落在消费者指令不一定说明其本身最慢；延迟、吞吐、次数和等待是不同指标，不能给跨GPU“周期排行榜”。

## 架构对照：Thor固定，对照Ampere

上一GPU栏目对照Volta，本期转Ampere的异步拷贝特性。PTX文档cp.async（PTX7.0，sm_80及以上）给global→shared的4/8/16B复制、commit/wait语义，典型最低CUDA11系列；这是Ampere引入、后续沿用，非Thor专属。跨线程消费还需适当CTA同步，wait_group只约束该异步复制，不是所有内存操作的通用屏障。[具体ISA条件](https://docs.nvidia.com/cuda/parallel-thread-execution/#data-movement-and-conversion-instructions-cp-async)。

Thor的通用sm_110目标从PTX9.0/CUDA13基线核验，本例没有反复复用共享tile，直接每线程加载一次比人为加cp.async更易保持合同，所以不强行使用异步拷贝。Thor/Blackwell新增的块缩放与Tensor Core指令需要逐opcode核对dtype、布局和专属目标，不能从“Blackwell”推定通用sm_110可用；本课不发射这些指令，也不生成其他目标。支持特性不等于对状态编码有收益。

## 原生后端验收

先检查`bitsandbytes.__version__`、torch/CUDA运行时、已装库的真实sm_110 code object，再跑native.py训练、导出/恢复及dtype断言。当前CMakeLists下载失败，因此**没有提供未经核实的原仓库构建开关**；待获取源码后核实其后端选项和体系结构过滤，所有CUDA扩展必须限定CMAKE_CUDA_ARCHITECTURES=110或等价的sm_110。完整独立候选构建已交付，不能将其编译成功替代bnb兼容性验收。无设备的原生构建与性能仍是明确待补项。
