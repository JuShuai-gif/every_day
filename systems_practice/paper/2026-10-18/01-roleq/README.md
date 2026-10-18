# RoleQ：把scale放在功能单位上

Johannes Knittel、Alec Helbling、Hanspeter Pfister；[arXiv:2610.21808v1](https://arxiv.org/abs/2610.21808v1)，首次/本版本2026-10-15。预印本，未核实会议录用。实际读[全文](https://arxiv.org/html/2610.21808v1)§3.1–3.5、§4.1及相关位宽说明；作者仓库检索没有取得可验证实现，不把arXiv页面GitHub纠错入口当代码仓库。

## 问题、步骤与作者结果

在[out,in]布局，reader按行、writer按列放scale；三值向量先按绝对值排序，对每个前缀求`(sum |w|)^2 / count`，最大前缀决定support，scale为其平均幅值。作者管线还包含旋转、GPTQ、冻结码后scale蒸馏，以及可选Fisher选择的第二三值平面；“轴规则不需数据”不等于整条管线无需校准。

作者§4.1报告Qwen3-8B-Base经scale蒸馏，1.590驻留信息bpw时MMLU47.6；加稀疏平面到2.157bpw为62.8，FP为76.8。这是作者特定模型/数据/评估结果，不是本机输出，也不是任意文件压缩比或Thor速度。

## 独立现成例子

```sh
sh systems_practice/paper/2026-10-18/01-roleq/run.sh
```

Python3.9标准库，W为4×4 FP64列表。`fit`用prefix公式，另用3^3暴力枚举核对3组小向量（含全零/相同幅值），不是拿同一实现自证。结构化writer矩阵按列量化MSE=.63125、按行24.8875；矩阵转置后优劣反转。两者实际文件均44B，包含8B头、32B FP64 scales、4B三值码；5个ternary码装1字节且重载核对。小矩阵metadata比码还大，不能声称已经达到1.59文件bpw。

例子只验证单向量拟合、轴与存储；没有激活、Hessian、旋转、梯度训练/蒸馏或Fisher估计，也没有任务精度。所有输入是构造示例，不用评估集选模型配置。结果见[results/run.txt](results/run.txt)，范围见[verification.json](verification.json)。

## 复现路线、故障与取舍

难度：小公式易，完整复现难。需要经作者确认的代码、模型checkpoint、C4/蒸馏数据、评估工具与足够设备资源；先逐层检查旋转等价、再固定码/scale、最后用独立任务集评估。今天没有安装/下载，原生依赖版本、训练/导出完整性均待核实。涉及CUDA时只使用Thor SM110；论文作者A100结果只作引用。

故障链一：更低权重误差却任务退化→局部欧氏目标忽略激活/知识敏感性→逐层输出和独立任务分开比较→不可据小例子选scale轴上线。故障链二：宣传位宽很低但文件超预算→遗漏scale/header/尾部→实际write/stat和重载→选择真实部署预算；不能用log2(3)替代物理存储。

追问：reader/writer轴如何从[out,in]看出？prefix搜索为何能处理support？相同幅值和全零怎么办？三值理论信息量与5码1B有什么区别？权重误差为何不能代替MMLU？第二平面的索引和scale怎样计费？

源码/作者实现未获取，论文方法只作为独立数学实现依据；[source.json](source.json)保存检索和阅读边界。
