# 2026-10-22 每日量化：移动平均校准的顺序偏置

## 方法与应用场景

第二轮校准专题只深入 **MovingAverageMinMaxObserver**。不是再讲一遍HistogramObserver。相机初始曝光异常会出现首批大值，后续趋稳；移动平均能逐步忘记早期极值，但也可能忘掉仍重要的稀有场景。对照是全局absmax，输入顺序改变是本次现成反例。

算法：非首批边界更新`m_t=(1-c)m_(t-1)+c*min(batch)`，max同理；第一个非空批直接初始化。格式与位宽：对称INT8，激活per-tensor、权重per-output-channel；人为选择[-127,127]使scale=absmax/127、zero-point=0，不能直接套到默认[-128,127]的127.5除数。舍入用torch.round，饱和到选定范围，真实INT8存储，计算显式扩宽INT32并在累加后乘激活scale与每行权重scale。训练范式是PTQ：没有训练、没有STE、没有参数更新；EMA不是QAT。

## 原仓库与实际读过的实现

今天真实浅拉取[PyTorch](https://github.com/pytorch/pytorch)，commit **37f56e48ce431907080585a595c437f9edb23411**，version.txt为2.16.0a0，BSD-3-Clause。首次DNS失败保留[source-initial.json](source-initial.json)，成功获取事实保留[source.json](source.json)，人工阅读范围单列[source-read.json](source-read.json)。不篡改获取脚本初始的source_read=false。

实际读[observer.py](https://github.com/pytorch/pytorch/blob/37f56e48ce431907080585a595c437f9edb23411/torch/ao/quantization/observer.py)的MovingAverageMinMaxObserver构造/forward、MinMaxObserver.forward/calculate_qparams、基类_calculate_qparams；以及[fake_quantize.py](https://github.com/pytorch/pytorch/blob/37f56e48ce431907080585a595c437f9edb23411/torch/ao/quantization/fake_quantize.py)的FakeQuantize.forward，README/许可证。调用链为`ob(x) → detach/aminmax/EMA → calculate_qparams → frozen scale → 本例整数导出/参考推理`。FakeQuantize只是用于核实“更新观察器”和“启用QDQ”是两个开关，今天示例不把浮点QDQ叫压缩存储。

原场景是PyTorch校准/QAT观察器组件；原生API原样调用，数据编排、INT8文件和INT32推理为独立教学实现。没有使用自动graph convert或生产低位后端。Google直访失败，知乎搜索只读到二手“EMA更鲁棒”摘要，未采纳该结论；实际源码与分布偏移反例为依据。

## 如何接入我的代码

[example.py](example.py)可直接运行完整流程，不自动安装、不下载模型。需要Python≥3.10和**上述commit构建的torch**；脚本检查torch.version.git_version，不默默把未审阅版本标为同一实现。本机Python3.9.6及内置Python3.12.14均没有torch，因此未做native执行/包兼容验证。已读上游README还要求构建PyTorch本体使用C++20；本课自写C++仍是C++17，未尝试构建上游。源码中的2.16.0a0仅是版本标记，不表示有可用稳定wheel。可用获取工具重新取得源码记录，准备环境由已有设备环境完成：

```sh
python3 systems_practice/quantization/fetch_source.py calibration --record systems_practice/quantization/2026-10-22/calibration/source-device.json
# 已有固定commit的torch环境，工作目录由run.sh切换到本课。
PYTHON=/path/to/audited/python sh systems_practice/quantization/2026-10-22/calibration/run.sh
```

获取工具抓取当时HEAD，若不同于37f56e48ce431907080585a595c437f9edb23411，必须在源码环境切回该commit或重新审阅，不能只修改脚本常量骗过校验。没有torch的Mac可运行独立数学反例：

```sh
python3 systems_practice/quantization/2026-10-22/calibration/independent.py
```

原生示例K=17、N=7，weight FP32 `[7,17]`，校准8批`[8,17]`、调参`[32,17]`、评估与偏移各`[31,17]`。校准第一批放大6倍，候选c=0.01/0.1/0.5只在独立tune集按输出NRMSE选取。eval从不更新观察器。无训练集，因为没有训练步骤。冻结后反向校准顺序只作对照，不再借eval选择参数。

接入现有`nn.Linear(17,7,bias=False)`的位置是替换weight来源、在该层输入处收集校准批，将freeze得到的scale交给infer；有bias时需在输出scale后正确加bias，本例合同不含bias。标准库自定义`EMA1`文件依次写header、激活scale、行scale、N*K个signed INT8，导出到忽略的build/linear.bin并重载验证；这不是torch state_dict或TensorRT engine。INT32上界`17*127*127`经检查，不声称任意K都不会溢出。

## 量化前后比较

原生例子会报告FP32参考、FP16存储/FP32计算参考、absmax、EMA、逆序EMA的NRMSE/最大误差/余弦/饱和；实际文件字节与payload/scale/header分开。计时为CPU单线程、预热5次、9批各30调用均值的中位数，int32路径含在线量化和扩宽，不能叫原生INT8 kernel时间。原生误差/真实文件/性能**全部未验证**，没有填入数学反例数据代替。

已运行的[independent.py](independent.py)只处理四标量，校准边界[12,1,1,1]在c=.5时正序2.375、反序6.5。真实4个i8+一个f32 scale文件8B，与4个FP16同为8B，说明metadata会吃掉小张量压缩收益。普通输入MSE：absmax0.00094953、EMA0.00003459；偏移输入MSE：absmax0.00038750、EMA31.16797。它不是原仓库用法，不是GEMM，更不是模型任务精度。[完整结果](results/independent.json)。零值、空/非法alpha拒绝与文件重载通过。首次把st_size属性误写成调用的失败保留，修复后输出另存。

## Thor SM110 与优化

本例只运行CPU观察器与独立INT32参考，未构建CUDA扩展、未实现GPU kernel。torch.quantized CPU打包、浮点QDQ和Thor低位Tensor Core不能混为一谈。原项目当前CUDA wheel/JetPack兼容矩阵未验；即使宿主torch版本匹配也不能证明Thor后端支持。需要将来单独验收真实后端、dtype、scale和累加合同，所有新增CUDA构建固定`sm_110`，不自动使用专属后缀。今日没有新增GPU优化/ncu/ISA热点，架构对照游标不推进。

## 验证与待补

[verification.json](verification.json)：源码获取/实现阅读/完整示例交付为true，CPU原生执行/Thor为false；[系统Python失败](results/native-attempt.txt)、[内置Python失败](results/native-bundled-attempt.txt)都为缺torch。Python语法检查通过不等于原生API运行。

旧backlog仅重试QAT源码获取一次，DNS失败，未发现可验证的QAT源码缓存，[记录](results/backlog-qat-source.json)保留；不把它算今日第二篇、不推进两次。今日方法留native/Thor待补，下一方法QAT。

两个故障链：①同数据不同batch顺序scale不同→保存每批边界/顺序区分实现错误与EMA固有权重→固定校准协议并用holdout选c，代价是额外调参；②普通分布误差低但异常曝光饱和→看偏移集裁剪率而非只看平均MSE→回退absmax或扩展代表数据，代价是普通范围步长变粗。上线需再检查空数据、NaN/Inf、零tensor、eval不更新scale、导出重载与业务任务精度。

追问：①EMA与全局极值如何不同？②为什么默认对称qint8可能除127.5？③校准与调参为何分离？④冻结后还能更新统计吗？⑤INT8存储为何未必带来INT8算术？⑥小矩阵metadata为何可能抵消压缩？
