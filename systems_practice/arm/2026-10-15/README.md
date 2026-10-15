# 2026-10-15 ARM22：小Batch GEMM的权重加载复用

## 速览与工作合同

承接第21课线程粒度，本课先把单线程微内核做清楚：为什么一次加载4个权重可以同时推进两行输出？工作能力层为第3层“证据驱动优化”。参照ROCK 5B/RK3588 CPU侧小Batch分类头，A `[M,K]`、W `[N,K]` FP32，Y=`A Wᵀ`；M=1/2/3/8、N=1/7/32/65、K=1/15/64/129。有限数、非别名、输出独占；尾N用局部4元素暂存，不能写过实际行尾。

本机Mac arm64运行。ROCK 5B的4×A76+4×A55为[Radxa产品文档](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)参照，实际板卡、Linux镜像、核拓扑/频率未测。本日Radxa直访403，硬件对应复用docs/arm/BOARDS.md的9月22日核实记录，未声称本日重读产品全文。Thor CPU是Neoverse-V3AE，GPU SM110与本CPU代码无关；本期不把Mac时间当板端结果。

## 源码与ARM机制

2026-10-15实际读取 [ncnn master innerproduct_arm.cpp](https://github.com/Tencent/ncnn/blob/master/src/layer/arm/innerproduct_arm.cpp)，`InnerProduct_arm::create_pipeline`约80–115行权重打包，`forward` 250–312行 `elempack==1 && num_output_elempack==4` 分支，BSD-3-Clause。读取内容SHA256：`43dfd9428c9ffa663aac3e92b56209ce4d7142e9b02d3d489a5db3bc2447c4f5`，分支日期固定内容、未固定commit。原场景为ncnn全连接推理，pack4权重和lane FMA消费对应；本课**独立启发实现**，使用同样4输出列面板，但按M=1/2复用，省略模型加载、bias/activation、多线程、FP16及INT8分派。

`pack`把W从N×K变成ceil(N/4)×K×4。`neon`的一条 `vld1q_f32` 读取同一个k上的4输出权重；`vfmaq_n_f32` 把A的一个scalar广播到4条lane。mr=2对第二个A行重复FMA但复用w。读过[ACLE NEON参考](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)对应vld1q_f32/vfmaq_n_f32条目，后者A64映射为FMLA lane。基础NEON不是SVE，不要求dot-product/i8mm扩展。

| 状态（示意） | lane0 | lane1 | lane2 | lane3 |
| --- | --- | --- | --- | --- |
| w(k) | W[j,k] | W[j+1,k] | W[j+2,k] | W[j+3,k] |
| c0更新 | +A[i,k]×w0 | +A[i,k]×w1 | +A[i,k]×w2 | +A[i,k]×w3 |
| c1更新 | +A[i+1,k]×w0 | +A[i+1,k]×w1 | +A[i+1,k]×w2 | +A[i+1,k]×w3 |

例如w=[1,2,3,4]、A两行为2和3、初值0，一轮得到[2,4,6,8]与[3,6,9,12]。数值属于手算，不是硬件计时。

## 代码到真实指令

[main.cpp](src/main.cpp)的`neon`，实际Mac汇编 [host-final.s](results/host-final.s) 包含以下连续指令（编译器寄存器选择）：

```asm
ldr q1, [x10], #16
ldr s2, [x9]
fmla.4s v0, v1, v2[0]
ldr s2, [x9, x28, lsl #2]
fmla.4s v3, v1, v2[0]
```

以实际文件该循环为准：q1装16B，s2装一个A元素，v0/v3分别是两行4输出累加器。两条FMLA共享v1，减少该面板权重load次数；每条累加器自身仍有跨K依赖。栈上的向量store/reload可能是尾部临时数组，不把所有栈访存都误认作寄存器压力spill。`scalar`关闭自动向量化，仍可能使用标量融合乘加；它是可解释基线而非最佳编译器版本。

## 运行、对照与结果

```sh
# 工作目录为本课目录
sh run.sh release
sh run.sh sanitize
clang++ -std=c++17 -O3 -fno-vectorize -fno-slp-vectorize -S src/main.cpp -o build/host.s
```

128个shape/微核组合与标量参考比对，容限2e-4×(1+|ref|)，零shape拒绝。Release/ASan/UBSan通过，日志见 [release-final](results/release-final.txt)、[sanitize-final](results/sanitize-final.txt)。最终格式化后重新运行结果为准。每个测量5次预热、21批×50调用，P50是每批均值，不是请求P50；单线程、热权重，输出逃逸避免优化删除。sanitize时间不用作性能结论。

最终复测（Mac，微秒/调用，批均值P50）：

| M | scalar | neon1 | neon2 | 分配+pack+neon2 |
| --- | --- | --- | --- | --- |
| 1 | 8.56584 | 2.59166 | 2.61082 | 3.9725 |
| 2 | 7.99832 | 2.35668 | 1.23 | 4.01584 |
| 8 | 32.3408 | 9.40584 | 4.91332 | 7.7275 |

M=1的neon2略慢，保留退化；M=2的预打包核更快，但含pack不如neon1核时间，需在相同含pack边界比较，不能跨列宣布E2E收益。固定测试顺序与频率/缓存仍是混杂因素，M=1/2标量反常比例不能当线性缩放结论。本期小例的预打包计算证据足够，不宣称生产P95/热稳定。

同shape比较scalar、neon1与neon2，以及重新分配/打包+neon2。性能数值直接读release表；不要把pack包含项与预打包内核混比。该设计没有创建线程；沿用第21课的线程池时还需测唤醒/队列，不假称本课覆盖OS调度成本。

算术量=2MNK FLOPs。mr=1每行每输出4列读取16K字节权重；mr=2理想两行共读16K，逻辑权重load量减半，增加一个向量累加器与A流。冷DRAM流量不一定减半：原本可能已缓存。M=1无法获得跨行复用，mr2分支可能无收益；N尾列packing增加无效计算。一次pack至少读/写约8NK字节（含padding另计），模型权重复用才能摊薄。不要把更少源级load等价固定周期下降。

## 故障链与迁移验收

1. N=65准确性坏、N=64好：可能尾store写穿下一行，也可能pack错误。先比较每个输出和邻行哨兵，ASan检查分配边界；采用局部tmp只拷有效lane。回归N=1/7/65，代价是尾分支与拷贝。
2. 核内变快请求却更慢：检查是否每请求重新pack/分配、M太小或线程唤醒。分段计pack、compute、queue，比较静态权重预打包；收益不足回退neon1/现有库，不能隐藏初始化成本。
3. Mac快板端慢：频率、A55/A76选择或内存竞争均可能。先记录拓扑/温度、绑定经确认CPU、同shape复测；不从Mac FMLA条数推断Cortex吞吐。

板端命令（未执行）：

```sh
uname -a
lscpu -e
cat /proc/cpuinfo
# 在AArch64 Linux目标原生构建，别把Mach-O复制过去
CXX=g++ sh run.sh release
perf list
perf stat -e cycles,instructions,cache-misses ./build/example
```

perf事件先检查支持/权限，混合核不要照抄raw事件。跨编译须使用匹配aarch64-linux-gnu工具链/sysroot，检查`file`、`readelf -h -l -d`与动态库；目前没有该工具链/板端验证。上线前复验尾块、非有限输入政策、长期温控、权重复用次数、CPU–NPU带宽竞争与E2E；本课未完成产品部署。

## 追问与下一课

追问：①pack4为什么改变权重读取方向？②mr2减少了哪种流量？③M=1为什么可能退化？④尾lane如何避免越界？⑤标量关闭向量化为何仍可能FMA？⑥何时pack成本无法摊销？

Google实际请求已获得页面但未作为已读工程正文；知乎案例访问403，未采信摘要。源码与指令资料为采用依据；本课无相关MMU主题，不选用本地ARM PDF。下一节23：量化块解码与点积融合。
