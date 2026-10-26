# 2026-10-26 ARM集成02：任意行尾与packed布局复用

5–10分钟速览：上一集成例固定四行；今天让1/2/3/5/7/9行安全工作，并让ReLU直接消费packed RMSNorm输出。核心问题是**尾部lane的有效性与跨算子布局合同**。源码到指令/计时证据一起阅读，无额外必做作业。

## 工作合同与能力目标

C++17、FP32 row-major `[rows,cols]`，rows1–1024、cols1–4097，教学输入有限且小幅值。输出`max(0,x/sqrt(mean(x²)+1e-5))`，无gamma。能力层是“正确性约束+证据驱动CPU优化”，目标场景为RK3588视觉后处理；Mac运行不证明Cortex-A76/A55性能或Linux部署完成。Thor GPU的SM110不用于命名ARM CPU。

## 数据怎样变化

| 5行输入 | packed块 | 有效性 |
| --- | --- | --- |
| 行0–3 | block0的lane0–3 | 全有效 |
| 行4 | block1的lane0 | 有效 |
| 不存在的行5–7 | block1的lane1–3补零 | 可计算，不回写 |

每块`cols*4`个元素，分配`ceil(rows/4)*cols*4`；补零发生在pack入口，而不是越界读取后遮罩。各lane沿cols求平方和，不跨lane归约；分母仍cols，不是有效行数。零lane在epsilon下归一化仍为0；ReLU原位语义保持0；unpack只回写有效行，确保填充不污染输出。

## 代码到ARM机制

[main.cpp](src/main.cpp)的`packed_relu`使用`vld1q_f32→vfmaq_f32→vrsqrteq_f32→两次vrsqrtsq_f32→vmaxq_f32→vst1q_f32`。四个FP32 lane对应四行：加载/乘加是独立行统计，rsqrt估计经Newton修正，FMAX逐lane与零比较。不使用SVE、SDOT等可选扩展；标量基线禁自动向量化，仍允许标量FMA。

实际[A64汇编原样函数节选](results/packed.s)中可定位`packed_relu`，包含`fmla.4s`、`frsqrte.4s`、`frsqrts.4s`和`fmax.4s`。FMAX不是水平最大值，FRSQRTS产生修正因子而非完整平方根。指令存在不证明吞吐或目标核时延；函数末尾尾组循环仍执行4lane，只有有效输出参与误差检查。每lane的sum有循环依赖，今天只研究布局与尾组，不顺带声称解决依赖瓶颈。

## 同条件对照与观察

```sh
sh systems_practice/arm/2026-10-26/run.sh release
sh systems_practice/arm/2026-10-26/run.sh sanitize
sh systems_practice/arm/2026-10-26/assembly.sh
```

比较scalar+ReLU、已打包kernel+ReLU、pack+kernel+unpack。三者相同输入和语义，预分配，不计allocation；NEON用近似rsqrt+两次修正、scalar用sqrt，精度单独对double oracle检查。20预热、31批×200次、CPU批均值P50/P95，不是单请求尾延迟。volatile输出防止消除，编译参数相同；顺序、系统频率、缓存未完全控制，结果只适用本机本次。

逻辑代价：设R'=4*ceil(R/4)，packed空间4R'C B，对齐浪费比R'/R；R=1时计算四条lane，内核更慢很合理。pack/unpack至少增加原布局读/写及packed布局写/读，是否值得取决于后续算子保持布局多久。今天直接融合ReLU，不能据此推断完整网络都能沿用该布局；转换开销必须与用户调用边界一同统计。

## 实际来源与验证

2026-10-26实际重读[Tencent/ncnn rmsnorm_arm.cpp](https://github.com/Tencent/ncnn/blob/master/src/layer/arm/rmsnorm_arm.cpp) master，blob`9543033a8bd6c1ad5b228a9802e1820859fd11df`（不是commit），`rmsnorm`的elempack4/1及`RMSNorm_arm::forward_inplace`前半，BSD-3-Clause。原场景多维tensor、gamma/多精度/OpenMP。本例独立启发实现，保留每lane统计与rsqrt修正，新增任意行pack/尾组和ReLU复用；没有复刻ncnn分派。

[Arm ACLE](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)实际核对`vrsqrtsq_f32`与`vmaxq_f32`指令映射；可用A64基础NEON路径。本地资料规则已读，本期不使用MMU/屏障PDF解释数值lane；没有相关PDF阅读声明。Google/知乎检索访问受限，见[主课来源](../../daily/2026-10-26/source.json)。

本机Clang21/Darwin arm64：56个shape、3次shape拒绝、无效lane为0、double参考容限2e-5通过Release/ASan/UBSan。真实结果见[最终Release](results/verified-release.txt)与[sanitizer](results/verified-sanitize.txt)。本次1×513的scalar/packed/含pack批均值P50为0.690625/1.00645/1.04125µs；5×513为1.41854/1.06937/2.16354µs；32×513为9.02354/4.34563/9.04937µs。含pack收益消失或退化，日志保留，不能只摘内核最好结果。没有GPU/NPU/E2E、PMU、板端、热稳定或能耗验证；日期目录按规范不创建JSON。

## 故障链路与生产取舍

1. 不足四行却直接load四行→ASan越界；定位最后block有效行和分配公式→先补零打包再向量计算；代价为padding和额外搬运，回归R=1/3/5/9。
2. packed输出交给row-major后继→数值排列错；用各行不同常量和逐索引oracle区分数值精度/布局问题→增加明确layout合同或一次unpack，重新测含转换时间。
3. 只报告kernel时间→部署反而慢；比较三条同边界计时→小shape走scalar或让后继继续packed；不能假定层数足够摊薄转换。

迁移验收：读取板端`lscpu`/OS/编译器/核拓扑；Linux编译`c++ -std=c++17 -O2 src/main.cpp -o build/linux`，若GCC基线用`-fno-tree-vectorize`代替Clang禁向量化开关；检查ELF/动态库、生成指令、所有边界和长时输入，重新测三条时间；无收益回退scalar。未执行这些Linux命令，不保证某CPU编号属于大核。进一步验收应加入真实上游/下游layout、资源上界、长期负载和端到端精度。

追问：分母为何不是R？padding怎样避免越界？FRSQRTS输出什么？FMAX为何不混行？批均值P95为何不同于请求P95？怎样判断继续packed还是转回row-major？

下一集成案例接入真实相邻算子的布局合同与版本化分派，继续source阶段，不重启28课。
