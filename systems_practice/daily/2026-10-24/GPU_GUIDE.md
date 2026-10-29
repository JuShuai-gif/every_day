# Thor SM110 定位、采集与指令证据

所有命令工作目录 `systems_practice/daily/2026-10-24/`，仅在Thor执行。先读 [Nsight Compute CLI](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)、[PTX ISA](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html) 与 [Turing tuning guide](https://docs.nvidia.com/cuda/turing-tuning-guide/index.html)。读取日期2026-10-25。Mac没有nvcc/ncu，下面是完整待执行流程，未生成假报告。

1. `sh run.sh thor` 先验100例，再记录正常事件批均值。记录 `/etc/nv_tegra_release`、`nvcc --version`、`ncu --version`、程序输出driver/runtime/设备名；保存板端功耗模式、温度/频率，不能把文档版本写成设备版本。
2. `ncu --list-sections`、`ncu --query-metrics` 核查安装版本可用section/metric；若某section不存在按该版本返回清单调整，原始错误保留。[profile.sh](profile.sh)先输出清单再采集；要求匹配工具支持Thor。权限错误如ERR_NVGPUCTRPERM应由设备管理员配置性能计数器权限，不改用其他SM。
3. 通过单variant命令和kernel名regex定位 `rms_base` / `rms_warp`。`--launch-skip 21`跳过该kernel的1次正确性+20次warmup，`--launch-count 1`采第1个计时批的第1次。要比较其他shape显式修改同一输入参数，两边一致；不要选到CPU参考或拷贝。先少量section，确认目标后再加详细计数器，避免全程序重放。
4. LaunchStats/Occupancy核对block、grid、registers；MemoryWorkloadAnalysis核对DRAM/L1/L2、local load/store；SchedulerStats/WarpStateStats看eligible warp、barrier/long scoreboard等等待。候选指标名可在query结果检索 `gpu__time_duration`、`launch__registers_per_thread`、`dram__bytes`、`long_scoreboard`、`local_op`，必须选安装版本确实存在的项，不能填预想值。
5. 在带图形界面的主机用 `ncu-ui build/profile/warp.ncu-rep` 打开报告，Source页关联本地 `src/rmsnorm.cu`；构建保留 `-lineinfo`，源码未匹配时设置source search路径。对比SourceCounters与SASS/源行：加载循环、归约、rsqrt、输出循环；缺采样或映射不等于这些行无成本。命令行可 `ncu --import build/profile/warp.ncu-rep --page details` 读取聚合报告。
6. `profile.sh`用同一编译选项导出PTX/cubin，cuobjdump及nvdisasm保留真实SASS与行号。报告需要匹配同一二进制与输入；修改代码后重新采集。普通事件计时与分析器重放计时分开归档。

## 已交付与待验证的ISA

[源码](src/rmsnorm.cu)中的真实手写PTX：

```ptx
shfl.sync.bfly.b32 %0, %1, %2, 31, 0xffffffff;
```

`%2`依次16/8/4/2/1，clamp31、membermask全32lane；每次sum加交换后的部分和形成五级依赖。它是PTX6.0引入、要求sm_30+的warp寄存器交换，Thor支持；本课CUDA13编译命令满足，但**本机尚未经过ptxas验证**。不是实际反汇编SASS，不填假SHFL机器指令或周期。

编译后重点核对（以下都是候选热点，不是测量结论）：平方累加的串行依赖；五级shuffle/add链；倒平方根与全行输出的依赖；基线shared load/store/barrier；候选寄存器数及local spill。`rsqrtf`最终指令和误差处理以实际SASS为准。要判断耗时需结合发射/等待采样与真实时间，不能把指令数量乘一个网上固定延迟当测量。缓存load少也可能被低occupancy抵消。

## 固定Thor，与Turing仅作原理比较

| 机制 | Thor SM110执行条件 | Turing SM75理论对照 | 本kernel适用性 |
| --- | --- | --- | --- |
| warp shuffle | CUDA13普通sm_110；32lane正确参与 | 支持shfl.sync，继承的warp交换能力 | 本例实际使用，无Tensor Core |
| `ldmatrix.sync.aligned.m8n8.x1.shared.b16` | PTX6.5基线形式要求sm_75+，Thor可继承；需shared地址、对齐和warp一致参与 | Turing矩阵load特色路径；供MMA消费，不是通用RMS归约 | FP32平方和不需要matrix tile，未使用 |
| 扩展ldmatrix形状/低位格式 | 新PTX形状有单独目标/特性要求；generic sm_110不自动获得a/f专属指令 | 不能把新形状倒推为Turing支持 | 不启用sm_110a/f，也不改执行目标 |
| 低位Tensor Core | Thor低精度能力还需对应数据格式、指令及库实现 | Turing有低位矩阵乘路径，格式/累加语义必须对应 | 本例无GEMM，不能把NF4解码或标量平方和称为原生低位TC性能 |

本轮对照Turing；上次Ada，下次Ampere。比较是理解指令适用条件，不生成其他SM执行命令。对LLVM/ARM的真实A64汇编另见ARM栏目，不得拿来充当Thor SASS。

## 研究访问边界

已实际读GitHub `norm.cu`、官方PTX/nvcc/ncu文档。Google直接搜索URL `https://www.google.com/search?q=CUDA+RMSNorm+warp+reduction+NF4+double+quantization` 本次工具未能打开；知乎原作者候选 `https://zhuanlan.zhihu.com/p/2050538577591902493` 仅获得搜索片段，直读403，未称读过全文。不采用其“一次HBM”之类未经本机测量的结论。
