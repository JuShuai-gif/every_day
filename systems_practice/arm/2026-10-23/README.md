# 2026-10-23 ARM 第28课：持续负载中的频率、热状态与请求延迟

## 1. 本节要学会解释的ARM问题

5–10分钟速览：同一段NEON代码运行几秒后变慢，如何区分热限制、核迁移与测量干扰？承接第27课的设备所有权，本节聚焦实际ARM SoC的持续CPU负载证据。目标是AGX Thor/T5000、Neoverse-V3AE；[官方规格](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-thor/)与[功耗文档r38.2](https://docs.nvidia.com/jetson/archives/r38.2/DeveloperGuide/SD/PlatformPowerAndPerformance/JetsonThor.html)于2026-10-23核查，实际板卡/拓扑/SDK仍缺失。Mac只提供Apple Silicon宿主证据。

## 2. 先看数据或状态如何变化

| 层次 | 观察对象 | 不能推出的结论 |
| --- | --- | --- |
| A64/NEON | 每轮8个FP32转8个INT8，FCVTAS/SQXTN | 指令存在不等于吞吐提高 |
| OS/频率策略 | cpufreq policy、迁移、运行队列 | scaling_cur_freq不一定是精确执行频率 |
| SoC温控 | thermal zone、trip、cooling state | 温度上升不必然已发生降频 |
| 系统功耗 | tegrastats VIN、采样间隔 | VIN不是单CPU kernel功耗 |
| 服务请求 | 单次CPU调用/排队/设备阶段 | CPU单调用P95不是完整推理P95 |

持续负载使活动度、供电和温度变化，策略可能限制频率；通用DVFS原理并非ARM独有，具体核吞吐与thermal governor配置要在目标SoC核实。不能用Mac的频率行为解释Cortex-A76/A55或Neoverse-V3AE。

## 3. 最小实现怎样对应ARM机制

[src/main.cpp](src/main.cpp)复用[10月21日完整标量/NEON实现](../../daily/2026-10-21/src/quantize.hpp)，不复制一份新内核。输入65539个FP32，inverse_scale=1.25，连续布局、无重叠；输出INT8。NEON一次加载两个128位向量，FMUL缩放、掩码处理NaN、FMIN/FMAX钳位、FCVTAS按半整数远离零、两级SQXTN窄化，尾部3个走标量。逻辑数据量5N字节是读4N/写N，不是测得DRAM流量；工作集可驻留cache。

本次新生成[results/neon.s](results/neon.s)，实际片段如下（Apple汇编语法）：

```asm
fcvtas.4s v3, v3
sqxtn.4h v3, v3
fcvtas.4s v4, v4
sqxtn2.8h v3, v4
sqxtn.8b v3, v3
```

`practice::neon`中实际可见`fcvtas v?.4s`、`sqxtn`、`sqxtn2`与store，寄存器编号以文件为准。FCVTAS产出4个32位整数，SQXTN把4×32窄化为4×16，再把8×16窄化为8×8；饱和不会修复此前的错误scale或越界读取。新证据是持续单调用采样与真实汇编，原算法来源说明复用10月21日ncnn研读记录，**不宣称今天重读ncnn**。

## 4. 已写好的对照与观察步骤

```sh
sh systems_practice/arm/2026-10-23/run.sh release 2 65539
sh systems_practice/arm/2026-10-23/run.sh sanitize 2 65539
# n=0和向量宽度以下的尾部；失败输入另存日志
sh systems_practice/arm/2026-10-23/run.sh release 1 7
c++ -std=c++17 -O2 -S systems_practice/arm/2026-10-23/src/main.cpp -o systems_practice/arm/2026-10-23/build/inspect.s
# 仅Thor Linux板上运行（本次未执行）
sh systems_practice/arm/2026-10-23/board.sh
```

先20次NEON预热，随后AB/BA交替测标量/NEON，每次调用单独计时，校验放在计时外。前/后各三分之一窗口分别记录NEON单调用P50/P95；每窗口最多保留最先100000样本，达到上限时这是窗口前缀统计，不代表全窗口分布。每1000轮打印一个对照时间点，stdout会扰动后续调度。额外vector样本存储有上限，但不是硬实时采集器。Sanitizer只验证正确性，其时间不作为性能结论。

本机2秒明显不足以确认热稳态。`early/late`仅为时间窗口名；不能称“冷态/稳态实测”。最终Release日志给出实际样本数和分位数，初始并发测试日志也保留，结论使用后续串行复验日志。n=0、7与非法时长/负长度都有文本证据。

## 5. 工作场景排障与优化取舍

- 后半段P95上升→可能热限频、核迁移或后台争用：同步核对温度/trip/cooling状态、频率policy、线程所在CPU和调度记录；温度与慢帧只有相关性时保持待判定。按已审批功耗/散热条件重跑同一输入，比较完整窗口；不要先锁最高频再称优化。
- CPU更快而服务更慢→可能共享带宽、排队或设备等待：比较CPU段、队列长度、GPU/NPU与同步段，不能用本例P95替代E2E。减少线程/并发可能更稳定，收益待板端测。
- 能耗比异常→VIN包括载板且采样跨度不匹配：核对传感器覆盖范围与时间戳；对真实P(t)积分得到J，再除完成请求数。缺遥测本课不输出能耗，也不把功耗模式上限当功耗实测。

## 6. 来源、结果与下一节

实际读取[Linux v6.12 gov_step_wise.c](https://github.com/torvalds/linux/blob/v6.12/drivers/thermal/gov_step_wise.c)，blob `fd5527188cf91a7e4c99a171dc5b102f9726140b`，GPL-2.0-only，函数get_target_state→thermal_zone_trip_update→step_wise_manage。该通用Linux实现根据trip、趋势和上下限更新cooling target；原场景是thermal governor，本课只借它解释观测对象，**不假定Thor SDK实际启用同一个governor**，也没有复制源码。

NVIDIA r38.2文档实际阅读tegrastats、VIN及throttle说明：VIN包含模组和载板，CPU/GPU/EMC频率及thermal zone能作为诊断数据。本课board.sh只读nvpmodel、拓扑、cpufreq和tegrastats，不修改功耗/散热。Google入口不可访问，知乎检索未得到可用原作者材料；采用一手Linux/NVIDIA来源，失败记录在当日主课source.json。ARM日期目录不生成JSON。

本机最终串行Release：36178轮，前窗11943样本P50/P95=6.5/6.583µs，后窗12180样本=6.375/6.5µs。没有观测到足以归因热限频的证据；零/小长度出现0µs是计时分辨率限制，不是没有执行。Release/ASan/UBSan均通过，汇编真实生成，见[最终Release日志](results/verified-release.txt)。未采集Mac温度/功率/PMU，未执行Thor持续负载、真实推理或能耗验收；无GPU/NPU性能。本课没有CUDA kernel，执行目标约束仍为Thor SM110。首轮28节教学交付结束，下一阶段进入经核验源码的端到端板端项目，不自动回第一课；板端产品闭环仍未完成。

## 7. 迁移验收与面试追问

目标先记录型号、内核/L4T、CPU拓扑、编译器/ABI和当前功耗条件；Linux ELF与Mac Mach-O不能互换。板端原生构建可沿build.sh，交叉构建必须提供目标sysroot，不能仅换`-target aarch64`。固定输入、尾部/零值和reference检查后，拉长采样直至有可证明的稳定区间，保留全程错误/超时与资源上界；将该CPU段接入真实推理，再测排队/同步/E2E。没有完整后端时明确只是CPU阶段。

追问：FCVTAS和SQXTN分别解决什么？为何2秒后半段不能叫热稳态？scaling_cur_freq能否代表实际周期？VIN积分的测量范围是什么？单调用P95与批均值P95有何区别？核迁移与热限频怎样用证据区分？

## 8. 工作能力与部署闭环

主要对应第4层产品交付，当前证据只覆盖可编译CPU段、量化正确性、A64指令和采样协议。board.sh是待执行观察入口；不能把教学脚本、28课交付或若干PASS拼成真实板端长期稳定性证书。后续优先接通一个实际后端并记录全链路，再决定是否继续优化NEON。
