# 2026-10-17 ARM23：量化块解包与NEON乘加融合

## 速览与工作合同

承接22课小Batch权重复用：今天学会沿字节→nibble→有符号lane→FP32累加定位格式错误。工作场景是ROCK 5B上单请求CPU回退Linear，量化权重驻留、FP32激活输入，N=1到65539。核心能力层是证据驱动优化；本课不是RKNN/NPU量化器或完整模型部署。只提供现成示例，无额外必做题。

每32权重用16字节，加4字节FP32 scale；最后块零填充，逻辑长度单独持有。输入q∈[-8,7]，有限FP32激活，结果FP32，参考用独立未打包q与double点积。空输入和超出INT4范围拒绝。所有vector由调用者拥有，函数借用仅在调用期间有效；分离路径scratch预分配。

## 数据怎样进入lane

| 字节/向量 | 含义 | 核验 |
| --- | --- | --- |
| q[j]低4位 | 第j项的q+8 | AND 15后减8 |
| q[j]高4位 | 第j+16项的q+8 | 逻辑右移4后减8 |
| int8→int16→int32 | 有符号扩展，保留负号 | SSHLL/SSHLL2 |
| int32→FP32→乘scale | 恢复块内权重 | SCVTF、FMUL |
| FP32权重×激活 | 一次向量FMA | FMLA.4S |

例：字节0xF0，低lane为-8，高lane为7；这不是二补码nibble直接符号扩展。块间scale不同，不能先累完全部整数再乘一个scale。代码 `pack/decode/fused` 明确对应上述布局；尾块走逐元素标量，不读超出激活长度的数据。

## 上游与指令证据

2026-10-17实际获取并阅读 [ggml-org/ggml master](https://github.com/ggml-org/ggml)：[src/ggml-quants.c](https://github.com/ggml-org/ggml/blob/master/src/ggml-quants.c) 的 `dequantize_row_q4_0`，以及 [src/ggml-cpu/arch/arm/quants.c](https://github.com/ggml-org/ggml/blob/master/src/ggml-cpu/arch/arm/quants.c) 的 `ggml_vec_dot_q4_0_q8_0` 入口和i8mm分支。版本采用分支+实际读取日期，文件SHA256：

- ggml-quants.c：`5574a2dccf7c07e75b143733e04a5412d3d8c819e7945f5217a7b83a2b2ff8ab`
- ARM quants.c：`a4d3cfdea82b73c0086f63ad9f698e536117a1c25f2f266fc9cd6e7f51deab1b`

原场景是GGML块量化点积；本课为启发后独立实现，保留半块nibble映射和就地消费，改成FP32 scale与激活，省略Q8激活、FP16 metadata、i8mm/SDOT/SVE分派。因此不是GGUF兼容codec，也不声称阅读了整个217KB文件。MIT许可见[上游许可证](https://github.com/ggml-org/ggml/blob/master/LICENSE)。

[Arm ACLE Intrinsics Reference](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)实际核对vmovl_s8/s16与SSHLL映射。Apple clang21生成的[真实汇编](results/host-arm64.s)中 `fused` 有：`sshll.8h v3,v4,#0`、`scvtf.4s v7,v7`、`fmla.4s v0,v16,v7`。前两者构成扩展与转换链，FMLA消费其结果；不能据此推导Cortex周期。完整文件保留，相关指令摘录见[指令片段](results/instructions.txt)。实测高半块由`movi.16b #248`加`usra.16b #4`合并右移和减8（模256后作为int8解释）；低半块为AND与ADD。移位/减8可能被编译器合并，应以实际汇编解释，不能强求每条intrinsic一一保留。

源码首次DNS失败后重试成功。Google直接检索Internal Error，知乎命中页跳转安全验证，未采用未读文章；没有把摘要当源码。今日非MMU/中断机制，不采用本地ARM合集PDF。

## 同条件对照与性能边界

```sh
sh systems_practice/arm/2026-10-17/run.sh
cd systems_practice/arm/2026-10-17
c++ -std=c++17 -O2 -S src/main.cpp -o build/check.s
```

分离路径每次完整解码到scratch再NEON点积；融合路径直接消费解码lane。两版同q/scale/x、同容限；基线允许编译器自动向量化，不能称“纯标量”。scratch分配及离线pack不计时，两版都含解码。纯计算函数有编译器memory barrier防止被提到重复计时循环外；它不是ARM硬件内存屏障。

理论每32项，融合读20B权重和128B激活；分离另写128B并读回128B scratch，逻辑增加256B。不能把逻辑流量等同DRAM事务。融合增加拆位/扩展/转换指令，数据驻留cache时收益可能由执行端限制；多请求复用已解码权重时，预解码也可能更合适，本课不测试该复用场景。

预热10次，31批×100次，报告批均值P50而非请求尾延迟。固定版本顺序、频率/cache状态是混杂因素，不作严格因果归因。最终N=65539，分离/融合CPU批均值P50=43.0596/13.2967µs；N=33为0.07125/0.01292µs，仅本机、固定顺序、预分配scratch。最终无其他基准并行的复测见[最终结果](results/final-release.txt)；早先并行/未防提升日志保留，不作为最终性能证据。

## 工业故障与取舍

1. 只有后半块点积错误：候选为相邻nibble布局误解或负号解码。用0xF0定位低/高lane，再对原q逐项比；修复布局与offset，代价是明确文件格式版本。回归16/17/31/32/33。
2. 误差随块数增长：候选为scale跨块错用或尾填充当有效输入。用交替scale、边界长度及独立double oracle区分；每块先恢复后累加，末块仅处理真实长度。
3. 内核变快但服务更慢：候选为重复pack、输入复制或不同核/频率。先含pack/分配/E2E对照再决定是否缓存量化权重；频率、线程、热状态未控制时不承诺收益。

## 实际验证与板端迁移

Mac Release/ASan/UBSan通过12长度、2非法输入，真实A64生成；不是Cortex板端结果。具体参照[Radxa ROCK5B官方规格](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)本次读取确认RK3588的A76/A55；实际板型、OS/SDK与核拓扑未知。

板端候选命令（未运行）：

```sh
uname -a
cat /etc/os-release
lscpu -e
c++ --version
c++ -std=c++17 -O2 -march=armv8-a+simd src/main.cpp -o build/board-example
./build/board-example
perf list
perf stat -e cycles,instructions,cache-misses ./build/board-example
```

先在本课目录创建build，确认事件权限与所选CPU，再按实际核号绑定。A55顺序执行与A76乱序执行对依赖的容忍度不同，但此处没有PMU证据，不外推Mac数字。验收应包含格式/尾块/非有限数据入口检查、代表shape、冷热与持续负载、E2E；无收益则保留分离路径。Linux ABI和动态依赖需重编译核验，不能搬运Mach-O。

追问：①q4_0为何不是直接signed nibble？②SSHLL与USHLL混用会怎样？③scale为何按块？④融合减少的256B逻辑流量为何未必出DRAM？⑤预解码何时比融合好？⑥Mac汇编证据能证明A55吞吐吗？

下一节24：图像转换与归一化融合，继续核对布局、尾部及含转换代价。
