# 2026-10-12 RK3588：相机行跨度与单次归一化合同

## 工业场景

ROCK 5B/RK3588 相机服务接收 RGB888 帧，源行跨度可能大于 `W*3`。把含 padding 的相机缓冲区直接交给紧凑 Tensor 接口，会产生周期性错行；把已经归一化的数据再交给带 mean/std 的转换图，会产生稳定但错误的输出。今天把这两种错误变成可重复检查。

模型是固定 `NCHW [1,3,3,5] → [1,2,3,5]` 的 1×1 Conv；输入提交为紧凑 FLOAT32 NHWC。部署参照 30 fps、单在途请求，33.3 ms 是产品预算，未实测达标。CPU验证另覆盖宽641。单帧内存上界为源 `H*stride`、输出输入 `12HW` 字节、参考 `8HW` 字节及 SDK 自有内存；基线多一个 `3HW` 字节临时缓冲区。

## 概念回顾

相机帧的宽度描述一行有多少有效像素，行跨度描述相邻行起点的字节距离，两者不能互换。对交错三通道数据，像素地址由行号乘跨度、列号乘通道数和通道偏移共同决定。即使总缓冲区足够大，忽略跨度仍会把填充字节当作下一行像素。这类错误通常不会触发越界检查，却会让推理结果随图像宽度发生突变。因此输入适配器首先验证维度、乘法溢出和最小可读范围，再按行提取有效像素，不能用内存分配大小代替布局合同。

与布局紧密耦合的是预处理的唯一责任方。本课让主机把像素变成减均值、除标准差后的浮点值，模型转换配置保持恒等变换。提交描述符声明真实数据类型和排列方式，由运行时转换到模型需要的表示。开启透传表示调用方已经满足原生输入要求，不能把它理解成通用加速开关。逻辑输入字节数、相机跨度和设备原生带跨度大小分属三个接口，混用会使看似正确的尺寸检查失去意义。

基线先去掉行填充再归一化，候选在一次遍历中完成两步，减少一个临时数组及其读写，但两者必须保持相同的舍入与通道顺序。内存流量减少不等于端到端提速，运行时内部转换、设备执行和输出读取仍可能占主导。输入数组必须活到同步推理和结果读取结束，输出通过租约释放，最后销毁上下文。校验使用独立像素公式和固定卷积权重，避免两条路径复制同一个错误。宿主的逐元素正确性只证明适配器合同，模型转换、板端精度和时延必须在真实工具链与设备上分别验收。

## 知识图谱

```text
相机 RGB888 / stride(bytes)
  └─ Frame::validate：有效范围、尺寸溢出
      ├─ baseline：逐行pack → normalize
      └─ fused：逐行normalize → 紧凑NHWC FLOAT32
          └─ inputs_set(type/fmt/pass_through=0)
              → RKNN模型(恒等mean/std) → 同步run/get
                  → NCHW输出校验 → Output释放 → Context销毁
```

前置：字节与元素单位、RGB顺序、NCHW/NHWC索引、C++17 RAII。不能混淆：相机stride与设备`size_with_stride`；FLOAT32用户输入与设备内部FP16/INT8；主机调用区间与NPU设备区间；同一物理内存与无需同步。

实际阅读 [Rockchip Model Zoo](https://github.com/airockchip/rknn_model_zoo)，main，2026-10-12：`examples/mobilenet/cpp/rknpu2/mobilenet.cc` 的 `init_mobilenet_model/inference_mobilenet_model/release_mobilenet_model`，以及 `examples/mobilenet/python/mobilenet.py` 的 config/load/build/export/inference 主流程。Apache-2.0，原场景是MobileNet分类。本例是**受其启发的独立实现**：保留输入描述符、查询、run/get/release调用边界，替换为确定性小卷积和异常安全所有权；省略图像缩放、分类、RGA和零拷贝。另读 Toolkit2 master 的 `rknn_api.h` 中输入合同/性能查询与README v2.3.2。详见[source.json](source.json)，不把分支读取冒充固定commit。

## 编码练习

唯一必做任务，预计25分钟：先运行现成基线，然后亲手重写 `src/input.hpp` 的 `fused`，保持其接口，用行跨度读源并直接写紧凑NHWC浮点数组。约5分钟看合同，12分钟实现，8分钟跑所有尺寸与故障反例。现成最终候选已提供，可用于复核；不得靠改 oracle、放宽容限或删检查过关。

本课具体改动减少 CPU 临时pack数组，不讨论CUDA kernel，也不以CPU替代GPU课程；下一主方向照常是PTX/CUTLASS。

## 文件说明

- [input.hpp](src/input.hpp)：合同、两条预处理路径、独立固定卷积oracle；[main.cpp](src/main.cpp)：CPU校验。
- [convert.py](convert.py)：无模型下载的ONNX生成、ONNX ReferenceEvaluator对照及RK3588转换。
- [rknn.cpp](src/rknn.cpp)：完整板端C++ Runtime、属性拒绝、输入寿命、输出租约、分口径计时。
- [验证](verification.json)与[实际日志](results/release.txt)。
- 附加现成材料：[AutoRound](../../quantization/2026-10-12/autoround/README.md)、[ARM19](../../arm/2026-10-12/README.md)、[OS14](../../os/2026-10-12/README.md)、[C++17第13课](../../cpp17/2026-10-12/README.md)、[RAZOR/CoRePrune](../../paper/2026-10-12/README.md)。均不增加必做编码任务。

## 编译与运行

工作目录为项目根；主机不安装依赖。

```sh
sh systems_practice/daily/2026-10-12/run.sh
# 已有numpy/onnx环境：生成微型图并验证；模型只写忽略的build/
python3 systems_practice/daily/2026-10-12/convert.py --onnx-only
# Linux已有匹配RKNN-Toolkit2环境：同时转换；Mac不支持凭空验证此步骤
python3 systems_practice/daily/2026-10-12/convert.py
# RK3588板端，用已安装SDK的真实路径替换变量值
export RKNN_INCLUDE=/opt/rknn/include
export RKNN_LIB=/opt/rknn/lib
sh systems_practice/daily/2026-10-12/build.sh rknn
systems_practice/daily/2026-10-12/build/rknn_input systems_practice/daily/2026-10-12/build/tiny.rknn
```

主机 Apple Clang21、Python3.9.6。转换脚本按已读Toolkit2 API编写；其README列v2.3.2，但本机没有Toolkit2、ONNX或板卡。建议用供应商匹配的Toolkit2/Runtime组合；程序查询并输出实际API/driver版本，不能从头文件推断板端驱动版本。本例 `do_quantization=False`，无需INT8校准；将来启用INT8必须提供代表相机分布且经过同一归一化的独立校准集，核对当前版本dataset布局约定，不能把今日单张评估帧同时用作校准。今日不声称完成INT8模型转换。

## 正确性验证

45组 `(H,W,padding)`；零高/宽、stride过短、截断和尺寸乘法溢出拒绝；最后一行无尾padding仍合法。独立公式逐元素核验，两条CPU路径完全一致。故障注入安全地计算错误结果，错stride影响30元素，重复归一化影响45元素。

模型转换应先通过ONNX FP32参考 `atol=rtol=1e-6`。板端检查精确I/O维度、格式及30输出，任何非有限值拒绝；非量化RKNN绝对误差上限0.005为本例验收阈值，若失败先记录真实输出并排查，不自动放宽。该阈值不是分类任务精度保证。运行成功才可填板端结果。

## 性能分析

假设基线临时pack对CPU造成多余一次写和一次读，则逻辑流量比融合多`6HW`字节；这是理论流量，不是DRAM计数或实测速度。小图的分配开销可能掩盖流量差异。今天CPU只验正确性，无性能数字。

板端预热5轮、采集20次完整 `预处理→inputs_set→run→outputs_get→校验→release` 主机区间，输出P50/P95。另查询`RKNN_QUERY_PERF_RUN`的SDK最近一次`run_duration(us)`，失败打印返回码，不填零。它是SDK设备统计，不是逐算子自测，也不可用主机区间减它就断言纯复制成本。采集型号、OS、温度、频率、SDK/driver版本；大帧公平比较必须保持shape、内容、精度和同步一致，至少测含预处理与不含预处理两个区间。

## 实际运行结果

Mac Release、ASan/UBSan通过；官方真实`rknn_api.h`的C++17语法检查通过，**未链接RKNN库**。最初把含上游`optional`的研究目录用作include路径引起头文件遮蔽，隔离仅RKNN头文件后通过；这不是SDK不兼容。ONNX生成尝试因`onnx`缺失失败，日志见[onnx-attempt.txt](results/onnx-attempt.txt)。转换、板端执行、NPU精度、NPU性能及端到端时延均未验证；没有生成假的`.rknn`或GPU收益。

## 工程注意事项

一个请求独占上下文和临时输入；没有启用异步模式。`pass_through=0`允许Runtime做类型/布局转换，不承诺零拷贝。输出格式若发生变化必须写明确转换，当前按合同拒绝；失败析构也检查返回码。主机数学模型不是RKNN模拟器，逻辑字节检查不是设备DMA一致性验证。

## 工业故障与面试追问

1. 宽度不是对齐整数时输出花屏→可能stride错误或RGB/BGR错误→用彩色坐标图比较首个错元素位置→按行读且确认通道顺序；增加适配成本但先保正确。
2. 所有输出幅度缩小或偏置漂移→可能归一化执行两次→保存模型入口3个通道的值并对照config→只保留一个责任方；重新转换模型并回归旧输入。
3. 偶发结果变化/内存报错→可能输入提前复用或输出释放不配对→单在途、记录get/release计数→把缓冲区绑到请求寿命；吞吐优化必须在此合同上增加事件/租约。

追问：stride单位为何必须是字节？最小可读范围为何不是`H*stride`？`pass_through`绕过了哪些转换？模型属性与用户输入描述符为何可不同？减少pack为何可能无加速？同步输入生命周期若改成异步怎样验收？

## 自测问题

相同RGB内容、W=5、源stride=28的两帧在CPU oracle上完全一致，但只有RKNN板端输出系统性偏小：你会按什么顺序取得哪些证据，区分布局、预处理、量化与资源寿命四类原因？
