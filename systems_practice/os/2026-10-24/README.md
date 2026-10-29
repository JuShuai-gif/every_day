# 2026-10-24 OS24：主机提交与设备完成；租约/事件与回收

## 承接与边缘问题

承接23课DMA地址与同步所有权。本课24a讲提交不等于完成，24b讲缓冲区租约和事件回收。场景为32元素传感器输入：调用方超时后放弃结果，但设备可能仍在读输入；直接复用会把下一帧混入上一帧。10月24开始、10月25完成核验，现成附加示例。

## 主题一

提交成功只建立异步工作的队列关系。设备完成事件必须记录在最后一次使用之后；CPU mutex/release-acquire并不能让设备提前结束。状态图 `free→submitted→complete→free`；取消只置abandoned，不把submitted变free。输出可读取要求completed且未放弃/失败。教学模型由测试显式触发complete，不会谎称产生真实中断或DMA。

## 主题二

资源以generation租约归属某一次提交，旧callback不能释放新请求的slot。reclaim验证generation和完成状态；关闭也必须先排空或依据SDK合同确认停止，再释放pinned/device缓冲区。结果可用性与资源可回收性是两条轴：取消/失败可令结果无效，但仍须等待设备最后一次使用结束。生产系统要处理generation溢出与多槽/并发，当前单线程1000次教学范围不会绕回。

```text
CPU准备 → 提交并交出租约 → H2D / kernel / D2H → event完成 → 回收
                   └ 超时：abandoned，只丢弃结果 ────────────┘
       CPU锁保障主机元数据；设备event保障SDK定义的完成边界
```

## 源码与平台差异

已实际读 [NVIDIA cuda-samples v13.0 asyncAPI.cu](https://github.com/NVIDIA/cuda-samples/blob/v13.0/Samples/0_Introduction/asyncAPI/asyncAPI.cu) `main`：pinned allocation→异步H2D→kernel→异步D2H→eventRecord→eventQuery；BSD-3-Clause文件头已读。blob `5a38d3ab145202c95721ae2af738cdb8d3700526`，读取2026-10-24～25。上游示例部分异步调用未逐次包装错误检查、query循环也未完整区分非NotReady错误；本课明确补足，不能将SDK示例当生产错误处理模板。[source.json](source.json)记录范围。

[main.cpp](src/main.cpp)是独立状态机启发实现，不是CUDA Samples改写或真实OS驱动。目标路径复用本仓库10月22日的[完整RAII transfer.cu](../../arm/2026-10-22/src/transfer.cu)：stream/event/pinned host/device部分构造回滚，query区分NotReady/Success/错误，析构前stream同步。它仅H2D/D2H，无自写GPU计算kernel；不产生新的PTX/SASS或性能宣称。其sm_110构建和能力11.0检查保留。

xv6无该CUDA后端；Mac只能运行状态合同。Linux事件/驱动是SDK完成语义的实现边界，不等同于C++锁内存模型。Google/知乎研究访问未取得可核验正文，沿用[共同访问记录](../../daily/2026-10-24/GPU_GUIDE.md#研究访问边界)，不凭二手片段下设备结论。

## 现成观察示例与命令

```sh
# 仓库根目录；无需安装或下载
sh systems_practice/os/2026-10-24/run.sh release
sh systems_practice/os/2026-10-24/run.sh sanitize
# 仅Thor已配置CUDA13+；普通sm_110
sh systems_practice/os/2026-10-24/run-thor.sh
```

测试每轮32个同值输入，验证sum=32*i；1000轮注入取消/设备失败标记、早复用、提前回收、旧完成和重复完成。模型用array拥有缓冲区，失败不会通过UB制造“偶发成功”。它没有线程竞争测试，不把确定性枚举当调度器证明。

## 实际结果与验证边界

[Release](results/verified-release.txt)、[ASan/UBSan](results/verified-sanitize.txt)：1000轮，400交付、600放弃/失败、5099拒绝，末尾可回收。真实SDK尝试[日志](results/thor-attempt.txt)缺nvcc；设备/驱动/DMA/事件完成未验证。无性能计时，无xv6/QEMU/Linux内核运行。[verification.json](verification.json)分栏记录；没有把CPU模型标为Thor成功。

## 工业故障与迁移

| 触发→信号 | 根因与诊断 | 修复/取舍 |
| --- | --- | --- |
| 超时即free→下一帧污染上一帧 | 逻辑取消被误当设备停止；日志关联generation与event完成 | 保留租约至完成，代价是超时请求仍占槽，需要背压 |
| 旧完成callback到达→新请求被提前释放 | token未校验或绕回；延迟旧callback注入 | generation校验，生产规划足够宽计数与安全绕回 |
| query非NotReady错误仍自旋→永久占槽 | 错误被当未完成；打印原始CUDA错误 | 显式终止/隔离失败流，只有确立完成后释放；不能盲目free |

面试追问：①提交返回保证什么？②取消为何不自动可回收？③event应记录在哪条流、哪一步之后？④旧callback如何识别？⑤CPU acquire为什么不能替代设备完成？⑥关闭时哪些资源必须按顺序等待和释放？

## 下一节

25课：映射/读取的选择与文件更新/读者寿命，把设备租约延伸到模型文件热更新；不新增强制自测。
