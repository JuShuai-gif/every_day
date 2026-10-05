# 2026-10-05 CPU 体系结构：统计计数器的伪共享与归约边界

## 工业场景

双相机推理服务由1/2/4个CPU worker统计完成的patch，每个线程每批处理200000条整数权重事件，权重为1～7。要输出每线程精确累计值，不能丢更新，线程创建失败也不能挂起。约束：每批结束时精确；若产品另要求每事件在线可见，则不能采用只在末尾发布的local版本。本课只测CPU统计阶段，不含相机、推理、GPU/NPU或完整请求。

## 概念回顾

缓存一致性以缓存行为单位工作，业务所有权却通常以对象为单位。两个线程各自修改不同的原子计数器，语言层面没有数据竞争，但如果对象落在同一一致性单元，写入仍可能反复争夺所有权。这就是伪共享。把内存序改为宽松只能减少排序约束，不能消除读改写操作，更不能使缓存行同时处于两个核的独占写状态。反过来，单线程的紧密排列有较小工作集，填充可能浪费缓存，因此不能把对齐看作普遍收益。

本课把空间隔离与结果发布边界放在同一条统计链路中。紧密数组作为基线，显式六十四和一百二十八字节步长作为布局对照，每次事件仍执行相同的原子加法；本地累计版本把中间值放在线程私有变量，只在结束时发布。后者减少的是共享读改写次数，必须先确认业务只消费最终结果。若监控依赖逐事件进度，它就改变了可观察合同，不能只拿耗时更低作为上线理由。完成线程的汇合操作提供最终读取边界，计数器本身的宽松操作并不发布其他缓冲区。

基准还依赖线程启动、调度和异常清理。所有线程先到达起跑门，再开始计时与释放，结束计入汇合开销；每个样本是整批工作完成的墙钟时间，不是单请求延迟。起跑门由互斥锁和条件变量保护，谓词等待处理提前通知与伪唤醒。构造线程中途失败时必须先发布取消并唤醒已创建线程，然后由资源所有者汇合，否则异常展开可能永久等待。布局、语言同步和系统调度共同决定结果；本机计时支持性能现象，但没有硬件计数器时不能把某次差异全部归因于缓存一致性。

## 知识图谱

`worker独占对象 → 原子relaxed读改写 → 地址/步长 → 一致性单元竞争 → 整批CPU时间`

`起跑门mutex/CV → 线程执行 → join → 最终读取`；异常分支 `构造失败 → abort/go → notify_all → RAII join`。

前置：C++17原子、互斥锁与对象寿命。不能混淆：data race和false sharing、原子性和发布、ABI对齐和硬件cache line、进度可见和最终快照。C++保证join后的可见性；Linux futex或macOS等待实现是平台细节，不是语言保证。

## 编码练习

**唯一必做任务，25分钟：**在已完成的`trial`框架中增加“每64个事件发布一次累计增量”的模式，保留最后不足64项的尾批。前5分钟写出允许的进度滞后合同，15分钟实现并覆盖0/1/63/64/65条，最后5分钟复用现有计量口径比较。若业务要求逐事件可见，明确拒绝采用该模式。现成四种实现和其他栏目均是阅读材料，不是额外作业。

## 文件说明

- [src/main.cpp](src/main.cpp)：packed、64/128隔离、local四种完整实现；故障注入与独立oracle。
- [build.sh](build.sh)、[run.sh](run.sh)、[source.json](source.json)、[verification.json](verification.json)、[results](results/)。
- 今日附加：[8-bit优化器](../../quantization/2026-10-05/optimizer_8bit/README.md)、[ARM13 FP16](../../arm/2026-10-05/README.md)、[OS08](../../os/2026-10-05/README.md)、[C++17 07](../../cpp17/2026-10-05/README.md)、[两篇论文](../../paper/2026-10-05/README.md)。

实际读过[folly/lang/Align.h](https://github.com/facebook/folly/blob/main/folly/lang/Align.h)的`hardware_destructive_interference_size`、`cacheline_align_v`与`valid_align_value_fn`；仓库https://github.com/facebook/folly，main，读取2026-10-05，精确commit未固定，Apache-2.0。原场景为跨平台布局/对齐工具；保留“隔离量是实现选择而非可移植硬件常数”的机制，省略Folly移植层和ABI宏。本例是**源码启发的独立实现**，不复制Folly代码。上游fallback ARM值64不证明当前Mac行长，故同时对照128。Google与知乎访问失败，未引用其文章，具体尝试见source.json。

## 编译与运行

从仓库根目录：

```sh
sh systems_practice/daily/2026-10-05/run.sh release
sh systems_practice/daily/2026-10-05/run.sh sanitize --quick
sh systems_practice/daily/2026-10-05/run.sh tsan --quick
```

本机Apple clang 21、arm64、C++17。目标Linux原生编译可使用`CXX=g++ sh run.sh release`（在课程目录）；未在Linux/板端运行，不将Mach-O迁移当作Linux产物。

## 正确性验证

36个边界trial覆盖0/1/7/257条×1/2/4线程×3实现；逐槽与独立串行权重和比较。三处线程构造失败注入验证释放与退出，0线程拒绝。Release、ASan/UBSan、TSan通过。TSan不证明缓存行假设或所有内存序推理。64字节版本在性能测量中同样逐槽校验，不是仅跑无校验benchmark。

## 性能分析

每模式3次预热、21次采样，轮换模式顺序；每样本200000事件/worker。计时从打开gate前到join结束，排除创建、分配、输入与oracle；包含唤醒、调度、执行和join。P50/P95使用排序位置10/19，样本很少，不作尾延迟SLO保证。local相对atomic模式改变中间可见性，只有最终快照合同下才可比較。64/128的atomic模式才是只改变布局的对照。

在Linux板端先`lscpu -e`确认拓扑，`perf list`查看支持的事件，再对`./build/release`做`perf stat -r 5 -e cycles,instructions,cache-misses,context-switches,cpu-migrations`。这些通用事件不足以单独证明伪共享；有支持时补`perf c2c record -- ./build/release`与`perf c2c report`，ARM平台不保证支持。结合地址、线程迁移、单线程对照与真实PMU解释，不把cache miss等同所有权传输。

## 实际运行结果

首轮实测在[release.txt](results/release.txt)：4线程整批P50，packed 6.49692 ms、64隔离0.380417 ms、128隔离0.378625 ms、local 0.111375 ms。1线程前三者约0.43～0.45 ms，隔离无稳定优势。仅本机CPU统计微基准；无GPU/NPU/E2E数字，没有绑定核心或采PMU，结论为隔离候选值得迁移复测。格式化后[最终复验](results/verified-release.txt)4线程packed/64/128/local的P50分别6.37029/0.378167/0.378292/0.108875ms；[Sanitizer](results/verified-sanitize.txt)与[TSan](results/verified-tsan.txt)通过，首轮记录保留。

## 工程注意事项

显式128字节对齐会放大每线程对象，不能直接改变公共ABI。对小对象数量/内存预算先计算`workers*sizeof(slot)`。累计值使用uint64，当前上界32×200000×7远低于范围；扩展长期服务必须定义溢出策略。用户线程函数在本例不抛出，业务回调的异常传递需要额外协议；不把本例当完整推理线程池。监控中间快照可读原子，但只join保证所有线程的最终批次已完成。

## 工业故障与面试追问

1. 加线程却变慢→可能是伪共享/迁移/频率变化→比较相同atomic的packed与隔离、单线程、迁移计数→隔离并复测；代价是内存膨胀，不能凭一次计时断言缓存行尺寸。
2. 异常退出卡死→第2个线程创建失败，前一个仍等gate→注入失败定位等待谓词→先abort+唤醒再join；回归0/1/3失败位置。
3. 监控进度长时间为零→local只在末尾store→检查采样合同→定期批量发布或恢复每事件atomic；牺牲部分优化换实时可见性。

面试追问：relaxed为何不消除伪共享？对象对齐与数组步长有什么关系？join保证什么？只有一个核时隔离收益如何变化？线程构造失败为何先唤醒？如何区分true sharing与false sharing？为什么批P95不是请求P95？

## 自测问题

若监控线程要求每1毫秒读取准确累计值且worker可能在任意事件后被抢占，怎样判断“每64项发布一次”的方案是否满足合同，需要哪些额外证据？
