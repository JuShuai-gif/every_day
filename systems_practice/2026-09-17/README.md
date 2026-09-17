# 2026-09-17：RK3588 NPU / RKNN——带 stride 的 UINT8 NHWC 输入绑定

## 工业场景

双相机机器人控制头每帧向 RK3588 NPU 提交一张裁剪后的 RGB 图像，模型输入为 UINT8 NHWC `[1,4,6,3]`（练习尺寸；部署可替换为 `[1,224,224,3]`）。低 Batch 下，CPU 的逐行预处理、Runtime 内存绑定和一次 `rknn_run` 都可能进入端到端关键路径。约束是输入必须按 Runtime 查询到的物理 `w_stride/size_with_stride` 写入；禁止将紧凑 `H*W*C` 缓冲区误绑定为对齐缓冲区。目标是零初始化 padding、正确回读 Identity 输出，并把 CPU 预处理、主机 Runtime 调用和 NPU 设备时间分开记录。

## 概念回顾

RKNN 模型中的逻辑 Shape 描述元素语义，Runtime 查询到的 `w_stride` 与 `size_with_stride` 描述实际绑定内存的行跨度和总字节数，两者不能互换。图像通常在 CPU 上是紧凑 NHWC：每行恰有 `W*C` 字节；NPU Runtime 为对齐或内部布局可能要求每行 `w_stride*C` 字节。若把紧凑地址作为物理缓冲区绑定，首行之后会从错误偏移读取，轻则精度漂移，重则越界。正确路径是先查询 tensor attr，以 `size_with_stride` 创建并绑定 memory，将整块清零后仅逐行拷贝逻辑像素，保留尾部 padding。绑定内存的创建、设置、运行和销毁必须属于同一 `rknn_context` 生命周期。`rknn_run` 外侧的计时包含主机调度与同步，不能直接称为 NPU 核心时间；设备时间仅在目标版本实际支持的性能查询工具给出时单列。这个契约适用于低时延视觉输入，也能避免未来换模型后因 stride 改变留下的隐性 bug。

## 编码练习

完成 `src/rknn_stride_binding.cpp` 中的板端路径：它已查询输入/输出 attr、用 RAII 管理 context/memory、按 `w_stride` 拷贝紧凑 RGB 行、绑定输入输出并以 Identity 输出做逐行正确性检查。将 `tools/make_identity_onnx.py` 与 `tools/convert_rknn.py` 在目标转换机运行，随后在 RK3588 上运行该程序。练习改动点：把固定 `4x6x3` 扩展为从 attr 推导的尺寸，同时保持非 3 通道或非 UINT8 时快速失败。

来源与简化边界：这是基于 RKNN-Toolkit2 的公开转换流程与 RKNPU2 Runtime C API 的**独立最小实现**，不是模型库源码拷贝。已核实本地归档的 [RKNN-Toolkit2 README](../references/rk3588-arm/rknn-toolkit2-README.md)，确认 Toolkit2 转换、Lite2 与 C/C++ Runtime 的职责区分；参考项目为 [airockchip/rknn-toolkit2](https://github.com/airockchip/rknn-toolkit2)，master（2026-09-16 本地快照）。本次网络无法读取指定版本的示例源码，故不把任何未读函数归因给它；实际部署前请以设备随附 `rknn_api.h` 和相同版本 Model Zoo 示例复核 `rknn_create_mem`、`rknn_set_io_mem` 的 ABI。为控制在 20–30 分钟，仅保留单输入单输出 Identity，省略真实检测模型、多输入和量化校准。

## 文件说明

- `src/preprocess_cpu.cpp`：可移植的紧凑 NHWC → 带行 padding 缓冲区参考与边界测试。
- `src/rknn_stride_binding.cpp`：RK3588 C++ Runtime 完整绑定、执行和 Identity 回读路径。
- `tools/make_identity_onnx.py`：生成最小 ONNX；`tools/convert_rknn.py`：转换为 `.rknn`。
- `CMakeLists.txt`：默认 CPU 构建；传入 `RKNN_API_ROOT` 后才构建板端目标。
- `run.sh`：Mac 本机 CPU 验证入口。

## 编译与运行

Mac 本机（实际可运行的辅助检查，不是 NPU 推理）：

```sh
cd /Users/guhaoran/code/EveryDay/systems_practice/2026-09-17
./run.sh
```

受支持的 Linux x86_64 RKNN-Toolkit2 转换机（Toolkit2、Python `onnx` 由使用者已有环境提供）：

```sh
python3 tools/make_identity_onnx.py
python3 tools/convert_rknn.py
```

RK3588（Runtime、驱动与转换出的模型需按同一发布包兼容矩阵配套；此 Mac 未核实具体版本）：

```sh
cmake -S . -B build-rk3588 -DCMAKE_BUILD_TYPE=Release -DRKNN_API_ROOT=/opt/rknpu2/runtime/Linux/librknn_api
cmake --build build-rk3588 --target rknn_stride_binding
./build-rk3588/rknn_stride_binding stride_contract.rknn
```

## 正确性验证

CPU 检查使用 `N=1,H=4,W=6,C=3,w_stride=8`：每行前 18 字节必须与紧凑输入相等，后 6 字节必须为零；空输入必须抛出异常。板端验收要求程序打印 `RKNN Identity stride correctness=PASS`，并在故意把 `w_stride` 当 `w` 使用的对照版中复现不匹配。真实模型还应以原始预处理和参考输出评估精度，不能用 Identity 通过代替模型精度。

## 性能分析

先预热，再至少 100 次测量，分别记录：(1) CPU 行拷贝/预处理时间；(2) 从提交到 `rknn_run` 返回的主机 Runtime 调用时间；(3) 仅当目标 SDK 工具实际提供时记录的 NPU 设备时间；(4) 含采集、预处理、推理和后处理的端到端延迟。另记 P50/P95、帧率、CPU 占用和内存。不要将 Mac CPU 或主机调用时间标成 NPU 时间，也不要跨 Apple Silicon 与 RK3588 外推性能。

## 实际运行结果

Mac arm64：Release 实际编译运行通过，`CPU stride-pack correctness=PASS`；1,000 次预热后 10,000 次平均 **0.0856833 us/次**，日志见 [output.log](results/mac-cpu-run/output.log)。ASan/UBSan 也实际通过，平均 1.62102 us/次，见 [sanitize.log](results/mac-cpu-run/sanitize.log)；两者都是 CPU 辅助检查，非 NPU 数据。转换未运行，缺少本机 RKNN-Toolkit2/ONNX 环境。RK3588 未运行，当前没有板卡、Runtime/驱动和 `.rknn`；NPU 执行、设备时间、真实模型精度与功耗均未验证。网络读取开源示例源码失败，原始失败与范围见 [verification.md](results/verification.md)。

## 工程注意事项

`size` 是逻辑数据量，分配/绑定应使用 `size_with_stride`。所有 query 和 set/bind 返回码在生产版应附带 SDK 版本、tensor attr 日志；本练习对关键调用失败直接退出，并用 RAII 反向销毁 memory/context。转换端 Toolkit2、板端 Runtime 与内核驱动必须按 Rockchip 发布包兼容，不能假定任意版本互通。INT8 模型还要锁定 RGB/BGR、scale、zero point 和校准集；本 Identity FP/UINT8 契约练习没有校准，不能据此推断量化精度。

## 自测问题

如果新模型逻辑输入仍是 `[1,224,224,3]`，但 Runtime 查询到更大的 `w_stride` 且输出改为量化 INT8 NCHW，你会如何重构绑定与逐行/逐通道验证，保证不把 CPU 预处理或 Runtime 调用时间误归为 NPU 设备时间？
