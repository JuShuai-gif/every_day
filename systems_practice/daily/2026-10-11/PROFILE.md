# Thor SM110：定位、采集、源码与ISA

本文件所有执行目标为Thor SM110，其他架构只理论比较。没有nvcc/ncu/设备，以下均是待执行命令，不是实测报告。

## 先核对工具与系统

在本课目录，先运行 `run.sh thor` 完成正确性，再保留以下文本：

```sh
cat /etc/nv_tegra_release
uname -a
nvcc --version
nvcc --list-gpu-code
ncu --version
ncu --list-sections
ncu --query-metrics --query-metrics-mode all
```

采用JetPack支持的CUDA13/TRT10.13组合。[Nsight release notes](https://docs.nvidia.com/nsight-compute/ReleaseNotes/)记载2025.3支持CUDA13，且Thor SBSA的clock-control有限制；用 `--clock-control none`，另记录功耗/频率/热状态。具体ncu build、计数器权限与设备驱动兼容性由这些输出确认，本机没有可核实安装。

## 从名称到特定启动

```sh
ncu --clock-control none --set basic --launch-count 6 ./build/thor/kernels 8 4097
# --launch-skip按匹配kernel计数：跳过1次正确性和20次预热。
ncu --clock-control none --kernel-name 'regex:affine_relu_fused' \
  --launch-skip 21 --launch-count 1 --section SpeedOfLight \
  --section MemoryWorkloadAnalysis --section LaunchStats \
  --section Occupancy --section SchedulerStats --section WarpStateStats \
  --import-source yes -o build/fused ./build/thor/kernels 8 4097
ncu --clock-control none --kernel-name 'regex:affine_baseline' \
  --launch-skip 21 --launch-count 1 --set full \
  --import-source yes -o build/affine ./build/thor/kernels 8 4097
ncu --clock-control none --kernel-name 'regex:relu_baseline' \
  --launch-skip 21 --launch-count 1 --set full \
  --import-source yes -o build/relu ./build/thor/kernels 8 4097
ncu --import build/fused.ncu-rep --page source
ncu-ui build/fused.ncu-rep
```

先确认section列表有这些名称，不可用则记录安装版本并替换为其列出的等价section。用query-metrics查 `dram__bytes`、`l1tex__t_sectors`、`launch__registers_per_thread`、`smsp__warp_issue_stalled` 家族，再选可用全名添加 `--metrics`，不要把缺失指标填0。基线两个报告各解释一次启动，不能把融合耗时与仅relu半条链比较。

| 假设 | 要看什么 | 不支持假设时如何退回 |
| --- | --- | --- |
| 中间写回昂贵 | 两基线总逻辑16N vs融合8N；DRAM/L2字节、load/store sectors | 缓存命中/启动主导时不能按带宽倍率推收益 |
| float4减少访存指令 | SASS load/store宽度、事务/有效字节 | 编译器可能标量化；确认对齐与寄存器增加 |
| 小shape并行度不足 | active warps、waves、eligible warps、寄存器数 | 小shape用标量/更细粒度候选，重测 |
| load依赖等待 | source view的消费者与long-scoreboard等可用stall | 停顿处不一定是根因；回溯producing load/cache |

`-lineinfo`把源码行映射到机器指令；在GUI Source页并排选择CUDA、PTX、SASS，定位 `activate` 与float4读写。TRT内部kernel没有开源SASS来源映射保证，单独 `ncu --set basic ./build/thor/trt` 定位真实名称，不能套用本课kernel名称。replay/cache控制会改变环境，收益以不挂profiler的同口径event测试为准。

## 生成真实PTX/SASS

```sh
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx src/kernels.cu -o build/kernels.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --cubin src/kernels.cu -o build/kernels.cubin
cuobjdump --dump-sass build/kernels.cubin > results/thor-sass.txt
nvdisasm -g build/kernels.cubin > results/thor-disassembly.txt
cp build/kernels.ptx results/thor-ptx.txt
```

保留nvcc/ptxas版本和参数。源码中的 `max.f32` 是手写PTX且待编译；没有SASS文本时不造指令序列。潜在热点是global load→仿射→max→store依赖；当前没有shared/barrier，也没有Tensor Core。实际FMA合并、128位访问与寄存器压力要由SASS确认；指令延迟、吞吐、执行次数与等待是不同量，没有目标实测不能写周期排行榜。

## 本次轮换：Thor SM110对照Hopper

上次GPU课理论对照Ampere，本次换Hopper。Thor裸 `sm_110` 的编译目标在PTX ISA9.0加入，采用CUDA13工具链；不能自动启用a/f专属指令。[PTX ISA](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html)有不同目标的支持条件，产品叫Blackwell不代表所有Blackwell数据中心指令均可直接用。

Hopper SM90引入TMA bulk/tensor异步搬运与cluster/异步屏障配合，适合大tile复用；CUDA12/PTX8.0时代引入。Hopper的warpgroup MMA要按具体变体核实 `sm_90a`、dtype、descriptor与同步约束，不能把普通SM90或Thor裸110等同于支持该架构专属形式。[Hopper tuning guide](https://docs.nvidia.com/cuda/hopper-tuning-guide/index.html)。本课是一次读写的逐元素操作，没有shared重用，未使用TMA/WGMMA；强行分块会新增搬运和屏障。两架构都有普通浮点max/全局访存，不能称为Thor新指令。本课不生成任何Hopper二进制。
