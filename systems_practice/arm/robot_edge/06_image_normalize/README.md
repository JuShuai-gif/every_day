# 推理前处理：带 stride 的 RGB8 到归一化 NCHW 张量

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

本工程模拟边缘视觉推理的 CPU 前处理：验证相机 RGB8 缓冲 → uint8 转 FP32 → 每通道均值/标准差归一化 → 从交错 HWC 转平面 CHW（batch=1 时即 NCHW）。默认输入 1280×720，每行额外 padding 64 字节，输出 3×720×1280 个 float。

这里只覆盖 CPU 前处理，不加载模型、不调用 RKNN/NPU/GPU，也不采集摄像头；本机结果不能证明目标板推理速度或整条视觉管线的端到端性能。

## 项目结构与输入合同

`src/pipeline.hpp` 实现图像/参数模型、验证和三个阶段；`tests/cases.hpp` 实现逐元素容差比较、已知布局答案、stride 与 SIMD 尾部测试；`src/main.cpp` 定义工作负载和测量。项目内有独立 CMake/CTest、sanitizer、Mac/交叉编译/SSH 脚本、环境/perf 采集及记录模板。

- 图像宽 `1..4096`、高 `1..2160`；stride 至少 `width×3`，额外 padding 至多 4096 字节；像素存储必须恰好 `stride×height`。
- 通道顺序明确为 RGB，输入像素范围 0–255；不隐式交换 BGR，不把 padding 当像素。
- 输出大小必须恰好 `width×height×3`，排列为完整 R 平面、G 平面、B 平面。
- 每通道计算 `(pixel/255 - mean)/stddev`；参数必须有限、stddev 至少 1e-6，且归一化输出应可表示为有限 FP32。设备集成需核对模型训练时的相同参数、颜色与布局。
- 固定输入约 `stride×height` 字节，输出 `width×height×3×sizeof(float)`；baseline 另有同样大小的交错 FP32 中间张量。容量上限约束计算规模，不声称这些就是整个进程 RSS。

## 三阶段优化

| 阶段 | 实际实现 | 要隔离的变化 |
| --- | --- | --- |
| baseline / Multipass | 分配交错 FP32 中间张量，转 float、归一化、转平面三遍 | 中间张量分配及多遍读写的成本 |
| stage1 / Fused | 复用输出，直接单遍写三个平面，预计算标准差倒数 | 融合/减少中间内存的收益与数学舍入变化 |
| optimized / Vectorized | 同一融合管线，每轮 NEON 读 8 个 RGB 像素（24 字节） | SIMD 相对于编译器优化后的融合循环的收益 |

NEON 使用解交错载入，扩展 uint8→uint16→uint32→float，写对应平面。每行只在 `x+8<=width` 时向量读取；剩余不足 8 像素走标量，不依赖行末 padding 可以越界读。无 `__ARM_NEON` 或 EDGE_ENABLE_NEON=OFF 时使用标量回退并打印实际 backend；EDGE_AUTO_VECTORIZE 另控制编译器向量化。

倒数乘法与除法可能有微小舍入差异；验收容差为 `2e-6 + abs(reference)×2e-6`，逐元素检查有限值。Stage1 可能已由编译器自动向量化，不能只因手写 intrinsic 就声称 optimized 更快。

## 完整复现步骤

1. 在记录模板定义 shape、RGB/BGR、stride、NCHW、mean/stddev、容差及单帧前处理预算。保留模型输入合同，防止“快了但换了计算”。

2. Mac 构建、自检与 sanitizer：

   ```bash
   bash run-mac.sh --samples 30 --warmup 5
   ./build/native/image_normalize --test
   ./build/native/image_normalize --mode all --samples 120 --csv records/manual-samples.csv
   ```

   脚本创建独立 records/mac-*，保存命令、编译参数、环境、CTest、ASan/UBSan、CSV/JSON。脚本管理其 CSV；自定义 `--csv` 或 `--test` 直接调用可执行文件。

3. 从 Mac 构建 Linux/aarch64 ELF 并部署：

   ```bash
   export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
   export SYSROOT=/absolute/path/to/rk3588-sysroot
   bash build-rk3588.sh
   export BOARD=user@rk3588-host
   bash run-rk3588.sh
   ```

   工具链必须能在 Mac 运行、匹配目标 rootfs；替换实际路径/地址。检查 ELF 与库依赖，记录二进制校验和。依据 lscpu/MIDR 识别核类型再设 CPU_SET；不能猜固定核编号。前后采集频率、温度和负载。

4. 板端 `--test` 后分别定位三阶段：

   ```bash
   perf stat -r 5 -e cycles,instructions,cache-misses \
     ./image_normalize --mode baseline --profile --samples 120 --iterations 5
   perf record --call-graph dwarf -o baseline.data -- \
     ./image_normalize --mode baseline --profile --samples 120 --iterations 5
   perf report --stdio -i baseline.data
   objdump -d -C ./image_normalize > image_normalize.disassembly.txt
   ```

   给 stage1/optimized 使用独立模式和输出文件；检查标量融合是否自动向量化、优化版是否实际使用 NEON、热点是否转向内存带宽。`objdump` 需要板端 AArch64 版本。PMU 包含进程初始化/预热，通用 cache-misses 不是直接测量的内存带宽；不可用时记录失败。

5. 改动后重新逐元素比对，并做至少一分钟重复执行：

   ```bash
   ./image_normalize --mode optimized --samples 120 --seconds 60 --iterations 1 \
     --budget-us 10000 --csv normalize-stress.csv
   ```

   10 ms 是练习用单帧预算，按目标相机帧率和推理余量调整。记录 p95/p99/max、RSS、温度变化；至少 5 轮比较，保留 optimized 变慢的结果。

## 测量与完整性限制

时间是一帧验证和完整张量生成，baseline 的中间分配包含在内；吞吐单位是像素/秒。输入生成/输出预分配与完整参考比较在计时外。所有输出通过编译器屏障保持可观察，不能删除主体计算。

计时内 token 只采样输出首尾 float 的 bit pattern，降低全张量哈希对内存带宽测试的干扰。因此重复 token 能发现首尾异常，但**不代表每次长测都检查了完整张量**；完整正确性由计时外逐元素测试验证。浮点舍入允许的差异也意味着不同阶段 token 未必相同。

单帧 p99 需 `iterations=1`；较大 iterations 的分位数是均摊值。RSS 为进程峰值，不能直接当单算法的额外内存。

自检覆盖独立 RGB→平面已知答案、1/7/8/9/15/16/17 等宽度、0/1/64 padding、padding 不影响输出、错误尺寸/缓冲、非有限参数及标准差边界。真正接入 RKNN 时仍需校验模型量化、张量接口、缓存一致性、拷贝成本和真实推理输出；这里没有虚构 NPU 或目标板收益。
