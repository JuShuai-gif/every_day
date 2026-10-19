# VLM结构剪枝：评分盲点与恢复训练

## 论文与实际阅读

**Structural Pruning of Large Vision Language Models: A Comprehensive Study on Pruning Dynamics, Recovery, and Data Efficiency**；Yiran Huang、Lukas Thede、Massimiliano Mancini、Wenjia Xu、Zeynep Akata。[arXiv:2604.24380v1](https://arxiv.org/abs/2604.24380)，本条目首发/读取版本均2026-04-27，距本课175天。作者页面标注IJCV2026接收，未独立查期刊刊载；仓库说明它扩展GCPR2025工作（2507.20749），因此不把2026扩展版称为整个方法的首次公开。

实际读[一手全文](https://arxiv.org/html/2604.24380v1)§3.1剪枝、§3.2恢复及§4.1–4.2/Table2选段。深度剪枝用BI=1−平均cos(H_i,H_{i+1})，宽度剪枝按依赖组与Taylor重要性联合删除，恢复比较SFT、logits与hidden-state distillation。Table2中LLaVA7B在15%剪枝、未恢复条件下，宽度方案保留90.87%平均相对性能，层方案72.22%；这是作者模型/基准结果，不是本例精度或通用结论。高剪枝率可严重退化，不能只引用低比例成功结果。

## 作者代码与关系

实际读[YiranHuangIrene/VLMCompression](https://github.com/YiranHuangIrene/VLMCompression) README、LICENSE与[ShortGPT/short_gpt/short_vlm.py](https://github.com/YiranHuangIrene/VLMCompression/blob/main/ShortGPT/short_gpt/short_vlm.py)，2026-10-19 main，精确blob见[source.json](source.json)，commit未固定。`ShortVLM.eval_importance→compute_bi`读取模型hidden_states并调用`block_influence`；`remove_layers`按重要性排序，倒序del避免索引漂移。`metrics.py`尚未读取，不假称已审完整评分实现。根Apache-2.0，子项目有独立许可证；未复制源码。

仓库README提供剪枝/恢复入口，但本次未审完宽度依赖图、训练/导出/评估链，不把仓库存在视为全流程可复现。示例是独立两维机制实验，不调用作者API，不实现VLM、自动微分或宽度剪枝。

## 机制与可运行示例

[example.py](example.py)构造teacher：输入x→2I缩放块→B旋转/混合块。第一块将向量乘2而方向不变，因此BI近0，但删去它会改变输出幅度。这说明cosine变化小不是“删后输出相同”的充分条件。

删层后student保留B，projector P从I开始，真实执行200步梯度下降：`loss=mean(||B P x−teacher(x)||²)/2`，`grad_P=B^T e x^T`。校准32、训练64、评估31行互不重用；固定学习率0.2/200步，不用评估选参数。这里只演示projector能够修复一个可逆线性失配；无法据此推断深非线性VLM在高压缩下也能恢复。

```sh
sh systems_practice/paper/2026-10-19/01-vlm-pruning/run.sh
```

Python3.9标准库，无额外依赖。真实[输出](results/cpu.txt)：BI约0/0.01059，删除第0块；评估MSE从0.4423539降至6.1912e-11；参数确实更新，日志给第1/10/50/200步训练loss；零范数输入明确拒绝。没有任务准确率或性能测量，也没有量化存储收益声明。

## 复现路线、故障与边界

完整作者复现难度**难**：需要PyTorch/transformers、对应3B–7B模型、原视觉指令训练集、训练加速环境与lmms-eval；资源耗时未在本机估计。最小路线：固定commit/依赖→本地已有模型少量校准→只删少量层→核对hidden_states→projector恢复→独立任务评估→保存/重载与设备回归。不自动执行下载。任何后续CUDA构建只能Thor sm_110，旧第三方扩展需单独核验。

故障链一：BI低却输出明显改变→评分只看方向→用x与2x反例/逐层重建误差核对→增加输出/任务验收；代价是额外评估。故障链二：删除多层后删错位置→正序索引漂移→打印原层ID→倒序删除并重载校验；真实模型还需修复config/cache依赖，不能只删ModuleList。

追问：cosine遗漏了什么？为什么层剪枝与宽度剪枝的依赖合同不同？projector恢复在哪些失配下无能为力？校准/恢复/评估为什么要分开？怎样核对删除前后KV cache层编号？

[verification.json](verification.json)：论文选段/作者选定实现已读，独立CPU实验已跑；作者原生训练/导出/完整模型与Thor未验证。
