# 2026-10-03 ARM11：独立NEON累加器为何不能无限增加

## 1. 本节问题与速览

承接第10课FMA/归约：同样FP32点积，为什么四条链可能比一条快，十六条又不一定继续改善？5–10分钟先看下表和真实汇编，完整正文用于工程迁移。输入连续x/y，N=7/4096/65539，单线程，有限数值；每个函数不分配内存。基线`dot<1>`、候选`dot<4>`和`dot<16>`，双精度标量oracle检查误差。

工作锚点为ROCK 5B/RK3588的CPU特征匹配阶段，主要能力层3：证据驱动优化。2026-10-03实际读[Radxa规格](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)：四A76与四A55；没有实板，具体OS、核ID、频率/PMU和SDK均待采集。Mac结果不能证明A76/A55吞吐。本例不使用GPU/NPU，也不以SM号描述ARM CPU。

## 2. 状态与代价推导

| 模式 | 一次主循环处理 | 累加状态 | 尾部上界 |
| --- | --- | --- | --- |
| U=1 | 4个元素 | 1个128位向量，4个FP32 lane | 3个标量 |
| U=4 | 16个元素 | 4个互不依赖向量 | 15个标量 |
| U=16 | 64个元素 | 16个互不依赖向量 | 63个标量 |

每条链满足 `acc_j(t+1)=fma(x_j,y_j,acc_j(t))`，同一acc有真依赖，其他acc允许并行发射。分链只改变部分和分组，不改变数学点积；归并会改变舍入。总逻辑输入流量8N字节，约2N FLOP，算术强度约0.25 FLOP/B（不含缓存复用和地址指令）。即使计算依赖被隐藏，加载资源也会成为限制；这只是模型，不是实测DRAM带宽。

寄存器压力来自累加器、加载暂存、指针和循环状态的共同活跃区间。NEON有32个128位V寄存器的架构命名空间；某些寄存器受ABI保存规则影响，编译器可改变调度。无限展开可能增加代码体积、栈spill与尾处理，不能从U直接推导收益。

## 3. 代码对应真实ARM指令

[源码](src/main.cpp)使用`vld1q_f32 → vfmaq_f32 → vaddq_f32 → vaddvq_f32`，不足整块部分用`std::fma`；[实际汇编](results/main.s)由AppleClang21、`-std=c++17 -O3 -S`生成。以下是实际摘录：

```asm
; dot<1>：每轮更新同一个v0
ldr q1, [x10], #16
ldr q2, [x9], #16
fmla.4s v0, v2, v1
; dot<4>：四个独立目的累加器
fmla.4s v3, v6, v4
fmla.4s v2, v7, v5
fmla.4s v1, v6, v4
fmla.4s v0, v7, v5
```

`.4s`是四个32位浮点lane；q加载16字节，后索引地址推进16。`dot<4>`加载用ldp q成对读取，不是跨lane归约；最后`fadd.4s`合并向量，`faddp.4s/faddp.2s`横向相加。标量尾部为`ldr s`与`fmadd s0,...,s0`。

`dot<16>`实际使用v0–v7、v16–v23作16个累加器，v24–v27作加载暂存。三个dot函数体都没有栈spill；主程序的Folded Spill是宿主控制流程/ABI保存，不能拿它证明点积内核溢出。十六链后面有较长的fadd合并链，结尾成本真实存在。观察指令存在不证明微架构吞吐或延迟周期。

## 4. 已写好的公平对照

```sh
sh run.sh
c++ -std=c++17 -O3 -S src/main.cpp -o build/inspect.s
sed -n '/__Z3dotILi1EEfPKfS1_m:/,/cfi_endproc/p' build/inspect.s
sed -n '/__Z3dotILi16EEfPKfS1_m:/,/cfi_endproc/p' build/inspect.s
```

同一x/y、语义和容限，U是主要变量；编译器随U改变展开、加载和尾部路径，不能声称只测FMA依赖。20组预热、100组样本，每组100次调用，候选次序轮换，有编译器memory barrier和volatile结果防止整个循环消除。P95是调用批均值分布，不是单帧请求P95。代码内标量oracle未作为性能候选，三个候选均明确用NEON。

[Release/ASan真实输出](results/host.txt)第一段为Release，第二段带Sanitizer不用于性能结论：

| N | U=1 P50 us | U=4 P50 us | U=16 P50 us |
| --- | --- | --- | --- |
| 7 | 0.00209 | 0.00375 | 0.00416 |
| 4096 | 0.96709 | 0.26208 | 0.21500 |
| 65539 | 13.1325 | 3.7975 | 3.80167 |

3081组数值对照均通过（N=0..1026×3），此二进制分数输入最大误差0，不保证任意分布精确。N=7多链更慢：大U直接进入较长标量尾路且归并/分支开销不能摊销。N=65539四链与十六链几乎相同；没有PMU，不能断言已触顶DRAM或加载端口。较长测量输入另核对oracle见[补充日志](results/final.txt)：3种benchmark shape×3候选均通过。补充Release的N=65539 P50为13.2296/3.7900/3.81292 us；与初次类似，其他尺寸有时钟/调度波动，旧日志原样保留。

## 5. 工业排障与取舍

1. 线上多数N<16，展开后延迟升高 → 先分桶N并看dot入口cmp和尾分支 → 大U没有进入NEON主循环 → 为短输入保留U=1；代价是分派分支，回归N=0..65。
2. 板端展开后出现大量`str/ldr q,[sp]`且变慢 → 限定dot函数内检查，区分函数入口保存和循环spill → 缩小U或活跃区间；再次记录资源、精度与板端分布，不把Mac无spill推广到A55。
3. 点积变快但整帧无改善 → 分解拷贝/等待/NPU执行，统计调用占比 → CPU热点不是主瓶颈；回滚复杂分派或连同布局一起测，不能用微基准比值预测E2E。

## 6. 来源与验证边界

实际读取[ggml master vec.cpp](https://github.com/ggml-org/ggml/blob/master/src/ggml-cpu/vec.cpp)的`ggml_vec_dot_f32`非SVE多acc路径，及[simd-mappings.h](https://github.com/ggml-org/ggml/blob/master/src/ggml-cpu/simd-mappings.h)的NEON宏/ARR/FMA/reduce，2026-10-03，精确commit未固定。原场景为CPU推理张量点积；原实现通过宏选择多寄存器与标量尾部。本课独立实现可变U，不复制宏、不移植SVE/FP16/多dtype框架。MIT LICENSE正文已读。[Arm intrinsics官方参考](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)用于接口/指令查验。源码阅读、本机运行是；板端与PMU不是。Google/知乎检索入口无法读取，不声称读过文章；[尝试URL和原始错误摘要](../../daily/2026-10-03/source.json)保存在主课来源记录。

## 7. 迁移验收与追问

在ROCK 5B Linux本地构建：`c++ -std=c++17 -O3 src/main.cpp -o build/example`，先运行`uname -a`、`lscpu -e`、读取`/proc/cpuinfo`并核对核型号，按实际拓扑选择taskset CPU；不硬编码大小核ID。执行`perf list`后才选择cycles/instructions/cache事件。跨编译必须使用匹配aarch64-linux-gnu工具链/sysroot；Mac Mach-O不部署到Linux。板端构建、ELF/动态库依赖、尾部精度、热稳态30分钟、功耗、任务E2E均是待验清单；无收益保留U=1/4。

追问：1. V与Q命名是什么关系？2. 多acc为何减少真依赖？3. 看到stp d8是否就是循环spill？4. 短N为何不进入向量循环？5. 如何测加载限制而不猜周期？6. 加法树变化的误差怎样验收？

下一课12：AoS/SoA、交错加载与数据重排；从连续向量扩展到实际排列成本。
