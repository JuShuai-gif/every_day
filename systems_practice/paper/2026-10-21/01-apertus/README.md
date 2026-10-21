# Apertus：稀疏教师监督与量化代理梯度

## 论文、问题与结论

[Apertus LLM Family Expansion via Distillation and Quantization](https://arxiv.org/abs/2605.29128)，Andrei Panferov、Davit Melikidze、Martin Jaggi、Dan Alistarh，首发2026-05-27；本日读v1的方法/实验选段，元数据最新v2为2026-06-10。按arXiv预印本处理，不根据仓库关键字宣称已正式录用。场景是从已有大模型扩展小模型/低位版本，既有推理资源约束，又要减少语言能力损失。

机制一：教师只缓存top-k logits，降低存储/训练成本，但遗漏概率质量需要明确处理。机制二：量化感知蒸馏（QAD）前向使用量化权重，反向通过STE更新浮点主权重；冻结范围与恢复训练分别影响稳定性。阅读[全文v1](https://arxiv.org/html/2605.29128v1)§2.1稀疏logits、§3.1量化与norm fusion、图4及附录A/C.2；不是仅阅读摘要。

作者报告：QAD结合norm fusion后基础模型loss增加约0.1–0.2，instruction few-shot性能恢复约90–104%；这是作者数据集/模型/协议结果。Weight averaging对RTN、GPTQ和QAD作用不同，QAD收益很小而未采用，不能把所有技巧收益相加。这些结果不代表本机小例子的任务精度或吞吐。

## 已读代码、许可与调用链

作者仓库[swiss-ai/qat-suite](https://github.com/swiss-ai/qat-suite)，固定commit `40303358230f99953ba1b0402fe2d640f2caf26b`，2026-10-21通过GitHub读取选定文件，未克隆/运行整仓。树中未找到LICENSE，许可状态待确认；不复制上游实现进本课。

- [`pseudoqat_pkg/distill_loss.py`](https://github.com/swiss-ai/qat-suite/blob/40303358230f99953ba1b0402fe2d640f2caf26b/pseudoqat_pkg/distill_loss.py)：`_TeacherDistillLoss.forward/backward`，对齐稀疏教师概率与学生log概率的损失/梯度。
- [`pseudoquant.py`](https://github.com/swiss-ai/qat-suite/blob/40303358230f99953ba1b0402fe2d640f2caf26b/pseudoqat_pkg/pseudoquant.py)：`STE_FakeQuantize`前向QDQ、反向代理梯度；实际读30–80行。
- [`train_distill.py`](https://github.com/swiss-ai/qat-suite/blob/40303358230f99953ba1b0402fe2d640f2caf26b/pseudoqat_pkg/train_distill.py)：245–420行optimizer.step/zero_grad、校准与冻结、保存；`pyproject.toml`记录Python>=3.11、torch==2.10.0、vllm==0.19.0，其他依赖也需锁定。

调用链：教师稀疏输出 → 蒸馏loss → 量化模块STE → backward → optimizer.step → 校准状态冻结/权重保存。保留的是稀疏概率质量与真实训练更新；本地独立实现不用自定义autograd、分布式、LLM或作者训练器。

## 数学推导与现成例子

设教师top-k集合S、原概率t，学生全词表概率p，保留质量m=ΣS t<1。L=−ΣS t log p；对学生logits梯度为 **m·p−t_S**。若写p−t_S，梯度和变为1−m而非0，已经改变目标；若把t_S归一化则需相应说明目标变化。这里的m不是全训练数据的同一个常数。

`example.py`使用3类、2特征，训练64、评估31个固定不同seed样本。INT4前向固定scale0.125、对称码[-7,7]、最近偶数舍入，浮点主权重从零开始，160步固定学习率0.12的identity STE更新。格式是fake quant/QDQ，**没有INT4打包或低位kernel**；算法属训练式量化蒸馏示意，不能把“INT4数值”当成4bit文件。无校准或超参搜索，评估不用于训练与选步。

```sh
# EveryDay根；Python标准库，无依赖安装
sh systems_practice/paper/2026-10-21/01-apertus/run.sh
```

[真实结果](results/cpu.txt)：稀疏loss对logits有限差分通过；该检查**不证明STE等于离散量化函数的真实导数**。一个检查样本top2质量0.7525935；eval教师KL从0.1753812降为0.0375640，浮点主权重和QDQ权重均输出，证明有实际更新。学生由零初始化，未做预训练学生的压缩恢复；没有FP训练等预算对照，因此此下降不证明QAD优于普通蒸馏。无数据集精度、模型压缩比或GPU性能。

## 故障链与迁移验收

1. top-k目标不归一化却省略m → logits梯度有限差分失败/梯度和异常 → 明确损失定义，再对稀疏与稠密等价小输入检查；不能靠调学习率掩盖。
2. 只在导出时round、训练前向仍用浮点 → 训练loss很好而量化后退化 → 记录每步量化前向、主权重更新和固定范围；检查checkpoint重载后真正执行的量化格式。
3. 把STE当精确导数 → 在截断饱和区仍持续推权重 → 观察主权重与码值分离，按算法选择梯度裁剪/scale策略；本例identity STE没有这些生产保障。

迁移路线：先核对作者commit、许可、完整依赖与数据协议；再用小本地模型验证稀疏loss/FP对照、训练预算相等、导出重载与任务评估；最后在Thor核查低位后端。难度高，长训练、多模型与教师缓存不能由本例替代。未来CUDA及扩展只sm_110；本次未写/运行作者GPU路径，不下载权重。

追问：①top-k质量为何影响所有logit梯度？②归一化稀疏目标何时改变训练权重？③为什么有限差分不能证明STE正确？④范围冻结与norm融合何时生效？⑤怎么区分恢复训练收益与位宽效应？⑥QDQ checkpoint如何迁移到真实打包后端？

[source.json](source.json)与[verification.json](verification.json)区分全文阅读、作者代码阅读、本地实验和完整复现。
