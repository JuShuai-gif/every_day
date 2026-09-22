# 量化课程共用 C++17 存储与 CPU 参考

AWQ、GPTQ、AdaRound、AutoRound 的上游校准/优化接口留在各课 `upstream_api.py`；可选底层实验中的 nibble 打包、解码、存储验证、FP16 舍入、标量 CPU GEMM 和计时均在 [quant_cpu.cpp](src/quant_cpu.cpp)。[公共字节工具](../../common/cpp/lesson.hpp) 显式处理端序、长度与尾部。这里是独立教学后端，不是上游部署文件格式或低位加速内核。

从仓库根目录运行：

```sh
sh systems_practice/quantization/cpp/run.sh check
SANITIZE=ON sh systems_practice/quantization/cpp/run.sh check
mkdir -p systems_practice/.tmp/quant-cpp-fixtures
systems_practice/quantization/cpp/build/cpp-OFF/quant_cpu \
  --integration-test systems_practice/.tmp/quant-cpp-fixtures
# 查看标量参考的编译器生成汇编；不保证禁止自动向量化。
c++ -std=c++17 -O3 -ffp-contract=off -S \
  -I systems_practice/common/cpp systems_practice/quantization/cpp/src/quant_cpu.cpp \
  -o systems_practice/.tmp/quant-cpp-fixtures/quant_cpu.s
```

每课 `sh run.sh check` 同样运行独立后端检查；默认 `sh run.sh native` 只走Python/PyTorch算法/评估。显式选择 `sh run.sh native-cpp` 才先构建 C++，再调用固定版本上游 API，经 [native_bridge.py](../native_bridge.py) 传入张量。桥接脚本只作文本传输和进程编排，没有位操作、解码、计算内核或 CPU 基准。AdaRound 的 Torch 硬化/validation 和 AutoRound 的 autograd 属于训练/校准过程；它们不能代替这里的 C++ 部署验证。

## 格式与数值契约

- 文本交换 `QINPUT1 N K GROUP M OFFSET`，接着按行优先依次写 original、native-QDQ、upstream-RTN、scale、zero、evaluation、shifted。每行 N 个输出通道，每个通道 `ceil(K/GROUP)` 组。OFFSET=1 表示 AIMET 的 offset，C++ 转成 zero=-offset；否则直接传 zero。所有张量转 FP32 交换，维度限制明确检查。
- C++ 写 `linear.q4`：ASCII `Q4C1` + 三个 little-endian uint32（N/K/GROUP），共16字节头。逐组交错 FP32 scale/FP32 zero（8字节），然后行优先、低 nibble 在前的 u4。跨行连续打包；仅总元素为奇数时补一个零高 nibble。尾组保留元数据。
- 解码为 `(q-zero)*scale`，scale须正且有限，zero须有限且是整数；拒绝损坏 magic、截断、额外字节、非零尾 nibble。文件写完后从磁盘重载并逐字节、逐码核验。
- 原生 QDQ 与 C++ 解码比较允许上游 FP16 舍入误差（绝对误差阈值为 `min(0.25*scale, 0.002*max(abs(weight),scale))+1e-7`）。这不是不同格式可直接互换的保证。
- FP32原始权重/输入作为参考。对照为 FP16存储舍入、独立 absmax[-7,7]、上游 RTN、原生量化解码；对照输入先按 binary16 舍入再转 FP32 累加。报告 evaluation/shifted/zero_input 的 NRMSE、最大绝对误差和余弦（零向量为 null）。不声称 FP16 累加或完整模型任务精度。

当前格式预算：AWQ 4624 B、GPTQ 2320 B、AdaRound 212 B、AutoRound 340 B（均含16字节头；AdaRound按每输出通道参数展开）。这些是本教学格式的尺寸，不是上游模型文件大小。原生方法未运行时不能把合成数据结果标为方法实测。

## 验证和计时边界

独立检查覆盖已知字节顺序、空/奇数码、非法码、损坏记录、零scale/NaN、五种分组形状、63,488种有限 FP16 位模式、ties-to-even、已知矩阵乘和零行。`--integration-test` 为四课的形状生成合成网格张量，走真实文件协议、磁盘往返、数值与计时管线；没有执行上游算法。

基准在 C++ 中进行，10次预热、50次采样，P50=排序第25个、P95=第48个，`steady_clock` 覆盖输出分配与已解码标量 FP32 GEMM，排除文本读取、解码、磁盘、训练和编译。保留可观测输出以防死代码删除。编译器可能自动向量化；不是 BLAS、packed INT4、GPU/NPU 或 RK3588/Jetson 的性能。

本次实际证据见 [审查报告](../../docs/LANGUAGE_AUDIT.md) 和 [后端验证](verification.json)。原生库依赖缺失状态单独保留；没有自动安装或下载模型。
