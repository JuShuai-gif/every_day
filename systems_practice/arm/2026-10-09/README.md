# 2026-10-09 ARM 17：带宽瓶颈与预取的适用条件

上一课已经把 packing 的搬运成本摊到多次使用；本课问剩下的顺序特征扫描是否值得提前请求下一缓存线。机器人相机后处理读取 4097 个 `uint16_t`，代码的 `sum_prefetch` 在 `i+32` 仍在范围内才调用 `__builtin_prefetch`，因此语义仍是普通 load/sum；预取不保证数据到达、不分配所有权，也不能修复随机访问或带宽饱和。

实际读取 Arm Compute Library 的 GEMM 合并内核路径（2026-10-09；GitHub raw 请求该特定路径返回内部错误，故不声称已读其内容），并以 clang AArch64 的 builtin 为可观察机制：在 AArch64 目标上执行 `clang++ -target aarch64-linux-gnu -O3 -S main.cpp`，检查 `sum_prefetch` 的 `prfm` 与 load 指令；Mac arm64 实际编译运行只能证明宿主正确性，不能证明 RK3588 A76/A55 或 Thor Neoverse-V3AE 的缓存收益。

Mac 实际运行：4097 元素和空输入均通过。故障链：预取距离太小会来不及隐藏 miss；距离太大可能污染 cache；随机索引通常让 hint 无效。生产排查先用 `perf stat -e cache-misses,cycles` 和 P50/P95，再比较无预取基线。下一课是 TLB 与页工作集。

来源与边界：ARM Compute Library（Apache-2.0）是成熟实现候选，但本次具体 raw 文件未读；本课为独立 C++17 教学实现。命令 `sh run.sh`；未测板端、PMU 或性能。
