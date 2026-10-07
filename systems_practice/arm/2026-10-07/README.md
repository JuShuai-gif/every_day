# 2026-10-07 ARM 第15课：工作集与依赖加载

## 1. 本节要学会解释的ARM问题

承接INT8点积：算术足够快后，模型索引/稀疏元数据的依赖加载为何随工作集变慢？5–10分钟先读状态表和A64片段，再看完整测量合同。主能力层为证据驱动优化，目标工作是ROCK 5B/RK3588 CPU稀疏表访问；本机Apple arm64仅提供机制与实验，A76/A55缓存容量、核号、频率和PMU未验证，不外推板端数字。

输入为128字节步长的Node单环，4KiB到32MiB，节点只存下一个索引。128是人为布局，不声称各ARM缓存行均为128。每次相同函数访问相同节点数；顺序和随机环只改变访问顺序。随机排列使用固定种子，构造期间检查每个节点恰好访问一次；n=0拒绝。

## 2. 先看数据或状态如何变化

示意三节点环：

| 当前索引p | 下次地址 | 加载后p |
| --- | --- | --- |
| 0 | base + 0×128 | 2 |
| 2 | base + 2×128 | 1 |
| 1 | base + 1×128 | 0 |

第i+1次地址依赖第i次加载结果；这限制并行未决请求数量。局部性和依赖链是通用CPU原理，ARM特定证据是下节的A64寄存器/寻址，不把原理包装成ARM独有。工作集增大还可能增加TLB压力；随机次序也改变硬件预取效果，所以单条曲线不能唯一测定cache容量。

## 3. 最小实现怎样对应ARM机制

[src/main.cpp](src/main.cpp) 的 `chase` 实际编译产生[host-a64.s](results/host-a64.s)：

```asm
lsl x8, x1, #7
ldr x1, [x0, x8]
subs x2, x2, #1
b.ne LBB0_1
```

x0是nodes基址，x1是64位索引，左移7形成128字节偏移；LDR把下一索引写回x1，下一轮LSL必须等待它。x2计数递减并设置条件标志。此依赖不能用前面课程的多累加器消除，除非业务确有多个独立链。没有NEON不是编译失败：地址链不能按独立lane直接向量化。每次逻辑读取8字节，真实cache事务可能搬整行，不能用 `8/时间` 宣称DRAM带宽；本课单位是批均值ns/依赖加载。

## 4. 已写好的对照与观察步骤

```sh
sh systems_practice/arm/2026-10-07/run.sh release
sh systems_practice/arm/2026-10-07/build.sh sanitize
systems_practice/arm/2026-10-07/build/example-sanitize check
clang++ -std=c++17 -O3 -S systems_practice/arm/2026-10-07/src/main.cpp -o systems_practice/arm/2026-10-07/build/inspect.s
```

构造/触页不计时，先完整预热，11个样本，每个样本至少262144次依赖加载。输出P50/P95是批均值分位，不是单次读取/请求P95；11样本最近秩P95为最大样本。首轮在其他编译活动附近运行，仅作功能/初测，最终独立复测见verified日志。编译器生成标量LDR，没有自动向量化。顺序环只是诊断对照，不保证业务能合法重排；随机访问32MiB慢不证明“L2恰好小于32MiB”。

本机 `sysctl hw.cachelinesize hw.l1dcachesize hw.l2cachesize` 失败：Operation not permitted，原始输出在[cache-query.txt](results/cache-query.txt)。因此不填写猜测cache容量。Linux板端先运行：

```sh
lscpu -e
getconf PAGESIZE
find /sys/devices/system/cpu/cpu*/cache -name size -o -name type -o -name shared_cpu_list
perf list
CXX=g++ sh systems_practice/arm/2026-10-07/build.sh release
perf stat -e cycles,instructions,cache-references,cache-misses,page-faults -- systems_practice/arm/2026-10-07/build/example-release
```

先确认支持哪些事件、实际核拓扑和亲和性再选择CPU，通用cache-misses语义依PMU实现，不能当L1专有事件。无需root修改系统参数；权限不足记录待验。

## 5. 工作场景排障与优化取舍

故障一：大表随机访问P95恶化→cache/TLB/首次触页/调度均可能→先看首次与预热差别、缺页/上下文切换及真实PMU→若证据支持局部性问题，再改紧凑索引或批处理；重排会增加构建成本，必须把转换计入E2E，并核对图遍历语义。

故障二：顺序环很快就宣称内存延迟很低→预取与访问规律改变了实验→同节点数/同函数随机化对照并查看LDR依赖→报告负载特定延迟，不拿顺序结果估算随机元数据服务。

故障三：Mac结论迁移A55后失效→顺序执行/乱序资源、页大小、cache配置、频率都可能变化→记录实际板卡镜像、编译器、核绑定和PMU→保留原始对照而不复制阈值。顺序化小环可能无收益，若重排本身更贵则回滚。

## 6. 来源、结果与下一节

2026-10-07实际读 [intel/lmbench master/src/lat_mem_rd.c](https://github.com/intel/lmbench/blob/master/src/lat_mem_rd.c) 的 `benchmark_loads`、`loads`、`step`，以及文件头。原项目以依赖指针追逐测访存；本例独立重写索引环和验证，不复制/修改lmbench，输出不是lmbench结果。其文件头GPL附结果发表限制，未将它误写为宽松许可。保留依赖、预热和工作集扫掠；省略其benchmp进程编排和最低值统计。本课改用批均值分位，不能与其数字直接比较。

Arm官方cache页面请求失败；改读 [Arm Trusted Firmware xlat_tables_defs.h](https://github.com/ARM-software/arm-trusted-firmware/blob/master/include/lib/xlat_tables/xlat_tables_defs.h) 中Normal/Device和MAIR属性定义（master，当日；BSD-3-Clause），仅用于核对内存类型。Google/知乎直访失败、另一个macOS基准源码Cache miss，都记录为失败，没有声称阅读。

本地辅助PDF《MMU-Chapter 15 MEMORY TYPES AND CACHEABILITY.pdf》实际渲染并读物理第1页15.1：区分Normal与Device。SHA256 `6884e77082808af8a0e32625049aee664ce2e470b1ac7d562cfcd8ed01e4bd6e`。与TF-A定义一致，但此页不足以给出cache大小或延迟；malloc普通内存实验不是MMIO访问。许可未确认，未复制PDF或正文。本机无硬件属性寄存器读取，不把资料分类当实测。

Release/ASan/UBSan14边界环＋零长度拒绝通过；实际A64片段如上，工具版本见[toolchain.txt](results/toolchain.txt)。CPU初测见[release.txt](results/release.txt)，格式化后独立复测见[verified-release.txt](results/verified-release.txt)。最终独立复测的批均值如下（ns/依赖加载）：

| 工作集 | 顺序P50 | 随机P50 | 随机P95 |
| --- | --- | --- | --- |
| 4KiB | 2.12606 | 1.86840 | 1.89797 |
| 1MiB | 2.39070 | 6.10192 | 6.49245 |
| 32MiB | 7.07443 | 51.4197 | 65.0490 |

4KiB随机略快是小差异/运行噪声，不能声称随机排列有优势；未绑定核/锁频，不从结果反推cache容量。无PMU、Linux板卡、GPU/NPU/E2E数据。下一课16：分块与packing，先判断重排收益能否覆盖代价。

## 7. 迁移验收与面试追问

验收：确认Linux/aarch64 ABI与运行库；单环oracle、n=1/尾边界；工作集/步长/样本单位固定；预热与缺页分离；记录支持的PMU/核号/频率；转换+原业务E2E无退化才采用。不能因一处耗时拐点标出L1/L2容量。

追问：LDR的结果为何限制下一加载？128字节步长与cache line有什么区别？为什么随机环也不能完全排除预取？ns/load和GB/s分别回答什么？TLB会怎样混入工作集曲线？板端复测至少固定哪三个因素？

## 8. 工作能力与部署闭环

已获得构建、环合同、真实A64和本机测量证据，可用于识别“串行地址依赖”这种性能形态。尚缺ROCK 5B的OS镜像/拓扑/计数器、真实稀疏推理数据以及持续运行功耗。它是分析步骤示范，不代表完成板端优化项目。
