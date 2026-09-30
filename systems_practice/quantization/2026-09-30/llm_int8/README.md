# 2026-09-30 LLM.int8：离群特征分解与真正的Linear8bitLt用法

## 方法与应用场景

一个局部特征通道绝对值很大时，逐行absmax会拉大整行INT8步长。LLM.int8将含离群元素的列移到浮点残差支路，主体用INT8乘加。今天只深入**动态离群列分解**，不训练、不做AWQ缩放、不把INT8格式当作算法。权重W[32,64]，输入A[16,64] FP16，输出[16,32]，公式为A×Wᵀ；无bias。

格式/位宽：权重有符号INT8真实1B/项，FP32行absmax；主体激活INT8、逐行动态absmax，离群激活保持FP16。INT32累加后按`SCA*SCB/127²`缩放，浮点支路相加。threshold=0禁用离群分解，作为absmax基线；3/6/10仅为此合成例的调参候选，不是通用最佳阈值。无zero-point；舍入/端点由已读上游后端实现决定。

## 原仓库与实际读过的实现

[bitsandbytes-foundation/bitsandbytes](https://github.com/bitsandbytes-foundation/bitsandbytes)，读取日期2026-09-30；原仓库URL可达，无迁移证据。原生示例固定**0.48.1**；[release链接到commit](https://github.com/bitsandbytes-foundation/bitsandbytes/commit/7e16503e403de460d4ed7dfd6c90a656628f5149)，许可证MIT。实现实际经tag URL读取，hash URL请求Cache miss，未声称字节级复验hash版本。完整[读取记录](verification.json)与保留失败的[fetch记录](source.json)。

| 文件/符号（永久链接） | 实际读取的调用关系 |
| --- | --- |
| [nn/modules.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/nn/modules.py)：Int8Params._quantize/to、Linear8bitLt.forward/save/load | load浮点权重→to量化CB/SCB→eval→bnb.matmul；SCB初始化后才可加载量化checkpoint |
| [autograd/_functions.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/autograd/_functions.py)：matmul、MatMul8bitLt.forward | eval进入Lt；训练态CPU可能改走MatMul8bitFp，所以示例显式eval |
| [backends/default/ops.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/backends/default/ops.py)：int8_vectorwise_quant/int8_mixed_scaled_mm | 检出列、主体清零，浮点残差使用**反量化INT8权重列**，不保证保留原始FP16权重 |
| [backends/cuda/ops.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/backends/cuda/ops.py)：_int8_linear_matmul_impl | K不整除4时退回FP32矩阵乘；整除时调用cigemmlt_32，是否选Tensor Core仍需实测 |
| [CMakeLists.txt](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/CMakeLists.txt)、pyproject.toml、LICENSE | 构建由COMPUTE_CAPABILITY产生CUDA targets；CUDA13列表有110；Python≥3.9、torch≥2.3且<3、numpy≥1.17 |

上述API原样调用，本地样本、评价、导出检查为独立编排；没有复制上游内核或称完整LLM复现。main README只用于现状核对，API以0.48.1为准。tag README请求Cache miss，已读main README/固定tag依赖，不混写为全部固定tag文件成功。

## 如何接入我的代码

本课目录运行`sh run.sh cpu`或在Thor运行`sh run.sh cuda`。现有Python3.9.6，torch/numpy/bnb均缺失，因此实际运行在import torch时报错；不自动安装。最低依赖按上述pyproject；本课候选复验环境Python3.10+、PyTorch2.6.x、bitsandbytes0.48.1，**并未实装验证**。CPU backend还受PyTorch整数matmul和架构支持限制，不假设Mac支持。

完整[example.py](example.py)包含：固定随机权重、校准seed101、调参seed202、评估seed303、分布偏移seed404；只有调参集选择threshold，校准集打印统计，算法本身不需要离线训练或固定校准scale。用`bnb.nn.Linear8bitLt(..., has_fp16_weights=False, threshold=...)`替换既有`model.proj`，先load_state_dict原FP16权重、to目标设备、eval，后推理。默认无bias与64输入通道，接入用户层时须匹配shape/bias/device，不能盲目套到共享权重、卷积或已量化层。

导出`build/linear-int8.pt`，检查weight.dtype为int8、SCB存在，逐张量计真实payload，再统计torch.save文件大小；后者含容器开销。重载到已初始化量化SCB的新层，验证逐位一致。此API顺序来自所读加载实现，不是凭记忆猜测。输出记录FP32/FP16/threshold0/选择后的方法的NRMSE、max_abs、cosine；全零、空batch、单行与分布偏移不会静默跳过。原生边界若失败则保留错误并进入backlog，不自动用自写QDQ代替。

## 量化前后比较

| 项目 | 当前结果 |
| --- | --- |
| 原生FP32/FP16/absmax/LLM.int8误差 | 未运行，缺torch与原生环境 |
| 真实INT8权重/SCB/导出文件字节 | 示例已提供计数，尚未产生文件，不填实测值 |
| CPU或Thor框架forward性能 | 未验证；程序20预热+101次同步主机样本，包含量化/分解/调度，不是kernel时间 |
| 离群索引/激活payload/端点比例 | 示例逐项输出，未验证；码值达到127比例不等同真实越界饱和率 |
| 训练更新 | 0；这是PTQ/推理动态分解，不是QAT |

给定形状理论weight INT8为2048B、SCB为128B，对FP16权重4096B；只是形状推导，不含bias/weight_format/序列化/临时workspace。离群列d的临时量包括FP16 subA的16×d×2B、反量化subB的32×d×2B与索引；实际峰值须由后端分配/释放观察，不能把权重压缩比当速度收益。若所有列成为离群列，残差支路可占满，量化与索引成本仍存在。

## Thor SM110 与优化

固定tag CMake已核实`COMPUTE_CAPABILITY`，只设CMAKE_CUDA_ARCHITECTURES可能被上游覆盖。以下在**已准备依赖的Thor**运行，源码仅缓存本项目.tmp，不自动执行安装：

```sh
# 从EveryDay根目录；目录必须未占用，否则先核对已有checkout。
git clone --depth 1 --branch 0.48.1 https://github.com/bitsandbytes-foundation/bitsandbytes.git systems_practice/.tmp/quant_sources/bnb-0481
 git -C systems_practice/.tmp/quant_sources/bnb-0481 rev-parse HEAD
cmake -S systems_practice/.tmp/quant_sources/bnb-0481 -B systems_practice/.tmp/quant_sources/bnb-0481/build-thor -DCOMPUTE_BACKEND=cuda -DCOMPUTE_CAPABILITY=110 -DCMAKE_CUDA_ARCHITECTURES=110
cmake --build systems_practice/.tmp/quant_sources/bnb-0481/build-thor --parallel 2
# 先确认构建输出CUDA Targets只有110，且PyTorch可识别(11,0)。
PYTHONPATH="$PWD/systems_practice/.tmp/quant_sources/bnb-0481" sh systems_practice/quantization/2026-09-30/llm_int8/run.sh cuda
```

0.48.1构建源码有CUDA13/110分支，只说明具备候选编译路径；并不证明wheel、cuBLASLt、PyTorch、JetPack驱动或性能兼容。主课[工具链与ncu/ISA教程](../../../daily/2026-09-30/OPTIMIZATION.md)可作采集方法参考，但其FP32 GEMM**不等同本方法的低位kernel**。本期不声称已完成LLM.int8内核优化或SASS分析；原生Thor正确性、路径确认、kernel基线/优化和精确ISA热点列为待补，不以通用主课kernel冒充。CPU默认回退也不能冒充原生INT8 Tensor Core。

## 工业故障、迁移验收与追问

1. threshold=6仍误差偏大：先分离激活量化误差与权重重建误差，再查残差是否使用已量化权重。减阈值只能保护激活，无法恢复丢失权重信息；调参只看独立集，不用评估集追答案。
2. K改成65后“INT8比FP16慢”：检查所读cuda实现的K%4回退，采样实际算子/内核；padding需保持数学/存储并计入适配成本，不能根据参数dtype宣称低位加速。
3. 重载报SCB未初始化：按源码先to(device)建立量化容器，再load量化状态；记录tag/commit与后端，不直接把state dict塞普通Linear。

迁移先验收版本/CC、dtype/scale/输出、导出重载、尾部/零/分布漂移，再比较独立计时与业务精度、长跑内存。无收益或偏移退化时允许保留FP16。追问：1. 为什么离群处理按列？2. threshold0意味着什么？3. 残差能恢复哪些信息？4. 真实存储如何包含scale与索引？5. train/eval为什么可能改变CPU路径？6. K%4的回退怎样从trace辨认？

## 验证与待补

源码浅克隆失败DNS，无可验证缓存；tag实现已通过网页读取、commit由release追到；示例已交付；CPU运行失败缺torch；Thor未验。五项状态与精确读取范围见[verification.json](verification.json)，原始失败[results/native-attempt.txt](results/native-attempt.txt)。当天AWQ仅重试一次且DNS失败，保留[重试记录](../awq-retry-source.json)。失败继续backlog，下一方法为校准感知缩放，不把本课标为全部完成。
