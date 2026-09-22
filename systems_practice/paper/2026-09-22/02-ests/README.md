# ESTS at WMT26: Routing-Informed Expert Pruning for Model Compression

[arXiv元数据](https://arxiv.org/abs/2609.12310) · [v1全文](https://arxiv.org/html/2609.12310v1) · [作者仓库](https://github.com/oceanusm/wmt26-ests-model-compression)

作者 Liu O. Martin、Lucas Bandarkar、Nanyun Peng。首次提交与所读v1日期均为 **2026-09-11**。arXiv comments 写明将发表于 WMT2026 proceedings，未另行核实正式出版页。阅读 §2–3、Table2、§5–6、附录A/B；归档按 `arxiv:2609.12310` 去重。

## 问题、核心思想和结果边界

MoE压缩需要决定每层保留多少专家。论文以目标任务路由质量排序，以跨语言路由分布的 JS 散度分配层容量；约束 `K≤c_l≤E`、`sum(c_l)=L(E-k)`，封顶再分配后用 Hamilton 取整，同时裁剪专家与路由参数。随后恢复训练及 MXFP4 导出。中文k26模型报告5.38B参数、5.15GiB混合精度文件；参照20.91B、38.96GiB是BF16，不是同格式纯剪枝比。每 token仍激活4专家，存储减少不能证明解码提速；内部评估使用合成参考，存在偏差。[全文与限制](https://arxiv.org/html/2609.12310v1)

## 开源范围核对

通过作者 [模型卡](https://huggingface.co/oceanusm/ests-gptoss-zho-k26)定位仓库，实际检查 `submissions/ests-gptoss-zho-k26/`：README、inference.py、pruned_gptoss.py、prepare_model.py、setup/run、JSON/robust inference 文件存在。阅读的 [prepare_model.py](https://github.com/oceanusm/wmt26-ests-model-compression/blob/cff2c9fd3d63942b267df9b6be39cb42f90999c9/submissions/ests-gptoss-zho-k26/prepare_model.py) 在真实 commit `cff2c9fd3d63942b267df9b6be39cb42f90999c9` 中：`resolve_model_source` 找本地路径/缓存或 snapshot_download；`expose_model` 复制/软链并防止覆盖。它准备既有检查点，不做剪枝训练。本次未核实完整 routing校准、剪枝和恢复SFT源码，不能把推理发布当成全算法开源。

提交 README 标注 vLLM0.11.1、TP1、1GiB固定KV cache；这是作者运行配置，不代表 Thor 可直接运行。未执行其 setup（会建环境并下载模型），未下载检查点。根仓库显示MIT，模型卡标Apache2.0；使用具体资源前分别核查，不合并为一种许可。

## 最小复现路线与难度

完整复现**难**：真实 GPT-OSS 检查点、路由采样数据、恢复SFT数据/训练，以及自定义可变容量MoE/MXFP4后端均需对齐。先验证容量预算/专家重映射，再用现有小MoE取得真实校准路由，最后在独立任务测试集评估；不能用代码生成器代替缺失的作者训练脚本。官方评测平台说明使用H100，这是背景，本期不提供H100执行命令；任何未来CUDA移植仍固定Thor SM110，并先查自定义vLLM后端支持。

## 简单可运行例子

[src/example.cpp](src/example.cpp) 是根据论文数学机制编写的**独立标准库实验**。3层、每层6专家、top2，总预算12；输入是人工路由分布、2维随机专家与路由权重。实现JS、封顶再分配、Hamilton取整、专家/路由同步切片，用独立64个2维输入比较输出误差。全零JS时均分是教学补充规则；无恢复训练、无MXFP4、没有语言模型或任务评分。

```bash
sh systems_practice/paper/2026-09-22/02-ests/run.sh
```

C++17 程序实际通过52组预算/饱和/零分歧检查、2个非法预算、JS两端、重映射与字节长度。无新增作业。

## 真实结果与验证边界

[原始输出](results/cpp-output.json)：容量 `[4,2,6]`；真实 FP32专家和router payload `288→192 B`（不含配置/元数据，不是论文文件格式）；每 token激活数 `[2,2]`；合成输出 MSE `0.18045482`。保留误差，不假装剪枝无损；未进行训练恢复。没有实测速度、GPU/NPU、峰值内存或功耗。阅读/运行分开记录于 [source.json](source.json) 和 [verification.json](verification.json)。

## C++ 迁移与历史结果

2026-09-22 已将 CPU 计算与物理存储实现迁到 C++17；`run.sh` 用 CMake 编译运行，需本机 C++17 编译器与 CMake。源码有中文关键注释；公共二进制/FP16工具见 [lesson.hpp](../../../common/cpp/lesson.hpp)。默认 Release；`SANITIZE=ON sh run.sh` 开启 ASan/UBSan（从本课目录运行）。Mac arm64 的两种构建均通过；RK3588/Jetson 尚未实测。

当前输出见 [cpp-output.json](results/cpp-output.json)，内存安全检查见 [cpp-sanitize.json](results/cpp-sanitize.json)。随机样本改用固定种子的 C++ MT19937 与显式 Box–Muller，分布/分区含义保留，但不与 Python 随机序列逐值相同；新误差不可当作跨语言速度或精度提升。旧 [output.json](results/output.json) 和 [原验证记录](results/verification-python-historical.json) 保留为历史证据，不能代表新实现。
