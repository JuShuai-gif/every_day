# 2026-10-19 SmoothQuant：共享 LayerNorm 的一致缩放与真实 INT8 导出

## 方法与应用场景

第二轮聚焦fan-out：一个LayerNorm后接两个Linear，输入FP32 `[B,32]`，权重分别 `[24,32]`、`[16,32]`，合并输出 `[B,40]`。真实模型中对应Q/K/V共享Norm；只平滑一个消费者会破坏其他分支。上一期SpQR保留稀疏异常；本期把激活难度迁移到权重，额外成本是校准与alpha选择。

SmoothQuant是PTQ缩放算法；W8A8是本例整数位宽方案，signed INT8并不是FP8；QAT是训练范式，本例没有任何训练更新。对输入通道j取 `s_j=max_cal|a_j|^alpha / max_all_consumers|w_:j|^(1-alpha)`；将Norm的gamma/beta除s，所有消费者权重列乘s。Linear的bias保持不变。先检查未量化等价，再做每输出行权重/每token激活absmax、round至[-127,127]。原生fake-quant保存浮点并用FP32 F.linear，**没有真实int32累加或原生INT8 Tensor Core执行**。

## 原仓库与实际读过的实现

[mit-han-lab/smoothquant](https://github.com/mit-han-lab/smoothquant)，实际浅克隆解析commit `c61476d728e42ae0d8a35e7e78494edcac3237b5`；blob拉取TLS/超时失败，随后GitHub连接器按相同commit取得源码快照。MIT License，读取2026-10-19。[初次DNS](source-initial.json)、[浅克隆与blob失败](source.json)、[成功快照](source-recovery.json)均保留；并非整仓checkout成功。

- [smooth.py](https://github.com/mit-han-lab/smoothquant/blob/c61476d728e42ae0d8a35e7e78494edcac3237b5/smoothquant/smooth.py)：`smooth_ln_fcs`，以及`smooth_lm`中OPT/QKV、Llama gate/up的调用位置。
- [fake_quant.py](https://github.com/mit-han-lab/smoothquant/blob/c61476d728e42ae0d8a35e7e78494edcac3237b5/smoothquant/fake_quant.py)：`quantize_weight_per_channel_absmax`、`quantize_activation_per_token_absmax`、`W8A8Linear.from_float/forward`。
- README安装/用法段、setup.py和LICENSE。setup.py没有固定依赖，README给torch1.12.1+cu113、transformers4.36.0；旧CUDA wheel不适用于Thor，不能原样照抄。

调用链：校准Norm输出→共享fc列表计算s→原地更新Norm和所有权重→`from_float`对权重原地QDQ→`forward`对输入原地QDQ→浮点linear。本课原样调用上述API；数据拆分、导出/重载、误差与时间编排独立编写，不能叫上游原生压缩格式。

## 如何接入我的代码

[完整example.py](example.py)、[run.sh](run.sh)。本机Python3.9.6，torch缺失；原生API静态核对完成，依赖组合未运行验证。推荐先在已有CPU PyTorch环境中准备transformers4.36.0（导入smooth.py即需多个模型类），记录实际torch/transformers版本；不自动安装。旧torch README版本仅为上游记录，不保证适配当前Python或Thor。

从项目根运行：

```sh
sh systems_practice/quantization/2026-10-19/smoothquant/run.sh
# 若归档迁移后缓存不存在，先拉固定源码；所有文件仍在systems_practice
GIT_LFS_SKIP_SMUDGE=1 git clone --depth=1 --filter=blob:none --no-checkout https://github.com/mit-han-lab/smoothquant.git systems_practice/.tmp/quant_sources/smoothquant-manual
# 在该缓存仓库fetch固定commit并checkout少量文本，不获取模型
# 源码就绪后指定SMOOTHQUANT_SOURCE为包含smoothquant/的仓库根
SMOOTHQUANT_SOURCE="$PWD/systems_practice/.tmp/quant_sources/smoothquant-manual" sh systems_practice/quantization/2026-10-19/smoothquant/run.sh
```

固定commit准备的完整步骤见[prepare_source.sh](prepare_source.sh)，只读取少量文本、不安装。默认run.sh使用本次源码快照缓存；快照中不包含大模型，未提交到Git。

校准64随机行，调参32行独立选择alpha∈{0,.5,.8,1}，评估31行与漂移31行只报告不选择参数；Norm第0通道gamma=32制造固定激活幅度问题，漂移将输入第7列放大12倍。零输入和非法scale长度单独检查。更换已有Linear时，将ln/fcs替换为真实模块的副本，校准数据换为经过同一Norm的真实特征，所有共享消费者一起传入；没有可折叠Norm时不能直接套本例。

`from_float`会修改权重；`forward`会修改输入。示例深拷贝参数、各fan-out分支clone输入，保证FP32 oracle不被量化污染。输出写入忽略的build/weights.bin：little-endian SQ81头、K/分支数、FP32 Norm gamma/beta、每分支N、真实signed i8权重、逐行FP32 scale及FP32 bias。重载重新构建浮点QDQ层并核对输出；这是透明教学格式，不是torch-int checkpoint。序列化解析仅针对程序自身导出，不用于不可信外部模型文件。

## 量化前后比较

程序准备FP32、真实FP16算术参考、absmax、SmoothQuant；报告NRMSE/max_abs/cosine、权重端点占比、实际文件长度与i8 payload。端点占比不等同溢出裁剪率：absmax本身把最大值映射到端点。计时为CPU单线程LayerNorm+clone+QDQ+浮点Linear，3预热、11×20调用批均值P50；不含校准/导出，非INT8 kernel时间。离线搜索耗时另计。

| 项目 | 本次状态 |
| --- | --- |
| 校准/alpha选择/等价性/误差 | 代码齐全，缺torch未执行 |
| 真i8文件/metadata/重载 | 代码齐全，未生成产物，字节数未测 |
| CPU framework时间 | 未测 |
| GPU/NPU/E2E/模型任务精度 | 未验证 |

保留不如absmax的可能，alpha不应按评估集调优，也不能声称0或1是任何模型上的最优端点。

## Thor SM110 与优化

今日示例仅CPU算法/API验证，不新增CUDA kernel。[NVCC13.0目标列表](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-compiler-driver-nvcc/index.html)与[NVIDIA版本说明](https://docs.nvidia.com/cuda/cusolverdx/0.2.1/release_notes.html)确认CUDA13采用Thor sm_110命名；JetPack/L4T/驱动/ncu的实际板端组合仍未知。旧的CUDA11.3 wheel不是Thor验证依据。

另实际读[torch-int setup.py](https://github.com/Guangxuan-Xiao/torch-int/blob/main/setup.py)，2026-10-19 main：构建时查询GPU、使用C++14、链接路径含x86_64；因此不能声称它直接支持Thor ARM64/C++17。尚未审完kernel及依赖，不执行该扩展构建。迁移须先在忽略缓存修正平台链接和C++17、确认PyTorch支持11.0 arch，然后固定 `TORCH_CUDA_ARCH_LIST=11.0` / `CMAKE_CUDA_ARCHITECTURES=110`，实际nvcc只允许 `-arch=sm_110`，禁止专属后缀。只设环境变量不会自动修复旧代码。

目标验收先收集 `/etc/nv_tegra_release`、`nvcc --version`、`ncu --version`、PyTorch架构列表、设备capability=(11,0)与库依赖；再对原生导出格式做数值回归和同步计时。今日无新GPU内核、无PTX/SASS、无GPU性能；之前[Thor四位宽候选与ncu教程](../../../daily/2026-10-14/README.md)只是独立内核参考，**不能直接读本SQ81格式**，要先写明确adapter且重新验收。GPU比较游标仍Hopper（下次Ada）。

## 故障、迁移与追问

1. 平滑后只有某个分支精度变差→遗漏共享Norm消费者或bias处理错误→量化前逐分支检查等价→传入完整fc集合，Norm gamma/beta同时缩放；代价是共享s受所有消费者约束。
2. 基线误差随调用次序变化→上游原地QDQ污染输入/权重→保留副本，比较调用前后tensor→每分支clone或重新设计只读适配；clone成本要留在框架计时。
3. 文件变小但推理没有快→重载还原FP32、执行fake quant→检查实际dtype/算子和真实字节→接真实整数后端后再测，不能拿文件比值当速度比。

验收：先未量化等价，再QDQ/导出重载，最后不同数据分布与后端性能；每一步失败保留原日志。追问：共享Norm为什么要联合统计权重？Linear bias为什么不乘s？每token与每通道scale能否互换？fake quant为何未必省内存？alpha调参与评估怎样分离？原地API怎样破坏公平对照？

## 验证与待补

[verification.json](verification.json)：获取是（固定commit源码快照）/阅读是/示例是/CPU运行否/Thor否。缺torch原始日志在[results/native-attempt.txt](results/native-attempt.txt)。AST与shell语法通过只表示静态检查，不升级运行状态。旧LLM.int8只重试一次源码拉取，DNS失败；保留获取记录，不推进其游标。下一方法LLM.int8。
