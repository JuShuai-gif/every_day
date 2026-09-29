# 2026-09-29 RK3588 NPU / RKNN：输出数值契约与缓冲区租约

## 工业场景

ROCK 5B / RK3588 的视觉控制头升级为 INT8 后，输出看似正常却改变控制阈值，且异常请求逐渐耗尽 Runtime 内存。本课把问题缩成 `[1,3,4,5] FP32 NCHW → 1×1 Conv → [1,2,4,5]`，只检查数值解释和输出所有权。输入60个浮点、输出40个元素；同步单请求，Runtime输出最多存活一个作用域。目标不是训练模型，而是建立模型发布时可重复的验收门。

源码先读 [RKNN Model Zoo](https://github.com/airockchip/rknn_model_zoo)，main，2026-09-29：`examples/mobilenet/cpp/rknpu2/mobilenet.cc` 的 `init_mobilenet_model`、`inference_mobilenet_model`、`release_mobilenet_model`；以及 `3rdparty/rknpu2/include/rknn_api.h` 的输出结构、获取/释放契约。原场景为MobileNet分类；保留查询属性→设置输入→运行→获取→后处理→释放，省略图像解码、RGA、分类排序。代码是受其接口契约启发的独立C++17实现，不是原始源码拷贝。根许可证Apache-2.0；SDK头有单独声明，不随本课复制。精确commit因GitHub DNS失败待补。[来源记录](source.json)。

## 概念回顾

量化输出首先是一段带解释规则的字节，而不是天然可用的浮点数组。逐张量仿射量化把整数码映射为实数：先从整数码减去零点，再乘缩放因子。零点表达实数零在整数域的位置，不能用符号位或直觉替代。模型转换后必须重新查询输出类型、布局、元素数和量化属性；仅凭原始模型的输出类型或上次运行的参数，可能把有符号整数当无符号整数，也可能在布局不匹配时读错通道。减法前提升到较宽整数，检查缩放为有限正数，并拒绝尚未实现的格式，才能让错误在控制量进入业务前显式暴露。

这个数值契约与输出缓冲区的生命周期紧密相连。运行时分配的输出指针是一次获取所授予的临时访问权，后处理代码拥有读取权却不拥有永久保存权。获取成功后立即建立唯一的作用域租约，正常返回和异常展开都执行释放；先解码或复制进自有容器，再让结果离开作用域。租约不可复制，移动后旧对象失去释放责任，避免双重释放。运行上下文必须比租约活得更久；请求结束后保留裸指针，即使下一帧暂未覆盖它，也已违反所有权约定。

验证要分成两个问题：自动浮点输出与手动反量化一致，证明解释规则正确；与原始卷积参考接近，才检查模型量化带来的误差。前者通过并不能证明校准集有代表性，后者失败也不一定是缓冲区损坏。计时同样分层：主机调用可能包含排队、同步和转换，不能直接命名为设备内核时间。先固定输入、误差门限和释放边界，再比较两条输出路径，才能把数值错误、资源泄漏与性能变化分别定位。

## 知识图谱

```text
ONNX数值语义 → 校准/转换 → RKNN输出属性(type/fmt/scale/zp)
                                  ↓
Runtime get成功 → OutputLease → decode或copy → 自有vector → release
                  ↓异常展开                 ↓
               同样释放             与自动输出/FP32 oracle双重对照
```

前置是NCHW索引、仿射量化和RAII。`contract.hpp::decode`连接字节与实数；`infer`连接SDK所有权与异常安全。这里使用普通逻辑输出，不等于native零拷贝输出；`size_with_stride`不能直接当逻辑元素数。C++保证析构时机，不保证厂商SDK异步完成或线程安全；本例不打开异步标志，每个context串行使用。

## 编码练习

唯一必做任务，约25分钟：在已给出的完整实现上，为`decode`加入调用方可选的“输出绝对值上界”验收参数，禁止无穷/负上界，解码超界时抛错，并用现有租约失败注入入口检查释放仍只发生一次。前5分钟追踪数据与租约，10分钟修改接口与调用，10分钟覆盖阈值相等、正负超界和异常释放，运行CPU检查。没有板卡也可完成此契约改动；RKNN代码与板端验收仍是同一练习的目标部分，不能以CPU通过替代。

## 文件说明

- [contract.hpp](src/contract.hpp)、[cpu_check.cpp](src/cpu_check.cpp)：实际被目标程序复用的反量化/租约契约及边界检查。
- [rknn_output.cpp](src/rknn_output.cpp)：完整目标程序，两种输出路径、属性拒绝、计时与正确性门。
- [make_model.py](make_model.py)、[convert.py](convert.py)：生成ONNX与32个小校准张量并转换。无外部模型。
- [运行结果与状态](results/verification.json)。运行脚本不安装依赖。
- 额外现成阅读：[SmoothQuant](../../quantization/2026-09-29/smoothquant/README.md)、[ARM07](../../arm/2026-09-29/README.md)、[两篇论文](../../paper/2026-09-29/README.md)、[OS02](../../os/2026-09-29/README.md)。它们不增加必做作业或自测。

## 编译与运行

从仓库根目录执行：

```sh
sh systems_practice/daily/2026-09-29/run.sh cpu
sh systems_practice/daily/2026-09-29/run.sh sanitize
```

目标Linux转换环境需已有匹配的RKNN-Toolkit2、numpy、onnx，建议以板卡SDK配套2.x为起点，具体版本必须记录，不承诺任意2.x兼容。已读官方 [mobilenet.py](https://github.com/airockchip/rknn_model_zoo/blob/main/examples/mobilenet/python/mobilenet.py) 的config/load_onnx/build/export路径，原先尝试的convert.py返回404。本例独立生成Conv代替下载MobileNet。

```sh
cd systems_practice/daily/2026-09-29
python3 -m pip show rknn-toolkit2 numpy onnx
python3 make_model.py
python3 convert.py
# 在RK3588 Linux上，RKNN_ROOT指向已有的include/与lib/或lib64/。
export RKNN_ROOT=/opt/rknn-runtime
sh run.sh board
```

将生成的小模型与本课目录复制到板端对应位置后运行。转换脚本输出Toolkit版本；Runtime程序查询api/driver版本。先保存`uname -a`、`cat /etc/os-release`、`cat /proc/device-tree/model`、SDK版本和转换日志，再核对配套发布说明。输入运行时声明FP32/NCHW且`pass_through=0`，校准npy为NHWC、值域[0,1]，均无额外归一化。若SDK改变校准布局约定先核对，不能以调高误差阈值掩盖布局问题。

## 正确性验证

CPU覆盖1024个码/零点组合，6项非法参数，1000次移动租约（500次异常展开）和16帧参考输出。ASan/UBSan检查越界与未定义行为。板端固定16种输入含全零，20轮预热+100轮采样，每轮两次推理；输出必须为逻辑NCHW逐张量仿射INT8，否则明确拒绝，不做隐式猜测。

自动与手动反量化最大误差门限`max(1e-6,scale*1e-4)`；与FP32卷积最大误差≤0.03，这是合成验收阈值，不是实际模型任务精度标准。每轮都校验有限值。目标端需另外观察连续请求RSS/Runtime报错；CPU租约检查仅证明C++责任转移，不能证明驱动无泄漏。校准集随机种子与评估帧生成方式分离，门限预先固定。

## 性能分析

程序报告两条路径的主机`input_set→run→get→decode/copy→release` P50/P95，包含自有vector分配；另报`rknn_run`主机调用区间。两条路径相同模型、输入、预热、样本数，交替顺序。不能把`want_float=0`自动称为优化：它减少SDK浮点输出的潜在开销，却新增本地解码和分配，应以实测选择。

设备NPU时间、转换时间、摄像头到控制输出E2E、功耗均未实测。需要设备内核区间时另用所安装版本官方性能工具采集，记录profiling扰动，不能用主机区间顶替。CPU辅助检查未做性能排名。今日没有CUDA kernel，ncu/PTX/SASS不适用于RKNN NPU；CUDA目标约束保留为Thor SM110，兼容性资料与待验项见量化栏目。

## 实际运行结果

Mac arm64、Apple clang21：Release与ASan/UBSan均通过上述CPU检查，日志为[Release](results/cpu.txt)、[Sanitizer](results/sanitize.txt)。[模型生成](results/model-attempt.txt)缺numpy，[转换](results/conversion-attempt.txt)缺rknn模块，[目标构建](results/board-attempt.txt)缺rknn_api.h。没有伪造ONNX/RKNN文件，没有RK3588运行、精度、NPU耗时或E2E结果。

## 工程注意事项

这是一输入一输出固定形状示例，不是通用Tensor解析器；拒绝NHWC输出、FP16输出或native blocked格式是有意收窄的契约。上线应为每种受支持格式编写独立解析路径。Runtime销毁/输出释放即使在析构中也检查并报告返回码；当前析构失败只能报警，生产系统需把清理错误接入健康状态。任何数据引用不得跨越lease作用域。转换可能改变IO dtype；以查询结果验收，不以文件扩展名推断。

## 工业故障与面试追问

以下为基于接口的排障案例，非本机复现的板端故障：

| 触发 | 信号 | 根因/最小诊断 | 修复与代价 |
| --- | --- | --- | --- |
| 沿用旧zp/scale | 全部输出偏移或比例错误 | 打印属性，对照want_float | 模型和元数据同版本，发布时双重验收 |
| 保存Runtime裸指针 | 下一帧结果覆盖、偶发NaN | 缩短scope检查引用逃逸 | 先复制或解码；增加CPU开销 |
| 异常路径漏release | 长期请求后内存增长 | 失败注入、释放计数、板端RSS | RAII租约，context最后销毁 |
| 将INT8当UINT8 | 负数变大正数 | 用-128/127边界与属性查询 | 类型分派与更宽整数中间值 |

面试追问（基础→实现→边界→取舍）：

1. 为什么零点不是固定的0？
2. `n_elems`、`size`与`size_with_stride`分别表达什么？
3. 租约移动后如何避免两次释放？
4. 为什么自动反量化一致仍不能证明模型精度合格？
5. 析构函数释放失败如何向服务健康状态传播？
6. 如何区分SDK转换、排队、设备执行和复制成本？

## 自测问题

若两条输出路径完全一致、全零输入通过，但明亮画面的控制量持续被低估，且释放计数正常，你会按什么顺序收集证据来区分校准分布、输入布局和值域三类问题？
