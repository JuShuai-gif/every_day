# Thor SM110：从定位到源行的采集路线

所有可执行命令都针对已由程序检查的Thor SM110。对照架构本次轮换到Ampere，只作机制比较，不构建或运行其他架构。

## 先确定对象与公平基线

`transpose_naive`连续读取、跨行写回；`transpose_tile<0>`共享分块让两端global连续，但shared列读取落入相同bank；`transpose_tile<1>`只改变共享行pitch。程序mode0/1/2各跑同一1024×2048、ldi2051/ldo1027。固定输入、线程数、预热、设备与功耗模式；按mode轮换重复独立运行，保存温度、频率、版本。当前顺序可能受热状态影响，不能据单轮宣称收益。先核对正确性，再采集；ncu重放影响耗时，正式延迟用未被profile的event程序。

## ncu定位、筛选与采集

```sh
cd systems_practice/daily/2026-10-02/session-02
sh run.sh gpu
ncu --version
ncu --list-sections
ncu --query-metrics > build/metrics.txt
# 定位所有匹配kernel，先确认demangled名称和launch顺序
ncu --kernel-name-base demangled --kernel-name 'regex:transpose_.*' --launch-count 3 build/gpu/transpose 2
# 正式profile.sh每mode跳过1次正确性+10次预热，只收首个计时launch
sh profile.sh
ncu --import build/reports/mode-2.ncu-rep --page details
ncu --import build/reports/mode-2.ncu-rep --page source --print-source cuda,sass
```

如果本机ncu版本不接受某输出选项，先`ncu --help`核对，再用GUI打开同一报告的Source页；报告中必须同时核对kernel名、模板参数与grid/block。优先观察SpeedOfLight、MemoryWorkloadAnalysis、LaunchStats、Occupancy与SourceCounters（名称以list-sections为准）。metrics搜索`bank_conflicts`、`wavefronts`、`sectors`、`long_scoreboard`、`short_scoreboard`、`barrier`，只有query确实列出后再传`--metrics`，不硬套别的GPU指标。需要sudo修改计数器权限时由设备管理员处理，本脚本不改系统权限。

| 对照 | 需要同时看到的证据 | 不能作出的推断 |
| --- | --- | --- |
| naive→tile0 | global store事务/sector效率改变；时间变化 | shared快所以所有shape更快 |
| tile0→tile1 | shared冲突/额外wavefront下降；相同有效元素；时间变化 | 地址模32计算就是实测32倍加速 |
| stride对齐→+3 | 行首对齐改变、sector变化 | 所有下降均来自shared |

## PTX、SASS与候选热点

```sh
sh export-isa.sh
# 查看实际产物；本Mac未生成这些文件
rg -n 'ld.global|st.global|ld.shared|st.shared|bar.sync' build/isa/transpose.ptx
rg -n 'LDG|STG|LDS|STS|BAR|IMAD|IADD' build/isa/transpose.sass
```

`-lineinfo`用于源码关联，`cuobjdump`和`nvdisasm -g`必须针对此次sm_110 cubin。PTX是虚拟ISA，不能用PTX条数推SASS周期。上述字符串仅定位候选，不能证明nvcc一定生成该拼写。没有工具链所以本期没有真实SASS摘录。

分析路径：地址乘加→global load→shared store→块屏障→shared load→global store。naive的跨行store可能扩大事务；tile0的shared load可能增加wavefront/依赖等待；barrier时间也可能来自最慢warp，而不只是屏障本身。PAD1不删除global读取依赖，也不会凭空增加内存带宽。将热点源行、采样stall原因、内存指标和事件时间一起判断；不提供猜测的指令延迟表。编译后检查register/shared占用和spill，若额外地址计算提高寄存器压力则重新测量。

## Thor固定目标与Ampere差异

[CUDA13 Ampere指南](https://docs.nvidia.com/cuda/archive/13.0.0/ampere-tuning-guide/index.html)的异步拷贝/分离arrive-wait小节已读：Ampere加入硬件global→shared异步搬运，可减少中转寄存器并配合计算重叠。[PTX9](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html)区分基础sm_110与架构专属目标，不能由Blackwell名字推断所有专属指令可用。

| 项目 | Ampere原理对照 | 本次Thor sm_110适用性 |
| --- | --- | --- |
| cp.async global→shared | SM80起、对齐/尺寸/等待语义必须满足 | 作为后续候选，当前代码未使用；纯转置几乎无可重叠计算，收益不保证 |
| split arrive/wait | 生产/消费阶段可拆开 | 本例统一block屏障更易验证，未替换成mbarrier |
| Tensor Core | Ampere增加TF32/BF16等模式 | 本课是搬运，无MMA；不能因此使用Tensor Core性能数字 |
| 更特殊指令 | 不适用Thor专属后缀规则 | 不启用sm_110a等后缀，未核实指令不纳入实现 |

优化候选验收：三实现数值/哨兵一致→GPU sanitizer通过→同shape/stride重复测event→ncu支持瓶颈解释→接入视觉推理测E2E。缺任何一步就保留未验证状态。
