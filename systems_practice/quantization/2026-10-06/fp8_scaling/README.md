# 2026-10-06 FP8：当前张量amax动态缩放

## 方法与应用场景

每天量化独立游标第17项，今天只深入动态per-tensor absmax缩放。E4M3FN是8位浮点格式；动态统计amax是方法；它不是INT8，也不是QAT。此法仍是absmax量化，价值在运行时随输入调整range，不宣称校准优化算法。与独立校准集确定的静态absmax对照，不把动态scale称作训练更新。E5M2仅作为梯度格式背景，不在本课展开另一种方法。

算式：乘法scale s=448/max(amax,1e-12)，q=E4M3FN(clamp(x*s,-448,448))，解码q/s。零点0、最近偶数、每张量一个FP32 scale；独立例子GEMM [8,33]×[7,33]^T，Python double合并；原生例子[16,64]×[32,64]^T，FP32参考/FP16参考与FP8 emulation。权重和输入分别缩放，输出不是INT32累加。动态图每次扫描amax有成本，异常值也会压缩小值的有效精度。

## 原仓库与实际读过的实现

实际执行浅克隆[torchao](https://github.com/pytorch/ao)，失败原文见[source.json](source.json)：`Could not resolve host: github.com`。忽略缓存无可验证checkout；只重试一个旧AWQ，亦失败，保留[原始记录](results/awq-retry.json)。没有声称源码已拉取成功。

随后网页读取v0.13.0的[Float8Linear.from_float/forward](https://github.com/pytorch/ao/blob/v0.13.0/torchao/float8/float8_linear.py)、[Float8LinearConfig/CastConfig](https://github.com/pytorch/ao/blob/v0.13.0/torchao/float8/config.py)、[tensor_to_scale/amax_to_scale/to_fp8_saturated](https://github.com/pytorch/ao/blob/v0.13.0/torchao/float8/float8_utils.py)、setup.py与LICENSE。BSD-3-Clause（Meta/Arm）；读取日期2026-10-06。release页确认缩写e318546，完整commit页面读取失败，**尚无经过核验的完整commit永久链接**，tag链接不冒充不可变SHA链接，进入backlog。[阅读记录](source-read.json)。仓库未观察到迁移。

调用链：from_float共享传入Linear参数→forward进入matmul_with_hp_or_float8_args→调用动态cast→torch.mm；缩放helper独立核实amax→FP32乘法scale→饱和cast。中间float8_scaling_utils及float8_tensor正文访问失败，所以后端完整dispatch/Thor兼容仍未审完；不声称已经读完全部实现。`example.py`直接调用已读的helper和模块入口，保留原生用法而非独立公式冒充API。

## 如何接入我的代码

```sh
# 工作目录为仓库根；不执行自动安装。
sh systems_practice/quantization/2026-10-06/fp8_scaling/run.sh native
sh systems_practice/quantization/2026-10-06/fp8_scaling/run.sh independent
# 仅Thor，可见CUDA设备必须为11.0；仍采用emulate做框架数值核验。
sh systems_practice/quantization/2026-10-06/fp8_scaling/run.sh thor
```

原生[example.py](example.py)以torchao0.13.0 API为固定阅读版本，torch2.8.0是该release原文导入测试组合，**不是已核实的Thor wheel组合**。建议独立Python3.10+已配置环境，当前3.9.6无torch；pyproject读取失败，依赖精确上下限仍待补。没有安装任何依赖。准备checkout应先成功执行fetch_source，再记录完整SHA和本地状态，固定所读tag后复核依赖；不用未经验证的HEAD覆盖示例版本。

现有`Linear`替换点是`Float8Linear.from_float(copy.deepcopy(layer), config=Float8LinearConfig(emulate=True))`；深拷贝避免from_float共享参数误改原层。动态模式不需要校准/训练/调参集；权重与评估各用独立种子。静态对照只在独立例子的calibration seed20取amax，eval seed30不挑参数，shifted另测。未执行训练，不挂QAT名称。

原生流程完整：生成小层→FP32/FP16参考→原生转换→前向→helper导出真实FP8权重和FP32乘法scale到build/fp8.pt→重载→解码F.linear对齐→零输入与同步框架计时。build不提交。该state只是本例数据导出，非生产打包引擎；Float8Linear保持高精度master权重，不能把临时FP8副本的字节数当模块总内存减少。

独立[independent.py](independent.py)实现254个有限码字往返、tie-even、零张量、NaN/空输入拒绝、实际235B文件导出/重载。它没有调用torchao，使用标准库，仅证明本例格式/数值。

## 量化前后比较

实测仅[独立CPU输出](results/independent.txt)：231权重FP32 payload924B、FP16 462B、真实E4M3FN+4B scale文件235B。iid GEMM NRMSE：FP16 0.0236%、静态4.4011%、动态3.9390%。shifted：静态90.5692%、动态1.0264%；静态饱和30项。shifted总体NRMSE下降受高幅值首行加权影响，不代表各行都更好，生产须另查逐token/任务误差。完整max_abs/cosine/存储见日志。

CPU Python编码P50约221.458µs，只是264元素编码主机耗时，不是模型/GPU/矩阵乘速度。原生误差、内存峰值、框架速度、Thor kernel均未测，不能填估计加速比。

## Thor SM110 与优化

[codec.cu](codec.cu)是独立GPU **编码**热点：已给定主机算出的scale，scalar_encode每线程1项，对照最终vector_encode每线程float4加载/uchar4写入并安全处理尾部。减少寻址/访存指令的假设待测；两者相同数据、最近偶数/饱和与字节输出，由CUDA Math host编码oracle逐字节检查8个shape。不是Tensor Core GEMM，也不包含GPU amax归约，不将编码时间冒充动态量化全流程。

[thor.sh](thor.sh)提供构建/运行/ISA/ncu；[GPU分析教程](GPU.md)给筛选、28次匹配launch跳过、热点/架构对照。全部执行目标`sm_110`，无a/f后缀；环境检查拒绝其他GPU。今日理论对照Hopper FP8转换，昨天Ampere，不改变执行目标。Mac尝试[构建](results/thor-build.txt)失败：nvcc缺失。

## 验证与待补

[source_fetched=false, source_read=true（所列局部）, example_delivered=true, cpu_example_run=false（原生）, thor_verified=false](verification.json)。独立CPU运行另记true，不替代原生状态。缺完整SHA、下载checkout、依赖/后端源码、torch、nvcc/ncu、设备。读取NVIDIA官方JetPack7.0档案确认Thor基线CUDA13.0/L4T38.2系列，但不能由此断言torchao0.13扩展已支持Thor。五种状态逐项保留，失败进入backlog，下一天可轮到block_fp4。

故障链一：错误把s乘法当除法→输出量级错→导出重载对齐→记录scale_mul语义；兼容成本是格式元数据。故障链二：突发输入沿用静态scale→饱和和误差陡升→记录饱和率及heldout→动态amax，付出归约成本。故障链三：CPU emulator成功→误判GPU部署可用→查wheel架构/实际operator→Thor单独验收，禁止切换其他GPU。

追问：E4M3FN与INT8码字有什么不同？为何scale需要方向说明？零张量怎样避免除零？动态量化为什么仍可能损失小值？为什么临时FP8数据不代表master权重内存减半？如何把amax、cast、GEMM和同步计时分开？
