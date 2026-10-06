# Thor SM110编码kernel：验证与性能证据路线

读取2026-10-06官方[JetPack7.0归档](https://developer.nvidia.com/embedded/jetpack/downloads/archive-7.0)：T5000、L4T38.2/38.2.1、CUDA13.0.0；这是选择的最低基线组合，不称当前最新版本。官方[GPU列表](https://developer.nvidia.com/cuda/gpus)列T5000/T4000为11.0。目标实际驱动/ncu版本仍未知，不能自动用桌面wheel。先在Thor收集`cat /etc/nv_tegra_release`、`uname -a`、`nvcc --version`、`nvidia-smi`（若该镜像提供）、`ncu --version`，核实实际SDK。

## 完整运行与正确性

```sh
cd systems_practice/quantization/2026-10-06/fp8_scaling
sh thor.sh run
compute-sanitizer --tool memcheck ./build/codec scalar
compute-sanitizer --tool memcheck ./build/codec vector
sh thor.sh isa
sh thor.sh profile
```

编译均C++17/O3/lineinfo/sm_110，nvcc的gpu-code列表必须含sm_110。主机amax不在GPU计时内；仅kernel用CUDA event，20预热、51样本；复制/分配/输出校验在外。本机没有工具链，所以无真实PTX导出或SASS，只有代码中的真实inline `mul.rn.f32`。build/codec.ptx及codec.sass必须在目标生成，不填示意机器码。cuda_fp8.h的[CUDA Math转换API](https://docs.nvidia.com/cuda/cuda-math-api/cuda_math_api/group__CUDA__MATH__FP8__MISC.html)定义有限饱和转换；CPU helper与设备输出需逐字节一致，目标编译尚未验。

## ncu定位、筛选、采集、关联

先看build/sections.txt与metrics.txt，确认各section在已装版本存在；不存在时查询实际名称，不静默删掉验证。脚本按kernel名regex筛选。每程序先7个小shape、1个大shape正确性launch、20预热，共28个匹配launch，跳过28后采一个大shape。修改测试数量后重新计算skip，可先`ncu --set basic --kernel-name regex:vector_encode --launch-count 1 ./build/codec vector`核查命名与shape，别把首个小shape报告当主基准。

```sh
ncu --import build/vector.ncu-rep --page details
ncu --import build/vector.ncu-rep --page source
ncu-ui build/vector.ncu-rep
```

在Source页沿`vector_encode`→float4加载→四个转换→uchar4存储，对应源代码/PTX/SASS视图（需要lineinfo和源路径可达）。保存ncu版本、目标SM与nvcc参数。若没有图形工具可导出文本；权限限制时保留ERR_NVGPUCTRPERM原文并申请该设备计数器配置，不把不可用值视为0。

| 观察问题 | section与解释 |
| --- | --- |
| 是否访存受限 | SpeedOfLight + MemoryWorkloadAnalysis查吞吐、sector/访问效率；相同逻辑5N字节不代表相同DRAM流量 |
| 向量化是否真的生成 | Source/SASS确认加载/存储宽度；四项每线程可能增加寄存器 |
| 占用率是否下降 | LaunchStats/Occupancy的寄存器、resident warps；本核无shared memory |
| 是吞吐还是依赖等待 | SchedulerStats/WarpStateStats结合转换消费者PC；long scoreboard可能源自上游load |

潜在热点是global load、scale乘法、FP8转换依赖和store；没有目标计数器不能排序耗时。stall落在消费者不证明该指令本身慢，更不能编造周期。小N少线程时float4版本可能更差；低延迟短任务受launch成本影响。profiler replay/cache控制会扰动条件，速度结论只取未附加ncu的基准。

## 架构与指令对照：Thor / Hopper

依据[PTX cvt ISA notes](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#data-movement-and-conversion-instructions-cvt)：E4M3x2/E5M2x2转换针对SM90在PTX7.8引入；当前target条件为SM89及以上，SM89支持在PTX8.1加入。Hopper代表FP8转换/矩阵执行扩展，Thor沿用该转换能力；不能称Thor独有。Thor执行仍要求能识别sm_110的CUDA13工具链。本kernel使用CUDA Math标量转换和普通向量访存，没有wgmma/tcgen05、Tensor Core或原生FP8 GEMM。格式/成对字节顺序、饱和/舍入条件按上述ISA，实际选择的SASS须反汇编确认。专属FP4/块scale指令存在额外a/f目标条件，今天不启用、不把Blackwell家族所有特性泛化到无后缀sm_110。

## 原生扩展构建边界

原生示例固定`TORCH_CUDA_ARCH_LIST=11.0`。若已有经审计的torchao checkout和依赖，在其工作目录使用：

```sh
TORCH_CUDA_ARCH_LIST=11.0 python3 setup.py build_ext --inplace
```

这是待验构建入口，不安装依赖。v0.13 setup.py已读部分，所选文件没有给出sm_110支持矩阵；扩展内部CUTLASS特殊目标/自动选择未完全核实，所以命令本身不足以证明所有扩展只生成这一目标。实际构建前须审查完整nvcc日志，出现其他架构或专属后缀必须停止并修订配置，不自行启用。当前无checkout/torch/工具链，不能宣称后端兼容。独立codec仅构建一个sm_110目标，不依赖torchao。
