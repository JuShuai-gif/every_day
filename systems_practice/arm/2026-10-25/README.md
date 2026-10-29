# 2026-10-25 ARM项目01：pack4 RMSNorm的lane含义与布局成本

## 速览：本节要解释的问题

28节基础课之后进入源码与项目增量，不重启01课。本期面向Thor T5000主机CPU的四路短特征归一化：为什么ncnn的elempack=4分支不能做水平求和？能力层是“硬件约束下写对＋证据驱动优化”；输入4×N行优先FP32、N≤1024，输出相同布局。Mac只验证代码、A64指令与本机CPU时间，Thor Neoverse-V3AE的Linux部署/拓扑/性能待验，不是完整机器人项目。

5分钟先看下表、`packed4`和两轮倒平方根修正，再比较预打包与包含pack/unpack的时间。附加现成示例，不增加强制作业。

## 数据与机制

| 存储 | 地址4*c+lane中的值 | 向量v0四个lane含义 |
| --- | --- | --- |
| rowwise原始 | 不能直接这样解释 | 一行连续元素可做水平归约 |
| packed4 | X[lane,c] | 四行各自的平方和 |

例如四行常量1/2/4/8时，平方均值应分别为1/4/16/64。若把四lane水平合并成一个scale，第一行输出远小于1，现成反例安全检测此差异。向量lane属于哪一条归约轴由布局决定，不是intrinsic自己知道的。

`pack`显式转置4×N；`packed4`每次加载四行的同一列，用FMLA沿列积累，每lane独立除以N加epsilon。`vrsqrteq_f32`是近似倒平方根估计，随后两次 `y=y*(3-z*y*y)/2`，四lane独立；最终乘原输入。只有正、有限z在本课范围内，不能把对零/负/NaN的处理交给近似指令碰运气。

## 真实指令证据

运行 `sh systems_practice/arm/2026-10-25/observe.sh`。Apple clang21实际生成的[packed4.s](results/packed4.s)包含：

```asm
ldr q1, [x10], #16
fmla.4s v0, v1, v1
fdiv.4s v0, v0, v1
frsqrte.4s v1, v0
fmul.4s v2, v0, v1
frsqrts.4s v2, v2, v1
```

LDR q一次16B读取四行值；FMLA.4s在四个FP32 lane上独立累加，不包含FADDP水平归约。FDIV按每行元素数归一化；FRSQRTE给初值；FRSQRTS给Newton校正因子，后续FMUL更新倒数，源代码做两轮。操作数`.4s`描述四个32位浮点lane，不能据指令数推测周期或Neoverse吞吐。[ACLE](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)已核对vrsqrtsq_f32→FRSQRTS映射。

## 源码阅读与保留边界

2026-10-25实际读取[Tencent/ncnn master rmsnorm_arm.cpp](https://github.com/Tencent/ncnn/blob/master/src/layer/arm/rmsnorm_arm.cpp)，BSD-3-Clause文件头；符号`RMSNorm_arm::forward_inplace`→`rmsnorm`的elempack=1/4与gamma分支。原场景是ncnn Mat不同dims、packing和混合dtype推理。**dims=1会把w*elempack交给elempack=1路径**，所以不能笼统说所有pack4都独立四行；本例对应dims=2的四行打包语义。

这里独立提炼四行布局与两次Newton修正，不复刻Mat、OpenMP、BF16/FP16/gamma，也不声称调用ncnn原生层。分支读日可追溯，commit未固定。基础数据/FP64 oracle复用今日主课；实现起点来自未完成10月24草稿，今天重新研究、验证并新建记录。ARM日期目录不放JSON。

## 已写好的对照与运行

```sh
sh systems_practice/arm/2026-10-25/run.sh release
sh systems_practice/arm/2026-10-25/run.sh sanitize
sh systems_practice/arm/2026-10-25/observe.sh
```

标量rowwise使用 `-fno-vectorize -fno-slp-vectorize`；候选为显式NEON，因此差异同时包含布局和SIMD，不能归因于单一因素。20组合包括全零、N=1/3/4/5/31/32/33/127/513/1024；两个路径都与FP64逐元素比较，空列拒绝和错轴反例通过。最大绝对误差2.38419e-7。最终原始日志：[Release](results/verified-release.txt)、[ASan/UBSan](results/verified-sanitize.txt)。

性能扫N=1/33/513/1024，20次预热、31个样本，每样本200次循环均值，输出CPU微秒P50/P95。三个边界分别为原始布局标量、已打包kernel、pack+kernel+unpack。只引用Release数字；Sanitizer计时是诊断副产物，不作性能结论。所有数组在计时前分配，sink消费结果，仍可能受时钟、缓存和编译器影响，不是请求P95。

逻辑流量模型：kernel读平方和、再读缩放并写出约12×4N字节；pack/unpack再加16×4N字节，均不等于DRAM实测。若上游已输出pack4，转换成本可省；若每次先打包再拆包，小行或内存竞争会吞掉SIMD收益。短期微基准未测温控、PMU和完整模型E2E。

## 故障链与工程取舍

1. 四路结果互相影响→可能误用了水平归约→用1/2/4/8四行常量隔离轴错误→保持lane独立；代价是必须维护packing元数据，并回归dims=1与dims=2的语义区别。
2. 单kernel快而服务慢→可能重复pack/unpack或多分配→将布局转换与kernel分别计时→让上下游共享一种布局，或回退rowwise；不通过删除转换获得不公平收益。
3. 极端值变NaN→检查epsilon、平方溢出和FRSQRT输入→用入口范围拒绝与FP64 oracle→必要时扩大累加精度，重新测速度；本例不支持任意范围FP32。

## 部署与下一步

目标参照Thor T5000/Neoverse-V3AE；硬件规格沿[板卡说明](../../docs/arm/BOARDS.md)，实际板卡、OS、SDK与核拓扑未获取。Linux上先 `uname -a; lscpu; c++ --version`，再 `CXX=g++ sh build.sh release`，用`file build/example; ldd build/example`核对ELF/动态库，按可用拓扑选择taskset核心，不硬编码CPU编号。Mac Mach-O产物不能复制到Linux直接运行。

验收需包括两种布局/尾部/零值、四行独立性、转换与kernel同口径、温度频率记录、持续负载和业务输出误差；未完成板端环节不标产品闭环。下一项目增量是将形状/布局适配器接到一个真实推理入口，先检查收益是否覆盖转换成本。

追问：①lane轴如何由Mat定义？②dims=1为何改变归约方式？③FRSQRTE与FRSQRTS各做什么？④FMA误差为何不必逐位等于标量？⑤预打包能否代表完整请求？⑥Mac A64证据能证明哪些板端事实？
