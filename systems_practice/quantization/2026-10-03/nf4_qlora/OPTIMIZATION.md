# NF4 SIMT GEMV：Thor SM110限定

本文件所有命令从本课目录运行；`build-gpu.sh`使用CUDA13+编译，程序拒绝非CC11.0设备。这里只比较同一自定义packed布局的两种映射：`nf4_scalar`每thread一输出、串行K；`nf4_warp`每warp一输出，合并K方向读取和缩短单lane累加链，最后5步shuffle。N=33/K=130含输出warp尾部、K尾部及零scale。FP64 host oracle容限1e-4；两个kernel同输入/码本/FP32积累，20次预热100次CUDA-event采样。最终候选未编译，无收益承诺。N很小时多CTA调度、shuffle、重复码本/scale加载可能使候选更慢。

```sh
sh build-gpu.sh
build/nf4 0
build/nf4 1
ncu --version
ncu --list-sections > build/sections.txt
ncu --query-metrics > build/metrics.txt
ncu --kernel-name-base function --kernel-name nf4_scalar --launch-skip 21 --launch-count 1 \
 --section LaunchStats --section Occupancy --section MemoryWorkloadAnalysis \
 --section SchedulerStats --section WarpStateStats --section SourceCounters \
 --import-source yes -o build/nf4-scalar build/nf4 0
ncu --kernel-name-base function --kernel-name nf4_warp --launch-skip 21 --launch-count 1 \
 --section LaunchStats --section Occupancy --section MemoryWorkloadAnalysis \
 --section SchedulerStats --section WarpStateStats --section SourceCounters \
 --import-source yes -o build/nf4-warp build/nf4 1
ncu --import build/nf4-warp.ncu-rep --page source > build/nf4-source.txt
ncu-ui build/nf4-warp.ncu-rep
mkdir -p build/isa
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/nf4.cu -o build/isa/nf4 2> build/isa/ptxas.txt
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx src/nf4.cu -o build/isa/nf4.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --cubin src/nf4.cu -o build/isa/nf4.cubin
cuobjdump --dump-sass build/isa/nf4 > build/isa/nf4.sass
nvdisasm -g build/isa/nf4.cubin > build/isa/nf4.lines.sass
```

先确认section可用再采集，skip21来自1次正确性+20次预热。指标不支持或计数器无权限保存原错误，不填零。阅读ncu Source视图：定位weight的byte load→shift/mask→码本索引load→scale乘法→FMA数据依赖；优化后关注shuffle→add和长scoreboard。用sectors/request检查映射，不把逻辑字节数当DRAM流量；用LaunchStats核实寄存器/local spill，不能预言编译器一定生成BFE/LOP3。热点及周期排名均待真实SASS和采样，本次没有生成PTX/SASS文件。

原始权重FP32理论17160B，自定义码2145B+scale396B+共享码本64B=2605B；这是本例设计字节数，不是运行实测，也不包含输入/输出、分配器、框架状态或训练适配器。kernel事件时间排除上传/分配/导出，不代表模型或端到端推理。原生Python例子输出的decode+dense是另一种计时边界，禁止混排比较。

[主课教程](../../../daily/2026-10-03/OPTIMIZATION.md)给出完整定位和对照。本期轮换对照Hopper：SM90的TMA/cluster需要对齐描述符、mbarrier或cluster同步等合同，小型一次性解码GEMV没有充分共享复用，因此不为“更新指令”强加TMA。shfl.sync为PTX6.0通用同步shuffle，Thor仍可用。Hopper与Thor均不把NF4码本编号直接等同有符号INT4矩阵乘操作数；本课只有SIMT FMA，未使用mma/tcgen05，没有低位Tensor Core性能结论。对照架构不执行，所有命令只生成sm_110。
