# Thor SM110：工具链、ncu与ISA证据

读取日2026-10-13。所有执行/编译命令固定普通sm_110，不启用a/f后缀。

## 先建立兼容证据

[官方Thor CUDA setup](https://docs.nvidia.com/jetson/agx-thor-devkit/user-guide/latest/setup_cuda.html)实际展示CUDA Driver/Runtime 13.0、Compute Capability 11.0；[PTX9.0 target](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html#performance-tuning-directives-target)区分sm_110基线与a/f特性。以CUDA13.x且`nvcc --list-gpu-code`有sm_110为前提。JetPack7.0两个旧直链和ncu2025.3发布页本次访问Internal Error，不能声称已核实某个JetPack/L4T/驱动/ncu完整组合；使用设备已配套的官方SDK并收集下列输出，未核验之前不部署。

```sh
# Thor，工作目录为本课；本任务没有运行这些命令
mkdir -p build
cat /etc/os-release
cat /etc/nv_tegra_release
uname -a
nvidia-smi
nvcc --version
nvcc --list-gpu-code
ncu --version
ncu --list-sections > build/ncu-sections.txt
ncu --query-metrics > build/ncu-metrics.txt
sh build.sh thor
build/gemm
compute-sanitizer --tool memcheck build/gemm
compute-sanitizer --tool racecheck build/gemm
```

设备程序也会拒绝非11.0能力；这不是对整套SDK兼容性的替代。若计数器权限不足，保存ERR_NVGPUCTRPERM，按设备管理员流程配置，不把无计数器报告当采集成功。

## 定位、筛选、采集、关联

先运行`build/gemm --bench 33 65 129`及`128 128 256`，保存无profiler的两个版本P50/P95。名称筛选用demangled kernel名称。单版本入口先1次正确性启动、20次预热，再100次采样，所以跳过21次匹配启动后采3次。`--launch-skip`与筛选语义应以本机ncu帮助确认；若版本不同，先只采1次检查LaunchStats的grid/block和名称。

```sh
ncu --kernel-name-base demangled --kernel-name 'regex:gemm_async' --launch-skip 21 --launch-count 3 --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats --export build/async --force-overwrite build/gemm --bench 33 65 129 async
ncu --kernel-name-base demangled --kernel-name 'regex:gemm_baseline' --launch-skip 21 --launch-count 3 --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats --export build/baseline --force-overwrite build/gemm --bench 33 65 129 baseline
ncu --import build/async.ncu-rep --page details
ncu-ui build/async.ncu-rep
```

section名先查存在再选；不能假定每个metric跨版本稳定。MemoryWorkloadAnalysis回答global事务/合并、shared冲突与L1/L2行为；LaunchStats/Occupancy回答寄存器数、每CTA 2048B shared与驻留约束；SchedulerStats/WarpStateStats回答可发射warp不足还是barrier/long-scoreboard等待。SpeedOfLight检视SM/内存吞吐，不能从“小shape低利用率”直接认定带宽瓶颈。

GUI Source页加载src/gemm.cu（编译已带-lineinfo），并排CUDA/PTX/SASS定位copy16、两个屏障与FMA。先比较每输出的访存/指令，再看stall及其前驱；replay、cache flush、采样开销会改变状态，最终速度结论只来自无profiler的事件基准。统一功耗/时钟/温度/竞争进程条件；报告热缓存，冷启动另测。

## 真实ISA生成命令与潜在热点

```sh
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx src/gemm.cu -o build/gemm-sm110.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -cubin src/gemm.cu -o build/gemm-sm110.cubin
cuobjdump --dump-sass build/gemm > build/gemm-sm110.sass.txt
nvdisasm -g build/gemm-sm110.cubin > build/gemm-sm110.lines.sass.txt
```

本次只交付代码里真实手写inline PTX；未生成PTX文件、未生成SASS，不提供虚构指令周期。现场应记录nvcc/ptxas版本、编译命令与真实文本SHA。检查PTX `.target sm_110`，SASS来自同一构建。

`cp.async`是潜在加载热点；源数据cache miss会让wait等待，不能把wait采样权重解释成其固有高延迟。两个CTA barrier可能等待最慢生产者/消费者。每输出16次FMA依赖同一累加器，有相关性限制；shared读的bank事务受线程映射影响。反汇编确认真实寄存器/加载/FMA/屏障后，用相关计数器判断频次与依赖，不能凭PTX指令名字排名耗时。

## 架构对照：Thor与Ada

| 范围 | Thor SM110（唯一执行目标） | Ada SM89（仅原理） |
| --- | --- | --- |
| 本课async机制 | 普通cp.async，16B对齐，提交/等待/CTA同步 | 沿用Ampere的cp.async，并非Ada新发明 |
| 工具链 | CUDA13/PTX9的sm_110命名，现场确认 | Ada原生目标由CUDA11.8引入，本课不生成其产物 |
| dtype/计算 | 本课FP32 FMA；不承诺专属Tensor Core路径 | 第四代Tensor Core新增FP8能力；普通FP32 FMA不能借此声称FP8加速 |
| 本课不用的能力 | a/f专属矩阵指令必须另查目标表，当前合同禁止启用 | FP8需要scale/布局/矩阵指令和误差验收，本课不更改FP32语义 |

[PTX cp.async官方语义](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html#data-movement-and-conversion-instructions-cp-async)与[Ada兼容指南](https://docs.nvidia.com/cuda/ada-compatibility-guide/index.html)为一手入口。cp.async在PTX7.0加入、要求SM80或更高；这里是沿用特性。本文没有把Blackwell桌面/数据中心的支持矩阵推到Thor。
