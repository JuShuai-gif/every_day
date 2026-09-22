# Thor SM110 量化 GEMM：从真实打包到 tile 复用

## 数值契约先于优化

矩阵为行主序 `A[M,K]`、`W[K,N]`，权重scale布局为 `[ceil(K/16),N]`。W4/A4每字节低半字节存偶数索引、高半字节存奇数索引；符号码采用二补码。数值范围仅使用[-7,7]，并非[-8,7]非对称量化。W8/A8使用[-127,127]；零点固定0。

对整型激活：

```
y[m,n] = sum_g(scale_A * scale_W[g,n] * sum_{k in g}(qA[m,k]*qW[k,n]))
         + sum_{o in outlier}(FP16(A[m,o]) * FP16(W[o,n]))
```

组内是INT32乘加，组间缩放及输出是FP32；最大16×127²=258064，INT32安全。对A16，组内改为binary16激活转FP32后与整数权重相乘，乘本组weight scale后合并。残差通道的主路A/W码均为0，避免双计数。

离群方案仍为完整矩阵保留零码位置，因此payload计算没有假设额外稀疏压缩。它只把最难量化的两条通道交给FP16残差，并实计残差成本。

## 基线到最终优化候选

`quant_baseline<WB,AB>` 每线程负责一个输出，重复读取并解码同一个A行/W列。优点是直接、无共享同步；缺点是相邻输出重复解码。

`quant_tiled<WB,AB>` 以8×16个输出为一块，128线程；K tile为16，恰好匹配scale组。每轮共享装入128个A元素和256个W元素，W解码结果在8行复用，A解码结果在16列复用。共享保存解码后的int或float，占用理论 `(8×16+16×16)×4=1536 B`；两次CTA barrier分别保护消费和下一组覆盖。所有边界线程都参与屏障，只对加载/最终写回加边界保护。

这是一版完整的SIMT整数/解码矩阵乘优化，**没有使用IMMA/MMA/tcgen05等原生矩阵乘指令**。不能标成Tensor Core吞吐，不把W4称为NVFP4，不把W8称为FP8。是否引入Thor原生低位矩阵指令，要另外核实SM110目标、数据类型、布局与后缀要求。

对8×16×16完整tile，基线源码层面为128个输出各自解码16对A/W；tile版只装载128+256个共享输入。实际优化程度取决于编译器CSE、缓存、真实执行次数和边界占用，不能把这个计数比例直接说成加速倍数。小M/N下shared和屏障可能抵消收益。

## ncu 怎样验证这个判断

先运行精度检查，然后用同一format/method采baseline和tiled。专用profile入口在校准/QAT、权重上传、一次数值检查、20次预热之后才打开cudaProfiler采集，只包一次kernel；结束后再次核对结果。

```sh
./systems_practice/daily/2026-09-18/session-02/profile.sh W4A4 outlier baseline
./systems_practice/daily/2026-09-18/session-02/profile.sh W4A4 outlier tiled
# 同Shape的FP32参考用于观察总成本，不用于伪造Tensor Core峰值比较。
./systems_practice/daily/2026-09-18/session-02/profile.sh W4A4 outlier fp32
```

脚本先实际运行 `ncu --version`、`--list-sections`、`--query-metrics`，检查所需section是否存在，再用：

```
--profile-from-start off
--kernel-name-base demangled
--kernel-name 'regex:.*(quant_baseline|quant_tiled|fp32_gemm).*'
--launch-count 1
```

报告存入全新、被忽略的 `build/ncu-XXXXXX/`，附二进制哈希、采集日志、`.ncu-rep` 和文本details。按脚本打印的命令用ncu-ui打开，在Source页将CUDA/PTX/SASS关联。CMake加`-lineinfo`，不用`-G`采正式性能。确认目标SM110、M32/N19/K65、grid=(2,4)、block=(16,8)；没有kernel或没有可用计数器时不能声称采集成功。

| 检查项 | section | 如何解释 |
| --- | --- | --- |
| 全局访存/解码复用是否减少 | MemoryWorkloadAnalysis、SourceCounters | 看请求/事务/缓存和实际指令计数；不能只凭源码数组读取次数 |
| shared复用代价 | MemoryWorkloadAnalysis、WarpStateStats | shared事务与冲突、barrier等待；不能为了减少stall删除必要同步 |
| 寄存器和驻留资源 | LaunchStats、Occupancy | 数组展开、register、shared及驻留限制；高occupancy不是充分条件 |
| 指令依赖与发射 | SchedulerStats、WarpStateStats | ready/eligible/issued warps与依赖等待；将消费者停顿追溯到前序load或累加 |
| 算术/带宽总体平衡 | SpeedOfLight | 很小的GEMM可能不足以打满设备；不能用低利用率直接断言“带宽瓶颈” |

Profiler replay和cache控制会改变条件，应记录配置；最终速度取程序脱离ncu后的100样本p50/p95，并在相同功耗模式、温度和系统负载下重复至少3轮。kernel边界不含CPU量化/packing，主机端到端边界包含这些在线工作；离线calibration/QAT另外排除。权重/scale首次上传也不在稳态端到端内。

## 今天的真实PTX与SASS边界

CUDA `code<4>` 实际使用如下inline PTX模板，`%1`为已载入字节，`%2`为0或4，输出进行有符号位域提取：

```ptx
bfe.s32 %0, %1, %2, 4;
```

这是**源代码中真实存在的PTX**，不是一个完整编译模块，不是SASS。整数乘加和shared访问由C++生成，不能未经导出就给它们指定实际机器指令名称、地址或寄存器编号。

```sh
./systems_practice/daily/2026-09-18/session-02/export-isa.sh
```

脚本固定 `CMAKE_CUDA_ARCHITECTURES=110`，重建实际目标后运行 `cuobjdump --dump-ptx` / `--dump-sass`，并独立执行 `nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx`；参数、版本、源码/二进制哈希均保存在 `build/isa-sm110-XXXXXX/`。独立PTX编译参数不必与CMake所有选项相同，分析被测二进制时以它的SASS为准。

目前这些目标命令没有跑通：缺nvcc/ncu，不存在真实编译器SASS报告。不得把示意指令串或另一个GPU的反汇编替换为Thor证据。

## 哪些指令/依赖值得重点看

| 源码/指令段 | 潜在长耗时原因 | 如何定位 |
| --- | --- | --- |
| packed字节global load → `bfe.s32` | 慢的可能是global load未命中，而非位提取本身 | 看加载后依赖等待与实际PC，不给bfe固定“慢指令”标签 |
| INT32 dot循环的乘加链 | 单输出存在串行累加依赖，tile也不消除全部链长 | 检查实际展开与调度，关注可发射warp和独立链数量 |
| A16的half→float转换 | 转换次数、重复解码与指令吞吐开销 | 比较基线/共享后动态转换次数；不要把格式压缩自动等同于算术加速 |
| group scale的load/浮点乘加 | 较细group增加元数据和缩放次数 | 结合scale读取及带宽开销分析；改变group会同时改变误差 |
| CTA barrier/shared消费 | producer到达差异、shared冲突或资源限制 | 查实际等待与shared指标；不能直接移除屏障 |
| outlier残差half乘加 | 增加额外读取与算术 | 比较outlier开/关的误差与所有payload/E2E成本，不能只报告精度收益 |

长延迟、低发射吞吐、动态执行次数和采样到的warp stall是不同量。没有Thor数据时这里只能提出可证伪假设，不能给每条指令编造周期数。

## 以Thor为锚点的架构对照

- 本次实际执行目标始终是Thor SM110，使用通用SIMT整数/浮点及shared机制。`bfe.s32`不是Thor独有指令，不能把继承的通用指令包装成新架构特性。
- 对照Ampere的cp.async搬运：它处理global→shared的搬运与完成语义，并不会自动完成INT4解码或解决本例的scale/残差成本。本次tile用普通加载，未声称复制与计算重叠。
- 对照Hopper的TMA/warp-group矩阵执行和Blackwell相关矩阵指令路线：需要数据描述、布局、dtype、同步及具体目标特性支持，不是将标量kernel换一个编译flag就成为原生W4A4 GEMM。对小M/N也可能有额外启动/布局代价。
- 本工程不使用未经官方Thor支持表核对的专属指令，不切换到sm_110a或其他产品SM；后续原生矩阵kernel必须针对SM110验证兼容性再实现。INT4、NVFP4、INT8、FP8分别讨论，不能只按位宽归类。

以上架构适用性的官方正文仍受网络阻断未完成复核。待查一手入口：[PTX ISA](https://docs.nvidia.com/cuda/parallel-thread-execution/)、[Blackwell Tuning Guide](https://docs.nvidia.com/cuda/blackwell-tuning-guide/index.html)、[ncu CLI](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)。没有将这些链接当作本次已读源码或已测硬件证据。
