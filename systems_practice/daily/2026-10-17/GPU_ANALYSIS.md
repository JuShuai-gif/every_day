# Thor SM110：定位、采集、指令关联

## 先核实工具链

2026-10-17实际读[CUDA13 nvcc目标表](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-compiler-driver-nvcc/index.html)、[PTX9.0目标及指令条目](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html)。CUDA13开始使用Thor `sm_110`命名；本课只生成baseline `sm_110`。不能从编译器支持推出已安装板端驱动兼容。JetPack下载页本次网页读取Internal Error，未据此宣称最新SDK组合。

在Thor上工作目录 `systems_practice/daily/2026-10-17`：

```sh
uname -a
cat /etc/nv_tegra_release
cat /etc/os-release
dpkg-query -W nvidia-jetpack nvidia-l4t-core
mkdir -p build
nvcc --version
nvcc --list-gpu-code
ncu --version
ncu --list-sections
ncu --query-metrics > build/available-metrics.txt
sh build.sh gpu
./build/energy 4096 4097
compute-sanitizer --tool memcheck ./build/energy 5 129
compute-sanitizer --tool synccheck ./build/energy 5 33
```

先 `mkdir -p build` 再重定向metric文件。记录runtime/driver、板型、温度/频率/功耗模式。JetPack包未安装/命令失败保留原始错误，不等于设备不存在。ncu版本必须明确支持Thor；[release notes](https://docs.nvidia.com/nsight-compute/ReleaseNotes/index.html)列出GB10b的clock-control限制，因此下面明确不请求锁频。

## 从瓶颈假设到采集

1. 先独立跑benchmark，定位长行是否慢；同shape同容限。
2. 查询section/metric后，再使用本机实际列出的section。下列常见名称若缺失，应记录并按查询结果选择等价项，不静默删掉分析目标。
3. 按模板kernel名及launch过滤。每次只运行一个版本，前10次匹配launch是预热。

```sh
ncu --kernel-name-base demangled --kernel-name 'regex:row_energy<1>' --launch-skip 10 --launch-count 1 --clock-control none --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats --section MemoryWorkloadAnalysis --section SpeedOfLight --section SourceCounters --export build/u1 ./build/energy 4096 4097 1
ncu --kernel-name-base demangled --kernel-name 'regex:row_energy<4>' --launch-skip 10 --launch-count 1 --clock-control none --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats --section MemoryWorkloadAnalysis --section SpeedOfLight --section SourceCounters --export build/u4 ./build/energy 4096 4097 4
ncu --import build/u4.ncu-rep --page details > build/u4-details.txt
ncu-ui build/u4.ncu-rep
```

若demangler名称带空格，以实际 `ncu --set basic ./build/energy 5 33 4`输出为准调整regex；不要误采零个launch。权限错误ERR_NVGPUCTRPERM交由板端管理员配置，保留错误；不能用空指标当0。replay、cache控制和计数器采集会扰动运行，速度只引用未挂ncu的数据。

| 观察 | 支持的假设 | 下一步 |
| --- | --- | --- |
| eligible warps少、依赖stall高，DRAM未饱和 | 串行FMA链可能限制 | 比U4能否降低stall并缩短event时间 |
| registers/local显著增加、active warps下降 | 活跃值或spill代价 | 查看SASS local load/store及资源限制 |
| DRAM/L2吞吐高且两版事务近似 | 带宽更可能主导 | U4不减少字节，接受无收益 |
| sectors/request恶化 | stride/地址或尾部混杂 | 核对同输入与实际有效通道 |

关注查询中可用的DRAM/L2字节和吞吐、global load sectors、launch registers/shared、active/eligible warp及long/short scoreboard等项。具体名字由版本查询确定；stall分类不是单指令周期计时，停顿常显示在等待加载结果的消费者上。

## 导出真实PTX/SASS与源码关联

```sh
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx src/energy.cu -o build/energy-sm110.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -cubin -Xptxas=-v src/energy.cu -o build/energy-sm110.cubin
cuobjdump --dump-sass build/energy-sm110.cubin > build/energy-sm110.sass.txt
nvdisasm -g build/energy-sm110.cubin > build/energy-sm110.lines.txt
```

编译参数与版本随文本保存；在ncu Source页设置源码搜索目录到本课src，选择C++/PTX/SASS，定位模板U1/U4的局部FMA及shuffle。只有实际生成后才能记录指令地址和源码行对应。

已交付手写inline PTX `shfl.sync.bfly.b32`，含全warp mask；不是生成的SASS。它交换FP32的位模式，五轮XOR蝶形后每lane都有行和，只由lane0写出。潜在热点为全局加载后的依赖、每acc FMA链、最终加法链、shuffle交换；没有目标测量不能给周期。编译器也可能改变调度或合并临时值，必须看真实SASS。

## 本次架构对照：Thor与Hopper

依据[Hopper tuning guide](https://docs.nvidia.com/cuda/archive/13.0.0/hopper-tuning-guide/index.html)与PTX9.0的 `setmaxnreg` Target ISA Notes：

| 机制 | Hopper对照，仅理论 | Thor本课固定目标 | 本kernel是否采用 |
| --- | --- | --- | --- |
| shuffle.sync | 沿用PTX6.0的warp交换，并非Hopper独有 | sm_110普通目标可用，CUDA13/PTX9 | 是 |
| TMA/cluster | Hopper新增异步张量搬运及cluster层级，需布局和完成同步 | 不把H100容量/cluster上限外推Thor | 否，单次读取行归约没有共享复用 |
| setmaxnreg | PTX8.0引入，所读表列sm_90a；warpgroup一致执行，增额可能等待 | 所读表列Thor的a/f专属支持，不属于本课普通sm_110承诺 | 否；维持固定目标，通过静态U控制寄存器活跃值 |

CUDA13满足本课目标名要求；Hopper专属指令的历史最低PTX8.0不等于可改用旧工具链编译Thor。本表没有其他架构构建命令，没有修改为a/f后缀。下一次理论对照按轮换进入Ada。
