# 2026-10-08 AWQ第二轮：通道缩放的融合合同与分布变化

## 方法与应用场景

第一轮讲过裁剪/打包，今天只深入**AWQ激活感知通道缩放**：对于输出`Y=XW^T`，取正通道scale `s`，使`(X/s)(W*s)^T`在未量化时等价，然后用激活统计与重建误差选择s。保护重要输入通道会改变同group内其他权重的量化步长，所以必须实际评估而不能假定更好。AWQ是PTQ算法，INT4是格式，W4A16是权重/激活位宽，QAT是训练范式；本期没有训练更新，不称QAT，也不是NVFP4。

原生示例`LayerNorm(128) → Linear(128,128,bias=False)`，X为`[tokens,128]`，校准/调参FP32，打包和目标推理FP16输入，group128非对称INT4，零点0–15；计算dtype由原仓库kernel决定。独立小例N7/K33/group16用offset8对称INT4，**格式与上游不同**，Python双精度累加，不冒充原生W4A16性能。

## 原仓库与实际读过的实现

[mit-han-lab/llm-awq](https://github.com/mit-han-lab/llm-awq)，真实浅克隆commit **d6e797a42b9ef7778de8ee2352116e0f48a78d61**，2026-10-08。首次沙箱DNS失败保留[source.json](source.json)；经网络授权边界重试成功，完整获取证据在[results/source-network-retry.json](results/source-network-retry.json)，包括每文件SHA256和永久链接。没有迁移到第三方AutoAWQ。本次实际读取：

| 固定提交文件 | 符号/调用链与阅读范围 |
| --- | --- |
| [auto_scale.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/quantize/auto_scale.py) | get_act_scale、scale_ln_fcs、auto_scale_block内_search_module_scale；mean(abs(X))、20档ratio、LN/后继权重融合 |
| [quantizer.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/quantize/quantizer.py) | pseudo_quantize_tensor→scale/zero/round/clamp；real_quantize_model_weight→WQLinear |
| [qmodule.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/quantize/qmodule.py) | pack_intweight、calculate_zeros_width、WQLinear.from_linear/forward；交错打包、padding metadata、batch<8选择GEMV |
| [entry.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/entry.py) | load_awq/apply_awq、real_quantize、dump/load量化权重分支；全模型入口会依赖本地模型及校准数据 |
| [gemv_cuda.cu](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/kernels/csrc/quantization_new/gemv/gemv_cuda.cu) | 网页读gemv_kernel、warp_reduce、gemv_forward_cuda_new；float4载入、half2解码乘加、shuffle/shared归约 |
| [setup.py](https://github.com/mit-han-lab/llm-awq/blob/d6e797a42b9ef7778de8ee2352116e0f48a78d61/awq/kernels/setup.py) | CUDAExtension源文件列表和C++17编译选项；实际兼容性未编译核验 |

原场景是LLM权重量化与TinyChat部署。原生脚本**原样调用helper/打包API，搜索编排独立改写**：只做LN→Linear而非整decoder block，不含auto_clip。独立CPU/CUDA实现仅受机制启发，不复制原kernel或其位布局。根LICENSE是MIT；pyproject classifier却写Apache，已记录差异。GEMV文件自身明确Apache-2.0且由NVIDIA代码改编，不能把根MIT泛化到该文件。本课不搬运第三方实现。

## 如何接入我的代码

已有依赖环境中，从仓库根执行：

```sh
# 本任务未安装任何依赖；这一步只获取代码，不下载模型。
git clone --depth 1 --filter=blob:none --sparse https://github.com/mit-han-lab/llm-awq.git systems_practice/.tmp/awq-native
git -C systems_practice/.tmp/awq-native sparse-checkout set awq
git -C systems_practice/.tmp/awq-native rev-parse HEAD
# 结果必须为上述commit，否则先检出/核验该commit，脚本也会拒绝错版本。
AWQ_ROOT="$PWD/systems_practice/.tmp/awq-native" sh systems_practice/quantization/2026-10-08/awq/run.sh native
```

上游声明Python≥3.8，README示范3.10；pyproject固定torch2.3.0、torchvision0.18.0、transformers4.46.0、accelerate0.34.2；qmodule还无条件import `awq_inference_engine`。**这套旧依赖不是已验证的Thor CUDA13环境**；不能通过伪模块绕过扩展import后宣称原生CPU运行。当前Mac Python缺torch，真实失败见[native.txt](results/native.txt)。

[native_example.py](native_example.py)已写好：随机初始化，无模型下载。种子101/102/103分别产生32条校准、32条调参、16条评估；模型种子17。统计只来自校准集，20档ratio用调参集输出MSE选择，评估不参与选择。使用get_act_scale与scale_ln_fcs验证融合等价，调用pseudo_quantize_tensor取scale/zero，再WQLinear.from_linear实际打包，保存`build/native.pt`并以init_only重载。误差对照FP32、FP16、独立absmax和AWQ QDQ；参数、payload与序列化容器开销分列。不是仅fake quant后声称已导出压缩模型。

已有网络中替换点是LN及其全部相应后继Linear：LN weight/bias除s，各后继权重乘s；若有额外未调整消费者/残差，等价性不成立。bias处理不同于权重列，不能随便一起乘s。不要只替换Linear却漏掉输入缩放。原生全模型API仅支持源码识别的block家族，单层例使用真实helper而不捏造run_awq(Linear)。

Thor上原生示例需经依赖移植审计且扩展已成功构建后，设置`THOR=1`；脚本强制CC11.0、对照QDQ再对照FP16基线测同步主机LN+Linear的21组批均值P50/P95，不把它叫单kernel时间。建议只在用户已有兼容环境构建：

```sh
cd systems_practice/.tmp/awq-native/awq/kernels
TORCH_CUDA_ARCH_LIST=11.0 python3 setup.py build_ext --inplace
# 固定sm_110，不添加专用后缀；检查实际nvcc命令确实包含compute_110/sm_110。
```

这不是依赖安装命令。PyTorch2.3可能不识别11.0，须先解决CUDA13/Jetson兼容PyTorch与上游版本约束；直接加环境变量不构成支持证明。其余attention/rope编译单元仍需逐一验收，当前未验。

## 量化前后比较

默认`sh systems_practice/quantization/2026-10-08/awq/run.sh`执行独立标准库例，非原仓库运行。数学实验使用同一FP32语义权重、显式FP16权重舍入参考、absmax及AWQ启发搜索；Python计算并非FP16算术。231权重真实packed116B，group FP32 scales84B，输入通道scale132B，共332B文件；FP16权重payload462B，FP32为924B。这个小shape的metadata占比大，不能宣传“4倍整模型压缩”。另有运行时Python对象开销未计入文件。

[实际输出](results/independent.json)：选择ratio0.30；评估NRMSE absmax0.051529→AWQ启发0.022090，离群通道迁移后0.021850→0.032630，出现退化。FP16权重舍入参考同分布NRMSE0.000116。文件重载逐值相等、尾nibble、尾group、全零通过。27个量化码落端点，端点计数不等于超范围裁剪次数。

预热3次，15样本每样本3次Python GEMM平均；FP32/已解码AWQ P50约0.15854/0.14893ms，不包含搜索/解码/打包，输入激活也是Python数值；两者都是相同Python循环，差异不能解释为低位加速。原生CPU误差/存储/性能以及Thor全部未验证。

## Thor SM110 与优化

[独立CUDA完整实现](src/gemv.cu)：W4A16、FP16输入、FP32 group32 scale/FP32累加，W[N,K]连续nibble offset8。`gemv_baseline`一线程一输出，最终候选`gemv_warp`一warp一输出，四warp/CTA，将K分给lane，shuffle归约。目标shape M1/N128/K1025，测试另含零M、K0/1/31/32/33/65、N尾部；与CPU double累加oracle比较`1e-4*(1+abs(ref))`。各方案相同数据、输出与误差标准。真实低位存储＋SIMT解码/FMA，**不是原生INT4 Tensor Core性能，也不是WQLinear格式兼容后端**。独立CPU例G16，CUDA G32是另一个明确合同，不将其数据文件混用。

串行基线可能受长FMA依赖、跨输出的stride访存限制；warp候选减少每lane串行工作、相邻lane读连续k，但增加5次shuffle、更多线程和部分byte重复读取，小K可退化。当前选择是教学最终候选，收益待验，不能说已经优化成功。

```sh
sh systems_practice/quantization/2026-10-08/awq/thor.sh
sh systems_practice/quantization/2026-10-08/awq/profile.sh
```

[GPU分析教程](THOR.md)解释定位/过滤/ncu采集、PTX/SASS和架构差异。已核实NVIDIA计算能力表T5000/T4000=11.0、JetPack页面Thor统一CUDA13、PTX9.0引入sm_110；JetPack7.0 release-note URL本次Internal Error，具体L4T/驱动/ncu组合仍须目标机核实。Mac无nvcc/ncu/Thor，[原始失败](results/thor.txt)为nvcc not found；没有真实生成PTX/SASS、没有GPU性能。

## 故障链与迁移验收

1. 融合后浮点输出已变→LN有遗漏消费者或scale方向相反→先在量化前查等价误差→全消费者同步变换，否则保留显式输入除s；回归残差/多投影分支。
2. 校准集误差低但部署退化→激活重要通道迁移→固定评估/shift集比较→重新校准或回退，代价为离线搜索与版本管理；不能用测试集重选ratio后仍称独立评估。
3. checkpoint能加载却输出错→u4打包交错/scale padding不匹配kernel→小矩阵逐元素QDQ对齐→固定导出格式与后端一起版本化；不能把自定义nibble喂给WQLinear。

验收：真实commit与许可证逐文件确认；检查torch/CUDA/扩展ABI；浮点融合→QDQ→packed重载→目标kernel四阶段分开；测保存bytes、正确性及目标延迟；小M/长K/尾部/shift长期验证。追问：1. 为什么按输入列缩放？2. 量化前等价为何不保证量化后好？3. group尺度如何耦合通道？4. metadata为何会抵消压缩？5. W4A16能直接用W4A4 WMMA吗？6. QDQ性能为什么不能外推packed kernel？

## 验证与待补

源码获取**是**、实现阅读**是**、原生示例交付**是**、原生CPU运行**否**、Thor验证**否**。独立CPU示例通过单列，不改变后三项含义。[verification.json](verification.json)记录范围。仅额外重试旧GPTQ一次，DNS失败见[记录](results/gptq-retry.json)；今天AWQ成功获取关闭其“无法获取源码”子项，依赖/扩展/Thor待验仍留backlog。明日GPTQ，今日同日续跑不重复推进。
