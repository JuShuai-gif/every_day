> 并发游标纠正：此页仅保留补充，今日正式方法是[QAT](../qat/README.md)，不重复推进校准方法。

# 2026-10-02 校准缩放：PyTorch HistogramObserver

## 方法与应用场景

今天只深入**直方图L2范围选择**。主课[四种位宽GEMM](../../../daily/2026-10-02/README.md)已有独立输出MSE网格搜索；那不是PyTorch HistogramObserver的实现。这里解释原生观察器怎么用，不增加编码作业。

算法是PTQ校准，格式是有符号INT8，位宽是W8A8，训练范式是无梯度PTQ；“INT8”“PTQ”“直方图”不能互相替代。输入X[32,65] FP32，权重W[19,65]（PyTorch Linear权重顺序），输出[32,19]。激活per-tensor对称[-128,127]、zero_point=0；权重per-output-channel对称[-127,127]，FP32 scales。最近偶数舍入，真实torch.int8存储后解码FP32 GEMM，不是原生INT8推理kernel。

## 原仓库与实际读过的实现

仓库[PyTorch](https://github.com/pytorch/pytorch)，阅读tag **v2.8.0**，release页确认commit `ba56102387ef21a3b04b357e5b183d48f0afefc7`，读取日期2026-10-02，BSD风格许可证（LICENSE多方署名）。永久链接：

- [observer.py](https://github.com/pytorch/pytorch/blob/ba56102387ef21a3b04b357e5b183d48f0afefc7/torch/ao/quantization/observer.py)：`HistogramObserver.forward/_combine_histograms/_non_linear_param_search/_compute_quantization_error/calculate_qparams`及MinMaxObserver。
- [fake_quantize.py](https://github.com/pytorch/pytorch/blob/ba56102387ef21a3b04b357e5b183d48f0afefc7/torch/ao/quantization/fake_quantize.py)：`FakeQuantize.forward`与observer/fake_quant开关。
- [LICENSE](https://github.com/pytorch/pytorch/blob/ba56102387ef21a3b04b357e5b183d48f0afefc7/LICENSE)。实际实现正文通过tag URL读取；full-hash raw访问失败，没有声称本地checkout成功。

调用链：`fit→FakeQuantize.forward→activation_post_process→HistogramObserver.forward`收集统计；`calculate_qparams→范围搜索→_calculate_qparams`得到scale/zero_point；冻结观察器后fake_quant前向使用固定参数。直方图跨batch范围变化需要重映射旧桶；L2搜索按桶近似密度评估，不是标签损失，也不是下游GEMM最优保证。示例原样调用公开API，自写数据、评价与导出；未复制上游实现。

[源码获取记录](source.json)保留真实clone DNS失败，已查缓存没有可验证PyTorch checkout；[阅读补充](source-read.json)记录tag/commit与范围；[验证状态](verification.json)区分源码获取、阅读、交付、运行、Thor。AWQ作为今日唯一旧backlog重试也失败，不推进第二次游标。

## 如何接入我的代码

Python为算法主入口，需要预先准备的**PyTorch2.8.0及兼容Python**；不自动安装。工作目录为本README目录：

```sh
sh run.sh
# 已有其他解释器时显式指定，脚本检查torch精确版本
PYTHON=/absolute/path/to/prepared/python sh run.sh
```

源码准备命令（仅在可联网环境按需执行，不需构建PyTorch）：

```sh
# 从EveryDay仓库根目录执行；只拉源码元数据
GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 --filter=blob:none --no-checkout --branch v2.8.0 https://github.com/pytorch/pytorch.git systems_practice/.tmp/quant_sources/pytorch-v2.8.0
```

读取指定commit的observer/fake_quantize/LICENSE并核对`git rev-parse HEAD`；本轮使用获取脚本确实尝试过，未成功。代码固定torch2.8.0，换版本要重审实现。

[example.py](example.py)可直接运行，不下载模型。校准128×65分成8批；独立tune32×65选择bins=256/1024/2048；eval与shift只报告，不更新观察器。先`disable_fake_quant`收集，随后`disable_observer`再`enable_fake_quant`，显式断言eval前后scale不变。零值/空张量测试观察器有限正尺度；INT8 encode/decode与原生FakeQuantize前向比较。

接已有Linear：将权重替换为`linear.weight.detach().cpu()`，校准样本替换成该层真实输入，保留独立调参/评估分区。示例无bias；接有bias层需在矩阵乘后加原bias，并计入导出和误差比较。示例在`build/linear.pt`保存真实INT8 weight、weight_scale、activation_scale/zero_point，`torch.load(weights_only=True)`重载后推理。是自定义数据格式，需要部署kernel适配；不是torch.quantized.Linear或TensorRT engine。

## 量化前后比较

现成代码报告FP32、FP16舍入/FP32累加参考、MinMax及Histogram的NRMSE/最大误差/余弦、饱和率、payload/metadata/序列化文件实际字节。计时20预热100次，边界为CPU框架QDQ+FP32 GEMM；FP16参考不代表FP16计算吞吐。校准与参数搜索不在推理计时中，导出和重载单独发生。

当前原生例子运行在`import torch`处失败：`ModuleNotFoundError`，见[原始输出](results/native.txt)。因此上面各指标**未验证**；主课C++实际数值不能填入这里冒充PyTorch结果。主课的shift反例用于说明为什么需要部署分布测试，而非证明此观察器一定失效或一定更好。

## Thor SM110 与优化

本例选择CPU算法路径，无CUDA扩展构建，不假设PyTorch2.8轮子原生支持Thor。若迁移必须先核对NVIDIA兼容JetPack/torch包与`torch.cuda.get_arch_list()`、设备能力及真实kernel。源码CUDA扩展目标只能`TORCH_CUDA_ARCH_LIST=11.0`，但仅设环境变量不能为不支持SM110的旧nvcc增加支持；须CUDA13+兼容组合。Thor基线/优化、ncu/PTX/SASS命令在[主课教程](../../../daily/2026-10-02/OPTIMIZATION.md)，当前全部目标验证待补。原生直方图scale语义与主课对称端点不同，不能无转换直接替换。

## 验证与待补

源码获取否；实现阅读是；完整示例是；CPU原生运行否；Thor否。失败进入backlog，下次主方法可继续QAT，旧项每天最多重试一个。源码迁移：已读取pytorch/pytorch该tag实现，无证据表明此版本文件需要迁移；不把未来torchao接口混入本例。

故障链一：评估越来越“准”→scale仍在更新→对比eval前后scale→冻结observer、重新独立评估→回归shift不改scale。故障链二：校准L2低但输出误差高→重要通道被全局桶主导→对比MinMax/Histogram输出NRMSE及饱和→换粒度/校准集需重新调参→代价为metadata或校准时间。迁移验收须同时通过导出重载、数据分离、格式解释与设备实测，不能由fake quant通过直接上线。

追问：①bins与量化code数量是否相同？②范围扩大时旧hist怎样合并？③只关fake quant能冻结统计吗？④tensor L2最小为何不保证Linear输出最优？⑤torch.int8导出是否等于INT8 GEMM？⑥shift测试为什么不能用于挑bins？
