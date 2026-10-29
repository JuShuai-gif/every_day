# 2026-10-24 ARM集成案例01：四行打包RMSNorm与lane语义

首轮28课已交付，本期进入源码kernel集成，不回到第01基础课。日期以开始时2026-10-24为准；实际阅读/最终运行跨到10月25日。现成阅读例，不另设强制作业或自测。

## 工业问题与两个机制

视觉特征四行一起处理，把row-major `[4,N]` 转为 `[N,4]`，让NEON每个lane代表一行。耦合点是**打包轴语义**与**倒平方根近似/修正**。前者决定统计量属于谁，后者决定精度与吞吐；排布正确才能谈加速。代表N=513，FP32，无gamma；有效输入沿用主课有限幅值合同。

```text
row-major[4,N] → pack[N,4] → 每lane沿N累加平方 → 每lane独立rsqrt
                                  ↓                   ↓
                          不能跨lane水平求和    estimate + 两次Newton
                                                       ↓
                        unpack[4,N] ← 每lane缩放输出
```

ncnn的elempack=4与elempack=1不能共用同一归约轴：前者四个lane是四行独立统计，后者向量lane可属于同一行。本例已写反例：四行常量1/2/4/8若合并成一个scale，第一行与逐行参考差异>0.5。不要用“都叫float32x4”判断语义。

设z=mean(x²)+epsilon>0，初始r≈1/sqrt(z)，修正 `r←r*(3-z*r*r)/2`。代码的 `vrsqrtsq_f32(z*r,r)` 实现括号项，两轮后与double oracle比较。允许浮点舍入和融合乘加差异，拒绝NaN/过大输入；算法不承诺所有FP32极值范围。没有可选SVE依赖。四行是入口合同；生产不足四行应分派到逐行参考，不把凑整后的空行混入有效行。

## 实际源码与迁移边界

实际阅读 [Tencent/ncnn rmsnorm_arm.cpp](https://github.com/Tencent/ncnn/blob/master/src/layer/arm/rmsnorm_arm.cpp)，master，2026-10-24～25，文件blob `9543033a8bd6c1ad5b228a9802e1820859fd11df`（不是commit）。BSD-3-Clause文件头已读；函数 `RMSNorm_arm::forward_inplace` → `rmsnorm`，重点elempack4与elempack1分支及两次rsqrt修正。原场景为ncnn多维/多精度tensor、gamma、OpenMP推理算子。

本例为**独立启发实现**，保留packed4统计轴与修正公式，省略gamma/BF16/FP16/OpenMP、多维调度，不宣称完整ncnn移植。源分支可变，读取日期和blob标识保留；未解析仓库commit。已核对 [Arm ACLE intrinsics](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html) 并实际生成[A64汇编](results/packed4.s)。本课无适配的本地PDF内容，未用未读PDF充当证据；Google/知乎访问边界见[主课研究记录](../../daily/2026-10-24/GPU_GUIDE.md#研究访问边界)，技术结论来自源码、ACLE及本机汇编。

## 已写好的对照、运行与计时

[完整C++17代码](src/main.cpp)包含rowwise、packed4、pack/unpack、混轴反例，使用vector管理内存。scalar禁自动向量化；NEON显式intrinsics不受该开关移除。两者使用相同输入/epsilon及可比O2，scalar使用sqrt，NEON使用两次修正；精度单独检验，不能把近似差异隐藏成同指令实现。

```sh
# 从仓库根目录，Apple Silicon AArch64 + 现有Clang
sh systems_practice/arm/2026-10-24/run.sh release
sh systems_practice/arm/2026-10-24/run.sh sanitize
cd systems_practice/arm/2026-10-24
clang++ -std=c++17 -O2 -fno-vectorize -fno-slp-vectorize -S src/main.cpp -o results/packed4.s
```

实际汇编中packed4可见 `ldr q`、`fmla.4s`、`fdiv.4s`、`frsqrte.4s`、两轮`frsqrts.4s`、`fmul.4s`和`str q`；rowwise可见标量`ldr s`/`fmadd s`、`fsqrt s`。这些是本机真实输出，不是Thor SASS。Apple汇编语法与Linux显示格式可不同。

20个零/随机边界shape、零维拒绝和混轴反例通过；记录[Release](results/verified-release.txt)、[ASan/UBSan](results/verified-sanitize.txt)。性能仅取最终Release日志：4×513，warm20，31批×200次，steady_clock批均值P50/P95，volatile消费输出。分别报告scalar、已打包kernel、pack+kernel+unpack；不计allocation。sanitize日志中的时间只作运行轨迹，不作为性能数字。无缓存冷启动、PMU、频率锁定或独占机器保证，短时差异不能外推板卡。

## 故障链路与工程取舍

| 条件→信号 | 根因/诊断 | 修复与代价 |
| --- | --- | --- |
| 把packed4水平归约→四行尺度互相污染 | layout语义错误；四行常量反例立即区分 | 每lane独立累计，按elempack派发 |
| 只测packed kernel→集成后收益消失 | 额外pack/unpack和小tensor启动成本；单列三条计时 | 上游持续保持packed布局或小shape走scalar；不能只报最佳子阶段 |
| 删除修正或允许极值→误差超过合同 | rsqrt初值精度/溢出；零、随机、幅值边界与oracle定位 | 恢复修正、限制合同，必要时使用更精确路径 |

面试追问：①lane是通道还是行由谁定义？②为什么本例不能vaddvq？③Newton修正依赖什么数值前提？④打包成本为何必须独立记录？⑤如何证明scalar没有被自动向量化？⑥怎样为非四行尾块设计生产派发？

## 验证边界与下一步

源码阅读、本机编译、执行、sanitizer、真实A64汇编已完成；RK3588/Thor ARM CPU、PMU、完整推理和能耗未验证。本课CPU测量不是GPU/NPU或端到端结果。后续集成案例承接任意行数的尾块派发和布局跨算子复用，不重新推进28课编号。进度入口 [progress.json](../progress.json)；本日期目录按规范不写JSON。
