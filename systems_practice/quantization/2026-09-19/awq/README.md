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
5. 将重建值、scale/zero、原始权重、上游无clip结果及评估输入交给 C++ 后端；写出独立Q4C1、重载并比较 CPU 输出。原生 WQLinear 文件与教学 Q4C1 分别统计。

接入已有Linear：以你的`linear.weight.detach().cpu()`替换随机W，校准X来自真实前向hook采集，独立评估X来自留出数据；有bias时需保留并在所有比较中一致加入。本例无bias、固定尺寸，只能处理满足上游限制的层。要替换整模型层，应使用原项目block缩放及转换流程，并先验证格式与运行后端。不能直接将这个`qweight`喂给昨日独立signed-INT4 kernel，它们的码值、零点与排列不同。

## 量化前后比较

2026-09-22 将部署侧的位操作、打包/解码、误差验证、FP16存储舍入、absmax基线和 CPU 计时迁入 [C++17 后端](../../cpp/README.md)。上游 API 的校准/优化和候选选择保留在 `upstream_api.py`，使用固定 commit；它只通过文本传递张量，不能充当 CPU 内核示例。

`sh run.sh check`（本课目录）只验证独立 C++ 后端；`sh run.sh native` 才运行原生方法与完整张量交接。后端写并重载 `build/linear.q4`（AdaRound 为 `build/native/linear.q4`）。Q4C1 包含16字节头、每组8字节FP32 scale/zero和低 nibble 优先 u4；与旧 Python 容器及上游模型文件不兼容，不能直接喂给原生加载器。格式、误差阈值、分组尾部与板端边界见后端说明。

以 FP32 输入/权重为参考，对照 FP16存储、独立 absmax、上游 RTN、原生量化解码；对照输入先舍入为 FP16，再以 C++ FP32 标量累加。对 evaluation、shifted、全零输入记录 NRMSE/max_abs/cosine（零向量为 null）。CPU基准10次预热、50次采样，覆盖已解码 GEMM 与输出分配，排除磁盘、解码和训练，不代表 BLAS、低位kernel或GPU性能。仅记录上游校准/优化的流程用时，不把 Python 算子计时作为体系结构实验。

**本机已通过**共用后端的 Release、ASan/UBSan、位模式/边界检查，以及本课形状的合成数据磁盘往返。**四种原生量化算法仍未运行**：缺对应源码/依赖（GPTQ还需Thor），没有真实量化模型精度或板端性能。合成检查不推进原生完成状态。当前证据见 [verification.json](verification.json)、[新原生入口尝试](results/native-cpp-attempt.txt)；原有 results 原样保留为历史记录。

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
