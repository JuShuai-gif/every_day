# 01：带背压的相机 CPU 前处理流水线

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

确定性灰度帧 → ROI/2×2 box 下采样 → uint8 量化 → [0,1] FP32 → 完整输出消费者。生产线程向容量 3 的索引队列提交 8 帧，主线程消费，最后关闭并排空。队列满时阻塞，不丢帧。没有相机驱动、DMA、推理模型或 NPU 调用。

## 结构与合同

include/camera.hpp 定义帧/ROI/workspace/队列；src/camera.cpp 实现算法与流水线；src/self_test.cpp 包含独立已知图像和队列边界测试；src/main.cpp 配置回放。其余 CMake、cmake/、scripts/、三个 shell 入口和 include/edge_bench.hpp 随项目独立分发。

640×480、stride=672、ROI=(3,2,633,475)，覆盖 padding、偏移和奇数尾部。输出 ceil(width/2)×ceil(height/2)。2×2 平均先整数除法量化，再乘 1/255；边缘只计有效像素。空尺寸/截断输入/尺寸溢出/ROI 越界均拒绝。

输入帧由调用方持有直到 join。队列只保存索引和时戳，最多 3 个 Item；close 唤醒读写双方并排空。异常先 close 再 join，避免生产者在满队列永久等待。workspace 属于单消费者。

8 张输入约 2.58 MB，单张输出约 302 KB；baseline 每帧还有 uint8 中间图像。图像生成在计时外，任务创建和 workspace 初始化在计时内。

## 分阶段优化与证据

| 阶段 | 改动 | 定位证据 | 接受条件 |
| --- | --- | --- | --- |
| baseline | 每帧分配中间图像/FP32，按列处理 | allocator、跨行访问、消费者 hash 各自热点占比 | 功能参考 |
| stage1 | 保持列式和两算子，只预留并复用 workspace | 分配路径减少，是否真的降低 p95 | 正确性保持，收益可重复 |
| optimized | 连续融合，NEON 每轮 8 个整数 box 输出，再转 FP32；尾部标量 | 中间读写/边界分支减少，向量指令与 hash 占比 | 板端场景预算达标 |

最终阶段同时变化循环、融合、NEON 和边界检查，不能把全部收益仅归于缓存或 SIMD。EDGE_ENABLE_NEON=OFF 保持同一融合算法并关闭显式 NEON，可配合 EDGE_AUTO_VECTORIZE 控制自动向量化；详细对照见 ARM_RK3588.md。

## 执行闭环

~~~sh
bash run-mac.sh
build/native/camera_resize --test
build/native/camera_resize --mode all --samples 120 --csv records/comparison.csv
build/native/camera_resize --mode optimized --seconds 60 --iterations 1 \
  --budget-us 5000 --csv records/stress.csv
~~~

5000 μs 是 8 帧回放批次的示例预算，须替换成实际要求。一次 invocation 包含队列/缓冲创建、线程启动、8 帧处理、完整输出 hash、排空与 join。顶层 p50/p95 是批次耗时，吞吐单位 frame/s。

last_batch 的 frame_queue_plus_processing_p95_us 从入队等待前计时，含背压、处理与 hash；是最后批次的辅助统计，不等于真实曝光到动作延迟，也不代替多轮 CSV。

~~~sh
CROSS_CXX=/absolute/toolchain/bin/aarch64-linux-gnu-g++ \
SYSROOT=/absolute/rk3588-sysroot bash build-rk3588.sh
BOARD=user@board bash run-rk3588.sh

perf record --call-graph dwarf -o camera.perf -- ./camera_resize \
  --mode optimized --profile --samples 200
perf report --stdio -i camera.perf
~~~

先确认 MIDR/CPUinfo 再分别绑定 A55/A76 核组；单核与多核绑定是不同实验。若 hash 已占大头，应测真实消费者而不能删掉工作宣称端到端收益；若队列等待主导，应分析处理速率而非无限增加容量。

## 验证与落地边界

覆盖手算 3×3 padding 图、单像素 ROI、奇偶宽度、完整逐像素比较、容量 1 背压、关闭唤醒/排空、处理异常和空回放。CTest 有超时，ASan/UBSan 检查越界和未定义行为。记录填入 records/TEMPLATE.md。

接入真实相机仍需帧池、DMA 生命周期、丢帧策略、曝光/模型完成时间，以及长期温控测试。这里只交付可运行的 CPU 流水线和验证流程，不虚构硬件验收。
