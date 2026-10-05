# FlexPosit：硬件窗口对齐的混合精度

## 一手出处与实际阅读

Yimin Gao、Liangtao Dai、Jun Yin、Xinfei Guo、Mircea Stan，arXiv:2609.04724，首次2026-09-04，最新v2为09-13；本次读[HTML v1全文中的II/IV/V和VI表II](https://arxiv.org/html/2609.04724v1)，没有把v1当v2。arXiv元数据标注MICRO2026接受；未另外核查会议程序。

[作者仓库](https://github.com/hplp/FlexPosit_artifact)main于2026-10-05可读目录/README、sensitivity列表，显示量化、硬件与预计算敏感度CSV。tag v1.1、quantization目录、02_headline_ppl.sh具体正文多次Cache miss，**没有读到算法实现**；目录存在不证明完整复现。仓库显示MIT，LICENSE正文仍未核实；不复制上游代码。详情[source.json](source.json)。

## 核心机制与作者结果

作者将权重量化为Posit，激活保留FP16，逐通道搜索2幂scale以提高SQNR，再按硬件列窗口测量增加位宽的PPL收益，分配平均位宽预算。相同窗口保持一致精度，位串行阵列按精度调整周期；“4.1bit”是模型平均位宽，不是每权重有0.1个物理bit。v1表II的LLaMA-2-7B WikiText2：FP16 PPL5.47，固定Posit(4,1)6.51，4.1bit6.00；恢复有限，并未达到FP16。其专用阵列结论不能外推Thor GPU。[原文方法与表II](https://arxiv.org/html/2609.04724v1#S4)。

## 已运行的独立例子

[example.py](example.py)从正Posit码字解析regime/exponent/fraction，再对称得到有限值集，排除NaR。明确固定es=1，在4/5bit数值集合上最近值量化，搜索−4～4的2幂scale；四个等大窗口各4元素，只允许一个窗口升级。采用合成平方误差替代作者全模型PPL，因此最优解只对这个小问题成立。没有SerialPosit打包或硬件仿真，68bit只是理论payload，metadata未计入，输出明确packed_export=false。

```sh
sh systems_practice/paper/2026-10-05/01-flexposit/run.sh
```

Python3.9标准库，无安装/下载。[实际输出](results/cpu.txt)：预算4.25bit升级第4窗口，校准平方误差0.205873；冻结scale/config后第3窗口分布放大40倍，误差4.211434。该反例说明分布变化要重新验收，未使用评估数据挑选配置。固定码本手算1的编码、预算数量和误差单调边界通过。零值在码本内，NaR不作为正常量化输出。

## 复现难度、失败与迁移

小实验易（秒级本机运行），作者全模型/硬件复现难：需要读取固定commit的量化代码、torch/模型数据、敏感度重计算、专用阵列仿真/综合工具与工艺条件；本期没有这些证据。最小路线先在小已存在本地模型核对scale/码本/窗口，再对独立eval算PPL，最后复现硬件统计；不执行README安装脚本，不自动下载模型。没有提供猜测的原生API。

故障链1：平均位宽达标但tile耗时不降→混合精度不符合运行后端窗口→核对实际分块与打包→重分组或保留统一精度，代价为误差/空间。故障链2：校准误差低、线上变差→scale与窗口敏感度依赖分布→冻结配置跑偏移集定位→扩校准覆盖并保留独立评估，不能只追训练误差。

追问：平均bit如何落到字节？为什么窗口需硬件对齐？SQNR最优一定等于PPL最优吗？2幂scale节省什么又损失什么？算法精度与ASIC吞吐如何分别复现？NaR应如何处理？

[verification.json](verification.json)：原文选段已读、作者实现未读、独立CPU例子通过、完整复现/Thor/设备性能未验。
