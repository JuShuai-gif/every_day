# 2026-10-27 ARM：NEON 能力分派与性能边界

## 1. 要回答的问题
同一点积何时可以走 NEON，何时安全回退？编译期 __ARM_NEON 只表示编译器能生成指令，运行时 sysctlbyname(hw.optional.neon) 才决定本机路径；不猜 i8mm/SVE。

## 2. 数据变化
每次加载四个 FP32 lane，vmlaq_f32 累加，vaddvq_f32 水平归约，尾部走标量。未知能力默认 scalar，避免 SIGILL。

## 3. 最小实现
[src/main.cpp](src/main.cpp) 是完整 C++17 例，build/run 产出 Release、ASan/UBSan 和 A64 汇编。实际读取 llama.cpp commit 7aca0d2ea8d92b56911233b822db01f9fbb1ae50 的 ggml/src/ggml-cpu/ggml-cpu.c：平台宏、ARM feature 和 ggml_numa_init；MIT。原场景是 CPU backend 分派，本课独立保留能力分层，省略量化注册。

## 4. 对照与观察
运行 sh systems_practice/arm/2026-10-27/run.sh；汇编中的 fmla/ld1/addv 只证明候选指令，不证明吞吐。没有 RK3588、Orin、Thor CPU PMU 数据，不跨核推断速度。

## 5. 故障链与取舍
交叉编译开启 NEON 但目标无扩展→SIGILL→读取 OS 能力并保留 scalar；构建宏显示 NEON 但能力查询失败→回退并记录错误。动态库还需检查 ABI 和符号，路径正确不等于 loader 加载正确版本。

## 6. 来源、结果与下一节
宿主 Release/ASan/UBSan 实际运行，汇编可观察；Linux HWCAP、RK3588/Orin、PMU 与端到端性能待验。下一节进入热点、PMU 与平台边界。

## 7. 迁移验收与追问
检查 sysctl/getauxval、编译三元组、动态库符号和 scalar fallback；同一输入验证尾部。追问：宏与 HWCAP 区别？查询失败为何不能默认 true？尾部如何保持语义？汇编存在为何仍可能变慢？如何做版本化动态库？

## 8. 工作能力
对应部署和证据驱动优化：输入为向量合同，指标为正确性、路径选择和符号化汇编；缺 Linux/板端 PMU 与真实性能，不能发布加速结论。
