# 工业级 CUDA、C++ 与 Edge AI 每日练习

每天北京时间 **08:30** 在 EveryDay 项目运行。完整要求见 [练习规范](../docs/PRACTICE_SPEC.md)。同一天追加内容使用独立 session 目录，历史文件不覆盖。

2026-09-22 最新安排：**每天一节 ARM 小课**，独立按前置知识递进，随每日 08:30 任务交付。[学习路线](../docs/arm/README.md) · [历史与下一节](../arm/index.md) · [今天第 01 节](../arm/2026-09-22/README.md)。主主题仍按 12 方向轮转。

2026-09-18 起 CUDA/PTX/SASS 代码与分析固定针对 **Jetson Thor SM110**，其他架构仅作理论对照，不改变目标。

当前 Mac 无可用 CUDA GPU：GPU 主题照常轮换，完整保留目标代码、构建与验证命令；本机可验证部分与 Linux NVIDIA GPU / Jetson 待验证部分分别记录。

轮换顺序：CUDA Kernel → TensorRT → RK3588 NPU / RKNN → PTX / CUTLASS → 量化 GEMM → GPU 访存优化 → GPU 体系结构 → C++17 并发 → CPU 体系结构 → ARM SIMD / NEON → 边缘端部署 → C++ 工程知识 → 循环。

2026-09-16 扩展为 11 个方向：新增 RK3588 NPU / RKNN 与 ARM SIMD / NEON。NPU 主题保留完整转换和板端代码；ARM SIMD 独立选题，优先借鉴 ggml、ncnn 的 CPU 实现并在 Apple Silicon Mac 本机验证，RK3588 为可选移植场景。

2026-09-18 扩展为 **12 个方向**：新增“量化 GEMM”，涵盖 W4A4/W4A16/W8A8/W8A16、SmoothQuant、离群处理、校准缩放与 QAT，代码目标仍为 Thor SM110。

2026-09-18 起另设 **每日量化方法**：每天在主知识点之外讲一个方法，拉取源仓库、阅读实际实现并给出完整使用示例及量化前后比较。独立轮换见 [量化栏目索引](../quantization/index.md)，下一方法 **SmoothQuant**。该栏目不取代 12 个主方向，源码获取/阅读/示例运行分别记录。

2026-09-21 起新增 **每日两篇论文**：[paper 栏目](../docs/paper/README.md) · [历史索引](../paper/index.md) · [今天两篇](../paper/2026-09-22/README.md)。覆盖剪枝、量化、模型压缩和边缘部署，包含核心思想、复现难度、简单代码及真实验证记录；优先近 180 天首发，独立去重。

| 日期 / 会话 | 主主题 | 核心知识点 | 代码路径 | 验证状态 | 性能数据与证据 |
| --- | --- | --- | --- | --- | --- |
| [2026-09-14](2026-09-14/README.md) | C++ 工程知识（补充历史） | gRPC Arena 启发的原子 bump、受管析构链表与 Producer/reset 生命周期门 | [frame_arena.hpp](2026-09-14/src/frame_arena.hpp)；[并发测试与基准](2026-09-14/src/main.cpp) | Mac Release 与 ASan/UBSan 实际编译运行通过；4 worker、受管析构和 reset gate 均通过 | 20 预热+100 次，256 对象：Release arena P50/P95 1.084/1.167 us，heap 对照 12.875/13.25 us；仅 CPU 微基准。[日志](2026-09-14/results/verification.md) |
| [2026-09-15](2026-09-15/README.md) | CUDA Kernel | 双相机 UINT8 NHWC → FP16 NCHW 归一化融合；中间张量消除；分离 Kernel 与端到端计时 | [preprocess.cu](2026-09-15/src/preprocess.cu)；[cpu_check.cpp](2026-09-15/src/cpu_check.cpp) | CPU Release 编译、4 种形状及负 Batch 校验通过；ASan/UBSan 通过。CUDA/GPU 因缺依赖未验证 | CPU 参考 `[2,224,224,3]`：p50 0.159875 ms、p95 0.275375 ms，10 次预热 + 50 次采样；GPU 数据未验证。[实测日志](2026-09-15/results/run-2m3zbaM3/output.log) |
| [2026-09-16](2026-09-16/README.md) | TensorRT | 小 Batch 动态 Shape/Profile 与缓冲区契约；同 Shape 复用练习；分离 CPU 提交、GPU 推理区间和 E2E | [trt_dynamic.cpp](2026-09-16/src/trt_dynamic.cpp)；[cpu_check.cpp](2026-09-16/src/cpu_check.cpp) | Mac CPU Release 与 ASan/UBSan 实际编译运行通过；6次变值帧/Shape、非法输入通过。GPU 配置因缺 nvcc 失败，TensorRT 目标编译/执行/精度未验证 | CPU B=2 参考 p50 0.000001584 ms、p95 0.000001708 ms/次；10组预热+100组采样，每组1000次；GPU Kernel/E2E/功耗未验证。[日志](2026-09-16/results/cpu-bEqMZkQH/output.log)；[失败与范围](2026-09-16/results/verification.md) |
| [2026-09-17](2026-09-17/README.md) | RK3588 NPU / RKNN | Runtime `size_with_stride`/`w_stride` 物理输入绑定；紧凑 UINT8 NHWC 逐行写入与 RAII 生命周期 | [rknn_stride_binding.cpp](2026-09-17/src/rknn_stride_binding.cpp)；[CPU 检查](2026-09-17/src/preprocess_cpu.cpp) | Mac CPU Release 与 ASan/UBSan 实际编译运行通过；RKNN 转换与 RK3588 NPU 未验证（无 Toolkit2、板卡、Runtime/驱动和 `.rknn`） | CPU 辅助 Release 平均 0.0856833 us/次（1,000 预热+10,000 次）；无 NPU 性能数据。[日志与范围](2026-09-17/results/verification.md) |
| [2026-09-18](2026-09-18/README.md) | PTX / CUTLASS | Thor SM110 token 池化：同步→cp.async→warp 独占输出直接累加；最终优化与 ncu/PTX/SASS 工具 | [ptx_pool.cu](2026-09-18/src/ptx_pool.cu)；[CPU 契约检查](2026-09-18/src/cpu_check.cpp) | Mac Release/ASan/UBSan：640 Shape、最终 direct 同源逻辑、唯一写者及 CLI 通过；SM110 编译/执行、ncu 与真实 SASS 因缺工具/板卡未验证；官方源码读取失败 | 无 GPU/E2E/功耗实测，优化收益待 Thor 验收。[新日志](2026-09-18/results/cpu-optimized.txt)；[优化说明](2026-09-18/OPTIMIZATION.md)；[边界](2026-09-18/results/verification.md) |
| [2026-09-18 / session-02](2026-09-18/session-02/README.md) | 量化 GEMM | Thor SM110 W4A4/W4A16/W8A8/W8A16；真实打包MAC、SmoothQuant式缩放、校准搜索、离群FP16残差、40步STE QAT；baseline/tiled对照 | [CPU与算法](2026-09-18/session-02/src/quant.hpp)；[CUDA](2026-09-18/session-02/src/quant_gemm.cu) | Mac Release/ASan/UBSan 20组比较及half/packing/尾块/独立oracle通过；Thor/ncu/ISA因缺工具未验证；源码请求失败 | W4A4 NRMSE 22.7527%→1.9250%（absmax→校准+离群）；总payload含metadata 2514 B，对FP16 2.637×；非GPU提速。[实测表](2026-09-18/session-02/results/comparison.md) |
| [2026-09-19](2026-09-19/README.md) | GPU 访存优化 | Thor SM110批次特征转置：global合并访问+shared bank布局；naive/unpadded/padded及4行候选；对照Hopper TMA；[每日AWQ](../quantization/2026-09-19/awq/README.md) | [CUDA](2026-09-19/src/transpose.cu)；[CPU](2026-09-19/src/cpu_check.cpp) | Release/ASan/UBSan：196 Shape×3布局及4非法输入通过；已读NVIDIA官方实现；AWQ固定commit网页源码已读/示例已交付，本地克隆与运行待补 | 无GPU/端到端性能；缺nvcc/ncu/Thor。bank 32→1仅地址模型。[验证](2026-09-19/results/verification.json)；[日志](2026-09-19/results/cpu.txt) |
| [2026-09-20](2026-09-20/README.md) | GPU 体系结构 | Thor SM110行归约：ILP独立累加链+寄存器/occupancy；五实例，对照Ampere整数redux；[每日GPTQ](../quantization/2026-09-20/gptq/README.md) | [CUDA](2026-09-20/src/row_reduce.cu)；[CPU合同](2026-09-20/src/cpu_check.cpp) | Release/ASan/UBSan 675比较、4非法Shape通过；PyTorch/NVIDIA源码已读；GPTQ固定commit已读/示例已交付，本地获取与运行待补 | 无GPU/端到端/功耗实测；nvcc/ncu/Thor缺失。[证据](2026-09-20/results/verification.json)；[日志](2026-09-20/results/cpu.txt) |
| [2026-09-21](2026-09-21/README.md) | C++17 并发 | 有界背压+谓词等待/关闭排空；LLVM线程池机制；[每日AdaRound](../quantization/2026-09-21/adaround/README.md) | [线程池](2026-09-21/src/bounded_pool.hpp)；[测试/基准](2026-09-21/src/main.cpp) | Release/ASan/UBSan/TSan实际通过；3容量×2000请求及20轮关闭竞争；AIMET迁移/固定commit已读、原生API交付，克隆/运行待补 | CPU容量8批次P50 501.458us、请求P95 43.75us；容量64为473.292/247.333us。无加速器数据。[验证](2026-09-21/results/verification.json)；[日志](2026-09-21/results/cpu.txt) |
| [2026-09-22](2026-09-22/README.md) | CPU 体系结构 | 统计计数器伪共享+relaxed原子语义；folly对齐源码；[AutoRound](../quantization/2026-09-22/autoround/README.md)；[两篇论文](../paper/2026-09-22/README.md) | [布局](2026-09-22/src/counters.hpp)；[基准](2026-09-22/src/main.cpp) | Release/ASan/UBSan/TSan各45并发试验通过；真实ARM ldadd汇编；AutoRound源码已读/示例交付但本地运行受阻；论文CPU例子通过 | 4worker、20万次/worker：packed P50 7872.88us，pad128 343.417us；仅CPU微基准，无硬件事件/加速器数据。[日志](2026-09-22/results/cpu.txt)；[验证](2026-09-22/results/verification.json) |
| [2026-09-23](2026-09-23/README.md) | ARM SIMD / NEON | INT8块点积：安全扩宽归约+每块scale；ggml实际源码；[HQQ](../quantization/2026-09-23/hqq/README.md)；[ARM02](../arm/2026-09-23/README.md)；[两篇论文](../paper/2026-09-23/README.md) | [标量](2026-09-23/src/scalar.cpp)、[NEON](2026-09-23/src/neon.cpp) | Release/ASan/UBSan/base各1218比较与10非法输入通过；真实A64汇编；HQQ阅读/交付是，克隆/原生运行待补；ARM/论文小例子实际通过 | Mac CPU P50 scalar36.458us、NEON9.541us、SDOT8.833us；20预热100采样，无板端/加速器数据。[日志](2026-09-23/results/cpu.txt)；[状态](2026-09-23/results/verification.json) |
| [2026-09-24](2026-09-24/README.md) | 边缘端部署（顺序补课） | 发布代次与请求共享快照；[OmniQuant](../quantization/2026-09-24/omniquant/README.md)；[ARM03](../arm/2026-09-24/README.md)；[两篇论文](../paper/2026-09-24/README.md) | [代码](2026-09-24/src/deployment.hpp) | Release/ASan/UBSan/TSan 通过；2万请求/1000更新；量化原生运行待补 | CPU控制面P50/P95 0.007291/0.007333us；[验证](2026-09-24/results/verification.json) |
| [2026-09-25](2026-09-25/README.md) | C++ 工程知识（顺序补课） | 异常回滚与移动所有权；[QuaRot](../quantization/2026-09-25/quarot/README.md)；[ARM04](../arm/2026-09-25/README.md)；[两篇论文](../paper/2026-09-25/README.md) | [代码](2026-09-25/src/main.cpp) | Release/ASan/UBSan 通过；2000失败注入/1000移动/容量边界；量化原生运行待补 | 无GPU/NPU/端到端实测；[验证](2026-09-25/results/verification.json) |
| [2026-09-26](2026-09-26/README.md) | CUDA Kernel（顺序补课） | 稳定 softmax 与 warp 寄存器归约；[SpinQuant](../quantization/2026-09-26/spinquant/README.md)；[ARM05](../arm/2026-09-26/README.md)；[两篇论文](../paper/2026-09-26/README.md) | [代码](2026-09-26/src/softmax.cu) | CPU Release/ASan/UBSan 96组+非法输入通过；Thor缺nvcc未编译；量化原生运行待补 | 无GPU/NPU/端到端实测；[验证](2026-09-26/results/verification.json) |
| [2026-09-27](2026-09-27/README.md) | TensorRT（顺序补课） | 输入消费事件与输出完成事件；[SpQR](../quantization/2026-09-27/spqr/README.md)；[ARM06](../arm/2026-09-27/README.md)；[两篇论文](../paper/2026-09-27/README.md) | [代码](2026-09-27/src/trt.cpp) | CPU所有权状态模型通过；TensorRT/Thor缺工具未编译；量化原生运行待补 | 无GPU/NPU/端到端实测；[验证](2026-09-27/results/verification.json) |
| [2026-09-28](2026-09-28/README.md) | 边缘端部署（保留为补充，不重复推进） | 发布代次+请求共享快照，失败保留旧版；[OmniQuant](../quantization/2026-09-28/omniquant/README.md)；[ARM03](../arm/2026-09-28/README.md)；[论文](../paper/2026-09-28/README.md) | [控制面](2026-09-28/src/deployment.hpp)、[验证](2026-09-28/src/main.cpp) | Release/ASan/UBSan/TSan通过；2万请求/1000更新；量化原生运行因依赖/克隆缺失待补 | CPU控制面P50/P95 0.00725/0.007292us；[最终记录](2026-09-28/results/verification.json)；无GPU/NPU/E2E性能 |


下一主主题：**RK3588 NPU / RKNN**。不得因本机缺少 GPU 而跳过代码生成；依规范生成目标环境命令并记录验证边界。

`2026-09-14` 为用户要求补充的历史 C++ 练习，不改变当前轮换位置。

2026-09-28 应用户要求按日期补齐 24–27 日；此前已交付的 28 日同题保留为补充。轮换从补课后的 27 日 TensorRT 继续，不能按最后显示的补充行再次选 C++。详见[补课总览](../docs/BACKFILL_2026-09-24_27.md)。


2026-09-28 用户新增[就业与 OS 衔接要求](../docs/arm/CAREER_OS.md)：主课和ARM小课围绕工程问题积累验证证据，不增加每日编码任务或改变12方向游标。

2026-09-28 起新增[每日OS独立栏目](../os/index.md)：每天两个相关小主题，首节[系统调用与FD共享状态](../os/2026-09-28/README.md)，Mac Release/ASan/UBSan通过，xv6/QEMU、Linux/板端待验；不推进主方向游标。
