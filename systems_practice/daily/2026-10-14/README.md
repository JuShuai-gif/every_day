# 2026-10-14 量化 GEMM：分组累加与真实位打包

## 工业场景

机器人视觉编码器投影层 `Y=A Wᵀ`，代表输入 `[M,K,N]=[31,33,17]`；W按`[N,K]`行主序保存，小M和K尾块使元数据、解码及启动开销突出。目标是让四种位宽的导出/执行合同一致，再判断shared复用是否值得。训练、校准、调参、评估分别64/64/32/31行，随机种子20261014；都是合成单层输入，不能解释成任务准确率。目标约束：输入有限、K≤4096、group=16、输出FP32、禁止静默截断尾部；生产时延预算由板端E2E回归决定，本课不杜撰实时保证。

## 概念回顾

低位矩阵乘的难点不只是把浮点数除以一个比例，而是让训练、导出和内核消费同一份数值合同。这里权重按输出通道分行，再沿输入维度每十六个元素分组。四位整数使用补码，一个字节存两个码字，低半字节在前；八位整数直接存一个字节。量化采用对称区间，零点为零，四位只使用负七到正七，保留负八不用。尾组只包含真实元素，填充位不贡献输出。若把高半字节读成无符号数，负权重就会变成大正数，即使文件大小完全正确，推理也会系统性偏移。

第二个耦合机制是组内累加与组间缩放。整型激活和权重先以三十二位整数点积，随后乘该输入行与输出通道的两个组比例，再加入浮点输出；不同组不能先混成一个整数和再统一缩放。十六位激活在此明确为半精度存储，读取后转单精度，与解码整数权重计算单精度点积，再应用权重比例。这是可检查的标量执行合同，不意味着已经使用低位张量核心。共享内存候选只改变解码和读取复用，不改变比例位置、输出数量或误差标准。

缩放与训练也必须服从同一合同。平滑把激活除以通道比例、权重乘以相同比例，在量化前保持乘积等价；它把困难从激活转移到权重，并不保证每个分布都获益。离群通道从低位主体清零后单独计算半精度残差，索引与残差存储需要计入成本。校准集提供统计，调参集选择比例与裁剪，评估集只报告结果。量化感知训练维护浮点主权重，前向走量化再反量化，反向以直通估计传播舍入梯度并屏蔽裁剪区外梯度；实际更新之后仍须硬化、打包和重载检查。训练误差下降而评估退化也必须保留。

## 知识图谱

`校准统计 → 通道s → A/s与sW → 每行/每组scale → signed nibble → INT32局部和 → FP32组间和 → 输出误差`。

- 前置：FP16存储、补码、row-major、CTA屏障、校准与评估隔离。
- `experiment.py:quant/pack/grouped_gemm/train_qat`是独立算法实现；`src/data.hpp`是另一语言的解码oracle；`src/gemm.cu:qgemm_baseline/qgemm_tiled`是Thor候选。
- INT4不同于FP4/NF4；W4A16中的A16固定FP16；QAT是训练范式，OmniQuant是校准优化方法；fake quant不压缩存储。
- 组内最坏INT8整数和≤16×127²=258064，INT32安全；若将整个K或batch混入同一累加器，需要重新证明。

实际读过[MIT SmoothQuant](https://github.com/mit-han-lab/smoothquant/blob/main/smoothquant/smooth.py) `smooth_ln_fcs/smooth_lm`（main，2026-10-14，MIT）：原场景在LLM LayerNorm和多Linear间融合通道缩放。本课保留`A/s,sW`等价性，省略Transformer、LayerNorm融合和torch-int后端，属于受启发的独立实现；源码哈希及阅读范围见[source.json](source.json)。[OmniQuant原生LWC](../../quantization/2026-10-14/omniquant/README.md)合并为今天的量化方法讲解，使用其真实API；不把独立STE训练归为OmniQuant复现。

## 编码练习

唯一必做任务，25分钟：阅读已完成的两版kernel，围绕`qgemm_tiled`的最后一组加一个可控尾部污染输入检查，确认K=15/16/17/33/65时无效元素为零、所有线程仍参加两次屏障；在Thor按相同fixture比较两版。建议5分钟核对码字/scale、10分钟改一个尾部断言或输入、10分钟运行与记录。Mac先做现成CPU验证；板端测试待设备具备后执行，不增加第二个任务。

基线每输出重新解码A/W，候选每16×16 tile把A/W解码到shared，`wi[16][17]`缓解读列bank冲突。理想完整tile中A/W解码逻辑次数各由4096降至256，但这是算法计数，不是DRAM事务实测。两次同步和约3KiB shared可能使小M退化；默认比较入口保留两版，最终候选名tiled，尚无收益证明。

## 文件说明

- [experiment.py](experiment.py)：absmax、SmoothQuant思想、离群残差、校准搜索、实际STE更新和28个fixture；NumPy为本机已有依赖，算法不强制C++化。
- [CUDA](src/gemm.cu)、[CPU解码](src/data.hpp)、[构建](build.sh)、[运行](run.sh)、[分析脚本](profile.sh)、[详细分析](PROFILING.md)。
- [独立量化OmniQuant](../../quantization/2026-10-14/omniquant/README.md)、[ARM21](../../arm/2026-10-14/README.md)、[OS16](../../os/2026-10-14/README.md)、[C++17第15课](../../cpp17/2026-10-14/README.md)、[两篇论文DBW/TaSQ](../../paper/2026-10-14/README.md)均为现成附加材料。

## 编译与运行

从仓库根目录：

```sh
PYTHON=/Users/guhaoran/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 sh systems_practice/daily/2026-10-14/run.sh
SANITIZE=1 sh systems_practice/daily/2026-10-14/build.sh
systems_practice/daily/2026-10-14/build/check systems_practice/daily/2026-10-14/build/case-*.bin
# 仅Thor：使用已有NumPy环境与CUDA13+ Jetson配套工具链
CUDA_BUILD=1 PYTHON=python3 sh systems_practice/daily/2026-10-14/run.sh
sh systems_practice/daily/2026-10-14/profile.sh
```

Apple clang21、Python3.12.14/NumPy2.3.5为本机环境。固定CUDA13支持`sm_110`，[官方Thor安装指南](https://docs.nvidia.com/jetson/agx-thor-devkit/user-guide/latest/setup_cuda.html)实际提供CUDA13.0示例；[nvcc13目标表](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-compiler-driver-nvcc/index.html)列出sm_110。未取得用户板卡，JetPack/L4T/驱动/ncu具体组合仍待采集。主机程序拒绝非计算能力11.0设备；不切到其他架构或专属后缀。

## 正确性验证

三层验收分开：NumPy对原FP32/FP16比较误差；C++独立解码28个fixture，对NumPy导出的量化结果比对；Thor两版对同一oracle比较`abs(error)≤3e-4×(1+abs(expected))`，非有限值拒绝。CPU成功不证明CTA同步或CUDA指令正确。

边界含奇数nibble、负码字、零矩阵、跨组尾部、空K拒绝；C++头部检查magic/位宽/shape/组数/截断/多余字节。所有二进制仅生成到忽略的build。权重文件实际写入packed+FP32组scale+FP32通道s，离群版另含uint32索引与FP16残差权重；不把码字payload当完整模型文件。

## 性能分析

CPU日志口径为一次`evaluate`的量化、打包、CPU分组GEMM、残差及检查总时间，不含文件I/O、训练和传输；3次预热、11样本P50。另列FP32 NumPy GEMM与FP16存储解码后FP32 GEMM参考时间，以及离线搜索/训练时间，后者不计在线收益。CUDA用10次预热、50次单launch event测量，内核外分配/拷贝，端到端仍未测。不能把两个计时域计算加速比。NPU完全未运行。

[PROFILING.md](PROFILING.md)给ncu定位、launch筛选、section/metric查询、源码关联及热点假设。理论架构对照从昨日Ada轮到**Turing**，执行目标始终Thor SM110；INT4 TC存在不说明这个SIMT解码内核用了它。

## 实际运行结果

见[原始数值与训练日志](results/experiment.json)、[验证状态](verification.json)、[最终CPU日志](results/release.txt)。下表NRMSE为独立评估集，量化后相对原FP32，非模型任务精度：

|模式|absmax|smooth|离群残差|校准搜索|QAT选择结果|
|---|---:|---:|---:|---:|---:|
|W4A4|0.153753|0.078814|0.044831|0.078814|0.078073|
|W4A16|0.078485|0.064571|0.031900|0.048166|0.048415|
|W8A8|0.010108|0.004154|0.002546|0.004154|0.004197|
|W8A16|0.005340|0.003287|0.001801|0.002527|0.002582|

QAT确实完成80步更新，W4A4主权重L2变化0.04427；其他模式出现评估退化，不隐去。新离群方向下W4A4 smooth NRMSE=0.250911，absmax=0.129763，说明校准失配。W4/W8普通权重文件617/897B，离群655/935B，原FP16权重1122B；文件比包含通道scale，不等于显存峰值或压缩后推理收益。真实PTX/SASS、GPU性能和功耗未验证。

## 工程注意事项

执行路径是packed输入→SIMT解码→INT32或FP32点积，非原生INT4/INT8 Tensor Core benchmark。QAT训练的权重scale冻结，推理沿用同一scale；重新absmax会改变前向合同。导出后应保留shape、group、符号和端序清单，本fixture为小端；生产还需版本/checksum/错误恢复。Smooth与离群的在线预处理成本不能从E2E中消失。

## 工业故障与面试追问

1. 仅跨group输出错误→怀疑scale移到K循环外→比较K16/17并打印两组scale→组内INT32先结算→回归组数和饱和边界。
2. 奇数K负数偏移→怀疑nibble行边界/符号→逐码比较独立C++解码→用全矩阵flat索引，符号扩展，尾nibble补零→回归K1/15/33。
3. 小M优化变慢→可能同步/无效线程占比高→无profiler event+Scheduler/LaunchStats交叉检查→保留基线分派阈值，实测决定，不能删除屏障。
4. 训练loss降而线上误差增→校准分布或数据泄漏→独立shift评估和数据集哈希→重校准/回退高精度，核对额外成本。

面试追问：①W4A16的16具体是哪种格式？②为何每组需要自己的比例？③K无限增长时INT32界限怎样推导？④为何尾部线程不能提前return？⑤shared复用可能在哪些shape亏损？⑥QAT更新后为何还要硬化重载？

## 自测问题

如果把两个相邻group的整数点积先相加，再只乘其中一组的scale，在什么条件下仍与原实现等价；怎样用最小矩阵同时暴露这个错误和负nibble解码错误？
