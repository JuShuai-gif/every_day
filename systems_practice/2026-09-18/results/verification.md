# 2026-09-18 验证记录

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
