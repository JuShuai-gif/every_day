# 验证摘要

- 2026-09-17（Asia/Shanghai）Mac arm64：`./run.sh` 实际配置、编译并运行通过。`CPU stride-pack correctness=PASS`；Release 的 1,000 次预热后 10,000 次平均 CPU 行打包时间为 **0.0856833 us/次**。这是 `[1,4,6,3] → w_stride=8` 的辅助 CPU 测量，不是 NPU 时间或部署性能结论。
- ASan/UBSan Debug 构建实际运行通过；同一测试平均 **1.62102 us/次**。Sanitizer 数值仅作检查，不与 Release 比较性能。
- 已检查 `run.sh` 的 POSIX shell 语法、必需文件和关键 Runtime API 符号；文件清单与 SHA256 见本次终端记录。未安装任何依赖。
- 目标转换未运行：Mac 没有 RKNN-Toolkit2/`onnx` 环境；未生成或伪造 `.rknn`。RK3588 Runtime 编译、模型转换、NPU 推理、输出精度、设备时间、端到端延迟与功耗均未验证，因为没有板卡、相配 Runtime/驱动与模型。
- 读取 GitHub 原始示例源码的网络请求实际失败：`curl: (6) Could not resolve host: raw.githubusercontent.com`；因此 README 明确未对未读示例函数做归因。已有本地官方 Toolkit2 README 快照仅用于职责/流程依据。
