# 2026-10-08 ARM 第16课：同一NEON微内核的packing摊销

## 速览与工作合同

承接第15课工作集，本节解释：**四个分散权重加载变成一个128位加载，要复用多少次才值得打包？**对应“证据驱动优化”能力层。参照ROCK 5B/RK3588 CPU上的小Batch输出投影，实际只在Mac arm64执行。`A[M,K] × W[N,K]^T → Y[M,N]`，FP32、W行stride≥K；M/N/K为非负，本例N/K≤2048、stride≤4096；输入有限且生成值有界。测试M=0/1/3、N=0/1/3/4/5/17、K=0/1/3/4/5/31/33、padding=0/7，基准M4/K257、N17/128。输出与FP64标量oracle容差`1e-5*(1+abs(ref))`，两NEON路径逐位一致。

## 数据布局与机制推导

原W按输出通道连续，每个k需要跨stride读四个通道。打包成`P[panel][k][lane]`，panel覆盖4输出，lane是通道偏移，尾通道填0。举N5/K2，原来的五行`[a0,a1]...[e0,e1]`变为第一panel `[a0,b0,c0,d0,a1,b1,c1,d1]`，第二panel `[e0,0,0,0,e1,0,0,0]`。输出只写有效lane。

| 源码 | 实际ARM机制 | 变化 |
| --- | --- | --- |
| pack | C++循环重排，编译器可向量化 | 额外读W/写P，包含分配与初始化 |
| compute非packed | `ld1.s {v1}[lane]` | 四个地址分别填128位向量 |
| compute packed | `ldr q1` | 一次连续128位加载4个FP32 |
| 两路径vfmaq_n_f32 | `fmla.4s v0,v1,v2[0]` | 4通道共享同一个A标量，累加次序相同 |

这是数据供给变化，不是把普通CPU局部性称为ARM独有。`v0`的循环携带依赖仍在，packing不会消除FMA链；也未实现完整高性能多寄存器GEMM。N方向四通道panel是本课的分块，K全长扫描，没有谎称实现多级cache tiling。

## 代码与真实汇编

[src/main.cpp](src/main.cpp)的`compute`两路径共享FMA结构，标量FP64只作oracle。实际Apple clang21 `-O3`汇编[generated-arm64.s](results/generated-arm64.s)摘录：

```asm
ldr q1, [x22, x11]
ldr s2, [x10], #4
fmla.4s v0, v1, v2[0]
```

对应packed路径；直接路径的`ld1.s {v1}[0]`至`[3]`逐lane加载，伴随尾部条件分支，再执行同样FMLA。q1是128位向量，s2是32位标量，v2[0]广播给四个lane；加载少不保证周期短，依赖/缓存/前端仍可能限制。按下列命令定位，不需自行猜是哪段函数：

```sh
sh systems_practice/arm/2026-10-08/run.sh
MODE=sanitize sh systems_practice/arm/2026-10-08/run.sh
c++ -std=c++17 -O3 -S systems_practice/arm/2026-10-08/src/main.cpp -o systems_practice/arm/2026-10-08/build/local.s
rg -n 'fmla|ldr.*q1|ld1.s' systems_practice/arm/2026-10-08/build/local.s
```

## 公平对照与成本模型

相同输入、FP32、FMA次序、预热3次，每样本5次调用平均，21样本取排序P50/P95；不是单请求P95。direct与packed都真实NEON，不能称前者无向量化。pack_only包含vector分配/清零/重排；packed_reused不含pack；pack_plus_R测一次pack加R次同一输入计算，包含分配释放。独立基准段按顺序执行，频率/温度/缓存可能漂移，因此不能把不同段的P50相加成“预测实测”；R=1/8有直接整批对照。

逻辑算术约`2MNK`FLOP；P容量为`4*ceil(N/4)*K*4`字节，packing额外逻辑读`4NK`及写P容量，不等于DRAM流量。摊销模型`Tpack+R*Tpacked < R*Tdirect`仅在各成本稳定、同口径时用来估计交叉点；右侧差若≤0，任何复用都不能保证回本。动态activation不能按静态weight那样跨请求缓存，权重更新必须使pack失效。

## 真实结果与边界

[最终Release](results/verified-release.txt)252shape通过、stride非法输入拒绝；[ASan/UBSan](results/verified-sanitize.txt)通过。以下单位为Mac CPU整事务批均值微秒P50：

| N / reuse | direct_R | pack_plus_R | 观察 |
| --- | ---: | ---: | --- |
| 17 / 1 | 7.6000 | 7.7082 | packing微弱退化，不能承诺收益 |
| 17 / 8 | 61.1666 | 51.5084 | 本次观察有改善 |
| 128 / 1 | 50.2250 | 39.7582 | 本机该shape改善 |
| 128 / 8 | 291.0330 | 172.9170 | 复用有利，但未隔离频率影响 |

单独pack P50为0.8166/7.1584µs；P实际容量20560/131584B。首次触页、核心调度、PMU、功耗、RK3588板端与推理E2E未测。Sanitizer计时不用于性能结论。

## 源码与资料阅读

2026-10-08读[Tencent/ncnn](https://github.com/Tencent/ncnn) master的[src/layer/arm/gemm_arm.cpp](https://github.com/Tencent/ncnn/blob/master/src/layer/arm/gemm_arm.cpp)：`pack_B_tile`中elempack1加载/transpose4x4/store、`gemm_transB_packed_tile`的vfmaq_laneq消费、`Gemm_arm::create_pipeline`常量B打包与forward按tile调用链。BSD-3-Clause，完整SHA未固定，网页抓取较早，未声称今日上游HEAD。原场景通用ARM GEMM；本例**独立启发**，保留面板供给、尾部与复用成本，不复制ncnn布局/多线程/动态tile选择，因此数据不能直接传进ncnn微内核。

[ACLE标量FMA表](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)核实vfmaq_n_f32→FMLA映射。[Radxa产品表](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)核实ROCK5B/RK3588四A76+四A55；板端OS/实际核ID未知，不固定亲和性号码。Google直接查询访问Internal Error；知乎GEMM原文跳安全验证，未读文章正文。技术依据为实际源码/ACLE，而非搜索摘要。

本地补充资料只读`VivekPublicRepo/ARM-MMU/MMUAdvanced/MMU-Chapter 19 MMU Performance Optimization Techniques.pdf`物理页1–2并渲染查看；SHA256=`bec29c5ba1ab2ac0169b26c61d789d9d7861b4ff889d5bf9f22b892d89740279`。页2把TLB命中、cache效率、页表walk列为候选因素，不能据此把本例改善归因TLB；本课只确认加载形态与时间，没有硬件计数器。已知该文页5四级页表错误仍按[勘误](../../docs/arm/LOCAL_LIBRARY.md)处理，本期不采用其周期或层级推断。未复制PDF，无日期JSON文件。

## 工业故障与取舍

1. 非方阵输出错位→pack与消费者k/lane顺序不一致→手算N5/K2并与FP64逐元素比较→固定布局合同与尾部填0，回归stride/padding；不能靠只测方阵隐藏错误。
2. 单帧更慢→pack分配/重排成本超过加载收益→比较R1整事务及pack_only→小N直接路径、静态权重缓存packed，保留版本标记；代价是额外P存储。
3. 更新模型后预测异常→使用旧packed权重→核对源权重版本与pack版本→原子替换完整只读权重包，旧请求持有旧包到结束；本例无在线更新实现。

## 板端迁移验收与追问

在ROCK5B Linux先用`uname -a`、`lscpu -e`、`c++ --version`核实OS/拓扑。已安装原生编译器用相同run.sh，交叉编译需匹配`aarch64-linux-gnu`与sysroot；`file build/release`、`readelf -l -d build/release`查ELF解释器及动态依赖。Mac Mach-O不能直接部署。用`perf list`确认可用事件再`perf stat -e cycles,instructions,cache-misses ./build/release`，进程整体计数只用于粗筛，不当单kernel归因；缺权限记录失败。板端固定实际选定核心、热状态、代表shape与真实E2E，若含pack变慢则回滚。以上目标命令未运行。

追问：1. lane代表K还是输出通道？2. packing为何可能增加总流量？3. 哪些缓存能跨帧复用？4. N尾部padding怎样影响成本？5. 汇编少了load为何仍可能不快？6. 怎样区别频率漂移与cache命中改善？

下一课第17节：预取与带宽，继续检验提前加载何时有效，而不是见到PRFM就宣称优化。
