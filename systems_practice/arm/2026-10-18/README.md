# 2026-10-18 ARM24：RGB→CHW与归一化融合

## 5–10分钟速览与工作合同

承接23课解码融合：这次把RGB uint8读取、通道拆分、FP32归一化合在同一次遍历。核心ARM机制是结构化加载LD3把交错字节拆到三个NEON寄存器，再扩宽和转换。工作能力层为“证据驱动优化”；主线设备为ROCK 5B/RK3588（Cortex-A76/A55），用于RKNN前的CPU图像准备。本机Apple Silicon验证只能证明Mac数值/指令/计时，不证明板端性能。

输入H×W×3、行跨度`3W+padding`，输出3×H×W连续FP32，公式`(pixel-mean[c])*scale[c]`。W/H允许0，最大4096，stride≤65536；教学向量拥有整个输入，不接收悬空ROI。没有resize、BGR交换、alpha、NV12或RKNN绑定。实际模型若在Toolkit再次配置相同归一化会改变数学合同，接入点是上传输入前唯一的预处理层。

## 数据如何变化

| 阶段 | 小样本/每8像素操作 | 意义 |
| --- | --- | --- |
| 原始RGB | `[0,10,20,30,40,50]` | 两个像素，通道不同 |
| 分离lane | R=`[0,30]`，G=`[10,40]`，B=`[20,50]` | LD3不等于普通连续LD1 |
| 扩宽 | u8→u16→u32 | 255不能按有符号8位解释 |
| 转换/归一化 | UCVTF；减均值；乘scale | FP32语义，禁用收缩 |
| CHW输出 | `[-2.12069,-1.60345,-1.87719,-1.35088,-1.42373,-0.915254]` | 此行来自实际运行 |

示意8lane来自intrinsic合同；上面的两像素数值来自标量尾部，用于追踪通道，不冒充两像素执行了LD3。8/9等宽度由同一oracle验证向量段与尾部交界。

## 源码与ARM机制

2026-10-18实际读[ncnn仓库](https://github.com/Tencent/ncnn) master的[src/mat_pixel.cpp](https://github.com/Tencent/ncnn/blob/master/src/mat_pixel.cpp) `from_rgb`（16–126行的AArch64 intrinsics/尾部），以及[src/mat.cpp](https://github.com/Tencent/ncnn/blob/master/src/mat.cpp) `Mat::substract_mean_normalize`三分支。版本为读取日期/分支，精确commit未固定，SHA256见下方；BSD-3-Clause。原场景是像素转Mat后调用Scale/Bias层。本课独立启发：保持拆通道、扩宽、行尾gap，独立写`convert<Fused>`；没有复制ncnn汇编或层运行时，也不声称ncnn整体采用本例融合策略。

实际阅读Arm官方[结构化加载案例](https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/coding-for-neon---part-1-load-and-stores)的RGB、交错模式、寻址章节；文章以AArch32语法示例，不照抄成A64。用[ACLE](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)核对`vld3_u8/vmovl_u8/vcvtq_f32_u32`。Google检索页面取得，知乎搜索403，没有采用二手性能数字。本期图像机制不涉及本地MMU PDF，未把该资料当NEON依据。

[最终真实汇编](results/final-main.s)中`convert<true>`向量循环为`ld3.8b {v21,v22,v23},[x8] → uaddw.8h → sshll.4s → scvtf.4s → fmul.4s`，高4lane用`ushll/ext/add/sshll`处理。这里出现了值得学习的编译器变换：mean为123/117/104等小整数，pixel减均值仍可精确表示，编译器把减法移到整数扩宽阶段，用16位负均值常量与像素相加，再按带符号结果扩宽、SCVTF转FP32。并非源码每个intrinsic都机械对应一条指令。减后范围如R通道[-123,132]，没有16位溢出语义问题；若改为非整数mean，不能假定仍生成同一序列。

baseline向量段仍可观察USHLL/UCVTF，先保存FP32再遍历归一化；候选把这些中间值留在寄存器，最终STR写CHW。LD3读取24字节产生3×8lane，扩宽不会创造新像素。生成汇编存在不等于吞吐已提升，下面计时独立验证。

## 对照、成本与观察命令

标量`reference`独立按channel/y/x索引；baseline `convert<false>`先做NEON转换再第二遍归一化，candidate `convert<true>`就地完成。两版同输入、输出和FP32操作顺序，不用标量慢基线夸大融合收益。

每像素逻辑流量：分步读取3B、写中间12B、读12B、再写12B，总39B；融合读3B写12B，总15B，理论省24B/像素。它不是DRAM实测量：写分配、缓存复用、prefetch、分配清零会改变实际流量。融合增加同时存活的寄存器与算术链，小图常由调用/分配支配，故必须分别测预分配和含分配版本。

```sh
sh systems_practice/arm/2026-10-18/run.sh release
sh systems_practice/arm/2026-10-18/run.sh sanitize
clang++ -std=c++17 -O3 -ffp-contract=off -S systems_practice/arm/2026-10-18/src/main.cpp -o systems_practice/arm/2026-10-18/build/main.s
rg -n 'convertILb1|ld3|ushll|ucvtf|fmul' systems_practice/arm/2026-10-18/build/main.s
```

5次预热，31批，每批5次，报告批均值中位数；不是请求P95。noinline和编译屏障防止消除调用，输出再次核对oracle。普通标量oracle可被自动向量化，baseline也使用NEON；比较的是融合，不是“C++对汇编”。固定版本测量顺序仍有频率/缓存/热状态混杂，release并行构建期间的原日志保留，最终独占重测见results/final-benchmark.txt。

## 工业故障与生产取舍

1. 奇数宽图像最后一列颜色异常→跨行向量读或stride当width→用W=7/8/9、padding=5和ASan定位→完整8像素才LD3，剩余标量；不能依赖相机padding永远可读。
2. 单通道整体偏移→RGB/BGR顺序或重复归一化→用两个已知像素逐lane核验并比较模型输入统计→固定通道合同且归一化只做一次；切模型时重跑输入金样。
3. 内核快但服务慢→分配/清零、布局转换或上传新增→分别测预分配/含分配/设备请求；若目标模型原本需要NHWC，CHW可能是多余搬运，应保持真实模型合同。

采用条件是目标shape误差通过且端到端不回退；没有RK3588测量，不作上线选择。短图差异接近计时粒度，不据此宣称稳定收益。

## 验证证据与迁移验收

Apple clang21/macOS arm64：54种shape/padding组合、2非法stride/storage拒绝，Release与ASan/UBSan逐位等于oracle。原始[初次日志](results/initial.txt)、[Release](results/release.txt)、[Sanitizer](results/sanitize.txt)全部保留。最终CPU数字见末段。没有JSON附属记录，未恢复已删除的ARM日期JSON。

[Radxa官方产品介绍](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)今日已核对；板卡OS/内核/RKNN Runtime、CPU拓扑、温度与频率没有现场数据。板端先执行`uname -a`、`lscpu -e`、`cat /etc/os-release`，核对CPU容量/拓扑后选择实际核，不能假定CPU编号。板端用`CXX=g++ sh run.sh release`（在本课目录），或用真实sysroot的`aarch64-linux-gnu-g++ -std=c++17 -O3 -ffp-contract=off src/main.cpp -o build/target`；检查ELF/动态加载器后再部署。Mac Mach-O不能直接放到Linux运行。

验收：保存真实相机shape/stride及模型输入dtype；A55/A76分别固定线程/核测试；保持输出与FP32参考一致；测CPU预处理、上传、NPU推理和端到端；采样温度/频率、持续负载并保留无收益结果。PMU先`perf list`查本板事件，记录可用计量域；今天没有PMU数据。

追问：LD3为何适合RGB？两次扩宽分别解决什么？为什么padding不是有效像素？理论少24B为什么不等于带宽必然减少24B？为何含分配与预分配要分开？A55与A76为什么可能有不同融合收益？如何发现归一化执行两次？

下一节25：运行时能力分派，保证扩展缺失仍能走合法基础路径。

本次读取的ncnn快照哈希：

- pixel.cpp: `1c1e2456c17026aadaf9ef371aa571c9bf676402959bbe1e3e075957755b986a`。
- mat.cpp: `fd08cc010f6f1da2e342df9ac31b2faf8f509e63ac54f1b043afad1f7f84c2e9`。

最终独占Mac复测（[final-benchmark.txt](results/final-benchmark.txt)）：W641×H480预分配split/fused批均值P50 **128.275/78.1668µs**；含分配142.558/93.1666µs。W9×H3预分配均为0.0166µs，未观察到融合收益。最终边界修订后Release/ASan/UBSan再次通过，见`results/final-release.txt`和`results/final-sanitize.txt`。这些数字只属于此Mac、固定顺序和热缓存条件；没有RK3588/DRAM/PMU因果证据。
