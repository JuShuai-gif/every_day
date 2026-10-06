# 2026-10-06 ARM14：INT8扩宽与dot-product累加契约

## 1. 本节要学会解释的ARM问题

5–10分钟速览：承接FP16课，今天转向整数精确性。为什么两个合法INT8乘积相加，仍可能在NEON中出错？先看下表，再运行现成代码、观察SMULL/SADALP/SDOT。主课复用同一实现，ARM14新增的是lane宽度与运行时扩展验收；不增加作业。目标岗位能力层3：核对CPU量化算子的范围与实际指令。

## 2. 先看数据如何变化

| 阶段 | 输入 | 结果与边界 |
| --- | --- | --- |
| 有符号byte | -128 × -128 | 16384，16位可表示 |
| 错误16位合并（仅数学反例） | 16384 + 16384 | 32768，超出32767 |
| 正确扩宽成对累加 | 两个16位乘积→32位 | 32768，继续累加安全 |
| SDOT | 16对字节，4组各4对 | 4个INT32 lane |
| 块scale | group≤4096整数和 | 乘两个scale后合并 |

扩宽和数据依赖不是ARM独有概念，SMULL/SADALP/SDOT才是这里观察的A64实现。

## 3. 最小实现怎样对应ARM机制

实际源码为[主课main.cpp](../../daily/2026-10-06/src/main.cpp)。`widening`的vmull_s8/vmull_high_s8先得到8个INT16乘积，vpadalq_s16把每对扩到INT32并加到四个lane，vaddvq_s32水平归约。`dotprod`把四对INT8乘积直接加到一个32位lane，语义不同于16个32位结果。

实际生成的[host-a64.s](results/host-a64.s)中，widening循环108–111行为：

```asm
smull.8h v3, v1, v2
sadalp.4s v0, v3
smull2.8h v1, v1, v2
sadalp.4s v0, v1
```

dotprod第153行是`sdot.4s v0, v1, v2`，之后`addv.4s s0, v0`。前两条存在读后写依赖，SDOT也依赖旧累加器；指令少不保证当前短块更快。此为clang21实际产物，不是期望汇编。

## 4. 已写好的对照与观察步骤

```sh
sh systems_practice/arm/2026-10-06/run.sh release
sh systems_practice/arm/2026-10-06/run.sh sanitize
rg -n 'smull|sadalp|sdot|addv' systems_practice/arm/2026-10-06/results/host-a64.s
```

主课[最终日志](../../daily/2026-10-06/results/verified-release.txt)真实通过4116案例、4拒绝；Mac DotProd查询为1。K65539，标量/扩宽/SDOT CPU批均值P50为18.0896/3.22666/3.22583µs。41样本×100调用、20预热；禁自动向量化。扩宽与SDOT无可宣称的显著差异，未做统计显著性检验；CPU短块合并成本可能限制收益，需PMU再判定。无板端/功耗结果。

## 5. 工作场景排障与优化取舍

ROCK 5B/RK3588上的INT8点积是部署参照，具体板卡软件未接入，不声称跑过A76/A55。症状一：极值才出错→怀疑16位中间溢出→用-128与长K区分→提前扩宽，保留group上限。症状二：编译成功却SIGILL→查HWCAP与崩溃PC→禁用扩展路径，不能依据品牌推断。症状三：SDOT无收益→看每块调用、scale合并和工作集→先测自动向量化基线，再考虑主课双块练习，不删除正确性步骤。

每块32项读取64B数据及8B scale；这是逻辑访问量，不能据此给DRAM带宽。增大group改变量化语义，不能当成相同模型的纯内核优化。

## 6. 来源、结果与下一节

2026-10-06实际读[ggml master quants.c](https://github.com/ggml-org/ggml/blob/master/src/ggml-cpu/arch/arm/quants.c)的`ggml_vec_dot_q8_0_q8_0` NEON/余块与`quantize_row_q8_0`，MIT；未固定完整commit，分支日期限定证据。独立启发实现，未复刻GGUF/FP16 scale/SVE。官方[ACLE](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)核对vmull、vpadalq_s16、vdotq_s32映射；源码调用入口→块载入→点积→scale→水平和。Google查询“ARM int8 dot product overflow ggml”返回Internal Error；知乎定向检索未找到可读相关正文，未引用博客性能。

Release/ASan/UBSan已通过，实际A64已生成，CPU计时已做。Linux/目标板/PMU/长稳尚未验。下一课15讲Cache、工作集与局部性，承接本课逻辑访问量，不提前推进。

## 7. 迁移验收与追问

在Linux板端先执行`uname -a`、`lscpu -e`、`cat /proc/cpuinfo`、`clang++ --version`、`perf list`；不硬编码大核编号或PMU事件。用原build.sh本机编译并运行，`file build/release`及`ldd build/release`检查ABI/依赖。跨编译需目标aarch64-linux-gnu和匹配sysroot，不能部署Mac Mach-O。执行全长度/极值测试，再按实际核拓扑绑定，测冷/热、持续负载与整请求P95；失败时保留基础扩宽路径。

追问：什么时候16位乘积安全而16位累加不安全？SDOT四lane如何映射16字节？编译宏与HWCAP解决什么不同问题？如何给长K设计重置周期？为什么指令减少而计时未变？Cortex-A55/A76的结果为何不能互相外推？

## 8. 工作能力与部署闭环

现有证据支持“能审计数值合同、编译核对指令并在Mac验证”。设备ABI、实际核拓扑、稳定性、温控和端到端回归仍缺失，不能标为产品交付完成。ARM日期目录按规则不生成JSON；来源和结果均在本页，原始汇编与主课日志保留。
