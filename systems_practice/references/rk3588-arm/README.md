# RK3588 NPU 与 ARM SIMD 方向依据

记录日期：2026-09-16。此处是课程方向扩展记录，不是新增的一套每日练习。

## 已读取的官方资料

- [Rockchip RKNN-Toolkit2 README](https://github.com/airockchip/rknn-toolkit2/blob/master/README.md)：本地快照 `rknn-toolkit2-README.md`。确认先转换为 RKNN 格式再用板端 API 推理；RK3588 属于支持平台；Toolkit2、Lite2 与 Runtime 的职责不同。读取的是 master 当日内容，未锁定源码 commit，不据此宣称某个 API 在用户实际 SDK 上已验证。
- [Arm ACLE README](https://github.com/ARM-software/acle/blob/main/README.md)：本地快照 `arm-acle-README.md`。确认 ACLE 为 Arm 官方 C 语言扩展规范来源，并提供 Neon Intrinsics Reference 入口。读取的是 main 当日内容；具体 intrinsic、目标扩展支持和指令生成需在每日练习时单独核实。

web 搜索本次连接失败，随后直接读取上述官方仓库原文成功。未安装 SDK、下载模型或访问用户的 RK3588 板卡。

## 纳入规范的两个独立方向

- RK3588 NPU / RKNN：围绕用户现有 ONNX→RKNN→NPU 链路，一次深入一个转换、精度、内存或运行时问题。
- ARM SIMD / NEON：围绕真实 intrinsics、标量参考、生成指令和边界处理，结合图像/量化/后处理任务。

现有 9 方向扩为 11 方向，RKNN 插在 TensorRT 后，ARM SIMD 插在 CPU 体系结构后。历史条目不变，索引下一主题由 PTX / CUTLASS 改为 RK3588 NPU / RKNN。每日仍为北京时间 08:30；保留单概念、单练习、单自测、中文注释和开源设计深度要求。

## ARM SIMD 独立方向补充（2026-09-16）

用户进一步明确：ARM SIMD 不必重点绑定 RK3588，优先从 ggml、ncnn 借鉴。规范、索引与自动任务已据此调整；本目录早期记录反映最初部署背景，不限制后续独立 ARM 选题。

本机实际读取：`uname -m` 为 `arm64`，`sysctl -n machdep.cpu.brand_string` 为 `Apple M5`，`sysctl -n hw.optional.arm64` 为 `1`。仅确认当前机器与架构，不宣称已测试某条可选 SIMD 指令。

新增已读官方资料：

- [ggml README](https://github.com/ggml-org/ggml/blob/master/README.md)，快照 `ggml-README.md`：项目描述包含 ARM SIMD 优化内核和低位整数定点量化等能力。具体实现将在每日选题时另行核实。
- [ncnn README](https://github.com/Tencent/ncnn/blob/master/README.md)，快照 `ncnn-README.md`：项目描述包含 ARM NEON CPU 推理、多核调度、FP16 路径及 INT8 量化推理。具体函数、布局和指令支持不从 README 推断。

两份快照均来自当日 master 分支，不替代具体练习的 commit/文件/函数依据。下一次每日主题仍为 RK3588 NPU / RKNN；本次没有生成新练习。
