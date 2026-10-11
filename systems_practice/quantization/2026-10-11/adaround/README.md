# 2026-10-11 AdaRound第二轮：软舍入损失与硬化交付之间的缝隙

## 方法与应用场景

一个机器人动作头 `Linear(33,7,bias=False)`，权重 `[7,33]`，校准256行、调参128行、评估128行，另有分布偏移集。奇数231个权重使u4尾半字节可检查。第一输出通道全零，前两输入通道相关；第二轮深入正则强度和最终硬化，不重复第一轮的基本API介绍。

**算法**是基于校准输出重建的AdaRound；**格式**是整数仿射网格，不是FP4/NF4；**位宽**W4，输入以FP16舍入后提升FP32评估，不宣称原生W4A16 GEMM；**范式**是PTQ中优化舍入参数alpha，不是给原模型做任务QAT。它以固定scale/offset下的输出误差替代独立权重RTN误差，额外付出缓存激活与逐层Adam优化成本。

`floor(w/delta)+h(alpha)`中h是截断拉伸sigmoid；重建项保留校准响应，暖启动后加入促使h趋近0/1的正则。alpha梯度可跨多轮更新，而scale/offset冻结。温度beta随迭代退火不是修改整数位宽。硬化后的误差才对应部署决策；软损失下降不保证硬误差下降。

## 原仓库与实际读过的实现

[qualcomm/aimet](https://github.com/qualcomm/aimet)，commit `6360e0c7d9f122cfa64f42475f099c3dafca4010`，2026-10-11真实浅克隆按需读取，版本文件2.41.0，BSD-3-Clause。旧quic链接在包元数据仍存在，实际拉取使用qualcomm地址。第一次沙箱DNS失败保留在[source.json](source.json)，成功重试见[source-network.json](source-network.json)，阅读证据见[source-read.json](source-read.json)。

调用链：

1. [入口Adaround.apply_adaround](https://github.com/qualcomm/aimet/blob/6360e0c7d9f122cfa64f42475f099c3dafca4010/TrainingExtensions/torch/src/python/aimet_torch/adaround/adaround_weight.py)继承基类，创建QuantizationSimModel并禁用输入/输出量化器。
2. [AdaroundBase.apply_adaround / _adaround_model](https://github.com/qualcomm/aimet/blob/6360e0c7d9f122cfa64f42475f099c3dafca4010/TrainingExtensions/torch/src/python/aimet_torch/_base/adaround/adaround_weight.py)先计算权重encoding，按图顺序包装支持模块，最后以**软舍入权重**写回浮点模型，导出0.6.1 encoding再去掉wrapper。
3. [AdaroundOptimizer._optimize_rounding](https://github.com/qualcomm/aimet/blob/6360e0c7d9f122cfa64f42475f099c3dafca4010/TrainingExtensions/torch/src/python/aimet_torch/_base/adaround/adaround_optimizer.py)只把alpha交给Adam；计算重建/舍入损失、backward和step。结束时wrapper暂时hard，并不代表基类返回模型已是packed权重。
4. [AdaroundWrapperBase.apply_adaround](https://github.com/qualcomm/aimet/blob/6360e0c7d9f122cfa64f42475f099c3dafca4010/TrainingExtensions/torch/src/python/aimet_torch/_base/adaround/adaround_wrapper.py)负责scale、floor、h、clamp和反量化；[AdaroundLoss](https://github.com/qualcomm/aimet/blob/6360e0c7d9f122cfa64f42475f099c3dafca4010/TrainingExtensions/torch/src/python/aimet_torch/_base/adaround/adaround_loss.py)包含暖启动、cosine beta退火和重建损失。

原场景是Conv/Linear逐层重建。示例原样调用公开API；数据/评估/教学u4容器是本仓库独立实现，省略大模型图分区、分布式、完整部署编译。未复制上游实现。

## 如何接入我的代码

完整[upstream_api.py](upstream_api.py)与[run.sh](run.sh)已写好；复用仓库现有 `quantization/torch_evaluation.py` 进行误差和框架计时，不额外布置编码题。

环境核验：源码要求Python>=3.10；fast-release依赖文件包含torch/torchvision/numpy/psutil等但没有锁死torch版本。此Mac实际Python3.9.6，torch、aimet_torch、psutil缺失，因此**不存在已验证的原生依赖组合**，不能虚构torch版本。准备与运行（依赖由用户预先准备，不自动安装）：

```sh
# 从EveryDay根目录；git缓存若已有则不要重复clone。
git clone --filter=blob:none --no-checkout https://github.com/qualcomm/aimet.git systems_practice/.tmp/quant_sources/aimet-pinned
git -C systems_practice/.tmp/quant_sources/aimet-pinned checkout 6360e0c7d9f122cfa64f42475f099c3dafca4010
AIMET_SOURCE_ROOT="$PWD/systems_practice/.tmp/quant_sources/aimet-pinned" \
  PYTHON=python3.11 sh systems_practice/quantization/2026-10-11/adaround/run.sh
```

脚本检查checkout commit、已安装包的5个算法文件SHA256和实际包版本；不相符直接失败，不能默认pip最新版兼容。接入已有层的位置是 `Head.fc`，替换后重新生成dummy_input/校准集，不能校准后再换权重。

校准种子2101，validation2102，evaluation2103，shifted2104；原模型固定且保留副本。两个候选只在校准集运行1000次迭代，`reg_param=0/0.01`，beta=(20,2)，warm_start=0.2；只用validation选硬化误差较低者。`num_batches=len(loader)`，batch32，无下载。eval与shifted不进优化/调参。

返回模型的软权重结合导出scale/offset再映射到u4：`q=clamp(round(w/scale)-offset,0,15)`，`w_hat=(q+offset)*scale`。脚本支持每tensor或每输出通道encoding；不支持结构直接拒绝。写出 `build/native/weights.u4.bin`（低nibble先，奇数末尾高nibble零）和真实metadata JSON，重载检查整数码完全一致。该容器是教学格式，**不是AIMET部署导出API或TensorRT engine**。框架重载 `.pt` 仍是FP32重建权重；推理走F.linear，需目标后端另实现真正低位算子。

## 量化前后比较

脚本会对同一heldout/shifted/全零输入比较FP32、FP16舍入存储、独立absmax、同encoding RTN、AdaRound硬化重建，输出NRMSE/max_abs/cosine与候选正则、饱和比例。计时为预热10次/50次同步主机F.linear，含分配/调度，不含校准/导出，不是设备kernel耗时。实际u4 payload理论应116B，FP16权重462B；**这两项在此仅是形状推导，尚未生成文件**，metadata可能使小层总文件反而大于FP16。

| 本次证据 | 结果 |
| --- | --- |
| 原生校准、硬误差、饱和、文件字节、框架耗时 | 未运行，缺依赖；不填数字 |
| 源码拉取 / 阅读 / 示例交付 | 是 / 是 / 是 |
| CPU原生 / Thor后端 | 否 / 否 |

[真实失败输出](results/native-attempt.txt)。无任务精度、加速或QAT训练完成声明。

## Thor SM110 与优化

本例执行CPU原生算法与FP32重建，不交付或宣称低位CUDA kernel。实际读到该commit的pyproject.toml默认CMAKE_CUDA_ARCHITECTURES为70/75/80，**没有110**；原样构建不能当作Thor原生二进制支持。scikit-build构建需显式覆盖 `-Ccmake.define.CMAKE_CUDA_ARCHITECTURES=110`，并核对构建日志中最终目标，不能仅设置torch环境变量。Python/torch wheel、CUDA13、AIMET C++扩展与11.0目标须逐项验收。以后构建CUDA扩展必须 `TORCH_CUDA_ARCH_LIST=11.0`，并确认torch识别该值；不加a后缀、不回退其他架构。算法输出不等同TensorRT可直接读；先核对Q/DQ、channel轴与scale语义再交给目标后端。今日具体GPU优化、ncu、ISA与Hopper对照见[主课](../../../daily/2026-10-11/PROFILE.md)，它是FP32逐元素核，不能当AdaRound的INT4性能。

## 验证与待补

五项独立状态见[verification.json](verification.json)。已对Python做AST语法检查，未把语法通过标为CPU运行。原生依赖、硬化数值、文件往返和Thor后端均进入backlog。仅重试一个历史项GPTQ，真实源码获取成功见[记录](results/gptq-retry.json)；未重新阅读/运行它，不推进其游标。

工业链路一：软重建误差很小→导出变差→先比较软权重/整数硬化误差→加强舍入正则或延长迭代→必须在独立heldout复测，不能直接把soft误差上线。链路二：旧encoding配新权重→scale轴/offset错→检查7个输出通道encoding与逐码roundtrip→固定模型hash并拒绝不支持格式→代价是迁移需重新校准。链路三：校准集相关性强→换相机退化→使用shifted集但不反向调参→扩充独立校准覆盖，保留失败结果。

迁移验收：固定源码/包、分离四组数据、输出finite、硬化误差达业务阈值、文件含metadata实测、后端正确性独立对齐后再测端到端。追问：1. alpha与scale分别是否更新？2. warm start何时有用？3. 为什么返回浮点模型还需要硬化？4. 通道相关性怎样改变最佳舍入？5. metadata何时超过压缩收益？6. PTQ优化alpha为何不等于任务QAT？
