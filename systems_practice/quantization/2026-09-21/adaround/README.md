# 2026-09-21 · AdaRound：学习舍入，冻结编码，再交付真实 INT4 容器

## 方法与应用场景

机器人小控制头 `Linear(33,8,bias=False)`，输入FP32 `[B,33]`、权重 `[8,33]`、输出 `[B,8]`。本期只深入**固定量化网格后优化每个权重向上/向下舍入**。相邻输入特征相关时，最小化逐权重舍入误差不等于最小化层输出误差；AdaRound用无标签校准输入和原层输出，学习能协同补偿的舍入选择。它需要离线优化，并可能对未覆盖的激活分布退化。

本例原样调用 AIMET 原生 API 完成优化；自行编写输入、实验编排与独立u4存储容器。不是重新实现一份数学例子后声称调用了AIMET。

| 维度 | 本期选择与边界 |
| --- | --- |
| 算法 | AdaRound：重建损失+退火舍入正则；仅优化alpha，固定scale/offset |
| 格式/位宽 | 权重均匀仿射INT4；校准及主对照激活FP32，即W4A32算法实验；不是FP4/NF4 |
| 粒度 | 遵循所读AIMET默认配置的实际导出编码，例子接受per-tensor或per-output-channel；不猜测默认group size |
| 训练范式 | 无标签PTQ，虽然内部用梯度/Adam更新alpha，但不是训练原模型权重的QAT |
| 推理 | u4真实打包→解码FP32→C++ CPU 标量参考；另有FP16存储舍入/FP32累加参考；不声称原生W4A16或INT4 Tensor Core |
| 边界 | `K=33`非整齐维度、全零输出通道、零输入、离群/相关输入与独立分布偏移集 |

上游机制：以 `floor(W/Δ)` 为下界，通过经过拉伸截断的sigmoid生成软舍入量，硬模式用`alpha>=0`决定加0还是1，再按offset和位宽裁剪、反量化。重建项是每样本输出向量的平方范数再取均值；正则是对所有权重的 `1-|2h-1|^beta` 求和乘系数。不能把这些不同归约都改成mean后仍沿用同一个正则系数。

默认前20%步数只优化重建，随后beta按cosine由20退火到2；Adam只接收alpha。本例500步是小输入用法演示，上游低于8位默认15000步，不宣称500步已收敛。没有任务标签或测试集训练。

## 原仓库与实际读过的实现

2026-09-21通过浏览器访问 `https://github.com/quic/aimet` 实际跳转到 [qualcomm/aimet](https://github.com/qualcomm/aimet)，核实迁移；文件快捷键固定到commit **`17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b`**，`packaging/version.txt` 为 **2.40.0**。许可证实际读到BSD-3-Clause。仓库克隆仍失败，原始 [source.json](source.json) 和迁移后 [重试记录](source-migrated-retry.json) 不被网页阅读成功覆盖；补充记录在 [source-browser.json](source-browser.json)。

| 实际阅读文件（固定永久链接） | 定位/作用 |
| --- | --- |
| [adaround/adaround_weight.py](https://github.com/qualcomm/aimet/blob/17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b/TrainingExtensions/torch/src/python/aimet_torch/adaround/adaround_weight.py) | `Adaround`、`_get_quantsim`、`_compute_param_encodings`、`AdaroundWrapper`；顶层现为v2兼容实现 |
| [_base/adaround/adaround_weight.py](https://github.com/qualcomm/aimet/blob/17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b/TrainingExtensions/torch/src/python/aimet_torch/_base/adaround/adaround_weight.py) | `AdaroundParameters`、`apply_adaround`、`_apply_adaround`、`_run_adaround_model`、`_export_encodings_to_json`及`_update_param_encodings_dict` |
| [_base/adaround/adaround_optimizer.py](https://github.com/qualcomm/aimet/blob/17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b/TrainingExtensions/torch/src/python/aimet_torch/_base/adaround/adaround_optimizer.py) | `adaround_module`→`_optimize_rounding`，实际`backward`与`optimizer.step`；`_compute_output_with_adarounded_weights`的Linear分支 |
| [_base/adaround/adaround_wrapper.py](https://github.com/qualcomm/aimet/blob/17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b/TrainingExtensions/torch/src/python/aimet_torch/_base/adaround/adaround_wrapper.py) | `apply_adaround`软/硬分支、`_generate_alpha_parameter`、`_init_param` |
| [_base/adaround/adaround_loss.py](https://github.com/qualcomm/aimet/blob/17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b/TrainingExtensions/torch/src/python/aimet_torch/_base/adaround/adaround_loss.py) | `compute_recon_loss`、`compute_round_loss`、`_compute_beta` |
| [pyproject.toml](https://github.com/qualcomm/aimet/blob/17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b/pyproject.toml) | Python>=3.10、scikit-build-core0.11.1、CMake>=3.26；默认CUDA目标列表并未覆盖Thor |
| [packaging/plugins/local/aimet.py](https://github.com/qualcomm/aimet/blob/17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b/packaging/plugins/local/aimet.py) | `get_aimet_variant`、`get_aimet_dependencies`、`get_version`；依据ENABLE_CUDA/TORCH/ONNX选包 |
| [依赖清单](https://github.com/qualcomm/aimet/blob/17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b/packaging/dependencies/fast-release/torch-gpu/reqs_pip_torch_gpu.txt) | CPU目录的reqs文件实际链接至此；torch/torchvision/numpy无版本锁定，psutil等也需准备 |
| [LICENSE](https://github.com/qualcomm/aimet/blob/17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b/LICENSE) | BSD-3-Clause；本期未复制上游源码 |

调用链：`Head + dummy + DataLoader` → `AdaroundParameters` → `Adaround.apply_adaround` → 建QuantSim并仅计算权重编码/禁用输入输出量化 → 按图顺序采样层输入和原层输出 → Adam优化alpha → 导出0.6.1参数编码 → 删除包装器并返回浮点模型 → 本期按冻结编码硬化、u4打包/重载 → 普通Linear解码推理。

**关键细节**：该commit的`adaround_module`虽设为hard，后续`_run_adaround_model`折叠权重时又明确开启soft。因此返回模型权重与`.encodings`不能直接称作可部署的整数权重；例子会按导出网格再次硬化，记录验证集误差，并交给 C++ 后端与同网格RTN比较。没有读取完整QuantSim/kernel后端，也没有完成AIMET源码构建；不作该部分支持保证。

## 如何接入我的代码

完整代码：[upstream_api.py](upstream_api.py)、[run.sh](run.sh)、独立容器 [C++ 存储后端](../../cpp/src/quant_cpu.cpp)。工作目录是本栏目；也可从EveryDay根目录用下列命令。

**已经核实的依赖要求**：AIMET此commit标注2.40.0，Python>=3.10，scikit-build-core[wheels]==0.11.1、CMake>=3.26、pybind11、cython>=3.0。完整运行依赖以所读fast-release清单为准；不能把旧`packaging/dependencies.py`中仅到torch2.1.2的表当成当前包的约束。当前清单没锁torch/numpy版本，故**不存在已在本机验证的精确依赖组合**。可在预先准备好的Python3.11、PyTorch2.9.0 CPU环境试验，但这只是待验候选，不能写成兼容性结论。脚本保存实际包版本并校验安装包五个关键文件与固定commit字节一致。

在有网络的环境手动准备固定源码（所有缓存仍在systems_practice内，不自动下载模型）：

```bash
# 从 EveryDay 根目录执行。目标目录已存在时先检查，不覆盖已有缓存。
git clone --depth=1 --single-branch --filter=blob:none --no-checkout https://github.com/qualcomm/aimet.git \
  systems_practice/.tmp/quant_sources/aimet-pinned-20260921
git -C systems_practice/.tmp/quant_sources/aimet-pinned-20260921 \
  fetch --depth=1 origin 17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b
git -C systems_practice/.tmp/quant_sources/aimet-pinned-20260921 \
  checkout --detach 17f4d5fa41231b218d96c5fdfd2a3329e6d31c7b
export AIMET_SOURCE_ROOT="$PWD/systems_practice/.tmp/quant_sources/aimet-pinned-20260921"
```

若已备好全部构建/运行依赖，可**自行执行**下列CPU源码安装命令；本自动化没有执行安装，也不建议在日常系统Python直接尝试。需由使用者选择既有专用环境，并按上游构建文档满足本地库依赖；此处安装流程未实测：

```bash
CMAKE_ARGS="-DENABLE_TORCH=ON -DENABLE_ONNX=OFF -DENABLE_CUDA=OFF -DCMAKE_CUDA_ARCHITECTURES=110" \
  python3 -m pip install --no-deps --no-build-isolation "$AIMET_SOURCE_ROOT"
sh systems_practice/quantization/2026-09-21/adaround/run.sh native
```

选择CPU是量化算法栏目验证路径，不替代任何轮到的GPU主练习。禁止把上游默认的旧CUDA目标列表复制成Thor构建命令；以上CPU命令不生成CUDA代码。

运行流程与接入位置：

1. `original.fc`替换成你自己的同形状Linear，校准前固定权重；真实模型用它自己的输入分布，合成随机输入不代表任务校准质量。
2. 校准seed2101、256行/8批、batch32；只用此分区优化alpha。正则候选0.001/0.01，beta20→2、warm_start0.2、500步；`post_training_tf`固定量化网格。两候选使用相同优化随机种子。
3. 验证seed2102的128行只选正则；评估seed2103及分布偏移seed2104都不参与选择。没有监督训练集、没有用评估集更新权重。
4. 原生入口写`candidate_*.encodings`，读取`param_encodings.fc.weight`；检查位宽、scale正值和粒度，硬化用于候选validation。冻结后传给 C++ 后端；offset在C++中转换为zero=-offset。
5. C++ 写出`build/native/linear.q4`，每行一组scale/zero，实际字节重载后校验；不再生成旧weights.u4.bin/affine.bin/decoded_fp32.pt。
6. C++ 比较评估、分布偏移和零输入，记录真实文件长度与 CPU 标量计时；报告在`build/native/comparison.json`。不设“必须优于RTN”断言。

已有`build/native`时脚本拒绝覆盖。需要新运行记录时复制本栏目到新session后执行；上游临时校准缓存通过TMPDIR留在本期被忽略的build/tmp。缺依赖或commit不匹配时退出2，表示没有运行量化，不是量化精度差。

## 量化前后比较

2026-09-22 将部署侧的位操作、打包/解码、误差验证、FP16存储舍入、absmax基线和 CPU 计时迁入 [C++17 后端](../../cpp/README.md)。上游 API 的校准/优化和候选选择保留在 `upstream_api.py`，使用固定 commit；它只通过文本传递张量，不能充当 CPU 内核示例。

`sh run.sh check`（本课目录）只验证独立 C++ 后端；`sh run.sh native` 才运行原生方法与完整张量交接。后端写并重载 `build/linear.q4`（AdaRound 为 `build/native/linear.q4`）。Q4C1 包含16字节头、每组8字节FP32 scale/zero和低 nibble 优先 u4；与旧 Python 容器及上游模型文件不兼容，不能直接喂给原生加载器。格式、误差阈值、分组尾部与板端边界见后端说明。

以 FP32 输入/权重为参考，对照 FP16存储、独立 absmax、上游 RTN、原生量化解码；对照输入先舍入为 FP16，再以 C++ FP32 标量累加。对 evaluation、shifted、全零输入记录 NRMSE/max_abs/cosine（零向量为 null）。CPU基准10次预热、50次采样，覆盖已解码 GEMM 与输出分配，排除磁盘、解码和训练，不代表 BLAS、低位kernel或GPU性能。仅记录上游校准/优化的流程用时，不把 Python 算子计时作为体系结构实验。

**本机已通过**共用后端的 Release、ASan/UBSan、位模式/边界检查，以及本课形状的合成数据磁盘往返。**四种原生量化算法仍未运行**：缺对应源码/依赖（GPTQ还需Thor），没有真实量化模型精度或板端性能。合成检查不推进原生完成状态。当前证据见 [verification.json](verification.json)、[新原生入口尝试](results/native-cpp-attempt.txt)；原有 results 原样保留为历史记录。

## Thor SM110 与优化

本期原生例子明确强制CPU，使用浮点模拟/解码，不定义CUDA kernel；因此不伪造kernel优化、PTX/SASS或ncu数据。AIMET的u4语义、Python层支持和低位GPU后端可用性是三件事。读取的pyproject默认架构列表不覆盖SM110；仅把变量改成110并不能证明扩展、ABI或PyTorch轮子兼容Thor。

2026-09-21实际核实 [NVIDIA JetPack7.0归档](https://developer.nvidia.com/embedded/jetpack/downloads/archive-7.0)：支持Jetson AGX Thor/T5000，Jetson Linux38.2/38.2.1、CUDA13.0.0、Ubuntu24.04；这只是可复查参考组合，不是板端已安装状态或最新版断言。初试旧路径返回404，已记录正确来源。没有板卡、nvcc/ncu及已构建AIMET扩展，原生AIMET Thor后端兼容性未证实。

需要进一步验证硬件路径时，可使用已经交付且固定SM110的独立 [GEMM baseline/tiled kernel及ncu/ISA教程](../../../daily/2026-09-18/session-02/README.md)：这里的相对链接从本栏目返回systems_practice后访问历史练习，**该实现不是AIMET后端，也不表示AdaRound权重已接入**。后续必须加读取本期u4/scale布局的适配并对比解码参考；再测kernel/传输/在线quantize和端到端，而不是拿C++ CPU 标量参考当GPU性能。任何新CUDA/PTX/SASS构建都必须固定`sm_110`，不得使用专属后缀。

## 验证与待补

[verification.json](verification.json)分开列状态：本地仓库获取否、固定commit网页实现阅读是、完整原生API示例交付是、CPU原生运行否、Thor验证否。网页源码阅读不等价于浅克隆成功；独立 C++ 打包测试不等价于原生量化成功。

实际 [native.txt](results/native.txt)：Python3.9.6，缺torch、aimet_torch、numpy、psutil，AIMET_SOURCE_ROOT未设置，退出2。[packing.txt](results/packing.txt)是旧 Python 容器的历史记录；当前 C++ 检查见 verification.json。没有安装依赖或下载模型。源码构建/原生运行与Thor路径进入backlog；下一自然日轮到AutoRound，同时最多重试一个待补项，不在同日重复推进。
