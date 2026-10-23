# 2026-10-23 OS 第23节：DMA地址与所有权转移

## 承接与边缘问题

承接epoll“就绪不等于完成”。本节23a CPU/物理/DMA地址，23b 方向、同步与所有权。场景是17元素输入在CPU–NPU之间复用：CPU能读到的虚拟地址不能直接写进设备描述符。现成合同模型提供观察，不增加作业。

## 主题一

CPU虚拟地址经页表到物理地址；设备看到DMA地址，IOMMU/桥接可能再次转换。Linux `dma_map_page_attrs`先检查方向与mask，再分派direct、IOMMU或device ops；返回dma_addr_t且必须调用dma_mapping_error检查失败。直接把`void*`强转整数，既没建立映射也没约束设备寻址范围。用户态SDK的buffer句柄不等于内核DMA API句柄。

## 主题二

streaming映射的map/unmap及sync调用定义CPU/设备访问阶段，TO_DEVICE表示设备读，FROM_DEVICE表示设备写，BIDIRECTIONAL不是“可以同时无同步访问”。重复映射期间先等设备完成，再sync_for_cpu读，CPU改完再sync_for_device交还。coherent分配降低显式cache维护需求，但仍需正确发布描述符与完成协议；CPU fence不等于设备完成。

状态：CPU写入41→sync_device→设备持有→设备写42/完成→sync_cpu→CPU读42。本课vector复制是可观察的逻辑状态模型，不模拟真实cache、IOMMU或DMA硬件；不会把41/42结果标成Linux DMA验证。

## 源码与平台差异

实际读取[Linux v6.12 mapping.c](https://github.com/torvalds/linux/blob/v6.12/kernel/dma/mapping.c)的dma_map_page_attrs、__dma_sync_single_for_cpu、__dma_sync_single_for_device；后两者同样分派direct/IOMMU/ops。原场景为Linux内核DMA映射层，GPL-2.0，示例独立且没有复制内核代码。保留状态和错误边界，省略真实设备、DMA mask、scatter-gather、缓存维护与中断。[source.json](source.json)记录文件blob与阅读日期。

另实际读取[Linux DMA API指南](https://docs.kernel.org/core-api/dma-api-howto.html)的CPU/DMA地址及streaming同步章节。xv6并不提供这套现代Linux DMA接口；macOS宿主只验证合同模型，不执行Linux DMA。

本地`ARM64 Memory Barriers..pdf`物理第9页，SHA256 `570c3452d3e58e9258b86759f0bc3a76328e44e9fb5a5ffab3fae0dfd11c9776`，实际读取5.2–5.6。该页用DC CVAC/CIVAC配DSB描述DMA方向，属于未说明一致性域、cacheline和OS映射的简化配方；在Linux驱动不得直接用它替代DMA API。资料许可未核实，只记录摘要，未复制PDF。其CPU代码同步序列也承接已有勘误，不作为本课实现依据。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-23/run.sh release
sh systems_practice/os/2026-10-23/run.sh sanitize
# 仅Linux目标只读检查：缺权限/文件保留错误，不把缺失当0
uname -a
cat /sys/kernel/debug/dma-api/error_count
```

[src/main.cpp](src/main.cpp)的token是独立逻辑ID，不是假物理地址。验证6个失败：设备持有时CPU写、完成前同步CPU、错误token、未同步CPU读、空映射、注入映射失败。RAII回收计数在所有路径归零。真实驱动验收应打开对应内核DMA调试配置，记录映射失败、map/unmap配对、方向/长度一致性及SDK约定；没有设备就保留待验。

## 实际结果与验证边界

本机Release及ASan/UBSan通过1001周期、6拒绝、live=0。见[verification.json](verification.json)、[results/verified-release.txt](results/verified-release.txt)。没有编译Linux内核、QEMU/xv6、RKNN板端或DMA设备，没有时间与带宽结论。模型只验证协议拒绝条件。

## 工业故障与迁移

| 链路 | 最小区分证据 | 修复及验收 |
| --- | --- | --- |
| CPU指针当DMA地址→IOMMU fault或设备读错 | 对照映射返回值/描述符、DMA API debug、内核fault日志 | 采用SDK或driver映射API、检查mapping_error；不能用强转消除警告 |
| 忘sync或方向错→旧数据/只在某板失败 | 标记owner/完成事件/方向、CPU与设备校验和 | 修正访问阶段，等完成后再同步；coherent板成功不证明streaming板正确 |
| 超时后unmap→设备仍在写 | 提交/完成/unmap时间线 | SDK取消或排空完成后回收；超时是请求策略不是硬件完成 |

迁移先核实设备、内核、SDK、IOMMU和coherent/streaming合同，再做零长度、尾部、映射失败与长时间复用。用户态不能调用内核函数；跨平台只迁移所有权设计。

追问：为何DMA地址不一定等于物理地址？TO_DEVICE从谁的视角定义？coherent还需要哪些同步？sync_for_cpu是否等待设备任务？超时后何时可以unmap？同一cacheline交给不同owner有什么风险？

## 下一节

第24节主机提交/设备完成与租约/事件回收，把今天逻辑owner接到已核实的SDK完成信号。
