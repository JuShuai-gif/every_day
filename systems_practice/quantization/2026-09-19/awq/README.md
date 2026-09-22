# 2026-09-19 每日量化：AWQ 的激活感知裁剪与原生打包

## 方法与应用场景

今天深入 **AWQ的单层激活感知clip搜索**，用于边缘视觉/语言投影Linear的W4A16权重压缩。AWQ是PTQ算法，INT4是权重数值格式，W4A16是位宽配置，FP16是此处A16格式；本期没有训练更新，不是QAT。完整AWQ还包含通道缩放，本例主动限定clip子机制，不能称为完整模型AWQ精度复现。

为何区别于absmax：大权重决定量化步长，但对输出的重要性也由输入激活决定。本例调用上游函数，根据校准输入与原始权重的分组点积误差选择裁剪阈值，而不是只最小化权重误差。搜索固定20格、最大缩小比例0.5；没有任务精度保证。部署用非对称4位码值0..15、每输出通道每128权重一组的scale/zero-point；round由PyTorch执行。CPU比较采用FP16存储后转FP32乘加，不能称为FP16算术或原生INT4 Tensor Core。

## 原仓库与实际读过的实现

仓库：[mit-han-lab/llm-awq](https://github.com/mit-han-lab/llm-awq)，固定真实commit **d6e797a42b9ef7778de8ee2352116e0f48a78d61**，读取日期2026-09-19。该commit通过GitHub提交页确认并重新读取固定URL，不是假定main永远不变。未发现需要迁移仓库的证据。

**获取状态：本机Git浅克隆失败，无可验证本地缓存；网页工具成功读取固定版本实现。** [source.json](source.json)保留最初失败事实，[source-web.json](source-web.json)另记网页阅读与永久链接，不把克隆失败改成成功。

| 文件/函数永久链接 | 实际读取范围与调用链 |
| --- | --- |
| [auto_clip.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/quantize/auto_clip.py) `auto_clip_layer` | 本例入口；输入W与校准X→候选clip→伪量化→分组输出误差→返回每组上界；检查输出通道64倍数和token抽样步长 |
| [quantizer.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/quantize/quantizer.py) `pseudo_quantize_tensor` | 返回浮点重建权重，可额外返回scale/zero；该返回值本身没有压缩 |
| [qmodule.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/quantize/qmodule.py) `WQLinear.from_linear` / `pack_intweight` / `forward` | 原生排列和INT16容器存四个4位码；小token与大token走不同CUDA入口。整个模块导入就要求CUDA扩展 |
| [auto_scale.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/quantize/auto_scale.py) `auto_scale_block` / `_search_module_scale` | 已阅读用于交代完整AWQ：按激活统计搜索通道缩放、恢复原参数再比较；本例不调用此block搜索 |
| [pyproject.toml](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/pyproject.toml) / [setup.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/kernels/setup.py) | awq0.1.0、torch2.3.0、transformers4.46.0；扩展CUDAExtension源清单和C++17构建选项 |

原项目是LLM低位权重部署；示例是**调用其真实原生API的独立编排**，没有复制其算法或冒充其完整模型流程。LICENSE正文实际是[MIT License，2023 MIT HAN Lab](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/LICENSE)，pyproject的Apache分类器与正文不一致；本记录以LICENSE正文为准，未提交第三方源码。

## 如何接入我的代码

[upstream_api.py](upstream_api.py)已经写好，不是第二个作业。工作目录EveryDay根目录。Python建议3.10；实际本机Python环境缺torch、transformers、awq、numpy，未安装。上游声明的精确依赖不等于Thor兼容组合；导入链还需要可加载的`awq_inference_engine`与tqdm等依赖。不能用假模块跳过导入并声称“原生CPU支持”。

网络恢复后可按以下命令准备**忽略目录内**的固定源码，不下载模型；本次没有执行成功：

```bash
GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 --filter=blob:none --no-checkout \
  https://github.com/mit-han-lab/llm-awq.git systems_practice/.tmp/quant_sources/awq-pinned/repo
git -C systems_practice/.tmp/quant_sources/awq-pinned/repo fetch --depth 1 origin d6e797a42b9ef7778de8ee2352116e0f48a78d61
git -C systems_practice/.tmp/quant_sources/awq-pinned/repo checkout --detach d6e797a42b9ef7778de8ee2352116e0f48a78d61
sh systems_practice/quantization/2026-09-19/awq/run.sh
```

不要覆盖已有checkout；若该目录存在，先验证HEAD，选择另一个忽略目录并通过`AWQ_SOURCE`指定。脚本拒绝固定commit不匹配、已修改的tracked源码和practice外路径。不自动pip install。上游`torch==2.3.0`环境无法因此直接视为支持CUDA13/SM110；需要另行准备经Thor验证的PyTorch，记录其版本、ABI及与这个旧AWQ commit的兼容性。

数据和步骤均在脚本中明确：

1. W为`[64,128]` FP32，校准X为`[512,128]` FP32，评估X为`[128,128]`，分别seed10/20/30；校准与评估均压低第0通道激活。无训练集，因为不训练；网格/分组参数固定，不用评估集调参，若以后选参数须另增验证集。
2. 原生`auto_clip_layer`收到`n_sample_token=128`，避免小样本导致内部切片step=0；通道64满足上游batch限制，K128同时满足group和native pack的64对齐。
3. 冻结阈值，将裁剪权重转FP16，调用`pseudo_quantize_tensor(..., get_scale_zp=True)`；把返回重建权重交给原生`WQLinear.from_linear`生成真实`qweight/scales/scaled_zeros`。
4. 将state_dict导出至本栏目被忽略的`build/awq-clip-state.pt`，加载进同版本WQLinear并逐tensor检查一致。存储统计来自tensor实际numel×element_size，序列化文件字节另记。
5. 用PyTorch对照原始/FP16存储/absmax/上游无clip与裁剪结果，重载检查点并测框架调用；C++ Q4C1实验只在native-cpp模式启用。

接入已有Linear：以你的`linear.weight.detach().cpu()`替换随机W，校准X来自真实前向hook采集，独立评估X来自留出数据；有bias时需保留并在所有比较中一致加入。本例无bias、固定尺寸，只能处理满足上游限制的层。要替换整模型层，应使用原项目block缩放及转换流程，并先验证格式与运行后端。不能直接将这个`qweight`喂给昨日独立signed-INT4 kernel，它们的码值、零点与排列不同。

## 量化前后比较

**主流程使用 Python/PyTorch。** `upstream_api.py` 调用原生算法并使用 [torch_evaluation.py](../../torch_evaluation.py) 完成张量误差对比、重建模型接入、torch检查点保存/重载和框架级计时。校准/训练、validation选型、evaluation分区不变；不因为在CPU上运行就迁移成C++。

从本课目录运行（已有对应上游依赖和固定源码时）：

```sh
sh run.sh native      # 默认路径；不构建教学C++后端
sh run.sh native-cpp  # 上述流程 + 可选C++物理布局/CPU内核实验
sh run.sh check       # 只检查独立C++后端，不运行原生算法
```

torch使用FP32原始输入/权重作参考；对比FP16存储、独立absmax、上游RTN和原生量化重建，覆盖evaluation、shifted和全零输入。对照输入先舍入FP16再转FP32算子，累加细节由torch后端决定；报告NRMSE/max_abs/cosine，零向量余弦记null。保存的 `build/torch-reconstructed.pt` 是FP32重建权重与元数据，不能当作INT4压缩文件；报告为 `build/torch-result.json`（AdaRound均在`build/native/`）。这是小Linear实验，不是完整模型任务精度。

框架计时10次预热、50次采样，记录同步主机wall time，包含F.linear调度/分配；CUDA设备在计时边界同步。排除校准、文件IO和重载，不能称单个kernel时间，也不能证明packed低位内核提速。Python可调用原生后端测框架性能；专门研究指令、缓存或内核时另用C++/CUDA实现。

显式选择 `native-cpp` 才将张量交给 [C++补充实验](../../cpp/README.md)，写出/重载Q4C1，检查字节、码值和标量CPU参考。Q4C1不是上游模型格式。此前C++ Release/ASan/UBSan与合成数据检查已通过；**新torch评估与四种原生算法仍未运行**，缺对应源码/依赖（GPTQ还需Thor）。入口尝试见 [最新日志](results/native-torch-attempt.txt)，状态见 [verification.json](verification.json)。不安装依赖、不下载模型。

## Thor SM110 与优化

今天固定方法的算法/导出路径已核验；**原生扩展Thor编译、运行和累加细节尚未核验**。`WQLinear.forward`选择原生GEMV/GEMM，不能仅据Python名判定Tensor Core dtype或累加器精度。今天没有生成/执行AWQ原生SASS，不承诺旧AWQ依赖直接兼容Thor。

未来在确认支持SM110的PyTorch/CUDA13环境中，扩展目标应固定如下，不能让可见设备或旧默认列表选择其他架构；此为待执行构建命令，不会自动运行：

```bash
cd systems_practice/.tmp/quant_sources/awq-pinned/repo/awq/kernels
TORCH_CUDA_ARCH_LIST=11.0 python3 setup.py build_ext --inplace
```

必须检查实际nvcc命令只包含compute_110/sm_110；旧PyTorch若不识别11.0就停止并记录，不能降级目标。源码setup.py没有硬编码其他SM，但依赖兼容仍是待补项。今日示例只做CPU重建推理，不调用原生GPU forward。后续原生kernel验收必须加入FP16正确性基线、同语义优化对照、ncu单launch、固定SM110 PTX/SASS和热点分析；未交付的这部分已进入backlog。主练习[优化教程](../../../daily/2026-09-19/OPTIMIZATION.md)提供通用操作步骤，**转置kernel结果不能代替AWQ kernel验收**；[昨日量化GEMM](../../../daily/2026-09-18/session-02/README.md)是不同格式的独立实现，也不是AWQ性能数据。

## 验证与待补

[verification.json](verification.json)分别记录：本地源码拉取false；固定版本网页实现阅读true；原生API示例交付true（clip子机制、CPU重建/真实打包编排）；CPU运行false；Thor验证false。主任务照常归档；AWQ不进入completed_methods，待本地固定源码/依赖和后端验证补齐。次日游标GPTQ；今日对AWQ的实际获取同时重试了昨天唯一backlog，无其他方法预备拉取。
