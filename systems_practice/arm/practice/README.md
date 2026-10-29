# RK3588 性能优化闭环：10 个可复现实验

目标板假设为 RK3588（4×Cortex-A76 + 4×Cortex-A55）。每个例子都实现同一件事的 `baseline` 与 `optimized`，并用确定性校验和确保结果相等。优化结果只应以板端归档的 p50/p95 与 `perf stat` 为准，不能从 Mac 输出外推。

| 编号 | 主题 | baseline → optimized |
| --- | --- | --- |
| 01 | 缓存与步长 | 列式跨行访问 → 连续行访问 |
| 02 | 分支预测 | 数据相关分支 → 无分支掩码求和 |
| 03 | 数据布局 | AoS 遍历 → SoA 热字段遍历 |
| 04 | 容器分配 | 未 reserve 的 push_back → reserve 后写入 |
| 05 | 分配器 | 每对象 new/delete → 预分配对象池 |
| 06 | NEON | 标量 FP32 加法 → NEON 四 lane 加法 |
| 07 | 指令级并行 | 单累加依赖链 → 四累加器 |
| 08 | 多线程缓存行 | 相邻计数器 → 64 字节对齐的私有计数器 |
| 09 | 批处理 | 逐元素调用 → 一次处理一批元素 |
| 10 | 内存拷贝 | 字节循环复制 → `memcpy` |

## 每个例子的闭环

1. **编译。** 在 Mac 上执行 `sh build-mac.sh`，先做代码与功能检查。交叉编译执行：

   ```sh
   CXX=aarch64-linux-gnu-g++ SYSROOT=/path/to/rk3588-sysroot sh build-rk3588.sh
   ```

2. **部署与环境记录。** 设置 SSH 地址后执行：

   ```sh
   BOARD=user@rk3588-host REMOTE_DIR=/tmp/arm-practice sh run-rk3588.sh
   ```

   脚本记录 `uname`、系统版本、`lscpu`、CPU 当前频率、板端编译器信息，并把输出拉回 `records/<时间戳>/results/`。

3. **测量。** 每个程序预热 10 次、采样 40 次，输出 `p50_us`、`p95_us`、`checksum`。分别运行 `--mode baseline` 和 `--mode optimized` 可缩小测量范围；`both` 会先做结果一致性校验。

4. **定位瓶颈。** 脚本在板端有 `perf` 时保存 `perf stat`。如需函数级热点，单独执行：

   ```sh
   perf record -g /tmp/arm-practice/example_01 --mode baseline
   perf report
   ```

   对照 `perf stat` 的 cycles、instructions、cache-misses、branches、branch-misses 与上下文，确认案例假设是否成立。无权限时记录错误信息，不把缺少 PMU 数据当作推论。

5. **优化。** 只在对应 `examples/NN/main.cpp` 中替换被测实现；不要同时改变输入大小、线程数和算法语义。每次改动先比较 checksum，再重复板端测量。

6. **验证与归档。** 为每次板端运行从 `records/TEMPLATE.md` 复制一份记录到时间戳目录，填写基线/优化 p50、p95、`perf` 观察、结论与限制。性能结论要求：结果一致、环境完整、至少一组重复采样；长时间稳定性另行记录。

## RK3588 注意事项

- A76 与 A55 性能不同。先从 `lscpu -e` 确认 CPU 编号；做严格比较时固定在同类核上，并把 `taskset` 命令写入记录。
- 温度、调频和后台负载会影响尾延迟。记录频率和温度；不要将单次 p50 作为结论。
- 例 06 仅在 AArch64/NEON 编译目标下启用 intrinsic；非 NEON 构建会回退为标量，输出仍正确但不能作为 SIMD 验收。

每个案例的具体基线、优化、定位证据、验收边界和板端命令见 [EXPERIMENTS.md](EXPERIMENTS.md)。
