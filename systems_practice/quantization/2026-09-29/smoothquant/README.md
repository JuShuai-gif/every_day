# 2026-09-29 SmoothQuant：把激活量化难度移到权重

## 方法与应用场景

今天只深入SmoothQuant的LayerNorm→Linear等价缩放。算法是使用校准激活统计的PTQ，不进行梯度训练；格式是对称INT8码，位宽W8A8，权重逐输出通道scale、激活逐token动态scale，零点0、round到最近整数，解码后本例用FP32 Linear。SmoothQuant不是INT8格式的别名，更不是QAT。

`X'=X/s, W'=W*s`（PyTorch权重按输入列乘s），实数乘积不变；`s_j=max|X_j|^alpha/max|W_:j|^(1-alpha)`。增大alpha减少激活异常通道，却可能扩大权重范围。缩放折进前一LayerNorm的weight/bias后，不新增在线除法；只有这些输出流向配套Linear时才可这样改写，多分支必须一起处理。

## 原仓库与实际读过的实现

[mit-han-lab/smoothquant](https://github.com/mit-han-lab/smoothquant)，main，2026-09-29网页实际阅读：

- [smooth.py](https://github.com/mit-han-lab/smoothquant/blob/main/smoothquant/smooth.py)：`smooth_ln_fcs`，统计合并多个fc列max、构造scale、修改LN及fc；`smooth_lm`中OPT的QKV与fc1调用位置。
- [fake_quant.py](https://github.com/mit-han-lab/smoothquant/blob/main/smoothquant/fake_quant.py)：`W8A8Linear.from_float/forward`、per-channel权重量化、per-token激活量化；from_float会原地改写传入权重，forward激活QDQ后仍调用浮点Linear。
- README依赖/使用部分、setup.py、LICENSE（MIT）。原torch-int部署路径仅README读到，未审查其内核，不把它计为本课已验证后端。

调用链：校准LN输出max→`smooth_ln_fcs`→`W8A8Linear.from_float`→输入QDQ→F.linear。例子原样调用这些已读API；自己的INT8导出/解码函数单独标明。浅克隆DNS失败，[source.json](source.json)保留失败事实，[缓存查询](results/cache-search.txt)无可验证缓存；commit API与短SHA原文请求均失败，精确commit/永久链接仍待补，以上是分支链接，不冒充永久链接。不能宣称源码已本地拉取或版本已固定。

## 如何接入我的代码

原项目README给torch1.12.1+cu113、transformers4.36.0；旧CUDA包不能用于Thor。本例CPU候选环境Python3.10+、torch2.5.1、transformers4.36.0，组合未运行验证，不自动安装。当前Python3.9.6，torch/numpy/transformers均缺失。[环境证据](results/environment.txt)。先在联网环境取得干净checkout、记录commit并复核两个文件；版本固定未解决前不把它称为可重复完成。

```sh
# 从仓库根目录，fetch工具只取源码，不安装依赖或下载模型。
python3 systems_practice/quantization/fetch_source.py smoothquant --record systems_practice/quantization/2026-09-29/smoothquant/results/source-retry.json
# 成功后检查记录中的真实commit；将对应缓存repo所需源码checkout出来。
# 若自行准备了干净、已核验版本的源仓库，指定其绝对路径：
export SMOOTHQUANT_SOURCE=/absolute/path/to/verified/smoothquant
PYTHON=python3 sh systems_practice/quantization/2026-09-29/smoothquant/run.sh
```

[example.py](example.py)创建LayerNorm(16)和Linear(16,8)，输入FP32 `[64,16]`校准、`[32,16]`调参、独立`[32,16]`评估，固定不同随机种子。alpha在0/0.25/0.5/0.75/1上只用调参集选；无训练集、无训练更新。先检查浮点等价，再对比FP32、FP16、absmax W8A8和SmoothQuant，最后导出真实int8权重/FP32 scale/LN参数/bias，重载并解码推理。产物`build/smoothquant-int8.pt`被忽略，结果追加`results/run-时间戳.json`。

接入已有模型时将`ln/fc`替换为真实相邻模块，在实际LN输出上收集act_scales；不要把模型原输入统计直接喂给该函数。多分支LN需传fc列表。示例不把自定义checkpoint冒充torch-int或TensorRT格式，也不声称任意模型可直接调用`smooth_lm`。

## 量化前后比较

运行后输出NRMSE/最大误差/余弦、scale和码真实字节、checkpoint磁盘字节、激活码/scale字节、rail占用与真正越界裁剪率。原生fake_quant的权重仍是浮点buffer，不能因为类名W8A8就声称存储缩小；自定义int8导出才实际压缩权重。此小规模metadata和容器开销可能抵消收益。全零/全一输入及导出重载一致性为边界检查。

| 指标 | 本次结果 |
| --- | --- |
| 原生API数值、FP16/absmax/SmoothQuant对照 | 未运行，缺checkout与依赖 |
| 实际导出字节与磁盘大小 | 未运行，不以理论字节冒充结果 |
| CPU框架耗时 | 未运行；脚本预热20/采样100，含LN/QDQ/Linear |
| Thor kernel、E2E、功耗 | 未验证 |

冻结alpha后评估，保留误差变大的结果；合成单层误差不等于LLM任务精度。准备了完整用法，但没有用独立数学运行替代原生运行。

## Thor SM110 与优化

本课执行CPU算法/API示例，没有CUDA kernel或CUDA扩展构建，不生成伪PTX/SASS。已核实[CUDA13.0发布说明](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-toolkit-release-notes/index.html)将SM101重命名为SM110；[NVIDIA CUDA13.0说明](https://developer.nvidia.com/blog/whats-new-and-important-in-cuda-toolkit-13-0/)关联JetPack7.0/Thor。JetPack7.0 release-note页面请求失败，当前板端L4T/驱动/ncu组合待实机核实；本机无nvcc或Thor。

torch-int依赖支持Thor尚未核实，旧cu113包不足以证明支持sm_110。将来扩展执行只能固定sm_110/架构110，并先核对nvcc支持列表、实际CUDA库和ncu版本；不改用别的GPU或专属后缀，不把本例浮点QDQ称为原生INT8 Tensor Core。今日不涉及GPU kernel，GPU优化候选/ncu对照要求不在这个CPU算法示例上伪造履行。

## 验证与待补

[verification.json](verification.json)分别记录本地获取否、网页实现已读、原生示例已写、CPU运行否、Thor验证否。运行尝试因缺源路径失败见[native-attempt.txt](results/native-attempt.txt)，Python语法检查另记总审计。版本固定、原生运行、导出误差/存储/耗时和后端验证进入backlog；下一方法LLM.int8。今日额外只重试AWQ一次，DNS仍失败，不重复推进旧游标。
