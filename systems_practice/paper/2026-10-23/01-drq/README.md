# DRQ：较低重建误差为什么仍可能更差

原文：[arXiv:2610.11226v1](https://arxiv.org/html/2610.11226v1)，标题 **When Lower Reconstruction Loss Hurts: Distributionally Robust Refinement for Low-Bit LLM Quantization**。作者Yanlong Zhao、Xiaoyuan Cheng、Huihang Liu、Baihua He、Xinyu Zhang、Harrison Bo Hua Zhu、Wenlong Chen、Li Zeng、Zhuo Sun。首发/读取版本2026-10-08 v1，未确认会议录用，按预印本处理。2026-10-23实际读§2、§3.2–3.3/算法、§4.1–4.5/Table1及参数敏感性选段，未声称逐页读完附录证明。论文CC BY4.0；全文和精确标题GitHub检索没有确认作者实现，代码许可不推测。[source.json](source.json)保留阅读范围。

## 机制与作者结果

固定bit/group/scale/zero-point，只改整数码。记E为量化误差、H为校准激活二阶矩，原重建损失tr(EHEᵀ)；鲁棒目标加上α·max_{uᵀCu=1}||Eu||²，C=(1−β)H+βI。作者按最坏方向提出码更新，再重新评价目标，并在独立检查子集限制重建损失增幅。不是改变kernel或增加在线计算。

Table1的Llama-3.1-70B GPTQ W2，作者报告C4 PPL31.77→27.11、七任务均值48.23%→54.56%；实验采用group128、校准与调参分离、A80080GB。这是作者结果，不是本机或Thor测量。二阶矩扰动模型不能覆盖全部任务变化，单层目标改善不等于任务准确率保证。

## 独立现成例子

[example.py](example.py)用Python标准库、两个输入维度、一个输出，C=I、固定2位网格0..3、scale1、零点0，穷举16种码。cal为同向输入，tune为反向输入，eval为独立随机输入，另保留反向偏移。α仅在tune上选，不用eval调参。它没有实现作者大模型逐块/幂迭代/候选筛选及重建增幅保护，故不是完整DRQ，尤其α=64是演示强鲁棒惩罚的合成设置。

```sh
sh systems_practice/paper/2026-10-23/01-drq/run.sh
```

真实结果见[results/run.txt](results/run.txt)：重建最优码(0,1)，鲁棒目标选(0,0)。cal损失0.0004→0.9604，普通eval 0.31062→0.36471退化，反向shift 0.79383→0；鲁棒目标32.0132→31.6932。两码真实打包1B，scale4B、zero1B，总文件6B，超过FP16权重载荷4B；存储退化也保留。未测时间、没有Tensor Core或GPU/NPU/E2E指标。

## 复现难度、故障与迁移

完整复现难：需要作者实现、原PTQ输出/格式、Llama/Qwen许可与权重、校准数据、模型级PPL/任务评估和大型显存设备；精确依赖未随可验证作者仓库确认。最小路线先固定一层及网格，核对二阶矩/特征值，再实现检查子集保护，最后接已有本地模型，不能下载大模型凑数。本次仅独立CPU例可复现，Thor后端未验。

- cal变好但测试变差→激活子空间覆盖不足或代理目标失配：比较held-out二阶矩/任务指标与原网格，增补独立验证；不能根据一次PPL反向修改校准集。
- α过大→平均误差恶化：本例真实展示；保留PTQ和安全约束，用tune限定候选，若未过门槛回滚，不能把worst-case下降当无条件提升。

追问：EHEᵀ度量什么？为什么C须正定？固定网格为何不增加推理算子？最坏方向优化为何会损害平均误差？检查子集与测试集应如何分开？

[verification.json](verification.json)：独立例运行通过；作者源码、完整训练/评估和设备部署均未完成。
