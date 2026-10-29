# 2026-10-29 量化 GEMM：W4A16 组尺度与低位解码边界

## 工业场景

机器人视觉编码器的投影层 `Y=A Wᵀ` 使用小 batch、`M=31,N=17,K=33`。今天把重点从四种模式的总览收紧到 **W4A16**：权重是有符号 INT4 打包，激活保持 FP16 存储，读取后以 FP32 累加，再按每个 K 组的权重 scale 还原。W4A4/W8A8/W8A16 仍作为同一实现的对照 fixture。训练、校准、调参、评估分开，不能把合成层误报成模型任务精度。

## 两个耦合机制

第一是码字和布局：低半字节在前，INT4 使用补码负值，奇数 K 的最后半字节必须补零；FP16 激活按元素读取，不能把字节偏移当成 half 偏移。第二是组内累加和缩放位置：每个 16 元素组先得到 FP32 dot，再乘该输出通道的 `sw[n,g]`；跨组先相加再乘一个 scale 会把不同量纲混在一起。C++ oracle 和 CUDA 两个 kernel 共用同一文件合同，确保错误来自布局或同步而不是参考实现差异。

知识图谱：`FP16 A → signed-nibble W → group dot → FP32 scale → output`；前置是 row-major、尾组、RAII、CUDA 错误检查。量化 GEMM 的低位存储不等于原生低位 Tensor Core；本课 CUDA 路径明确是 SIMT 解码。CUTLASS `81_blackwell_gemm_blockwise.cu` 与 `sm100_umma_builder.inl` 的实际阅读记录在 `source.json`，本课是受其 block-scale/collective 分层启发的独立 Thor 候选，省略 CuTe、UMMA 和 epilogue 融合。

## 25 分钟编码练习与自测

在 `src/gemm.cu:qgemm_tiled` 增加一个 `K=17/33` 的尾组污染 fixture：把 packed 权重的无效半字节写成非零，再证明 predicate 将它变为零且两次 `__syncthreads()` 仍保留；用 `baseline` 对照并检查 `abs(error)≤3e-4×(1+|ref|)`。这是唯一必做练习。自测：若把相邻两个 group 的整数 dot 先相加、最后只乘一个 scale，最小哪组输入会暴露错误？

## 文件与命令

- `experiment.py`：独立 NumPy 流程，真实 signed pack、W4A4/W4A16/W8A8/W8A16、SmoothQuant 式缩放、离群残差、校准搜索、80 步固定 scale STE、硬导出重载。
- `src/gemm.cu`：`qgemm_baseline` 正确性基线与 `qgemm_tiled` shared-memory 候选；PTX `bfe.s32` 仅是源码候选，不是已生成 SASS。
- `src/check.cpp`：C++17 独立解码和 group oracle。

```sh
sh systems_practice/daily/2026-10-29/run.sh
CUDA_BUILD=1 sh systems_practice/daily/2026-10-29/build.sh   # Thor 上执行，固定 -arch=sm_110
sh systems_practice/daily/2026-10-29/profile.sh               # Thor 上生成 PTX/SASS/ncu
```

Mac 实测：C++ 28 fixtures 通过，NumPy 20 行比较与实际 packed 文件通过；Mac 无 `nvcc`。之后在 Thor 上编译并运行 28 个 fixture 的两版 kernel，真实 PTX/SASS 已生成；ncu 计数器、受控 E2E 和功耗仍未验证。不得用 CPU 时间推断 GPU 收益。

## Thor SM110 优化与架构对照

基线每个输出重新解码，候选每个 16×16 tile 复用 shared；公平对照固定输入、输出 FP32、warm-up=10、kernel event=50，并分开量化/打包、H2D、kernel、D2H、E2E。ncu 先 `--set full` 查询 section，再按 `qgemm_baseline|qgemm_tiled` 过滤，观察 global/shared load、integer unpack、FMA、barrier stall、occupancy 和 source line。真实 cubin 后才运行 `cuobjdump --dump-sass`/`nvdisasm`，分析 `bfe.s32`、依赖链和寄存器压力。Thor 固定 `sm_110`，不使用 `sm_110a`；Hopper 的 TMA、Ada 的异步搬运、Blackwell 的 UMMA 只作能力差异对照，不能代替 Thor 结果。

## 故障链、取舍与追问

- 负权重全变大正数：nibble 未符号扩展 → 逐码比较 → 使用 `bfe.s32`/`u>=8 ? u-16`。
- K 尾块随机漂移：无效半字节或 shared 槽未清零 → K=15/16/17/33 回归 → predicate 写零且保留第二个 CTA 栅栏。
- W4A16 误差低但更慢：解码/scale/launch 主导 → 记录四段时间 → 仅在 ncu 证明复用有效时保留 tiled。
- QAT loss 下降而 shift 集退化：校准分布失配 → 独立 eval/shift → 回退 W8A16 或重新校准。

面试追问：W4A16 的 A16 是什么存储/累加语义？INT4 两个码字如何处理奇数 K？为何 scale 必须留在 group 内？shared tile 的同步作用域是什么？如何区分 fake quant 与真实 packed 部署？ncu 无计数器时先检查哪些权限和版本？为什么 PTX 不能直接当 SASS？

[验证记录](verification.json) · [源码记录](source.json) · [ncu/ISA 教程](PROFILING.md)

## 每日附加栏

[block_fp4](../../quantization/2026-10-29/block_fp4/README.md) · ARM source04 · OS 第28节 · C++17 第27课 · 今日论文见 `paper/2026-10-29/`。


## 2026-10-29 Thor 实机复核

Thor 实机复核：CUDA 13.0 / sm_110 编译、28 fixture × 两 kernel 数值对照通过，真实 PTX/SASS 已归档；ncu 因 GPU 计数器权限受限。见[验证总览](../../validation/2026-10-29-thor/README.md)。
