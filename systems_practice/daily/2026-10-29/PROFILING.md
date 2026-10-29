# Thor SM110：从公平基准到ISA证据

本文件所有执行命令固定`sm_110`；Mac 无 `nvcc/ncu`，后续 Thor CUDA 编译/运行及真实 PTX/SASS 已完成，ncu 计数器权限仍受限。不能将手写PTX说成反汇编。先在Thor记录`cat /etc/nv_tegra_release`、`uname -a`、`nvcc --version`、`ncu --version`、`nvidia-smi`（若镜像提供），同时保存JetPack包信息和`cudaDeviceProp`。官方CUDA13中Thor由旧SM101命名迁为SM110，本课不使用旧编号构建。Jetson配套驱动须按实际镜像核查，不以桌面驱动号替代。

1. 先运行`run.sh`全部28个shape，两版同输入、位宽、scale、容限。目标GPU计算能力不是11.0就拒绝。不能只用一个大方阵覆盖小M。
2. `profile.sh`先列section和metric。确认安装版本具有`SpeedOfLight/MemoryWorkloadAnalysis/LaunchStats/SchedulerStats/SourceCounters`；不存在则保存报错并按查询结果选择同类section，不把不可用计数器写成零。
3. 无profiler运行报告50次单kernel CUDA event P50/P95；这是设备队列区间，包含该launch执行，剔除分配/H2D/CPU量化。事件单次测量的调度开销应对两版相同。E2E另以主机时钟包围在线量化、H2D、launch、D2H和同步，至少报告输入处理/设备/等待分段。
4. `--kernel-name regex:qgemm_tiled --launch-skip 10 --launch-count 1`定位预热后的同一fixture launch。报告放`build/`不提交。Thor官方ncu发布说明指出clock-control限制，所以使用`--clock-control none`并自行记录频率/温度；不隐式锁频。
5. `ncu-ui build/tiled.ncu-rep`打开Source页，选择qgemm_tiled，关联`src/gemm.cu`、PTX、SASS；编译使用`-lineinfo`。`cuobjdump --dump-sass`与`nvdisasm -g`是实际产物提取，脚本在 Thor 执行至 ncu 权限错误；PTX/SASS 文本已归档。必要文本与版本可复制入results，cubin和report留build。

|假设|需要的证据|反证与代价|
|---|---|---|
|重复字节解码/全局访问过多|MemoryWorkloadAnalysis的请求/sector及L1/L2流量，Source执行次数|缓存已复用时DRAM不下降；不能用源码load次数替代事务|
|wi读列bank冲突|shared相关冲突/过多wavefront指标，先查当前SM可用项|17列padding增加占用；不同映射不一定有收益|
|两次barrier占比高|Scheduler eligible/issued warps、barrier相关stall和源码行|小shape launch下限或无效线程也可解释停顿|
|寄存器/共享内存限制驻留|LaunchStats资源、Occupancy与active warps|occupancy提高不自动代表计算更快|

手写`bfe.s32`从byte提取4位并符号扩展；这是PTX虚拟ISA，编译器最终可以选择不同SASS序列。候选潜在热点为字节load→位提取→shared写→barrier→shared读→IMAD/浮点乘加→scale依赖链。这里的IMAD/浮点指令名是待核查类别，不是已生成的SASS。stall归因到消费者并不证明消费者本身慢，需追溯load命中率和依赖生产者。无周期数字或已证实的瓶颈结论。

架构原理对照：Turing SM75在CUDA10时引入整数Tensor Core路径，官方描述INT4矩阵fragment 8×8×32、INT32累加；后续架构也可具备低位矩阵能力，不能称INT4专属Turing。Thor SM110默认目标要求CUDA13+；本课普通SIMT与shared/bfe不依赖a/f后缀。Turing fragment布局/warp共同参与要求不能直接套到任意packed flat数组；Thor具体原生低位TC后端必须单独审计CUTLASS/库版本和目标后缀，今日没有启用或证明。此处比较能力与合同，不提供另一目标构建命令。

依据：[Turing官方指南](https://docs.nvidia.com/cuda/archive/11.8.0/turing-tuning-guide/index.html)、[CUDA13 nvcc](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-compiler-driver-nvcc/index.html)、[Nsight Compute发布说明](https://docs.nvidia.com/nsight-compute/ReleaseNotes/)、[Thor安装指南](https://docs.nvidia.com/jetson/agx-thor-devkit/user-guide/latest/setup_cuda.html)。replay/cache控制会改变运行条件，最终收益由脱离profiler的同口径基准决定。


## 2026-10-29 实机补充

Thor CUDA 13.0 已生成 sm_110 PTX/SASS；普通主机和 Docker ncu 都返回 `ERR_NVGPUCTRPERM`，没有计数器报告。[实测总览](../../validation/2026-10-29-thor/README.md)。
