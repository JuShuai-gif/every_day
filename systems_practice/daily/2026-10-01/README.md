# 2026-10-01 量化 GEMM：分组缩放与跨 tile 累加

## 工业场景

机器人视觉投影层 `A[32,65] × W[65,19] → Y[32,19]`，行主序，模拟小M、奇数N和K尾块。压缩驻留权重，并核对在线量化、搬运和同步的总成本。输入有限值，维度1..4096；W4/A4、W8/A8均为对称整数，A16明确为IEEE FP16存储，输出和跨组累加FP32。没有任务数据，不声明机器人精度或时延SLA达标。

今天只练 **group=32与K tile=16解耦**。框架承接[9月18日实现](../2026-09-18/session-02/README.md)，新增两tile共用scale、尾块和手算反例，并保留四位宽×五方法对照。算法入口同时给[原生PyTorch校准例子](../../quantization/2026-10-01/calibration/README.md)；C++侧沿用可运行参考以验证打包和CUDA数据合同，不把它叫PyTorch实现。

## 概念回顾

量化矩阵乘先要确定数值合同，再谈压缩。四位权重把两个有符号码放进一个字节，低半字节对应偶数逻辑索引，奇数长度最后只使用半个字节。解码必须恢复符号，不能把负数当成大正数。激活采用整数时，一组内先用三十二位整数累加，再乘激活和权重的尺度；激活采用半精度时，先转换为单精度参与乘加。格式相同不意味着算法相同，整数四位也不等于四位浮点。

尺度的共享范围与线程块的搬运范围是两个独立概念。今天沿归约维每三十二项共享一个权重尺度，而共享内存每次只装十六项。一个分组需要两个搬运阶段，部分和应跨阶段保留，在分组结束时才转换量纲。下一组有不同尺度时，必须先完成上一组的缩放。若把所有整数部分和合并后只乘最后尺度，常量或单组输入可能通过，多组异幅输入却会失真。

存储压缩还依赖校准数据。最大值定范围只是基线；通道缩放将激活难度转移到权重，离群通道另走半精度残差，校准与调参分离避免误差评价泄漏。训练感知量化则保留浮点主权重，前向经过舍入裁剪，反向使用明确的直通估计并真实更新参数。小样本重建误差下降不等于模型任务精度提升，分布漂移可能让先前冻结的范围大量饱和。

共享内存复用可以减少重复解码，却增加屏障和资源占用。尾线程必须参与同步，越界搬运填零，消费者读完才能复用同一块存储。比较优化前后时必须固定量化参数、输入和计时边界，不能靠更换精度获得虚假的速度收益。没有目标设备时，只能验证主机数值和索引合同，不能从压缩字节数推导内核速度。

## 知识图谱

`校准统计 → scale冻结 → signed nibble/INT8/FP16 → tile载入 → CTA屏障 → group部分和 → scale恢复 → 残差 → 输出`。

| 耦合机制 | 代码连接 | 前提 |
| --- | --- | --- |
| group量纲 / K tile复用 | quant_baseline、quant_tiled的g和offset双循环 | group=32，tile=16；切组时结算 |
| 真打包 / 有符号解码 | Packed::set/get、code<4>的bfe.s32 | 全矩阵连续打包，不是每行补齐 |
| 校准 / 泛化 | fit、calibrate、qat | seed101训练、202校准、303调参、404评估；shift只报告 |

源码关系见[source.json](source.json)。2026-10-01实际阅读[MIT SmoothQuant main smooth.py](https://github.com/mit-han-lab/smoothquant/blob/main/smoothquant/smooth.py)的`smooth_ln_fcs`/`smooth_ln_fcs_llama_like`/`smooth_lm`：原场景是将缩放吸收到Norm和后续Linear，保留`A/s × sW`等价机制，本例没有整网融合或transformers依赖，属于独立启发实现，非原库移植。MIT许可已核实。PyTorch v2.8.0观察器源码与固定commit见每日量化栏目。本次没有复用未读博客的性能数字。

## 编码练习

唯一任务25分钟：将本期副本的group从32改为64，同时维持tile=16，证明每个输出在正确分组边界恢复量纲。5分钟画g/offset/k表，10分钟修改合同及K=63/64/65测试，5分钟运行本机检查，5分钟填写Thor待验或实测对照。不要改旧归档代码。完整group32基线和优化候选已写好，默认最终候选`tiled`，收益未验证。附加栏目均为现成阅读材料。

## 文件说明

- [quant.hpp](src/quant.hpp)：打包、half转换、分组oracle、SmoothQuant启发缩放、离群残差、调参与真实QAT更新。
- [main.cpp](src/main.cpp)：边界、手算oracle、20组对照及40步训练日志。
- [quant_gemm.cu](src/quant_gemm.cu)：Thor正确性基线/最终候选、CUDA RAII和错误检查。
- [优化与ncu/ISA](OPTIMIZATION.md)、[运行](run.sh)、[验证](results/verification.json)。
- [今日量化HistogramObserver](../../quantization/2026-10-01/calibration/README.md)；[ARM09](../../arm/2026-10-01/README.md)；[OS04](../../os/2026-10-01/README.md)；[C++17 03](../../cpp17/2026-10-01/README.md)；[两篇论文](../../paper/2026-10-01/README.md)。

## 编译与运行

工作目录EveryDay根，C++17；不安装依赖。所有CUDA产物仅Thor SM110。

```sh
sh systems_practice/daily/2026-10-01/run.sh cpu
sh systems_practice/daily/2026-10-01/run.sh sanitize
sh systems_practice/daily/2026-10-01/run.sh gpu --check
sh systems_practice/daily/2026-10-01/run.sh gpu
```

官方[JetPack7.0归档](https://developer.nvidia.com/embedded/jetpack/downloads/archive-7.0)核实Thor/Jetson Linux38.2或38.2.1/CUDA13.0.0参考组合；[PTX目标说明](https://docs.nvidia.com/cuda/parallel-thread-execution/#ptx-module-directives-target)说明sm_110自PTX9.0引入。本期选CUDA≥13.0，CMake架构严格110，运行时拒绝非CC11.0；不采用a/f后缀。现场仍需采集驱动、ncu和L4T精确版本，参考组合不是当前设备验收。

## 正确性验证

INT4为[-7,7]、INT8为[-127,127]，zero point=0，量化取最近整数、半值远离零；half转换为ties-even。权重scale按`[ceil(K/32),N]`，激活scale为校准后全张量标量。全零scale=1。每组INT8绝对和上界`32×127²=516128`，未溢出INT32。A16在FP32累加；跨组FP32。离群通道低位权重置零，原始A/W转half后作为单独残差；不能重复计入。

CPU包括全部有限half往返、奇数nibble尾部、10种K、6种数值模式、零矩阵、非法维度，以及独立反量化GEMM对照。手算`32×1+1×10=42`，故意把组码合并乘最终scale得到330，说明单组测试不足。CUDA `--check`覆盖10种K×4种M×4位宽×2 kernel=320次对照，N=17；尚未运行。GPU容限`1e-3+1e-4*abs(ref)`，输出先NaN污染，检查非有限和漏写。

`qat`每格式40次实际master更新，前向真实round/clip/pack，固定scale、范围内STE导数1，梯度做对角预条件和投影；调参集选择checkpoint，允许选step0。它是单层重建训练，非完整模型QAT。最终代码字节变化与master更新单列，不能以master变化证明导出码变化。

## 性能分析

[OPTIMIZATION](OPTIMIZATION.md)给出完整定位、采集、源码关联和对照。本机CPU计时只为辅助实现：3预热+20采样的CPU packed GEMM中位数，不是GPU加速。Thor同输入固定model，20预热+100样本，event量单kernel；主机墙钟另测在线CPU缩放/pack+H2D+kernel+D2H+等待，驻留权重不重传，不含模型加载、相机或排队。离线fit/search/QAT不在推理计时内，主机与GPU数据不得交叉比速度。NPU未参与。

存储按实际payload长度计，metadata包括FP32 scales、通道s、离群索引、激活scale；不含vector对象、allocator容量和训练master。详细误差/饱和/存储/CPU时间表来自[最终输出](results/cpu.txt)，W4A4 absmax/离群处理的NRMSE实测22.7618%/1.9703%，总payload2150/2362字节（FP16输入加权重6630字节）；离群模式CPU packed GEMM中位数0.049792ms，FP32基线0.033291ms，因此CPU并未加速。shift后离群模式NRMSE63.9042%，比absmax18.5886%更差。W4A4 QAT更新46461次master值但调参选step0、最终导出码变化0，不声称训练收益。四位格式真实压缩不意味着Tensor Core性能。本期两个CUDA实现都是SIMT，尚无原生低位MMA路径。

## 实际运行结果

本期以启动时北京时间2026-10-01归档，最终验证实际在2026-10-02完成，见记录时间；不重复推进两天游标。本机Release与ASan/UBSan状态及结果见[验证](results/verification.json)，包含原始失败与最终日志。真实PyTorch例子因缺torch未运行；已交付的原生API不等于本机验证通过。CUDA编译、GPU执行、ncu、PTX/SASS生成及GPU性能均未验证，缺nvcc/ncu/Thor；不提供虚构ISA或速度收益。

## 工程注意事项

group不是线程块尺寸。候选减少重复载入/解码但没有消除shared读、两次屏障或单线程乘加依赖，small-M甚至可能退化。模型导出必须携带布局、group、dtype、scale、离群索引，不能只传字节数组。量化权重不对齐每行，N=19使相邻行起始nibble交替；GPU按逻辑线性索引解码。内存输入输出不别名。部署验收先做四位宽/五方法数值回归，再做sanitizer、连续负载和真实任务精度；仅当未profile的E2E达到预算才接受候选。

## 工业故障与面试追问

以下为合同推导案例，不是Thor现场事故记录。

| 触发→症状 | 最小诊断 | 根因→修复与代价 |
| --- | --- | --- |
| group改32后K33错 | 42手算、打印g/k/scale索引 | tile末提前清partial→按group结算；增加寄存器活跃期 |
| 奇数N第二行负数错 | 全码往返与N17/19 | 错把每行当字节对齐→线性nibble索引 |
| shift输入误差暴涨 | 同时看clip fraction和shift NRMSE | 冻结范围失配→重新独立校准；不能拿评估集挑scale |
| tiled比baseline慢 | 看独立计时、occupancy和barrier stall | 重用不足/屏障占比→按真实M分派或保留基线 |

追问：1. group与tile为什么可以不同？2. 何时可把scale提到K循环外？3. nibble符号扩展怎样验证？4. A16的“16”约束存储还是累加？5. QAT的真实更新为什么可能不改最终码？6. 低位压缩但E2E变慢应先测哪三个阶段？

## 自测问题

若group=64、tile=16、K=65，同时加入两个FP16离群通道，如何设计最小输入区分“部分和在tile边界清零”“scale在group边界错用”“离群贡献重复计入”这三种错误，并给出Thor上线前所需的验证证据？
