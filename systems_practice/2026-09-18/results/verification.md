# 2026-09-18 验证记录

**最新状态：按用户追加要求，今天工程已实现最终 direct 优化、ncu/ISA 脚本，所有 CUDA/PTX/SASS 固定 Thor SM110。下列早期记录保留历史，旧架构和旧默认版本不再适用于当前源码；以末尾追加验收和 README 为准。**

- 首条执行命令 `TZ=Asia/Shanghai date +%F` 输出 `2026-09-18`。
- 已读取自动化 memory、PRACTICE_SPEC.md、index.md；项目及已检查的祖先目录没有适用 AGENTS.md，systems_practice 内没有 AGENTS.md。
- 基于索引最后 RK3588 NPU / RKNN 选择 PTX / CUTLASS。起始 Git 工作区干净，分支 main。
- CPU Release 与 ASan/UBSan 真实编译、CTest 通过；640 个正常 Shape、3 个非法 Shape。详见 cpu.txt、sanitize.txt。
- CUDA 配置真实尝试且 exit 1：`Failed to find nvcc. Compiler requires the CUDA toolkit. Please set the CUDAToolkit_ROOT variable.` 没有进行 GPU 编译/执行/精度验证，也没有 GPU/E2E/功耗数据。
- 工具：Darwin arm64，Apple clang 21.0.0 (clang-2100.1.1.101)，CMake 4.4.3。
- `scripts/format-cpp.sh` 实际运行成功；仅本次源码被改变，历史文件无 diff。原始 format.txt 为空表示成功无输出。

## 开源源码与一手资料读取尝试

在编写代码前优先尝试了以下具体源码，未取得正文：

1. https://github.com/NVIDIA/cutlass/blob/v3.5.1/include/cutlass/arch/memory_sm80.h
   - web.open：`Fatal error: connection failed: error sending request`。
2. https://raw.githubusercontent.com/NVIDIA/cutlass/v3.5.1/include/cutlass/arch/memory_sm80.h
   - curl exit 6：`curl: (6) Could not resolve host: raw.githubusercontent.com`。
   - web.open 再次尝试：`Fatal error: connection failed: error sending request`。
3. 替代一手规范：https://docs.nvidia.com/cuda/parallel-thread-execution/#data-movement-and-conversion-instructions-cp-async
   - web.open：连接失败，同上。
   - 对文档根 URL https://docs.nvidia.com/cuda/parallel-thread-execution/ 再用 curl：exit 6，`curl: (6) Could not resolve host: docs.nvidia.com`；web.open 也失败。

本地 references/ 只有 RKNN/ARM/ggml/ncnn 的 README，不存在可替代的 PTX 源码快照。没有引用这些不相关首页充当源码。未成功阅读 CUTLASS 原始实现，`cp_async` / `cp_async_zfill` 只是拟检索符号；本次代码为独立实现，没有声称源自或改编自 CUTLASS，也没有复制第三方内容。官方正文同样不可达，README 指明目标设备执行前仍需核对语义及兼容性。

## 验收限制

CPU 顺序 tile 模型只验证索引、补零契约与数值定义，无法验证 PTX 语法、设备对齐规则实现、异步完成、CTA 同步、最终机器指令或性能。源码实际阅读目标未完成。目标代码、构建/运行/诊断/分析命令已生成，均明确为待验证；不把理论字节量、CTest 总耗时或本机表现当作 GPU 数据。

## 2026-09-18 用户要求补充

- 增加 OPTIMIZATION.md：基线/最终优化候选、可证伪瓶颈假设、具体 ncu 过滤与报告流程、真实 inline PTX、PTX/SASS 提取命令及指令依赖分析。未修改 kernel 或重报 GPU 性能。
- 本次架构重点为 Ampere，对照 Turing；后续 GPU 内容轮换重点。扩展架构路线表明确待官方资料复核，不作已核实产品兼容性清单。
- web 对官方 OpenAI/CUDA/ncu 文档搜索失败：`Fatal error: connection failed: error sending request`；curl 对 ncu Profiling Guide 返回 exit 6：`Could not resolve host: docs.nvidia.com`。未声称已读正文。
- 仅说明文档/规范及现有自动化本地 prompt 更新，GPU 验证边界不变；代码未变，无需重跑 CPU 测试。

## 今天工程的实际优化与 Thor SM110 固定目标

- 用户明确要求“今天工程就要加上”以及今天/未来全部 CUDA、PTX、SASS 针对 Thor SM110；据此直接完善已有今日工程，不创建新练习或推进主题轮转。
- 新增默认 `pool_direct`，warp 独占输出、四个独立累加器、连续通道读取，无显式 shared tile/CTA barrier。保留 baseline 与 cp.async 中间版，新增 `--variant all`、`--sweep`、`--profile`；每个 GPU 版本初次验证前毒化输出，避免旧输出掩盖漏写。
- CPU Release 与 ASan/UBSan 实际通过 640 Shape：staging 模型和真实 host/device direct 累加逻辑对照独立 oracle，检查 NaN padding、漏写、每输出唯一写者、3 非法 Shape、默认/全部/profile/sweep 和非法 CLI。原始新日志 cpu-optimized.txt、sanitize-optimized.txt；未声称 CPU 性能提升。
- CMake/运行脚本固定架构 110，CUDA 源拒绝非 1100 编译目标，程序要求 runtime compute capability 11.0。选择 CUDA Toolkit 13.0+ 作为本工程配置基线。手写 pool_direct.ptx 使用 PTX 9.0 / `.target sm_110`；本机没有 ptxas，尚未汇编或运行这个独立模块。
- 实际尝试非 110 CMake 参数，预期拒绝成功：reject-other-arch.txt。实际 SM110 构建仍缺 nvcc：gpu-optimized.txt。
- profile.sh 查询工具能力、重新构建 SM110 目标、按 cudaProfilerStart/Stop 范围采单一 kernel；export-isa.sh 重新构建 SM110 后提取二进制 PTX/SASS、独立生成 PTX 与汇编手写模块，分开记录 provenance。Shell 语法与非法参数检查通过，目标执行分别因缺 ncu/nvcc 返回127。没有生成任何假 .ncu-rep 或编译器 SASS。
- 新增/重写文档讲解基线→异步→最终直接路径、ncu 证据链、潜在耗时指令/依赖与 Thor 锚定的架构对照。20–30分钟练习改为保持同一语义的所有权优化，保留一个无答案自测。
- 本轮先重新尝试 CUTLASS raw 源码、ncu CLI、Ampere/Hopper tuning guide；用户指定 Thor 后又尝试 Blackwell tuning guide、PTX ISA 和 CUDA GPU 表。web.open 均报 `Fatal error: connection failed: error sending request`。未取得正文，未假称读到源码或验证所有 Thor 专属指令；不混用 sm_110a 等后缀，不冒用其他 Blackwell 产品的能力表。
- 原始尝试 URL：
  - https://raw.githubusercontent.com/NVIDIA/cutlass/v3.5.1/include/cutlass/arch/memory_sm80.h
  - https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html
  - https://docs.nvidia.com/cuda/ampere-tuning-guide/index.html
  - https://docs.nvidia.com/cuda/hopper-tuning-guide/index.html
  - https://docs.nvidia.com/cuda/blackwell-tuning-guide/index.html
  - https://docs.nvidia.com/cuda/parallel-thread-execution/
  - https://developer.nvidia.com/cuda-gpus

优化收益、GPU 精度、设备内存/同步检查、编译生成的 PTX/SASS、指令延迟与功耗仍未验证。代码消除的显式 shared/barrier 是静态结构变化，不是实测加速。后续验收必须在 Thor SM110 上执行。
