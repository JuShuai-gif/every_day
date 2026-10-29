# 2026-10-27 RK3588 NPU/RKNN：ONNX 转换与输入所有权

## 工业场景
双目相机服务把带行跨度的 RGB888 帧送入 RK3588 NPU。今天固定一个小型 ONNX Relu 图，讲清 ONNX→RKNN 转换合同与输入/输出缓冲区寿命两个紧密机制。生产约束是 30 fps、单帧 [1,3,4,4]，输入必须在 rknn_inputs_set 到同步 rknn_outputs_get 期间保持有效；真实 Toolkit2、Runtime、驱动和板端验证另行完成。

## 概念回顾
rknn.load_onnx、config(target_platform=['rk3588'])、build、export_rknn 把图和校准选择冻结成 .rknn；脚本成功不等于板端输入格式正确。rknn_tensor_attr 是运行时合同，应用应查询并拒绝未知维度、类型或布局。量化校准数据必须独立于评估帧并代表相机分布；本课默认非量化路径，不伪造 INT8 结果。

输入描述符的 buf、size、type、fmt、pass_through 描述调用方内存。同步 rknn_run 结束前不能复用或释放输入；outputs_get 后必须 outputs_release。若以后切异步，请把请求、输入租约、输出租约和完成事件绑定，不能只把 run 放入线程池。

## 知识图谱
ONNX graph + target platform + calibration → load/build/export → tiny.rknn；camera stride → validated pack/normalize → rknn_input → inputs_set → run → outputs_get → check → release。size 是逻辑字节数，size_with_stride 是设备属性；CPU 复制正确不证明 DMA 一致性。

## 编码练习
唯一 25 分钟任务：把 src/input.hpp 的 fused 接入输入合同，覆盖任意 padding 和尾行并保持非法 stride 拒绝。5 分钟读转换/寿命合同，12 分钟实现，8 分钟运行 run.sh cpu sanitize；不把 CPU 通过当作 RKNN 通过。

## 文件说明
[input.hpp](src/input.hpp)、[cpu_check.cpp](src/cpu_check.cpp) 是逐行布局与独立 oracle；[convert.py](convert.py) 生成小 ONNX 和真实 Toolkit2 转换入口；[rknn_runtime.cpp](src/rknn_runtime.cpp) 是真实 rknn_api.h 运行时候选；[source.json](source.json)、[verification.json](verification.json) 和 [results](results/) 保存证据。

## 编译与运行
```sh
sh systems_practice/daily/2026-10-27/run.sh cpu
sh systems_practice/daily/2026-10-27/run.sh sanitize
python3 systems_practice/daily/2026-10-27/convert.py --onnx-only
RKNN_INCLUDE=/opt/rknn/include RKNN_LIB=/opt/rknn/lib sh systems_practice/daily/2026-10-27/build.sh rknn
systems_practice/daily/2026-10-27/run.sh rknn build/tiny.rknn
```
板端使用供应商匹配版本；本机没有 Toolkit2/Runtime。CUDA 课程仍固定 Thor sm_110，与 RKNN 分开。

## 正确性验证
CPU 覆盖 180 个形状组合和 4 个拒绝，两条路径逐元素误差不超过 1e-7。板端验收应查询输入/输出属性、拒绝非有限值并记录 FP32 误差；没有 .rknn 就不填设备结果。

## 性能分析
融合路径理论上少一次 3HW 临时写和读，这不是 DRAM 实测。板端预热 5 次、20 次采样，分别记录主机 inputs_set→outputs_get 与 RKNN_QUERY_PERF_RUN.run_duration；还要分开 CPU 预处理和端到端 P95。

## 实际运行结果
Apple Clang21 的 CPU Release/ASan/UBSan 结果写入 results/。本机未安装 onnx、Toolkit2 或 RKNN Runtime；转换、链接、板端精度与 NPU 性能待补，不生成假的 .rknn。

## 工程注意事项
实际阅读 Rockchip Model Zoo 提交 837db8e992815ff8647eadb709f07067f4bc3a71，Apache-2.0：mobilenet.cc 的 init_mobilenet_model/inference_mobilenet_model 和 mobilenet.py 的 load_onnx/build/export_rknn/init_runtime/inference。原场景是 MobileNet 分类，本课独立改编，保留 API 边界，省略 RGA、相机解码和真实校准集。

## 工业故障与面试追问
转换成功但板端维度拒绝：保存 rknn_query 属性并与 input_desc 比对；输出偶发花屏：记录请求代次、输入地址和 release 计数；INT8 稳定偏差：重新分离校准/评估集并保留 FP32 对照。追问：pass_through=0 允许什么？size_with_stride 为何不是逻辑长度？校准为何分离？异步后谁拥有输入？如何区分 run_duration 与端到端 P95？

## 自测问题
相同 ONNX 导出成功，但 RK3588 查询到 NHWC UINT8，而服务仍提交 NCHW FLOAT32；你会如何设计最小证据链，决定改转换配置还是改预处理适配器？

## 来源与边界
[source.json](source.json) 记录仓库、提交、函数和许可；[verification.json](verification.json) 分开记录源码阅读、CPU、转换和板端状态。下一主轮换为 PTX/CUTLASS，本课没有用 CPU 或 Metal 替代 GPU 内容。
