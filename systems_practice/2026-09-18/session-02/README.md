# 2026-09-18 量化 GEMM：W4A4 / W4A16 / W8A8 / W8A16 与校准、离群处理、QAT

## 工业场景

机器人动作头的小矩阵投影：`Y[M,N] = A[M,K] × W[K,N]`，代表 Shape `[32,65]×[65,19]`。K=65、N=19 刻意包含分组与 tile 尾部。输入有固定的高幅通道，模拟视觉/语言特征的离群分布；另提供未在校准中出现的新离群通道，观察失配。数据为小型确定性合成数据，不代表真实模型任务精度，不下载模型。

**CUDA、PTX、SASS 唯一目标：Jetson Thor SM110。** 可在 Mac 验证真实打包和数值；Thor 代码完整交付但未编译运行。INT4/INT8 是有符号整数，不是 FP4/FP8；A16 在本工程明确为 IEEE FP16。输出和浮点组间累加均为 FP32。

| 格式 | 实际存储与矩阵乘 | 核心边界 |
| --- | --- | --- |
| W4A4 | 权重/激活各两个有符号4-bit数装入一个字节，组内INT32乘加 | 对称范围[-7,7]，未使用-8；非原生INT4 Tensor Core |
| W4A16 | 真实4-bit权重 + binary16激活，权重解码后FP32累加 | weight-only路径；不是将float数组改名为A16 |
| W8A8 | INT8权重/激活，组内INT32乘加 | 对称范围[-127,127]；非FP8 |
| W8A16 | INT8权重 + binary16激活，FP32累加 | scale和激活体积可能使总压缩收益很小 |

每个格式都运行 absmax、SmoothQuant-style、calibrated、outlier、qat，共20组。优化后默认 GPU 对照包含 `quant_tiled`，保留 `quant_baseline`；性能是否改善待 Thor 实测。真实低位打包、标量整数 MAC 和原生低位 Tensor Core 是不同概念，本工程只实现前两者。

## 概念回顾

低位量化的核心不是把数据类型改成整数，而是确定有限码值如何表示原始数值。本工程用对称量化、明确舍入和饱和，四位权重真实打包，沿归约维每十六个元素共享一个权重尺度。整数激活与权重先在组内用三十二位整数累加，再乘各自尺度并合并输出；组尺度不同，不能把全部整数结果先加完再乘一个尺度。十六位激活则保留半精度存储，解码后采用单精度累加。补齐尾部、符号扩展和尺度索引都是正确性条件。

与之耦合的是校准数据如何决定量化难度。朴素绝对最大值容易被少量大幅通道牵制。平滑缩放将激活除以通道尺度，同时把权重乘以同一尺度，未量化时矩阵乘不变，但两侧舍入误差的分配改变。尺度太偏向一侧会把困难转移到另一侧，因此需要依据校准统计构造候选，再用独立调参集的输出重建误差选择，而不能拿评估集挑最小误差。离群通道还可拆到半精度残差乘法，但必须计入额外权重、激活与索引成本。

量化感知训练进一步把量化后的前向放进训练循环。本例固定校准尺度，保留单精度主权重，前向实际舍入、裁剪和打包，反向在裁剪区内用直通估计更新主权重，以浮点教师输出作为重建目标。四十次更新是真实训练，不是只调用一次伪量化；最终检查点由调参集选择，可能仍是训练前状态。训练损失降低不保证未知输入更好。

这些机制最终都要落到相同矩阵乘和明确的成本边界。打包减少的是表示体积，解码、缩放、离群残差和同步仍消耗时间。应分别看数值误差、饱和率、包含元数据的存储、内核与端到端延迟，并保存分布变化后的退化结果。没有设备测量不能把压缩倍数等同于加速倍数。

## 知识图谱

| 耦合关系 | 代码位置 | 必须守住的边界 |
| --- | --- | --- |
| 数值范围 → packed representation → MAC | `Packed`、`quantize`、`packed_gemm` | 4-bit二补码符号扩展；奇数元素尾部；INT32组内累加与组间scale |
| 校准统计 → SmoothQuant-style重参数化 | `fit`：`A'=A/s, W'=sW` | 未量化等价性检查；权重与激活必须使用同一s |
| 输出重建目标 → scale/clip选择 | `calibrate` | calibration统计与validation打分分开；evaluation不参与选择 |
| 离群通道 → mixed precision residual | `fit`、`prepare`、`packed_gemm` | 主路置零避免双计数；残差使用原始A/W的FP16表示 |
| fake quant → STE → master weight更新 | `qat` | 固定scale，40步更新，记录实际变化与checkpoint选择；无端到端模型训练承诺 |
| packed decode → tile复用 →同步 | `quant_baseline` / `quant_tiled` | 全CTA装载/消费/覆盖同步，边界线程不能提前退出 |

数据分离：train 48行（seed101），calibration 48行（202），validation 32行（303），evaluation 32行（404）；权重seed11。shifted是评估集第4通道额外放大30倍，仅用于最后的失配报告。

## 编码练习

**一个25分钟任务：用独立validation的GEMM重建误差选择scale，替代只使用absmax或固定alpha。** 完整框架与五种方法已交付，练习只聚焦这个选择点，不要求25分钟从零实现所有量化算法。

1. 5分钟：运行CPU表格，阅读 `fit` 的分组scale、平滑变换与 `packed_gemm` 的组内整数累加。
2. 12分钟：理解并重建 `calibrate` 的候选评估：保留absmax候选，枚举alpha、激活clip、权重clip，用validation输出MSE选择；可增加一档alpha，但不能用evaluation打分。保持各格式相同矩阵乘语义。
3. 8分钟：重跑正确性与20组对照，比较正常/shifted误差和额外存储；检查QAT是否真的改善独立评估，而不是只看训练损失。Thor可用时运行baseline/tiled的ncu对照。

## 文件说明

- [src/quant.hpp](src/quant.hpp)：C++17矩阵、IEEE FP16、真实4/8-bit打包、整数/weight-only GEMM、校准、SmoothQuant-style、离群残差、手工STE QAT。
- [src/main.cpp](src/main.cpp)：独立反量化oracle、边界检查、20组CPU比较、QAT训练日志。
- [src/quant_gemm.cu](src/quant_gemm.cu)：Thor SM110 FP32参考、量化基线和shared tile优化kernel，RAII、误差与计时、独立profile入口。
- [run.sh](run.sh)、CMakeLists.txt：本机与目标构建；[profile.sh](profile.sh)、[export-isa.sh](export-isa.sh)：ncu与真实PTX/SASS导出。
- [KERNEL_ANALYSIS.md](KERNEL_ANALYSIS.md)：优化过程、ncu操作、指令/架构分析。
- [结果摘要](results/comparison.md)、[原始Release日志](results/cpu.txt)、[验证范围](results/verification.md)。

源码来源与关系（读取尝试日期2026-09-18）：

| 仓库/具体文件 | 拟阅读符号与原场景 | 本次关系与简化边界 |
| --- | --- | --- |
| [mit-han-lab/smoothquant](https://github.com/mit-han-lab/smoothquant)，main：[smoothquant/smooth.py](https://github.com/mit-han-lab/smoothquant/blob/main/smoothquant/smooth.py) | 拟检索`smooth_ln_fcs`/`smooth_lm`，模型层间平滑与量化迁移 | 请求失败，未核实符号正文；本次独立实现数学重参数化，不声称复现模型层融合 |
| 同仓库 [smoothquant/fake_quant.py](https://github.com/mit-han-lab/smoothquant/blob/main/smoothquant/fake_quant.py) | 拟检索量化Linear/激活权重fake quant路径 | 请求失败；本次真实打包的单层GEMM与其实现关系未经源码比对 |
| [pytorch/pytorch](https://github.com/pytorch/pytorch)，main：[torch/ao/quantization/fake_quantize.py](https://github.com/pytorch/pytorch/blob/main/torch/ao/quantization/fake_quantize.py) | 拟阅读`FakeQuantize`，训练时观察器与伪量化 | 请求失败；手工STE与更新是独立最小QAT，不是PyTorch API复刻 |
| 一手论文 [SmoothQuant](https://arxiv.org/abs/2211.10438) | 平滑重参数化的算法依据，拟作网络失败后的替代一手资料 | 正文同样未取得；不声称本次完成论文逐条复核 |

web读取连接失败，curl raw GitHub返回DNS失败，详见原始 [source-read.txt](results/source-read.txt)。没有复制未读源码，没有将首页或记忆归因为实际源码参考；精确commit未取得。CUDA/PTX/ncu能力的设备验证同样待完成。

## 编译与运行

Mac已有AppleClang/CMake，无额外依赖或模型：

```sh
./systems_practice/2026-09-18/session-02/run.sh cpu
./systems_practice/2026-09-18/session-02/run.sh sanitize
```

Thor选定CUDA Toolkit 13.0+、CMake≥3.18、C++17与兼容JetPack/L4T/驱动；本机未验证具体软件栈组合。所有设备源码有SM110编译/运行检查：

```sh
./systems_practice/2026-09-18/session-02/run.sh gpu
# 同一profile入口只包一个kernel；校准/QAT在采集范围外。
./systems_practice/2026-09-18/session-02/profile.sh W4A4 outlier baseline
./systems_practice/2026-09-18/session-02/profile.sh W4A4 outlier tiled
./systems_practice/2026-09-18/session-02/profile.sh W4A4 outlier fp32
./systems_practice/2026-09-18/session-02/export-isa.sh
```

模型权重、激活、校准与QAT数据都由CPU生成。GPU默认运行20组baseline/tiled比较，并运行一次同Shape FP32参考；没有自动加载或训练大型模型。

## 正确性验证

实际CPU检查：所有有限FP16位模式往返与ties-even中点；INT4/INT8有符号码值往返和奇数尾部；K=1/15/16/17/65、M=3/N=5的组尾处理；零激活/权重scale；非法矩阵维度；packed MAC与独立“完全反量化→普通GEMM→残差”oracle最大差 <1e-3。所有平滑配置另验证未量化 `A'W'≈AW` 的 NRMSE<1e-6。

量化损失是待比较的结果，不要求低比特与原始FP32完全相等。GPU正确性对照是CPU的**同量化模型oracle**，逐元素误差容限 `1e-3+1e-4*abs(reference)`；随后另外报告相对原始FP32的NRMSE。每版运行前毒化输出，精度检查不从性能路径移除。

```sh
compute-sanitizer --tool memcheck systems_practice/2026-09-18/session-02/build/gpu/quant_gpu --profile W4A4 outlier tiled
compute-sanitizer --tool racecheck systems_practice/2026-09-18/session-02/build/gpu/quant_gpu --profile W8A8 calibrated tiled
compute-sanitizer --tool synccheck systems_practice/2026-09-18/session-02/build/gpu/quant_gpu --profile W4A16 qat tiled
```

以上Thor命令未执行。输入模型限定有限数值，FP16溢出需显式拒绝或通过部署校准避免。合成单层指标不能替代真实VLA/视觉模型的任务精度测试。

## 性能分析

CPU每条路径3次预热、20次测量，中位数含输出vector分配，排除输入预量化/packing和离线拟合。FP16参考将舍入后的值展开为FP32计算，不是CPU原生半精度加速。朴素packed CPU解码可能慢于FP32，这是实测教学对照，不作为部署速度结论。

Thor GPU event：20次预热+100次单kernel采样；端到端另20次预热+100次，包含在线CPU缩放/量化/packing、pageable H2D、GEMM含残差、D2H和等待。权重与scale已驻留；离线calibration/QAT、模型初始化与权重首次上传不计入该在线边界。FP32参考无量化预处理。报告kernel与主机链路各自p50/p95，不把二者混称NPU或完整控制系统延迟。

存储分别列权重packed payload、残差权重、scale/平滑系数/索引、激活payload及残差。比较基准是相同A/W的理论dense FP16 payload 6,630 B，计入量化metadata后再算比值；不是进程RSS、vector容量、训练master weights或CUDA allocator占用。无激活复用或更大Batch时比值会变。

最终GPU优化候选为 `quant_tiled`：每个8×16输出tile将16个K元素装入shared，一次解码在多行/列间复用，两个CTA屏障保护消费/覆盖。它减少重复global读取与位解码，但有shared、同步和尾块空闲成本；没有Thor实测不能断言更快。细节见 [KERNEL_ANALYSIS.md](KERNEL_ANALYSIS.md)。

## 实际运行结果

Release与ASan/UBSan都编译运行通过；20组结果和QAT轨迹一致。完整表见 [comparison.md](results/comparison.md)：

- W4A4：absmax NRMSE **22.7527%**，SmoothQuant-style **10.5821%**，校准缩放 **9.4600%**，校准+离群残差 **1.9250%**。
- W8A8：absmax **1.9212%**，校准+离群残差 **0.1173%**。
- W4A4离群方案总计 **2,514 B**，相同FP16 payload为6,630 B，约 **2.637×**，包含额外scale/residual成本。
- 新增未校准离群通道后，W4A4离群方案 NRMSE 上升至 **63.9467%**；不是所有误差下降都能泛化。
- QAT四种格式都执行40步、产生数万次master参数变化；三种格式的validation选回step0，W8A8选step1但独立评估略退化。保留完整失败/无收益结果，未谎称QAT必然更准。

本机CUDA配置实际失败 `Failed to find nvcc`；ncu/ISA脚本分别因缺少ncu/nvcc退出127。GPU编译、性能、真实SASS、Tensor Core吞吐和设备功耗均未验证。日志见 [verification.md](results/verification.md)。

## 工程注意事项

SmoothQuant-style只实现数学重参数化，没有把scale融合进真实模型的LayerNorm；线上 `prepare` 的除法/量化必须计入成本。outlier方法固定选校准amax最大的两个通道，不是完整动态LLM.int8异常分解；主路和残差路不可双计数。权重对每输出通道、每16个K元素一个scale，激活采用校准后的静态tensor scale；A16没有整数激活scale。

校准搜索alpha∈{0,.25,.5,.75,1}、Aclip∈{1,.95,.9}、Wclip∈{1,.95}，同时保留不平滑的absmax候选；A16的Aclip固定1。目标是validation输出MSE，不是输入量化误差。QAT在calibrated+outlier基础上训练非离群主权重，scale及残差权重固定，用有界STE、对角预条件梯度下降和投影；不是完整模型QAT，不学习scale或激活统计。

代码默认矩阵尺寸1..4096，INT8组内最大绝对乘加≤16×127²，INT32范围足够。4-bit/8-bit的最负码位未使用；序列化格式不能不加转换就传给假定另一套zero-point/packing的库。是否采用Thor原生矩阵指令，要在官方支持、布局与精度约束核实后单独实现和实测。

## 工业故障与面试追问

以下是设计风险；本次CPU分布失配和QAT无泛化收益已实际观察，GPU诊断尚未运行。

| 触发 | 现象 | 根因 | 最小诊断 | 修复/取舍 |
| --- | --- | --- | --- | --- |
| 新离群通道不在校准分布 | shifted NRMSE大幅上升 | 静态scale和残差通道集合失配 | 对照正常/shifted误差、量化饱和情况 | 扩充代表性校准或动态策略，计入在线成本 |
| INT4高半字节符号扩展错误或奇数尾元素越界 | 输出偏置、越界 | packing契约与解码不同 | 全码值往返、odd-tail、memcheck | 固定二补码/位序/逻辑长度，不能只比较压缩文件大小 |
| group尺度不同却只在最后乘一次scale | 数值错误且随K分组变化 | 丢失组边界 | 独立反量化GEMM oracle | 逐组INT32累加并缩放，正确处理尾组 |
| QAT训练损失下降而评估变差 | validation选旧checkpoint或eval回退 | 样本有限、STE近似、过拟合/优化不稳定 | 记录before/last/selected与独立eval | 保留独立验证和无收益结果；不保证多训练必然有效 |

面试追问：

1. W4A4、NVFP4、FP8分别约束哪种数值表示，位数相同为什么不是同一GEMM？
2. per-group权重scale为什么改变整数累加的缩放位置，尾组怎样处理？
3. `A/s × sW`为何未量化等价，量化之后误差却随alpha变化？
4. 离群残差如何避免主路双计数，额外payload何时吃掉压缩收益？
5. QAT中的master weights、fake quant前向、STE反向与最终packed权重有什么关系？
6. ncu看到位解码指令减少但延迟不降时，应怎样检查shared屏障、驻留资源和在线packing？

## 自测问题

如果W4A4在正常评估集比absmax更准且存储更小，但新离群通道出现后误差激增，同时Thor端到端耗时比FP16参考更长，你会如何分别检查校准数据、scale/残差策略、packed GEMM与在线预处理边界，并决定是否保留这个部署方案？
