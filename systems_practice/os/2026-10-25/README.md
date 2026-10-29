# 2026-10-25 OS24：提交、完成与缓冲区租约

## 承接与边缘问题

接OS23的DMA所有权，今天24a区分主机提交与设备完成，24b连接事件、租约和回收。相机请求超时后用户不再需要结果，设备仍可能读取该输入；立即把slot交给下一帧会污染两次请求。现成状态示例约10分钟，无新增作业。

## 主题一：返回不等于完成

用户态异步API返回通常只证明请求被接受。数据访问结束需要对应流的完成事件，错误完成也必须收尾。已读CUDA Samples v13.0 `simpleStreams.cu` 的主流程：pinned分配→多个stream提交kernel与cudaMemcpyAsync→record event→synchronize→correct_data→释放。原样例依赖默认流同步关系做部分计时，不能未经核查就迁移到nonblocking/per-thread默认流；工程方案在真实执行流末尾记event。

## 主题二：取消意图与物理回收

```text
free → submitted(token,input immutable) → complete → reclaim → free
              ↓ cancel(放弃结果)          ↑ failure也必须完成
              submitted(abandoned) ──────┘
```

本课`Slot`保存generation，旧完成通知不能释放新请求。`cancel`只改结果交付意图，不撤销设备访问；`reclaim`必须看到相同token且complete。超时不是完整错误恢复，生产驱动lost/device-reset需要独立状态，不能直接改free。

## 源码与平台差异

今日实际读[NVIDIA/cuda-samples v13.0 simpleStreams.cu](https://github.com/NVIDIA/cuda-samples/blob/v13.0/Samples/0_Introduction/simpleStreams/simpleStreams.cu) 的`AllocateHostMemory/FreeHostMemory/correct_data/main`流、事件和释放片段，BSD-3-Clause。原场景是复制与计算重叠，本课是独立C++17合同状态模型，保留完成前禁止复用，增加取消、generation与错误注入；不模拟DMA、调度、驱动或CUDA kernel。[source.json](source.json)。xv6不含此CUDA后端；Mac跑模型不等于Linux/设备验证。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-25/run.sh release
sh systems_practice/os/2026-10-25/run.sh sanitize
```

1000个请求填32个整数；偶数/奇数取消、每五次设备失败，检查提交期间重写、完成前回收、旧generation、重复完成和取消后的结果读取均拒绝。模型单线程枚举状态，不通过制造C++数据竞争演示错误。[src/main.cpp](src/main.cpp)。

真实Thor事件/RAII迁移入口复用[10月22日传输候选](../../arm/2026-10-22/README.md)的构建运行说明（固定sm_110）；该代码今天未重测，不标本课设备成功。迁移时在D2H后的**同一流**record，查询not-ready时保留租约，success后才回收；其他错误记录并进入恢复流程。不要以CPU acquire/release替代device event。

## 实际结果与验证边界

[Release](results/verified-release.txt)与[ASan/UBSan](results/verified-sanitize.txt)：1000周期、400交付、600取消/失败、5099拒绝，最终free。源码读取是，版本固定tag是，宿主编译运行是；xv6编译/QEMU、Linux、实际异步设备及板端均未验。未测性能；没有设备/E2E延迟数字。[verification.json](verification.json)。

## 工业故障与迁移

1. 超时后新帧偶发错→取消被等同完成→记录token/submit/cancel/event/reclaim顺序，暂停复用检查→延后回收，代价是超时期间仍占buffer，需要有界背压。
2. 请求B无故被释放→A的延迟回调打到复用slot→日志校验slot+generation→拒绝旧token；生产generation应使用足够位宽并处理回绕，教学仅1000周期不覆盖长期回绕。
3. 关闭时程序释放输入→队列空但设备仍在途→区分queued/inflight，正常退出等待事件并排空；设备失联不能无限假等，需驱动级恢复合同。当前模型不声称实现该恢复。

迁移验收：实际SDK版本、event所属stream、取消与设备完成分离、失败后资源回收、在途上界和关闭排空，配合设备工具检查访问越界。候选原因不是实板已观测故障。

追问：①submit成功保证什么？②取消为何不等于撤销访问？③事件应放在哪个流的何处？④generation解决哪类复用错误？⑤CPU内存屏障能否证明DMA结束？⑥设备失联时如何界定安全回收？

## 下一节

OS25：模型文件映射/读取选择，与热更新后的读者寿命。今天游标只推进24；异步设备验证保留backlog。
