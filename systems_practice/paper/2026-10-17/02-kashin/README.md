# Structured Transforms for Low-Overhead Quantization of Language Models

作者：Daria Cherniuk, Alexander Rudikov, Boris Kashin, Ivan Oseledets。arXiv:2609.11687v1，首次与本次版本日期2026-09-10；元数据以[arXiv记录](https://arxiv.org/abs/2609.11687)为准，不由编号猜月份。近期180天内，未核实会议接收，按预印本记录。2026-10-17实际阅读[一手全文](https://arxiv.org/html/2609.11687v1)的§3–4、Algorithm1、§5及limitations。

## 方法及作者结果

论文用P=IDCT·diag(ε)·DCT和x≈u+P v，在两组坐标交替贪心更新，每个因子再2-bit编码。作者在单H100、固定校准集与三seed协议下比较PTQ；对照QuIP#关闭了微调及向量码本，因此不能把结论当作击败完整QuIP#。 [原文](https://arxiv.org/html/2609.11687v1)

## 独立现成示例

本例用32维稠密DCT直接校验P²=I，16块×4步贪心残差从5.32662降至1.95e-14。自写Lloyd后处理替代作者闭式初始化，最终双2bit因子NRMSE0.14564，uniform4为0.11295，明确退化。60B实际文件含44B metadata及16B编码，FP16纯payload64B；分解精确不代表低位编码准确。

代码[example.py](example.py)，标准库Python3.9.6，工作目录为本课，运行 `sh run.sh`，真实输出[results/cpu.txt](results/cpu.txt)。文件仅写build忽略目录，不提交二进制。没有训练更新；这是确定性数值/打包实验，不冒称训练方法或原生作者API。没有性能计时、LLM任务精度或GPU/NPU结果。

## 复现路线与难度

完整复现难：作者仓库未核实，需先取得与论文一致的量化/评估实现，再准备自有模型与固定校准/评估数据、框架/库版本和目标硬件。先用小张量独立oracle验证格式和重建，再对同权重同输入做误差、真实存储和全路径计时，最后才运行LLM评估。本次未安装依赖或下载权重。原文全文GitHub链接及标题+GitHub检索未找到可确认作者代码，不把第三方摘要视为源码阅读。

本示例仅需标准库，预计分钟级可观察机制；作者模型所需显存/耗时未估计。若移植任何CUDA执行，只能Thor sm_110，原平台作者结果不能外推。源码获取/全文阅读/独立运行/作者复现分别记录在[verification.json](verification.json)。

## 工业排障与迁移

1. 变换后重建不等价：查DCT归一化和转置，用P²=I及x-u-Pv-r恒等式区分；先修变换再调量化，不用更多迭代掩盖。

2. 残差收敛但量化恶化：分开分解残差和因子编码误差；检查码本/centroid、metadata和在线变换成本，必要时回滚uniform4。

迁移验收：固定格式和元数据字节序、零值与负值、尾部、累加范围、独立评估数据、序列化重载、任务精度和设备/E2E计时；不达标保留基线。

追问：①原始表示与压缩编码的误差分别在哪产生？②metadata怎样改变小矩阵成本？③为什么数学重建成立仍可能部署退化？④如何设计独立oracle？⑤作者对照条件与本例省略项有什么区别？⑥何时选择回滚基线？
