# 2026-10-22 ARM27：CPU发布不等于设备完成

## 1. 本节要学会解释的ARM问题

承接26课的PMU计量边界，今天区分CPU线程间发布、DMA缓冲区可见性、SDK完成通知。5–10分钟速览：先看下面状态表，再运行CPU例子并定位STLR/LDAPR，最后读Thor拷贝候选中事件的位置。主要能力层是正确性与产品交付：让异构流水线在取消、异常、停机时仍保持地址有效。上一节能定位耗时，本节先保证“正在测量的缓冲区”没有被错误复用。

工作合同：CPU示例传10000帧，每帧17个int，单生产者/消费者；Thor候选为1/17/4096个FP32，H2D后D2H，无计算kernel。Mac arm64是实际宿主；目标Jetson Thor的CPU与CUDA SM110是不同处理器层次，SM110不是ARM CPU型号。RK3588/Orin本次不执行。

## 2. 先看数据或状态如何变化

| 状态 | 地址谁可以访问 | 允许的下一步 |
| --- | --- | --- |
| CPU filling | 生产者写payload | release发布ready |
| CPU ready | acquire观察到ready的消费者读取 | 消费者release发布free |
| SDK submitted | 设备可能仍读写pinned/device buffer | 客户端取消只标记结果作废 |
| Event completed | 同stream中此前D2H已完成 | CPU读取输出，随后允许复用 |

前三行的CPU握手与设备状态是不同维度。CPU主线程的读取完成可以发布free；真实设备场景必须把free放到最后一次设备使用之后。一个`ready=1`不能同时代表“提交已完成”和“计算已完成”。

## 3. 最小实现怎样对应ARM机制

[src/main.cpp](src/main.cpp)的`publish`是release store，`acquire`是acquire load。实际Apple clang产物[publication.s](results/publication.s)的两个完整函数主体是：

```asm
; publish: x0指向32位原子flag，w1为待发布状态
stlr w1, [x0]
ret
; acquire: x0指向同一flag，w0为返回的32位状态
ldapr w0, [x0]
ret
```

这是真实编译输出，不是手写预期。生产者先写普通payload，再STLR发布1；消费者读到对应的1后，普通payload读取处于C++ happens-before约束内。消费者读完再发布0，生产者取得0后才覆盖，形成反向复用保护。本机编译器选择LDAPR；Linux基本目标可能选择LDAR，不能把某条机器指令当C++标准规定。这里没有DMB，也不需要人为增加cache维护指令。TSan支持本次动态执行无已发现竞争，不是穷尽所有内存序的证明。

[transfer.cu](src/transfer.cu)使用同一个nonblocking stream依次H2D、D2H、event record，event synchronize成功后才读host数据。query允许success或not-ready，其他错误抛出。对象析构先同步stream，再检查每个free/destroy返回值；构造中途失败同样释放已取得资源。同步失败时停止正常回收并终止进程，不能把未知设备状态当空闲。这个保守策略适合教学，不代表完整服务重启恢复设计。

Linux v6.12 `arch/arm64/include/asm/barrier.h`中`__dma_wmb`是`dmb oshst`，而DMA API指南对streaming mapping要求方向正确的sync-for-cpu/device。屏障排序与cache维护不是同一动作；这些内核API由驱动调用，CUDA用户态应遵守SDK分配、提交和完成合同，不能在应用中补一条DMB就声称修好DMA一致性。

## 4. 已写好的对照与观察步骤

在仓库根目录：

```sh
sh systems_practice/arm/2026-10-22/run.sh
sh systems_practice/arm/2026-10-22/run.sh sanitize
sh systems_practice/arm/2026-10-22/run.sh tsan
c++ -std=c++17 -O2 -S systems_practice/arm/2026-10-22/src/main.cpp -o systems_practice/arm/2026-10-22/build/publication.s
rg -n 'stlr|ldapr|ldar' systems_practice/arm/2026-10-22/build/publication.s
```

现成安全反例保持submitted=true、client_cancelled=true、device_completed=false：错误策略允许复用，正确策略拒绝。没有故意执行数据竞争。CPU实际实现则用双向release/acquire传递全部payload；两者分别验证状态区分与CPU数据可见性。

Thor/Linux待执行：

```sh
uname -a
cat /etc/nv_tegra_release
dpkg-query -W nvidia-jetpack nvidia-l4t-core cuda-toolkit-13-0
nvcc --version
ncu --version
sh systems_practice/arm/2026-10-22/run-thor.sh
```

包名不存在时记录原错误，不把缺包查询当不存在CUDA。脚本固定`-arch=sm_110`并在运行时检查11.0，未使用专属后缀。检查API trace时可用`nsys profile --trace=cuda,osrt -o build/transfer build/transfer`（在本课目录），定位最后D2H、event与free的先后；二进制报告留build。今天没有自写计算kernel，ncu/SASS不能给出本课设备租约的正确性证明，也没有新增GPU指令比较游标。

## 5. 工作场景排障与优化取舍

| 症状→候选原因 | 最小辨别证据→修复→回归 |
| --- | --- |
| 取消后偶发上一帧/下一帧混合 | 同slot写入时间早于最后D2H完成，或frame id不匹配→取消仅屏蔽结果，保留地址直到event→取消突发/慢传输回归 |
| 加DMB仍拿到旧数据 | streaming DMA方向或sync范围错误，或者应用根本没有等SDK完成→先查映射/方向/完成合同，驱动用DMA API→在真正板端检查多次复用 |
| 停机析构挂住或异常 | 在途设备失败，主机已停止poll→记录stream同步错误和未完成计数，停止接单并走后端故障恢复→注入提交/完成错误 |

逻辑CPU payload流量每帧至少写68B读68B，10000帧合计1.36MB；这是逻辑字节，不是DRAM/一致性总线流量。原子flag还有轮询流量，busy-wait浪费CPU且受调度影响，因此本课不以吞吐来推荐轮询。实际部署可以用条件变量让CPU等待，但不能删掉设备完成证据。预分配减少分配频率，同时占用固定内存；容量越大不必然降低尾延迟。

## 6. 来源、结果与下一节

2026-10-22实际阅读：

- [CUDA Samples v13.0 simpleStreams.cu](https://github.com/NVIDIA/cuda-samples/blob/v13.0/Samples/0_Introduction/simpleStreams/simpleStreams.cu)，`main`的stream提交、异步D2H和event同步段，原场景是kernel/拷贝重叠。文件BSD-3-Clause头部；本课独立写RAII纯传输适配，保留同stream先后与完成机制，省略kernel与性能对比，没有照抄原样例依赖默认stream的计时方式。
- [Linux v6.12 DMA API指南](https://github.com/torvalds/linux/blob/v6.12/Documentation/core-api/dma-api-howto.rst)，consistent/streaming、barrier、重复映射sync范围；[barrier.h](https://github.com/torvalds/linux/blob/v6.12/arch/arm64/include/asm/barrier.h)，`__dma_mb/rmb/wmb`，GPL-2.0，未复制内核实现。
- 本地`/Users/guhaoran/书籍资料/ARM/VivekPublicRepo/Memory Barrier/ARM64 Memory Barriers..pdf`，SHA256 `570c3452d3e58e9258b86759f0bc3a76328e44e9fb5a5ffab3fae0dfd11c9776`，实际文本阅读物理页1、2、9；许可未核实，只作提纲。页9把CPU→DMA列为DC CVAC/DSB，把CPU→CPU数据也列相似配方。纠正：正常一致性内存的C++发布不要求显式clean cache，DMA须先区分mapping、方向与SDK/驱动合同，不能直接套用配方。没有将PDF其他页视为已审核。
- [CUDA13.0发布说明](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-toolkit-release-notes/)与[CUTLASS4.2.1 Thor命名](https://docs.nvidia.com/cutlass/4.2.1/overview.html)：核实工具链sm_110起点。JetPack7两个入口无法读取，未固定实际L4T/驱动/ncu组合；旧Orin文档不是Thor兼容证据。渠道失败见[研究记录](../../daily/2026-10-22/results/research.json)。

[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)、[TSan](results/tsan.txt)均通过10000帧。实际STLR/LDAPR已保存。无性能数字、无PMU、无板端验证。[Thor尝试](results/thor-attempt.txt)因nvcc缺失失败。日期目录不生成JSON记录。下一节28：持续负载、热稳定与能耗验收。

## 7. 迁移验收与面试追问

验收清单：核实板卡/OS/SDK与CPU拓扑；同stream最后使用后记录事件；验证1/17/4096元素、重复复用、取消与关闭；记录所有CUDA错误；保证成功同步后再析构；长期运行追踪内存/FD/队列上界；测真实请求阶段与热状态。Mac Mach-O不能当Linux ELF部署产物，板上使用原生aarch64编译器构建或使用经验证sysroot交叉编译，检查`file`、`readelf -d`后再运行。

1. 为什么CPU发布ready不意味着DMA已完成？
2. STLR/LDAPR分别约束哪个对象，payload何时可读？
3. 为什么消费者也需要发布free？
4. DMA coherent为何仍可能需要顺序屏障？
5. event记录在D2H前后分别意味着什么？
6. 析构时同步失败，应继续释放还是转入何种故障边界？

## 8. 工作能力与部署闭环

本节形成CPU发布与回收的真实证据、一个不会提前释放的Thor候选，以及可核查的SDK接入点。还缺板端编译、拷贝正确性、真实推理接入、长期稳定性与分段时序。读完应能审查地址最后使用者并定位完成证据，不能据此称完整异构服务已上线。与主课共享取消/回收背景，新增收获是ARM发布指令与设备可见性的边界。
