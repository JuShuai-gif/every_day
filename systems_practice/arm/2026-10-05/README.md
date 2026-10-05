# 2026-10-05 ARM13：FP16存储、转换和累加精度

## 速览与工作合同

承接AoS/SoA布局，本节回答：**为什么同一组FP16输入，用不同累加lane会得到有限值或无穷？** 5～10分钟先看下表与实测指令，正文解释诊断与迁移。ROCK 5B/RK3588 CPU特征点积是目标场景；本机Mac只验证arm64实现，不代表A76/A55性能。工作能力层3：为CPU低精度算子选择数值路径。

输入两个连续FP16向量，长度0～1025做尾部验证，17/4096/65539做计时。标量FP32 FMA与NEON FP32 FMA是相同精度合同；half-lane FMA只作较弱精度反例，不拿它冒充等精度提速。有限输入也可能溢出，业务应先定义非有限值处理。

## 数据如何变化

| 阶段 | 手算输入/操作 | 结果与边界 |
| --- | --- | --- |
| FP32→FP16存储 | 70000 | 本机转换为inf，进入kernel前信息已丢失 |
| FP32→FP16舍入 | 1+2^-11 | 本机默认环境round-to-nearest-even得到1 |
| FP16→FP32转换 | 300 | 可精确表示为300.0f |
| FP32累加 | 64项300×300 | 5760000，实测有限 |
| FP16向量FMA | 相同输入 | 单lane乘加结果已超FP16范围，实测inf |

存储每输入元素2B，两个向量逻辑读取4N字节；不是DRAM实测流量。FP32算术不能恢复已经溢出的存储值。half具备10个显式小数位，精度与范围是两个独立问题。

## 代码到实际ARM机制

[src/main.cpp](src/main.cpp)的`widened`使用`vld1_f16 → vcvt_f32_f16 → vfmaq_f32 → vaddvq_f32`。实际Apple clang21生成[host-a64.s](results/host-a64.s)包含：

```asm
fcvtl v1.4s, v1.4h
fcvtl v2.4s, v2.4h
fmla.4s v0, v2, v1
faddp.4s v0, v0, v0
faddp.2s s0, v0
```

`.4h→.4s`把4个16位lane扩宽；`fmla.4s`在32位累加器更新，依赖前一轮v0；两次FADDP归约四lane。`narrow`实际有`fmla.8h`，半精度算术并非仅更紧凑的内存表示。尾部逐项使用FP32 fma，不越界读。`scalar`基线为顺序fma归约，编译未使用fast-math，归约次序与四lane不同；一般输入应使用误差容限，本例二进制分数测试可精确对齐。

编译宏`__ARM_FEATURE_FP16_VECTOR_ARITHMETIC=1`和本机实际执行共同支持当前运行路径。宏说明编译目标，不能替代未知板卡运行时特性检测；代码在宏缺失时省略half算术对照，保留FP16存储转换+FP32算术。

## 源码阅读与采用边界

2026-10-05实际读[ggml vec.cpp](https://github.com/ggml-org/ggml/blob/master/src/ggml-cpu/vec.cpp)的`ggml_vec_dot_f16`，追到[simd-mappings.h](https://github.com/ggml-org/ggml/blob/master/src/ggml-cpu/simd-mappings.h)的`GGML_F16_VEC_LOAD/FMA/REDUCE`与ARM FP16分支。master按读取日期记录，精确commit未固定；MIT。上游用于张量点积，依据扩展选择half算术或转换到FP32。本课是启发式独立实现，保留转换/累加区别和尾部，省略张量分派、多平台和多累加器。并非ggml性能复现。

[Arm ACLE表](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)核实`vcvt_f32_f16`对应FCVTL、支持A64；实际读取转换项。Google/知乎检索与直连失败，无二手文章结论。本地资料库没有为本课采用未核实的FP16说明。

## 运行、同条件对照和结果

```sh
sh systems_practice/arm/2026-10-05/run.sh release
sh systems_practice/arm/2026-10-05/run.sh sanitize
c++ -std=c++17 -O3 -S systems_practice/arm/2026-10-05/src/main.cpp -o systems_practice/arm/2026-10-05/build/observe.s
```

[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)实际通过1026长度、舍入与两种溢出反例。5组预热、41组采样，每组100调用取均值后排序，P50/P95是**批均值**。N65539首轮标量52.1521μs、NEON13.4688μs；N17为0.01458/0.00625μs，计时分辨率与循环/调用占比较大。计时仅CPU函数，不含生成/转换/分配；不含GPU/NPU或推理请求。Sanitizer时间只诊断，不当性能。生成指令和局部提速未证明整个应用受此kernel限制。格式化后[最终Release](results/verified-release.txt)N65539标量/NEON P50=52.3054/13.5775μs，[Sanitizer](results/verified-sanitize.txt)通过；[最终汇编](results/verified-host-a64.s)与源码一致，初轮证据保留。

## 故障诊断与迁移验收

1. 推理点积inf→检查输入存储是否已inf，再用FP32累加对照→若输入有限而half累加溢出，保留半精度存储改FP32累加；代价是转换和寄存器数量，回归长向量/大值/抵消。若存储已溢出，改scale或FP32输入。
2. 板端illegal instruction→检查编译宏和目标`/proc/cpuinfo`、运行HWCAP，不能仅看“arm64”→为可选FP16算术做分派或编译基础路径；宏不是动态探测。
3. 数值通过但总时间退化→含转换/packing重测，检查短N与内存带宽→保留标量回退/复用转换结果，不能只用kernel收益作上线决定。

板端先`uname -a; lscpu`记录OS/核拓扑，板上`CXX=g++ sh run.sh release`；读`perf list`后用`perf stat -e cycles,instructions,cache-misses ./build/release`，未执行。交叉构建需自己的Linux AArch64 sysroot，Mac目标三元组与Mach-O不能直接部署。验收要求：输入dtype/尾部、编译目标与运行扩展、数值预算、含转换CPU阶段和E2E、长期频率/温控全部通过；目前后两项及板端都未验。

追问：FP16存储支持等于FP16算术支持吗？FCVTL为何不恢复已溢出的输入？FMLA.8H与FMLA.4S差别？四lane归约为何可与顺序结果不同？能力宏为什么不足以跨机器分派？逻辑字节量等于DRAM流量吗？

下一节14：INT8扩宽累加与可选dot-product，先保留本节的范围与扩展检查习惯。
