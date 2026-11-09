# 2026-11-09 RK016：中断计数增量与实际亲缘性

PDF第3章/p3；20–30分钟现成阅读，未连接RK3588。下一RK017。生成、用户学习和板端验证分开记录。

## 两个耦合机制与知识图谱

`设备事件 → IRQ handler → 每CPU累计计数 → 两次快照差/实际秒数`；`smp_affinity_list请求 → irqchip选择 → effective_affinity_list → 事件实际落核`。累计值大可能只是运行更久；速率需同一启动、同一CPU列、同一IRQ身份。CPU热插拔和重新绑定后不直接相减。硬中断次数、softirq次数与CPU时间没有一一对应关系，一次软中断可处理多项工作。

## 实际中怎么用

场景：相机反复启动停止后CPU0持续高占用。先记录板型、uname、内核commit、驱动/DTB及复现步骤；运行`sh collect.sh 实际IRQ号 > results/board-sample.txt`，在空闲、相机启停、稳定采集三个窗口各采一次。脚本只读proc/sys，不改亲和性。把输出的CPU列按名称对齐，以uptime差作近似窗口长度，检查两端online一致，再用main.cpp的rates合同解释增量；合成测试不是板端测量。

现象→证据：同时保存top、/proc/softirqs与/proc/interrupts，辨别硬IRQ增长与TASKLET热点。判断→代码：对照当板kernel/irq/proc.c的show_irq_affinity，requested与effective分别来自不同mask；effective文件缺失时记未知，不能复制requested冒充实际。处理：若需trace，先核实该镜像支持的irq/tasklet事件，在隔离测试窗口由工程人员启停并恢复原设置。本课不自动改trace或IRQ路由。真正补丁必须取得匹配BSP的变更并审查；盲改affinity可能只转移负载。

验收：固定相机循环次数，前后保持CPU在线集、功耗和负载条件；TASKLET增量及CPU时间恢复合理范围，采集帧数/错误率不退化，停止后不持续忙循环。只看IRQ总数下降不足以验收。PPI、managed IRQ、级联GPIO与共享IRQ需分别核查，不能把普通SPI的写入能力泛化。

## 工程博客与源码阅读

2026-11-09实际读sheldon_blogs《Android14 RK3588平台内核异常中断占用CPU问题排查》（2026-01-16）的问题、计数、亲和性、tasklet跟踪和结论段：[原作者](https://www.cnblogs.com/blogs-of-lxl/p/19491729)。Android14/RK3588，具体板型、kernel commit和RK patch未公开。文章观察ksoftirqd/0与pl330_tasklet，称最终合入ISP相关RK补丁解决；这里只迁移取证顺序，不认定DMA为根因，不提供臆造补丁。原文sort -rn优先按行首IRQ号排序，不能可靠找最热IRQ；应比较固定窗口内各CPU计数增量。

优先检索微信/知乎“RK3588 中断 亲和性/affinity”，没有取得更匹配正文；W00 Weston指定微信正文仍未读。ArmSoM PCIe等仅搜索候选，未算本课精读。

实际阅读[Rockchip develop-5.10 kernel/irq/proc.c](https://github.com/rockchip-linux/kernel/blob/develop-5.10/kernel/irq/proc.c)，读取日2026-11-09，GPL-2.0内核来源，show_irq_affinity、write_irq_affinity、register_irq_proc：请求路径检查irq_can_set_affinity_usr与active mask；effective接口受CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK控制。分支读取不是用户镜像精确版本证明；须以板端commit复核。本例为独立计数分析和只读采集，不复制内核实现、不替代原生路径。

## 运行与验证

`sh run.sh release`、`sh run.sh sanitize`；`sh collect.sh IRQ`仅Linux/RK3588板端。源码在src/main.cpp，测试覆盖累计最大但增量零、零窗口、计数回退、列数改变及空快照。实际日志和最终SHA256见下方验证记录；板端pending。无中断延迟、GPU/NPU性能结论。

## 工业故障与追问

累计数排序误判→固定时间差分并标CPU列→复核热点；requested全核而流量集中→查看effective与真实增量→区分控制器选择和软中断工作，不能直接判失效。

追问：为何ff不等于均摊？effective缺失如何记录？CPU离线如何处理快照？TASKLET次数等于工作量吗？共享IRQ怎么归因？修复后仅CPU下降能否验收？

## 无答案自测

两次采样之间CPU1离线又上线，IRQ也被驱动重新申请；哪几项身份和计数证据必须重建？

## 验证记录

Mac Release及ASan/UBSan通过，原始results/release.txt、sanitize.txt；计数合同4个拒绝用例。RK3588 board pending，未进行亲和性修改。

最终源码SHA256：

- `src/main.cpp`：`8dc8dc976840ba61f08d108820676c374494f5da2585b39221017ced33416366`
- `run.sh`：`13c64719c8619004704a4c9449b5891e628d027acf215e1245b94e66b502c73b`
- `collect.sh`：`27bf46abcc6756e0646f383f9559c792d8309c05f9327d9061846547facfbea9`
