# 2026-09-29 源码反例补充：合法地址也能读错矩阵

这是09-24寻址课的现成补充，不增加第二个必做练习或推进学习游标。先看[完整源码研读](../../../docs/arm/SOURCE_STUDIES.md)。

来源：实际阅读知乎[BBuf原作者教程](https://zhuanlan.zhihu.com/p/272208879)和GitHub [MMult1.h](https://github.com/BBuf/how-to-optimize-gemm/blob/2cd87c4b462baed8e0c896fc34f272604ee4894b/armv7a/src/MMult1.h)，提交`2cd87c4b462baed8e0c896fc34f272604ee4894b`，读取2026-09-29。原场景为行主序GEMM逐步优化；调用链`MY_MMult1 → AddDot → Y(p)`把lda用于B列步进，应为ldb。上游文件许可未确认，不复制实现。

本例为独立实现的接口反证，保留“错误地混用两个stride”这一失效机制；简化为FP32、2×3乘3×2和固定小矩阵。不是原仓库API、通用GEMM、NEON内核或性能实现；ARM具体寻址证据沿用[主课](../README.md)真实A64汇编，本例单独证明数据合同错误。

在仓库根目录运行，无外部依赖：

```sh
sh systems_practice/arm/2026-09-24/source-study/run.sh
```

脚本先编译严格C++17 Release，再编译ASan/UBSan；只写本目录忽略的build。可设`CXX`为本机已有编译器。预期并检查：

```text
rectangular expected: 58 64 139 154
rectangular wrong: 3027 5008 6078 11032
rectangular corrected: 58 64 139 154
square equal-stride control: wrong candidate also passes
```

A使用lda=5，B使用ldb=4且padding=1000。错误候选始终落在已分配内存内，因此Sanitizer无报错；程序必须用手算oracle辨别它。等步幅2×2控制组证明普通方阵能掩盖问题，另检查K=0与stride小于列数的拒绝。失败走异常并返回1，成功返回0；这与“发现精度错误仍exit(0)”的上游测试分支形成工程对照。

验证：本轮格式化后实际执行结果归档为[results/run-20260929.txt](results/run-20260929.txt)。这是本机CPU正确性实验，未运行原仓库、目标板或任何GPU/NPU；未测性能，不推导加速收益。源码获取/阅读已完成到上述网页及固定提交，原仓库本地构建和设备验证未完成。
