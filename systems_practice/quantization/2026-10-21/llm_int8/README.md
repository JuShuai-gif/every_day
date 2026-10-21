# 2026-10-21 LLM.int8：离群列阈值、真实权重与后端边界

## 方法与应用场景

第二轮聚焦已有Linear的替换、threshold调参和checkpoint重载。算法是激活离群列分解；格式是对称INT8主体加FP16输入残差；主路径权重W8、激活动态A8，不等于FP8，也不是QAT。无训练更新。输入M×64 FP16、权重32×64，输出M×32；分别使用64校准、32调参、31评估、31偏移样本，校准只统计分布，阈值由调参集选择，评估不反馈选择。

阈值>0时，当前batch某列任一激活绝对值达到阈值即标记该列。常规分支压低该列贡献，残差使用原始激活。threshold=0表示关闭离群处理，**不是所有值都作为离群值**。逆尺度/row absmax与INT32累加需要按实现恢复；输入列阈值不是权重阈值。

## 原仓库与实际读过的实现

原仓库[bitsandbytes-foundation/bitsandbytes](https://github.com/bitsandbytes-foundation/bitsandbytes)，实际浅克隆commit `833649043474794b8fe7a4136e0c40faf077b2e0`，2026-10-21读取，MIT。初始DNS失败保留[原始失败](source-initial-failure.json)，汇总阅读证据见[source.json](source.json)，网络重试获取10文件成功见[source-retry.json](source-retry.json)。原地址未重定向迁移。只缓存所需源码，不安装包或下载模型。

入口[Linear8bitLt/Int8Params](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/833649043474794b8fe7a4136e0c40faf077b2e0/bitsandbytes/nn/modules.py)；算法[MatMul8bitLt.forward/matmul](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/833649043474794b8fe7a4136e0c40faf077b2e0/bitsandbytes/autograd/_functions.py)；默认[vectorwise_quant/mixed_scaled_mm](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/833649043474794b8fe7a4136e0c40faf077b2e0/bitsandbytes/backends/default/ops.py)。

调用链：构造Linear8bitLt → load FP16权重 → `.to(device)`触发`Int8Params._quantize`产生CB/SCB → `.eval()` → `forward`搬移量化状态 → `MatMul8bitLt`动态量化激活 → `int8_scaled_mm`与mixed残差 → state_dict保存weight/SCB/weight_format → 先初始化新实例量化buffer再加载。

**源码发现**：`has_fp16_weights=False`时残差中的subB由CB/SCB反量化，不是保留的原始FP16权重，因此阈值改善不了已经丢失的全部权重信息。默认CPU后端把整数矩阵转换FP32相乘再转INT32；AVX512条件分派才可能用`torch._int_mm`。CUDA路径K不被4整除或cuBLASLt无算法时也可能回退FP32。库名含int8不能证明执行了Tensor Core。原生CPU训练模式又会分派到MatMul8bitFp，因此示例显式eval。

## 如何接入我的代码

完整[example.py](example.py)调用原生API，不是独立数学仿写。源要求Python>=3.10、torch>=2.4,<3（pyproject）；实际本机Python3.9.6不满足，备用Python3.12.14缺torch，两种失败日志保留。依赖已具备时，在自己的只读源码checkout固定上述commit，再设置BNB_SOURCE；本任务未自动安装。

```sh
# 在仓库根目录；BNB_SOURCE必须是已检出的固定commit原仓库
BNB_SOURCE=/绝对路径/固定commit的bitsandbytes PYTHON=python3.12 sh systems_practice/quantization/2026-10-21/llm_int8/run.sh --device cpu
```

示例核对导入模块所在checkout和git commit，运行时报告实际torch/bitsandbytes版本。现有`nn.Linear(64,32,bias=False)`的接入位置就是`make()`中的load_state_dict，把示例w替换成原层的FP16权重；有bias时需同步创建和复制bias，不能丢失。先CPU加载再to；不在推理中训练权重。

比较阈值0/3/6，以独立tuning NRMSE选一个，统计校准离群列数；固定后测试eval/shift。FP32参考用同一FP16输入和FP16存储权重转float相乘，另报告FP16算术参考；不是未舍入训练权重的FP32参考。原生INT8 checkpoint写build/native_state.pt，分别量张量payload和容器文件大小，精确重载输出检查。预热5次、11批×20次，计时包含框架分派、动态激活量化与残差；CUDA时显式同步，不叫单kernel延迟。

## 量化前后比较

| 项目 | 本次真实状态 |
| --- | --- |
| FP16/threshold0/selected输出误差、偏移退化 | 未运行，缺torch，无数值 |
| CB/SCB/format真实payload与文件字节 | 已实现测量，未生成checkpoint |
| 框架同步批均值P50 | 未测；不填理论加速比 |
| 零权重行、全零输入、M=0/M=1、错误K | 检查已写，原生后端未验 |

当前默认vectorwise量化源码对全零row存在除零中间值，示例保留全零有限性验收，不预先宣称通过。动态outlier统计随batch变化，不应缓存成跨请求恒定列集。FP16输入是原生接口类型，常规分支会动态转INT8，因此不要把整个计算简单标成W8A16。

## Thor SM110 与优化

本期交付[独立CUDA基线与共享内存优化候选](src/mixed.cu)，完整合同、运行、ncu和ISA分析见[Thor实验](thor-validation.md)。二者用相同INT8数据、scale、离群列mask和FP32累加，与解码输入的FP64 oracle比较。它们是LLM.int8分解思想的教学重建，不是bitsandbytes逐位复现：主体解码后执行SIMT浮点FMA，没有原生INT8 Tensor Core，不用标量MAC冒充低位吞吐。候选减少重复解码与全局读，但未在Thor编译或运行，不宣称更快。原生API与自写GPU代码分别验收。原生threshold0与6改变算法处理，不能作为同语义kernel优化对照。

已读本commit CMakeLists.txt：CUDA13支持110，项目实际用`COMPUTE_CAPABILITY`重建CMAKE_CUDA_ARCHITECTURES，因此只传后者不够。Thor官方cc11.0及CUDA13 sm_110名称已核对：[GPU表](https://developer.nvidia.com/cuda/gpus)、[nvcc13](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-compiler-driver-nvcc/index.html)。本机没有nvcc/ncu/Thor；目标JetPack/L4T、driver、CUDA、torch wheel、bnb extension须一起记录，未验证版本组合。

```sh
# 仅Thor目标；在固定checkout中执行，不安装包
nvcc --version
cmake -S "$BNB_SOURCE" -B "$BNB_SOURCE/build-thor" -DCOMPUTE_BACKEND=cuda -DCOMPUTE_CAPABILITY=110 -DCMAKE_CUDA_FLAGS=-lineinfo
cmake --build "$BNB_SOURCE/build-thor" -j2
# 从EveryDay根运行，脚本检查实际device capability必须为(11,0)
TORCH_CUDA_ARCH_LIST=11.0 BNB_SOURCE="$BNB_SOURCE" PYTHON=python3 sh systems_practice/quantization/2026-10-21/llm_int8/run.sh --device cuda
```

构建日志必须只出现sm_110/compute_110，不加a/f后缀。完整ncu和机器码核验步骤见[thor-validation.md](thor-validation.md)；其他架构只理论讨论；今日固定Thor SM110，对照从Hopper轮换到Ada，下一次Turing。

## 验证与待补

[verification.json](verification.json)：源码获取是、实现阅读是、完整原生示例是、CPU运行否、Thor验证否。[Python3.9失败](results/native-cpu.txt)和[Python3.12失败](results/native-cpu-python312.txt)为真实记录。Python静态语法检查不替代运行。未装依赖、未下载模型。

本日只重试一个旧calibration源码获取，DNS失败见[backlog记录](results/backlog-calibration-source.json)；检查缓存没有可验证实现，不推进该方法。今日LLM.int8进入已阅读/已交付状态，同时保留运行backlog；下一个方法calibration。

故障链：①载入INT8 checkpoint时缺SCB初始化→查看load异常→先to初始化再load，保存threshold另行恢复；②低位层反而慢→查CPU/CUDA fallback和离群列数量→固定输入/设备/同步，区分动态quant成本；③偏移数据离群列爆增→记录每请求列数和误差→阈值重新用独立调参集评估，不能拿测试集挑最好结果。

追问：①threshold0语义是什么？②离群列是权重还是激活统计？③为何残差未必恢复原始权重？④SCB和weight_format为什么不能丢？⑤CPU int8存储为何仍能走浮点MAC？⑥如何证明实际执行的是低位Tensor Core？
