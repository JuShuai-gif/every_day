# 每日量化方法：源码、使用示例与结果

每天在主知识点之外讲一个量化方法，独立于主方向轮换。主练习仍为一个 20～30 分钟编码任务；本栏目提供已写好的使用示例，不再添加第二份编码作业。主主题为量化 GEMM 时复用当日方法的材料。

**下一方法：HQQ。下一主主题为 ARM SIMD / NEON。** 2026-09-18已有 [真实量化 GEMM 对照实验](../2026-09-18/session-02/README.md)，它是独立实现，不是下列项目的 API 教程。

现在可从项目根目录运行已有实验（需要 CMake 与 C++17 编译器）：

```bash
sh systems_practice/2026-09-18/session-02/run.sh cpu
```

该命令生成四种位宽与五种方法的 20 组 CPU 比较；已有运行证据见 [结果表](../2026-09-18/session-02/results/comparison.md)。这不代表下列原项目已被安装或在 Thor 上验证。

## 每期你会拿到什么

1. 该方法解决什么问题、什么时候适用、有什么代价。
2. 原仓库的实际 commit、具体文件/函数及调用链，说明参数如何影响量化。
3. 可复制的使用命令和完整示例：准备小输入/本地模型 → 校准或训练 → 量化/导出 → 运行 → 检查结果。明确已有 Linear/模型应在哪一步接入。
4. 量化前后精度、真实存储和可实测性能的比较，保留失败或退化；区分 fake quant、压缩权重和实际执行 kernel。
5. 独立验证状态：源码获取、实现阅读、示例交付、CPU 运行、Thor 验证。所有 CUDA/PTX/SASS 均为 Thor SM110。

具体交付要求见 [主规范](../PRACTICE_SPEC.md) 与 [栏目模板](LESSON_TEMPLATE.md)。原项目不兼容 Thor 时必须说明；不因位宽相同就声称后端兼容。

## 初始轮换清单

下表中的地址和代码路径是**待拉取核实的候选**。本次网络无法访问 GitHub，尚未逐项核实仓库迁移、API 和当前 Thor 支持；每期获取真实 commit 后才能教授对应 API。目录路径保存在 [catalog.json](catalog.json)。

| 顺序 | 方法 / 专题 | 本期应选择的具体机制 | 候选源仓库 |
| --- | --- | --- | --- |
| 1 | AWQ | 激活感知的权重缩放/裁剪与W4A16 | [mit-han-lab/llm-awq](https://github.com/mit-han-lab/llm-awq) |
| 2 | GPTQ | 二阶近似与逐步误差补偿 | [IST-DASLab/gptq](https://github.com/IST-DASLab/gptq) |
| 3 | AdaRound | 学习舍入选择 | [qualcomm/aimet（已核实迁移）](https://github.com/qualcomm/aimet) |
| 4 | AutoRound | 数据驱动的舍入和裁剪优化 | [intel/auto-round](https://github.com/intel/auto-round) |
| 5 | HQQ | 无需激活校准数据的半二次权重量化 | [mobiusml/hqq](https://github.com/mobiusml/hqq) |
| 6 | OmniQuant | 可学习裁剪与等价变换 | [OpenGVLab/OmniQuant](https://github.com/OpenGVLab/OmniQuant) |
| 7 | QuaRot | 固定旋转与离群值分散 | [spcl/QuaRot](https://github.com/spcl/QuaRot) |
| 8 | SpinQuant | 可学习旋转 | [facebookresearch/SpinQuant](https://github.com/facebookresearch/SpinQuant) |
| 9 | SpQR | 低位主体与稀疏高精度异常权重 | [Vahe1994/SpQR](https://github.com/Vahe1994/SpQR) |
| 10 | SmoothQuant | 激活/权重间的量化难度迁移 | [mit-han-lab/smoothquant](https://github.com/mit-han-lab/smoothquant) |
| 11 | LLM.int8 / outlier handling | 离群特征混合精度分解 | [bitsandbytes-foundation/bitsandbytes](https://github.com/bitsandbytes-foundation/bitsandbytes) |
| 12 | Calibration-aware scaling | 统计观察器、直方图/裁剪与输出重建目标 | [pytorch/pytorch](https://github.com/pytorch/pytorch) |
| 13 | QAT | fake-quant前向、STE与参数更新 | [pytorch/ao](https://github.com/pytorch/ao) |
| 14 | NF4 / QLoRA | 非均匀4位码本、量化主干与低秩适配 | [artidoro/qlora](https://github.com/artidoro/qlora) |
| 15 | KIVI / KV Cache量化 | KV Cache的粒度、残留高精度区间与注意力误差 | [jy-yuan/KIVI](https://github.com/jy-yuan/KIVI) |
| 16 | 8-bit optimizer states | 优化器状态的分块量化 | [bitsandbytes-foundation/bitsandbytes](https://github.com/bitsandbytes-foundation/bitsandbytes) |
| 17 | FP8 scaling | FP8格式与静态/动态/分块缩放 | [pytorch/ao](https://github.com/pytorch/ao) |
| 18 | Block-scaled FP4：MXFP4 / NVFP4 | 分块浮点量化、scale编码和格式差异 | [NVIDIA/Model-Optimizer](https://github.com/NVIDIA/Model-Optimizer) |

位宽组合、算法、格式、训练方案和量化对象是不同维度，不能把以上标题都当成同一级算法。FP8 期只选一种明确缩放方法；FP4 期先选择 MXFP4 或 NVFP4，后续轮次讲另一种。后续可扩充方法，保留历史并核实源仓库。

贯穿每期的比较轴：

- 位宽：W4A4、W4A16、W8A8、W8A16；标明 A16 为 FP16 或 BF16。
- 格式：INT4/INT8、FP8 E4M3/E5M2、NF4、MXFP4、NVFP4；明确码本/指数/scale 的差异。
- 粒度：per-tensor、per-channel、per-group、per-token、block-wise。
- 参数：对称/非对称、zero-point、舍入、裁剪、静态/动态 scale。
- 对象：权重、激活、KV Cache、梯度与优化器状态；例如 8-bit 优化器状态不等于梯度量化。

## 实际拉取方式

从 EveryDay 项目根目录运行。`--record` 必须指定未占用的路径；下面为下一次尝试的示例，执行前若文件已存在应使用新的编号。

```bash
python3 systems_practice/quantization/fetch_source.py awq \
  --record systems_practice/quantization/results/2026-09-18-awq-source-retry-01.json
```

该脚本进行真实浅克隆，以 `--filter=blob:none --no-checkout` 按需读取目录中列出的文件，缓存放在被 Git 忽略的 `systems_practice/.tmp/quant_sources/`。记录 commit、文件 SHA256、源码永久链接、读取路径和原始错误。不安装依赖、不下载模型、不执行第三方源码。每条 Git 命令超时为 30 秒；单个选定源码文件最大 2 MiB，不构成网络总流量上限。

输出 `fetched` 仅表示文件已获取，`partial` 表示部分文件缺失，`failed` 表示未获得实现。缺失/迁移路径需在真实仓库中定位后修正，不能因为 README 下载成功就跳过实现阅读。脚本退出码 0 为 fetched，2 为未完整获取。`source_read` 与 `example_run` 始终初始为 false；讲解者实际阅读后在当期 verification.json 中附证据，脚本本身不冒认完成阅读/运行。网络恢复后可通过记录中的 commit 和文件哈希固定复现版本。

实际使用原项目还需要完整的相关包/构建依赖；这份源码快照不是已安装的软件包。每日教程必须在核实项目结构后另给针对该 commit 的准备和运行命令，不假定上述脚本已经安装 AWQ。

## 轮换与状态

状态文件为 [progress.json](progress.json)，方法顺序为 catalog.json 数组顺序。每日先检查 `last_lesson_date` 与 history；同一自然日已有栏目则补完/链接，不再次推进。首次从 AWQ 开始。一天的课程归档后记录方法、目录、日期、具体机制和五项状态，再将游标推进一位；末尾循环并改变具体设计点。

网络/源码失败也必须留当日尝试和待补内容，可在翌日讲下一方法，失败进入 backlog，不能列入 completed_methods。完成表示已读实现并交付经该版本核验的完整用法示例，不表示在 Thor 已运行；CPU/Thor 的运行验证独立记录。每次顺带尝试补齐至多一个 backlog，避免挤占当天内容。仅预备拉取不推进轮换。

| 日期 | 类型 | 方法 | 源码 / 阅读 / 示例 / CPU / Thor | 证据 |
| --- | --- | --- | --- | --- |
| 2026-09-18 | 配置及预备拉取，非已交付课程 | AWQ | 均未完成；GitHub DNS 失败 | [原始记录](results/2026-09-18-awq-source.json) |
| 2026-09-19 | 当日AWQ clip子机制；本地获取/运行待补 | AWQ | 本地拉取否 / 固定commit网页阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](../2026-09-19/quantization/awq/README.md)；[五项状态](../2026-09-19/quantization/awq/verification.json) |
| 2026-09-20 | 当日GPTQ二阶补偿；本地获取/运行待补，AWQ重试失败 | GPTQ | 本地拉取否 / 固定commit网页阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](../2026-09-20/quantization/gptq/README.md)；[五项状态](../2026-09-20/quantization/gptq/verification.json) |
| 2026-09-21 | 当日AdaRound学习舍入；AIMET迁移核实，AWQ重试失败 | AdaRound | 本地拉取否 / 固定commit浏览器阅读是 / 原生API示例是 / CPU否 / Thor否；独立u4检查通过 | [课程](../2026-09-21/quantization/adaround/README.md)；[五项状态](../2026-09-21/quantization/adaround/verification.json) |
| 2026-09-22 | AutoRound原生低层舍入/范围优化；AWQ重试失败 | AutoRound | 本地拉取否 / 固定commit实现阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](../2026-09-22/quantization/autoround/README.md)；[状态](../2026-09-22/quantization/autoround/verification.json) |
