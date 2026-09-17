# 验证记录 — 2026-09-16 TensorRT

## 实際执行

- 日期命令首先返回 `2026-09-16`（Asia/Shanghai）。已读 PRACTICE_SPEC 和总索引；无适用 AGENTS.md；已有主题 CUDA Kernel，故本次 TensorRT。当天目录此前不存在，无用户文件被覆盖。
- 环境：Darwin arm64，AppleClang 21.0.0，CMake 4.4.3。本次无需 Git；工作目录不是 Git 仓库，没有提交。
- 最终 CPU Release：[`cpu-bEqMZkQH/output.log`](cpu-bEqMZkQH/output.log)，退出0，CTest 1/1；变值帧与六次 Shape 序列、尾部哨兵、四个非法 Batch、空指针检查通过。
- 最终 ASan/UBSan：[`sanitize-eK6F5Sad/output.log`](sanitize-eK6F5Sad/output.log)，退出0，CTest 1/1，无 sanitizer 报错。
- CPU 参考：B=2、16个FP32；预热10组、采样100组，每组1000次再折算每次；p50=0.000001584 ms，p95=0.000001708 ms。这是辅助热缓存函数微基准，不能推断 GPU 性能；不作为隔离负载下的 CPU 性能承诺。

## 实际失败及未验证范围

- GPU 模式在 CMake 配置阶段退出1：[`gpu-L9qxckGK/output.log`](gpu-L9qxckGK/output.log)。原文：`Could not find nvcc executable in any searched paths, please set CUDAToolkit_ROOT`。
- 直接原因：当前查找路径不存在 CUDA Toolkit 的 nvcc；运行环境是无 NVIDIA GPU 的 Mac。未进入 TensorRT 头文件/库检测，未编译 `trt_dynamic.cpp`；不能把 CPU 编译成功描述为目标代码编译成功。
- 已生成完整 TensorRT 10/11 条件分支、构建配置、最小输入、GPU 推理及目标设备命令；GPU 源码仅人工检查，未进行使用真实 TensorRT/CUDA 头文件的静态编译。
- GPU 执行、正确性、计算精度、设备内存越界、CUDA 清理错误路径、Nsight 数据、E2E/Kernel/功耗均未验证。无 GPU 实测数字。
- 基线尚未实施 README 的 Shape 缓存编码练习，当前记录不能用于证明该优化正确或有效。

## 文档与档案检查

- README 十个二级章节按规范排列；概念回顾372个汉字（含标点总长度另见 audit.log），只有一个编码练习、一个无答案自测问题。
- 已读取并本地保存 NVIDIA 当前 C++ API、动态 Shape 基础和支持矩阵，返回的文档版本标记为11.3.0；没有将最新文档当作10.x已实测兼容证据。
- 初始 web 连接失败；curl 初始受限环境 DNS 失败；有些旧/错误文档 URL 返回404。随后正确的官方当前页面读取成功，失败的链接不作为依据。
- `run.sh` 每次使用唯一 results 子目录，不覆盖已存在构建/日志；TMPDIR、CUDA/编译器缓存都指向本练习目录。未安装依赖、下载模型或修改项目其他目录。
- 结构检查、shell语法检查和源码SHA256见 [`audit.log`](audit.log)。

## 下一步

先读 README 的编码练习和 `src/trt_dynamic.cpp` 的 infer 路径；有 Linux NVIDIA GPU / Jetson 后运行 gpu 模式，并保存正确性、显存检查和性能证据。下次主主题为 **PTX / CUTLASS**。
