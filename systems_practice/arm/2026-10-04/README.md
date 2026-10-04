# 2026-10-04 ARM12：AoS/SoA、LD3与转换成本

## 速览与工作合同

承接多累加器课，今天解释“布局更适合SIMD，为何每帧反而更慢”。ROCK5B/RK3588相机CPU预处理为部署参照：UINT8 RGB AoS、独立行stride，输出`(R+2G+B)>>2`灰度，非标准颜色空间变换。学习目标是从48连续字节推导NEON三个寄存器的lane，并决定要不要提前转SoA。主要能力层是证据驱动优化；Mac仅作宿主验证。

[完整实现](src/main.cpp)：输入输出不重叠，由vector拥有；输入覆盖h*stride字节，输出w*h字节；宽高0合法，width≤100000、height≤100000、3w≤stride≤1000000；低层函数要求调用前validate及容量检查。示例内尺寸受控，不提供裸指针长度推断。所有算术整数精确，上界1020，右移截断。

## 数据变化与ARM机制

| 对象 | 变化（示意） | 本机真实指令 |
| --- | --- | --- |
| RGBRGB…共16像素 | lane i分别取字节3i/3i+1/3i+2 | direct函数`ld3.16b {v0,v1,v2},[x13],#48` |
| R+B和2G | U8扩为U16，上界510＋510 | `uaddl.8h`/`uaddl2.8h`、`ushll.8h`/`ushll2.8h #1` |
| 加和除4 | 下半8lane、上半8lane合为16字节 | `shrn.8b`、`shrn2.16b #2`、`str q1` |
| SoA | 三段分别连续读取16字节 | soa函数三条`ldr q`，无LD3 |

这是[实际生成汇编](results/apple-arm64.s)的摘录，不是预期伪指令。`LD3`是交错加载/解交错，读取48字节，绝非只取16字节。循环条件x+16≤w保证不跨行读取尾部；最后逐像素处理。基线scalar本次编译体是`ldrb/add/lsr/strb`，没有向量化；编译允许自动向量化，不能把结论推广到所有编译器。

## 源码阅读与独立关系

2026-10-04实际读取[ncnn mat_pixel.cpp](https://github.com/Tencent/ncnn/blob/master/src/mat_pixel.cpp) master、`from_rgb`的NEON加载/宽化/planar写入、scalar tail与wgap；BSD-3-Clause，文件头已核查。原路径把U8 RGB转FP32三平面；本课受启发独立实现整数灰度，保留stride、交错lane和尾部，省略Mat分配器/FP32转换/其他像素格式，未运行ncnn。

[Arm ACLE](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)核对`vld3q_u8`与A64 LD3映射；不假定SVE/SVE2。Google主课检索与知乎NEON搜索入口失败，未引用二手性能。今天布局主题不采用本地MMU PDF，相关OS栏目另有实际阅读。

## 已写好的公平对照与运行

```sh
sh systems_practice/arm/2026-10-04/run.sh release
sh systems_practice/arm/2026-10-04/run.sh sanitize
clang++ -std=c++17 -O2 -S systems_practice/arm/2026-10-04/src/main.cpp -o systems_practice/arm/2026-10-04/build/inspect.s
rg -n 'ld3|uaddl|ushll|shrn' systems_practice/arm/2026-10-04/build/inspect.s
```

Apple clang21/arm64，66种w=0..65、h=3、offset1、stride=3w+7，与独立scalar逐字节一致，输出哨兵与无效stride检查通过，Release和ASan/UBSan均退出0。量测31个样本，每个样本16次调用均值，预热20次；分配在计时外，pack+SoA计转换读写，SoA reused只计处理。不是单请求P95，tiny输入受时钟分辨率影响；Sanitizer耗时不作性能结论。

独立复测641×480、stride1930的CPU调用批均值P50/P95（us）：scalar 130.013/132.026，AoS LD3 13.3386/13.7943，SoA reused 9.24481/9.72919，pack+SoA 34.8229/35.8672。17像素SoA的P50落到0，表示计时分辨率不足，不能解释为零计算成本。主结果见[独立复测](results/standalone-benchmark.txt)，首轮/并行构建后的记录也保留。SoA单核可能更快，但每帧转换总成本更高；只在上游原生提供SoA或多次复用平面时考虑采用。输出观察sink防止消除，31次会重复使用热数据，不能当DDR带宽测量。

## 工作量推导与采用条件

direct逻辑流量为3N读＋N写=4N字节；pack先3N读＋3N写，SoA再3N读＋N写，合计10N，平面额外占3N字节。多次复用r次时理论比较`Tpack+r*Tsoa`与`r*Tdirect`；需要`r > Tpack/(Tdirect-Tsoa)`且分母为正。不能把逻辑字节当DRAM计数，真实缓存回写、预取和共享带宽需板端采样。scalar与NEON差异还包含编译器寻址及别名处理，不是单一LD3收益隔离实验。

## 故障链路与迁移验收

| 症状→假设 | 最小辨别证据→修复 | 代价/回归 |
| --- | --- | --- |
| 仅奇数宽错行→忘记stride/wgap | 用每行不同颜色+239padding检查；行首按stride重新计算 | 保留标量尾部；宽15/16/17与ROI偏移回归 |
| 单kernel更快但总预处理变慢→漏算转平面 | 比较SoA reused与pack+SoA两计时口径 | 优先融合LD3处理；多消费者时重算复用阈值 |
| 输出高亮溢出→U8先加再宽化 | 全255手算1020>>2=255 | 使用U16中间值；必须保持一致截断规则 |

本例R/B权重相同，不能检测RGB/BGR交换；真实彩色归一化接入必须用不同通道系数的独立oracle，这是当前验证边界。零拷贝还需要拥有者和设备同步，不是布局一改就完成。

板端先运行`uname -a; lscpu -e; clang++ --version`，读取设备型号与OS/SDK，确认Cortex-A76/A55拓扑后由实际CPU编号选taskset核心；用同脚本编译Linux ELF，不复制Mac Mach-O。预热后采温度/频率、perf list可用事件、连续负载与模型E2E；没有板卡时不写PMU/功耗结论。已核实的板卡资料入口见[设备说明](../../docs/arm/BOARDS.md)，今天未重新查询实板。

追问：①LD3各lane来自哪个字节？②为什么需要宽化？③stride与平面跨度怎么分别计算？④数据复用几次才值得packing？⑤逻辑流量与DRAM流量为何不同？⑥为什么此灰度例子检测不到RGB/BGR反转？

## 状态与下一课

来源读过、代码/本机汇编/正确性/CPU基准已验证；Linux交叉编译、RK3588/Thor CPU实板、摄像头和模型端到端未验。实际文本日志全部保留，不生成ARM日期JSON。下一课13：FP16存储、转换与累加的不同能力边界。
