# 2026-10-28 ARM：算子布局合同与版本化分派

## 1. 要回答的问题
同一个行归约在输入尾部不是 4 的倍数时，怎样让 packed/NEON 路径与 scalar 路径共享布局合同，并根据运行能力安全分派？这承接 2026-10-27 的能力查询，新增重点是相邻算子的 stride/尾部接口，而不是重启 28 节。

## 2. 数据或状态变化
19 个 FP32 输入按连续 row 读取；NEON 每次消费 4 lane，最后 3 个元素走 scalar。布局合同是 `ptr + n`、不越界、输出与 scalar oracle 一致。示意 lane 不是板端实测。

## 3. 最小实现怎样对应 ARM 机制
`src/main.cpp` 用 `vld1q_f32/vaddq_f32/vaddvq_f32`，在非 AArch64 编译目标保留 scalar。实际阅读 `https://github.com/ggml-org/llama.cpp` commit `7aca0d2e8d92b56911233b822db01f9fbb1ae50` 的 `ggml/src/ggml-cpu/ggml-cpu.c`（MIT，2026-10-28）能力分派和 backend 注册；本例独立改编，保留运行时回退/尾部语义，省略 NUMA 和算子注册。

## 4. 对照与观察
`sh run.sh` 运行 n=19 oracle 并生成 A64/宿主汇编。汇编出现 `fadd/vadd` 只证明候选，不证明 RK3588/Thor CPU 吞吐。Linux `getauxval(AT_HWCAP)`、RK3588/Neoverse/Thor PMU 和交叉 ABI 待目标机验证。

## 5. 故障链与取舍
stride 单位错（元素/字节）→尾行错位→用带 guard 的 shape oracle 诊断；编译打开 NEON 但运行 CPU 无扩展→SIGILL→能力查询失败回退 scalar。packed 预处理若超过算子收益会退化，需把 pack、算子、E2E 分段计时。

## 6. 来源、结果与下一节
来源、关系和边界直接记录于本 README；日期 ARM 项目按规范不新增 JSON。Mac C++17 实际通过，板端/PMU/E2E 未验。下一步继续相邻算子布局版本化与集成验收。

## 7. 迁移验收与面试追问
验收：n=0/1/3/4/19、stride>n、能力查询失败、Linux AArch64 交叉链接。追问：编译宏能证明运行能力吗？为什么尾部不能越界加载？pack 与算子如何公平计时？生成 NEON 指令为何仍可能变慢？ABI/动态库如何检查？

## 8. 工作能力
对应 CPU 算子交付与证据驱动优化：保留 scalar 基线、NEON 候选、尾部 oracle、汇编和待验板端清单；不把 Mac 结果写成产品收益。
