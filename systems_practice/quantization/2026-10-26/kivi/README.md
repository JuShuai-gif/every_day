# 2026-10-26 KIVI：非对称KV粒度与残留窗口

## 方法与应用场景

第二轮聚焦残留FP16窗口的真实存储成本。算法是免训练、在线minmax的KV PTQ；格式是非对称均匀整数码；位宽本例K2/V2；没有QAT/STE、也不是NF4。K沿时间分组、每通道统计；V沿通道分组、每token统计。最新32/64 token保留FP16，较老部分打包；输入`K,V=[1,2,128,64]`、`Q=[1,2,1,64]`，CPU FP16存储、attention用FP32运算。

知识图谱：K沿T统计→保留通道尺度→真实int32容器打包；V沿D统计→保留token尺度→解包后注意力。残留窗口→高精度近期值→额外字节。算法不训练权重，不能用Linear权重量化来替代KV评估。

## 原仓库与实际读过的实现

[原仓库](https://github.com/jy-yuan/KIVI)，实际浅拉取commit `876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6`，2026-10-26，MIT；[第一次失败](source.json)与[成功重试](source-retry.json)分别保留。仓库地址未迁移，读取的是本地真实源码快照，函数阅读证据见[验证](verification.json)。

- [quant/new_pack.py](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/quant/new_pack.py)：`quant_and_pack_kcache/vcache → pack_tensor`，以及两种`unpack_and_dequant_*`与`unpack_tensor`。前者返回码、scale、min；反量化`code*scale+min`，min是浮点偏移，不是整数zero-point。
- [models/llama_kivi.py](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/models/llama_kivi.py)：`LlamaAttention_KIVI.__init__/forward`选段，近期K/V保留、达到窗口后转量化，注意力合并两个区间；本例没有复现整模型生命周期。
- [quant/matmul.py](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/quant/matmul.py)：读取`cuda_bmm_fA_qB_outer`入口，调用`kivi_gemv.gemv_forward_cuda_outer_dim`；GPU后端只做接口审查，未把已下载gemv_cuda全文标为已读。
- [quant/setup.py](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/quant/setup.py)：PyTorch CUDAExtension、C++17，未硬编码SM；不代表依赖支持Thor。

原项目用于LLM KV缓存。今天**原样调用CPU tensor pack/unpack函数**，外层随机输入、残留选择、错误检查、序列化和attention为独立编排；不是原项目完整推理复现。README更新称兼容transformers4.43，而requirements仍列4.36.2，不能混成一个已验证环境。

## 如何接入我的代码

[example.py](example.py)是完整示例：读取源码哈希→导入原生函数→独立seed调残留长度→打包→导出/重载→重建attention→误差/真实字节/CPU计时。无需模型下载。已有模型的接入点是Q/K/V投影与RoPE之后、缓存保存与attention之前；实际原生模型还要求`config.use_flash=True`、`k_bits/v_bits/group_size/residual_length`及FlashAttention依赖，不应直接把pack函数替换Linear。

```sh
# 仓库根，先使用已安装torch/triton/numpy的环境；不会自动安装
sh systems_practice/quantization/2026-10-26/kivi/run.sh
# 缓存路径变化时指定：
KIVI_SOURCE=/absolute/path/to/pinned/source PYTHON=python3 \
  sh systems_practice/quantization/2026-10-26/kivi/run.sh
# 从原仓库复建缓存：
python3 systems_practice/quantization/fetch_source.py kivi \
  --record systems_practice/quantization/2026-10-26/kivi/source-next-attempt.json
```

原requirements：torch2.1.2、triton2.1.0、flash-attn2.5.6、transformers4.36.2；原README建议Python3.10。CPU低层例仅使用torch/triton/numpy（triton是模块顶层import依赖，即使不调用JIT也不能假装不需要）；这些旧版本不是Thor兼容组合。实际宿主Python3.9.6和3.12.14均缺torch，已尝试并失败，未安装。执行前核实所用torch的`weights_only=True`支持；选定源码函数以SHA256固定，不混用新版API。

本例group32、2bit，每16码存一个int32。在线minmax在当前待存缓存上计算，没有离线校准/训练。tune seed200只选residual32或64，eval300、shift400独立；不能用评估误差重新选窗口。导出在忽略的build：cache.pt（框架容器）、cache.raw（实际张量payload）、cache-layout.json（布局）；重载后再运行。没有生成这些文件时不能填写实测压缩比。

## 量化前后比较

| 项目 | 已交付比较 | 本次结果 |
| --- | --- | --- |
| 参考 | FP16存储、FP32 attention | 未运行：缺torch |
| absmax | 对称2位窄范围QDQ误差基线，未打包 | 未运行 |
| 原生KIVI | K/V真实2位码+FP16 scale/min+FP16残留 | 未运行 |
| 指标 | MSE/NRMSE/max_abs/cosine、漂移、payload/容器/layout字节 | 未运行 |
| 时间 | pack与重建后attention分别20预热31单调用样本 | 未运行；非packed后端速度 |

范围内在线minmax无预期越界裁剪；端点占用不等于饱和误差。本例不报告未测饱和率。FP16输入参考会与原始FP32输入有误差，本期研究缓存存储变化，固定同一FP16参考，不冒充全模型任务精度。真实KIVI推理需直接消费压缩缓存，本例解包浮点attention仅检验数值，保留dense shadow，不能据此声称降低运行峰值内存或加速解码。

## Thor SM110 与优化

本期可执行示例固定CPU，不运行CUDA kernel。上游旧torch2.1.2/triton2.1.0早于CUDA13的sm_110命名，不能宣称可直接部署Thor。`TORCH_CUDA_ARCH_LIST=11.0`只约束扩展编译，不会让旧torch/triton获得新架构支持。未来显式批准配置好兼容依赖后，在固定commit checkout的`quant/`目录使用`TORCH_CUDA_ARCH_LIST=11.0 python3 setup.py build_ext --inplace`；nvcc须支持sm_110，保留完整编译日志，实际JIT目标也要独立审查。今天未运行该命令，未提供假造的低位Tensor Core收益。

本期不交付/声称KIVI CUDA kernel移植；后端移植、基线/优化、ncu、PTX/SASS均在backlog。主课独立CUDA练习另见[Thor指南](../../../daily/2026-10-26/GPU_GUIDE.md)，该指南的affine kernel不能当作KIVI性能证据。

## 验证与待补

状态：源码获取✓、实现阅读✓、原生用法交付✓、CPU运行✗、Thor验证✗。失败日志见[系统Python](results/cpu-initial.txt)、[3.12](results/cpu-bundled.txt)。AST/脚本检查只能证明静态结构，不证明API运行成功。今日恰好重试一个历史optimizer_8bit待补项，DNS失败且没有已验证缓存，[原始记录](results/backlog-optimizer-source.json)保留；预备拉取不算新课。

故障链一：组内常量→scale=0→除零/非有限码→用全零组诊断→入口拒绝并上游修复/精度旁路；本例不偷偷修上游数学。故障链二：T未满足group/pack倍数→断言失败或布局不符→核对T轴和D轴→保留残留尾部再压缩，容量收益下降。故障链三：只看2bit payload→实际内存超预算→统计metadata、残留、dense shadow、容器→分阶段测峰值后验收。

迁移验收：固定commit与导出布局；零量程/非法shape/残留切分回归；独立数据分区；保存实际字节；板端SDK与后端架构检查；数值通过后才报告设备/端到端性能。追问：K/V为何用不同统计轴？min和zero-point有什么区别？残留如何改变真实容量？解包attention为何不能证明2位性能？旧PyTorch为何不能只改环境变量部署Thor？何时应保留FP16旁路？
