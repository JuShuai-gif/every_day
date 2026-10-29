# ARM / RK3588 实验：Modbus TCP：流式状态机、字节序与分片成本

本文把本项目的算法改动、Arm执行特征和边缘部署验收连接起来。状态：**RK3588待实测**；Mac用于功能、代码路径和采样协议验证，不替代板端数据。

## 1. 先固定本项目的工作负载

每次invocation重放2048响应帧，接收块最大512字节；解析正常/异常响应，生成全部寄存器结果和摘要。

p99是2048帧CPU解析批次，不是PLC请求响应延迟。真实事务预算还需网络往返、重试、排队和设备执行，寄存器/秒不能直接等同现场吞吐。

## 2. 真正相关的 ARM 优化

- baseline逐帧复制+erase，stage1游标减少搬移，optimized260字节状态机加完整帧直解码。首先观察memmove/分配/分支，而不是为少量寄存器强写NEON。
- wire字段是显式大端读取，避免将任意TCP偏移reinterpret_cast成未对齐uint16_t指针；编译器可优化移位/合并，但不能依赖主机端序。
- 本例是Modbus TCP响应，不带RTU CRC尾部；不要为它追加CRC16，更不能把Arm CRC32指令当协议加速。正常与异常响应长度必须保持严格检查。
- 自动向量化可能影响寄存器循环或库copy，但状态机依赖前一片段，不保证SIMD收益。EDGE_ENABLE_NEON不产生本项目的显式向量内核。

定位事件建议：cycles,instructions,branches,branch-misses,cache-misses。事件支持与权限取决于板端内核/PMU，失败要留日志，不填0。

按实际chunk schedule看decode、prefix erase、header/body状态与结果存储；分别加入单字节分片和完整块控制输入并记录源hash。不能只留完整帧快路径数据。

## 3. 编译变体与可复现开关

本机控制实验（在本项目目录执行，每次生成独立记录）：

~~~bash
EDGE_AUTO_VECTORIZE=OFF bash run-mac.sh --samples 30
EDGE_AUTO_VECTORIZE=ON bash run-mac.sh --samples 30
~~~

EDGE_ENABLE_NEON只控制项目显式intrinsic路径；EDGE_AUTO_VECTORIZE控制编译器循环/SLP向量化，两者都关闭也不保证依赖库完全不使用SIMD。使用compile_commands、backend输出与反汇编核实真正差异。

交叉构建与部署先设置实际工具链、sysroot和SSH地址：

~~~bash
export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
export SYSROOT=/absolute/path/to/rk3588-sysroot
RK_TUNE=generic bash build-rk3588.sh
BOARD=user@rk3588-host RK_TUNE=generic RK_MATRIX=1 bash run-rk3588.sh
~~~

默认ON/ON开关的generic产物位于build/rk3588-generic/modbus_parser；非默认开关会用独立后缀，以构建日志为准。设置RK_TUNE=cortex-a55或cortex-a76产生独立目录，部署必须使用相同RK_TUNE。CMake对应EDGE_CPU_TUNE，仅性能调度调优，不据此提高ISA要求；区别见[GCC AArch64选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)。

RK_MATRIX=1让部署入口执行并拉回完整核型矩阵；默认0运行快速采集。矩阵可加MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3，长测将MATRIX_SECONDS改60，BUDGET_US按一次invocation设定。保持开关变量和tune与所部署产物一致。

## 4. 同一二进制先比核，再比编译调度

核型依据[Rockchip官方资料](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)，具体Linux CPU编号通过MIDR/cpuinfo与online、当前亲和性确认，禁止默认CPU4就是大核。先记录二进制SHA256和输入/源码hash。

在板端保留脚本相邻关系后运行：

~~~bash
./modbus_parser --test
bash scripts/run-matrix.sh ./modbus_parser records/matrix-generic
~~~

OUTDIR必须不存在或为空；run-matrix.sh、board_probe.py、summarize-matrix.py同目录。自动生成single_a55/single_a76/cluster_a55/cluster_a76，缺核型或同簇证据就标unavailable，不能猜拓扑。默认MATRIX_REPEATS=3、MATRIX_SAMPLES=120、MATRIX_SECONDS=3，warmup=5、iterations=1；BUDGET_US=0代表未设预算，可按本项目每invocation合同设置。

同ELF单A55/A76比较解析能力，同簇profile不是多连接并行。真实网关应按连接拥有独立parser，连接数/IRQ/socket成本另测；本例没有recv系统调用。

第一轮固定generic ELF和输入比较亲和性；第二轮固定同一核/同一输入比较generic、a55-tuned、a76-tuned ELF。不要把换核、换编译器和改算法同时发生的差异称为某一项收益。

## 5. 边缘资源与长期验证

optimized残片≤260字节，buffered峰值≤772；输出向量仍随帧数增长，RSS单独记录。EOF截断/非法Length必须拒绝，不能靠丢坏帧制造低延迟。

~~~bash
./modbus_parser --mode optimized --samples 120 --seconds 60 --iterations 1 --csv stress.csv
~~~

记录p50/p95/p99/max、真实budget_exceeded、吞吐、RSS、前后温度/频率和后台负载。RSS是进程峰值；warmup后的缓存状态也要一致。正式采样与perf/strace归因分开，--profile跳过自检，使用前必须独立通过--test。

## 6. 选核、保留或回退的证据

所有切分位置/异常/容量测试通过后再选状态机。若碎片极多时分支抵消收益，保留游标版作为回退；真实接入增加事务匹配、超时和重连后再复测。

没有功耗测量就不报告瓦数、能耗/任务或能效胜负。A55满足预算只是容量/部署选择证据；温度、降频、长期尾延迟也必须实测。所有未接入设备/网络/存储语义按README列为未验证。

在records/TEMPLATE.md的目标板专用区记录：chunk schedule/2048帧/异常数、buffer_peak、寄存器全量一致、分片对照、真实TCP与PLC时延NOT_MEASURED；同时关联矩阵CSV/JSON、拓扑证据、编译清单和失败日志。阶段收益与核型收益分别写结论。
