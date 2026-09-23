# Quantization-Aware Healing: A Practical Recipe for Recovering Compressed, 4-Bit LLMs

Bakbergen Ryskulov、Iker García-Ferrero、David Montero、David Jansen、Ali Hashemi、Jezabel R. Garcia、Antonio Tiene、Román Orús。[arXiv:2608.20953v1](https://arxiv.org/abs/2608.20953)，首次/所读版本2026-08-21，预印本，未核实同行评审发表。2026-09-23阅读[一手全文](https://arxiv.org/html/2608.20953v1)§3方法、§4设置、§5结果、§6部署经验和§7局限。

## 核心思想与证据

结构压缩和4位量化叠加后，用原始未压缩模型的输出分布恢复学生。损失为`KL(softmax(z_teacher/τ) || softmax(z_student_QDQ/τ))`；教师冻结，学生通过STE更新，论文τ=1，使用离线top100教师logits。这里“原始”强调结构容量，教师本身也大量使用MXFP4。作者图3在20B→9B设置报告QAH约100步达到54.9、QAT约700步达到54.6（三基准均值），不是7倍GPU延迟收益。论文没有同配置“原始教师 vs 恢复后BF16教师”直接实验，且单次运行缺少方差，不能据此断言教师选择必然占优。[方法与局限](https://arxiv.org/html/2608.20953v1)

## 复现难度与来源可用性

完整复现**难**：需大教师/学生、恢复语料、量化训练栈及可支持其格式的训练硬件；本机无torch与CUDA设备。作者公开[Hypernova-60B模型页](https://huggingface.co/MultiverseComputingCAI/Hypernova-60B-2605)，但本次论文和作者模型页未找到可核验的完整QAH训练/导出GitHub实现；搜索`"Quantization-Aware Healing" "github"`仅出现二手索引，未用其充当源码。开放权重不等于训练流程完整开源。

最小路线是先比较同一压缩小学生的原始教师、恢复教师和硬标签三种监督，保持步数与量化器一致，再补原生MXFP4、mask/next-token shift、导出后推理及多种子任务评估。实际大模型路线尚缺训练源码与精确依赖锁；不猜作者API。本课不提供未经核验的CUDA执行命令；未来目标只允许Thor SM110，原生训练后端支持需另验。

## 可运行的小例子

[example.py](example.py)是**独立Python标准库数学实验**，不是作者代码，也不是MXFP4实现。使用固定随机种子、FP64 Python算术、INT4对称fake-quant、冻结scale和范围内STE：教师24参数，删除两个输入通道后学生16参数，先80步全精度恢复，再各150步量化更新。训练/验证/测试37/19/41样本分离；没有用验证/测试选步数或scale，没有伪称压缩字节或低位内核速度。运行无需torch：

```sh
./systems_practice/paper/2026-09-23/01-qah/run.sh
```

本机Python3.9.6实际输出见[output.json](results/output.json)。测试KL从0.281198变为：原始教师0.276428、恢复教师0.273291、硬标签0.349741。**此玩具例子恢复教师更好**，不支持“原始教师必胜”；保留结果而不换seed追求预期趋势。三条分支最大参数变化分别0.045614、0.044899、0.504317，确实执行更新。chunk7与dense41的KL差≤1.12e-16，验证尾chunk按样本数加权，不声称bit-identical。

首次运行硬标签的0概率触发`log(0)`；已按`0 log0=0`跳过零项并补边界检查，[原始失败](results/initial-attempt.txt)保留。这里没有真正next-token序列、mask、top-k教师缓存、MXFP4导出或完整LLM质量复现；也没测GPU/NPU/端到端性能。来源/状态见[source.json](source.json)、[verification.json](verification.json)。
