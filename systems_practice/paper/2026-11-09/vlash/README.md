# VLASH: Real-Time VLAs via Future-State-Aware Asynchronous Inference

首次2025-11-30；阅读v1，当前修订2026-07-26 v2，读取2026-11-09。[一手全文](https://arxiv.org/html/2512.01031v1) · [版本历史](https://arxiv.org/abs/2512.01031) · [Han Lab项目与作者单位](https://hanlab.mit.edu/projects/vlash) · [官方仓库](https://github.com/mit-han-lab/vlash)。论文作者含Song Han及MIT成员；完整署名见项目/原文，符合Han Lab规则。

问题是推理开始状态与动作执行状态错位。核心：用已知旧action chunk滚动到执行时刻，训练时同步偏移state/action但保留当前图像。公式s(t+Δ)=roll(s(t),a[t:t+Δ])；未知未来环境仍无法由此恢复。读v1 §3–5、表1；π0.5/LIBERO/笔记本RTX4090/延迟3步时作者报告1.47倍速度、成功率94.6%，同步为96.8%，存在精度代价。实验数字固定v1；v2摘要已修订反应速度数字，不能混用。Han Lab列表标IROS2026，本文阅读的是arXiv v1。

独立例只验证一维状态rollout、5个offset样本对和超出已知chunk拒绝；training_steps=0，无真实微调。额外扰动反例保留误差，说明开环状态估计不是闭环控制保证。动作时间聚合与低位权重量化不同。

复现难：需要VLA权重、机器人轨迹、匹配控制周期和LIBERO或真实机器人；先检查offset数据与执行队列时间戳，再微调和固定回放验收。失效链：只偏移action不偏移state→监督错位；推理延迟超chunk→未来状态未知→拒绝/重新规划，不能索引越界。追问：图像为何不偏移？状态rollout依赖什么？未知扰动如何处理？推理延迟与控制步怎样换算？

运行：本目录`sh run.sh`。Python标准库；results保留输出。源码获取/阅读与运行状态见source.json、verification.json；作者全仓训练/评估完整性尚未审计，不把仓库存在当全流程可复现。无ncu/PTX/SASS结果，今后CUDA执行仅Thor SM110。

源码补充：2026-11-09实际阅读main分支`vlash/run.py`的VLASHAsyncManager.get_action, launch_next_inference, should_launch_next_inference，许可Apache-2.0 file header。只读相关入口，不代表全仓审计。Mac与Thor独立CPU例均通过，见results/host.txt、thor.txt。

代码迁移注意：作者run.py的launch_next_inference采用当前chunk最后一个action作为未来observation.state，这条实现依赖动作代表目标状态的合同；本例用增量求和，是另一种动作合同，不能直接互换。get_action在chunk切换时把待取张量转到CPU，实际同步成本仍需测。
