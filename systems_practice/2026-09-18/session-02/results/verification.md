# 量化 GEMM 验证记录

2026-09-18，Mac Darwin arm64，AppleClang 21.0.0，CMake 4.4.3。

## 实际完成

- 首先执行北京时间日期并读取规范、索引、memory；无适用AGENTS.md，开始时Git工作区干净。用户要求新增量化方向并实际实现GEMM对照，本次使用未占用的session-02，保留原有池化练习。
- CPU Release与ASan/UBSan实际配置、编译、运行成功，20组format/method比较完成，half/packing/奇数尾部/分组尾部/零scale/非法Shape/独立反量化oracle检查通过。
- 最终Release原始输出：cpu.txt；sanitizer：sanitize.txt；comparison.md由cpu.txt生成，没有手填测量数据。
- QAT四种格式均实际40步，分别发生47225、47620、47164、47496次master值变化，最终packed字节有变化。validation选择step0/0/1/0；完整记录before、last和selected损失，不用evaluation挑checkpoint。
- SmoothQuant-style重参数化在量化前验证A'W'≈AW；输出误差、saturation、payload/metadata、分布失配与CPU计时分别报告。
- C++17真实4-bit packing；W4/8A4/8为整数MAC，A16为binary16存储后FP32累加；非Tensor Core原生低位GEMM，非FP4/FP8。

## 实际失败与未验证

- Thor SM110 CUDA目标配置实际失败：`Failed to find nvcc.`，完整日志gpu-configure.txt。未进行GPU编译、执行、精度、设备内存/同步检查或性能测试。
- profile.sh实际调用退出127：`ncu missing; no Thor measurements`，见ncu.txt。
- export-isa.sh实际调用退出127：`nvcc missing; no generated PTX/SASS`，见isa.txt。
- inline PTX bfe.s32真实存在于CUDA源码；没有伪造编译器PTX/SASS、ncu报告或Thor指令周期。
- CPU性能只属于本机朴素教学实现，不是优化库、GPU、NPU或端到端模型性能。存储比较是部署张量序列化预算，排除进程/分配器/训练状态，与实际存储码字长度区分说明。

## 开源源码读取失败

先于实现，实际发起web.open读取：

- https://raw.githubusercontent.com/mit-han-lab/smoothquant/main/smoothquant/smooth.py
- https://raw.githubusercontent.com/mit-han-lab/smoothquant/main/smoothquant/fake_quant.py
- https://github.com/pytorch/pytorch/blob/main/torch/ao/quantization/fake_quantize.py
- 替代一手资料：https://arxiv.org/abs/2211.10438

批量读取返回 `Fatal error: connection failed: error sending request`，没有取得正文。随后curl再次读取smooth.py，exit6：`Could not resolve host: raw.githubusercontent.com`，原始日志source-read.txt。

因此没有实际阅读相关项目实现，未取得commit；README中的符号是拟检索目标，非声称读到的代码。SmoothQuant式变换、PTQ、离群残差与手工STE QAT均为独立、明确简化的算法实现，不声称复现完整开源项目或模型效果。先前任务的Thor/PTX/ncu官方正文请求也未成功，本次没有虚构新的来源。
