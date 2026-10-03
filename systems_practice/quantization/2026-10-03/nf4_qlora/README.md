# 2026-10-03 · NF4 / QLoRA：冻结四位主干与低秩适配

## 方法与应用场景

机器人端已有语言策略模型需要任务适配、训练显存受限时，QLoRA把主干权重压缩后冻结，让梯度只更新低秩适配器。本课只深入此方法：NF4是非均匀16码值的数据格式，不是INT4；4是每权重的码位宽，不代表四位乘法指令；QLoRA是冻结量化主干的参数高效微调范式，不等同QAT。昨天QAT改变训练中的量化感知参数，今天主干code保持不变。

块内absmax把权重归一化，再映射NF4码本；反量化为`scale * codebook[code]`。double quant进一步编码scale，需二级scale、offset及状态，不是再减少权重码位宽。低秩分支为`x Wq^T + (x A^T) B^T`；示例rank=4、系数1，主干解码为FP32，乘加FP32。原始CLI用BF16计算，权重码4bit；不能把两者称为同一W4A16性能路径。

知识图谱：权重分块→非均匀码→真实uint8打包→完整QuantState→解码权重；冻结主干→梯度经过主干算子→只更新A/B→独立调参集选checkpoint→保留集一次评估。前提是接入层shape、转置、码本和scale布局一致；减少存储不自动降低推理延迟。

## 原仓库与实际读过的实现

2026-10-03实际网页阅读，详情在[source-reading.json](source-reading.json)。当日浅克隆失败，原始[source.json](source.json)保留DNS错误；忽略缓存中无可验证checkout，不能声称已拉取。

- [artidoro/qlora](https://github.com/artidoro/qlora)，commit `7f4e95a68dc076bea9b3a413d2b512eca6d004e5`，MIT；[qlora.py永久链接](https://github.com/artidoro/qlora/blob/7f4e95a68dc076bea9b3a413d2b512eca6d004e5/qlora.py)。已读`get_accelerate_model`、`find_all_linear_names`、保存回调、`local_dataset/make_data_module/train`及requirements/LICENSE。原场景是因果LM监督微调：模型加载→BitsAndBytesConfig→prepare_model_for_kbit_training→get_peft_model→Trainer更新→适配器保存。`qlora-local.sh`调用这条真实CLI，不是自造API。
- [bitsandbytes](https://github.com/bitsandbytes-foundation/bitsandbytes)，tag0.48.1，commit `7e16503e403de460d4ed7dfd6c90a656628f5149`，MIT；已读[functional.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/functional.py)的NF4量化/解码、QuantState导出重载；[default/ops.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/backends/default/ops.py)的分块和打包；[modules.py](https://github.com/bitsandbytes-foundation/bitsandbytes/blob/7e16503e403de460d4ed7dfd6c90a656628f5149/bitsandbytes/nn/modules.py)的Linear4bit构造/加载，pyproject/LICENSE。基础调用链为quantize_nf4→quantize_4bit→后端→packed码和QuantState→dequantize_nf4。foundation地址已核实；不假定旧timdettmers路径仍是当前主仓库。

`example.py`原样调用原生量化/导出API，其小Linear与SGD训练循环是独立教学实现，省略paged optimizer、完整Transformer和分布式训练。`src/nf4.cu`仅受格式启发的独立SIMT候选，绝非原仓库kernel改编。

## 如何接入我的代码

工作目录为仓库根，Python脚本用自身路径把产物写进本课忽略的build/。依赖：审读bnb=0.48.1；其元数据要求Python>=3.9、torch>=2.3且<3、numpy>=1.17、packaging>=20.9。本机无torch，未核验一个可运行版本组合；Mac安装分类也不能证明CPU后端可用。目标Thor须有支持SM110的CUDA13工具链与匹配PyTorch，bnb后端兼容性仍待设备实测。没有安装、没有模型下载。

```sh
sh systems_practice/quantization/2026-10-03/nf4_qlora/run.sh
# 已有依赖的Thor上；脚本会检查CC必须11.0
sh systems_practice/quantization/2026-10-03/nf4_qlora/run.sh --device cuda
# 重试源获取（不会自动安装）
python3 systems_practice/quantization/fetch_source.py nf4_qlora --record systems_practice/quantization/2026-10-03/nf4_qlora/build/source-retry.json
```

小例子无外部模型：固定随机种子17，W=[32,128] FP32，训练/调参/评估输入分别[64,128]/[32,128]/[48,128]；无激活校准，NF4仅从权重块统计，blocksize64。对nested false/true分别导出真实uint8与完整状态，重载后逐元素等价；冻结解码主干，SGD学习率0.1更新rank4的A/B共80步，只用调参集选最优（含step0），评估集不参与选择。训练有`backward/step`和A/B变化断言，但本机未执行，不能记为已完成训练。

接入已有`nn.Linear`时，把其`weight.detach()`传给同一原生量化入口，保留bias；按forward的`F.linear(x,dq,bias)`接入，再加低秩分支。示例只实现无bias层。build/nf4-{False,True}.pt保存码和QuantState；adapter文件独立保存A/B。保留bias、模块名字和方向应由实际模型接入代码明确处理。

已有本地模型时可用完整上游CLI：

```sh
QLORA_SOURCE="$PWD/systems_practice/.tmp/quant_sources/nf4_qlora" \
LOCAL_MODEL="$PWD/systems_practice/.tmp/models/local-model" \
LOCAL_DATA="$PWD/systems_practice/.tmp/data/local-alpaca.json" \
sh systems_practice/quantization/2026-10-03/nf4_qlora/qlora-local.sh
```

先确保QLORA_SOURCE是真实clone并checkout上述commit（脚本拒绝不同版本）；路径须实际存在。JSON是已有本地alpaca记录数组，每条包含instruction/input/output，至少足够分出8条验证记录；建议>=100条。上游local_dataset先留10% test，make_data_module另从train划eval；本CLI执行train/eval，不报告test任务精度。保留测试集须另行推理评估，不能用eval当test。原始2023脚本的Transformers/PEFT/accelerate/datasets版本未锁定，和现代bnb0.48.1、Thor组合尚未验证，禁止直接宣称兼容。脚本开启离线模式，缺模型/依赖立即报错。小Linear导出重载是本期无模型的完整用法；本地LM入口是附加候选。

## 量化前后比较

同一test输入比较FP32、FP16、真实打包absmax INT4、原生NF4及NF4+适配器；输出NRMSE、max-abs、余弦。字节统计分packed码、所有QuantState张量元数据、序列化文件体积、独立FP32适配器。不能只用参数数/2冒充完整存储。

| 项目 | 本次实际结果 | 计量边界 |
| --- | --- | --- |
| FP16/INT4/NF4/适配后误差 | 未验证：torch缺失 | 同一heldout Linear输出 |
| 实际packed及状态字节 | 未验证 | 脚本运行后按真实tensor计数 |
| dense / decode+dense P50/P95 | 未验证 | 20预热100次，同步框架调用，包含Python与解码 |
| Thor SIMT基线/优化 | 未验证：nvcc/设备缺失 | CUDA event单kernel；不是原生低位Tensor Core |

全零64元素块验证状态/解码；int4基线每行scale与NF4每64元素块不同，这是格式/粒度对照，不是纯码本单变量试验。tiny层元数据、解码与适配器计算可能抵消存储收益；NF4也不保证所有分布误差都小于均匀量化。

## Thor SM110 与优化

[独立GPU候选和ncu/ISA教程](OPTIMIZATION.md)。源代码是K=130、N=33的NF4解码GEMV：标量每thread一行基线→warp协作每行候选，共享相同packed输入、scale、FP32计算与double oracle。仅SIMT，不使用原生4bit Tensor Core。自定义低nibble在前、scale每行分组；bnb default后端高nibble在前且按整体flatten分组，因此不能直接传入原生q/state。格式转换成本尚未实现/测量，主Python例子直接用原生API避免混淆。

JetPack7.0官方发布说明确认Thor采用CUDA13（历史兼容基线，不称最新）。执行目标始终sm_110，无架构专属a后缀。bnb的CUDA13分类不是SM110后端验证证据；原生CMakeLists网页读取失败，未编造扩展构建开关；现有wheel需在目标上确认架构覆盖再运行。自写CUDA的完整nvcc命令已交付。

## 验证与待补

[五项状态](verification.json)：源码获取否；网页实现阅读是；示例交付是；CPU运行否；Thor验证否。原始失败在results/cpu.txt、results/gpu.txt、source.json。每日仅重试旧AWQ一项，仍DNS失败，见[重试记录](../awq-retry-source.json)。本课进入backlog，明日游标KIVI；未把未运行材料记入completed_methods。

故障链一：省略nested状态→重载输出漂移→核对QuantState所有tensor和offset→完整导出并做解码一致性检查。故障链二：把低nibble格式接到bnb高nibble后端→误差巨大但shape正常→用两个不同码的单字节探针→显式转换和重测成本。故障链三：复用2023依赖与新GPU→导入/加载/launch失败→核对版本、CC、动态库与最小NF4 API→先验证后端再训练，不能自动回退成别的GPU目标。

阅读追问（非新增作业）：①NF4与INT4差别是什么？②double quant必须保存哪些额外状态？③为什么QLoRA不是QAT？④A随机、B零初始化时第一步谁先收到梯度？⑤为什么调参集最优可能是step0？⑥小层的压缩收益为何可能被元数据和解码抵消？
