# 10 个实验的操作与记录要点

所有实验使用相同流程：先 `example_NN --mode both` 检查 `correctness=PASS` 和相同 checksum；再分别运行 baseline/optimized（脚本已自动完成）并填写 `records/TEMPLATE.md`。运行前后都保存环境文件；如果执行 `perf stat` 失败，保留失败原因。

| 例子 | 基线与优化 | 如何定位 | 验收与记录 |
| --- | --- | --- | --- |
| 01 缓存步长 | `columns` → `rows`，算法和值不变 | `perf stat` 比较 cache-misses、cycles；检查数组大小固定为 1024² | 记录两版 p50/p95；只可写“连续访问在该工作集改善”，不可泛化到所有矩阵算法。 |
| 02 分支预测 | `if (x>0)` → 掩码累加 | 比较 branches、branch-misses；输入必须保持同一伪随机序列 | 记录 checksum 与分支失预测率；若编译器已经 if-convert，汇编和数据应说明无明显收益。 |
| 03 数据布局 | `Particle` AoS → x/y SoA | 比较 cache-misses 与热点循环；确认业务只读取 x/y | 记录热字段和结构体大小；若业务还要读 z/id，需新增独立实验。 |
| 04 容器容量 | `push_back` 自动扩容 → `reserve` | 用 heap profiler 或分配计数器（可选）确认重分配；测量总构建时间 | 记录元素数与最终容量；这是构建期优化，不代表后续遍历更快。 |
| 05 对象池 | 每个 `Node` `new/delete` → 连续 `vector<Node>` | 看 allocator 热点和 page/cache 行为；确认对象没有复杂析构需求 | 记录对象大小、数量与析构语义；真实项目如需非平凡析构，使用受管 arena。 |
| 06 NEON | 标量 FP32 add → `vaddq_f32` | 在 RK3588 保存反汇编，确认有 NEON 指令；Mac 结果不可替代 | 记录 `enabled=true`、编译参数和结果校验；测量内存带宽上限，不能把差值全归因算术。 |
| 07 ILP | 单 `uint64` 累加器 → 四个累加器 | 查看反汇编中的独立反馈寄存器；再看 cycles/instructions | 记录尾部长度（输入故意不是 4 的倍数）；浮点归约不可直接照搬，因为舍入顺序会变。 |
| 08 false sharing | 相邻 atomic → `alignas(64)` atomic | 固定在同类核上，查看 cache-to-cache 相关指标（若 PMU 提供） | 记录 CPU 亲和性、线程数与每线程次数；线程创建时间仍在计时内，应明确这一限制。 |
| 09 批处理 | 每项调用 `one` → 一次 `batch` | 反汇编核对 `one` 没有被内联；比较 instructions 与 cycles | 记录批次大小；真实 RPC/IO 批处理还须测端到端延迟，不能只测此 CPU 循环。 |
| 10 memcpy | C++ 字节循环 → `std::memcpy` | 保存 libc/编译器信息；检查吞吐是否接近内存带宽 | 记录复制大小、对齐和源/目的是否重叠；重叠区域必须用 `memmove`，不能套用本例。 |

## 板端执行顺序

```sh
# 1. 交叉编译；工具链和 sysroot 必须来自目标 Linux 系统。
CXX=aarch64-linux-gnu-g++ SYSROOT=/opt/rk3588-sysroot sh build-rk3588.sh

# 2. 上传、运行十个例子、采集环境和 perf（如果可用）、拉回 records。
BOARD=user@board.local REMOTE_DIR=/tmp/arm-practice sh run-rk3588.sh

# 3. 对某一个有疑问的案例做热点定位；固定 CPU 编号按实际 lscpu 结果填写。
ssh user@board.local 'taskset -c 4 perf record -g /tmp/arm-practice/example_01 --mode optimized'
ssh user@board.local 'perf report'
```

不要把脚本中的 `taskset -c 4` 当成 RK3588 固定的大核编号：先以目标板 `lscpu -e` 的实际映射为准。每次只改变一个因素；结果缺少环境、正确性或重复样本时，标记为“观察”，不写性能结论。
