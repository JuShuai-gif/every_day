# 2026-10-17 OS18：virtio请求队列与中断完成

## 承接与边缘问题

承接OS17事务持久性，本课18a请求队列、18b完成唤醒，回答“提交返回后能否复用输入”。在边缘推理里，模型输入可能仍被设备持有；提交成功、设备完成、主机回收是三个时点。现成观察约10–15分钟，无额外必做任务。

## 主题一：描述符链与提交

实际读 `alloc3_desc → virtio_disk_rw`：xv6为请求头、数据、状态分别分配三个描述符；不足时释放已分配部分并等待空闲项。填完链后发布avail ring及递增idx，经io_fence后通知MMIO队列。读盘时数据descriptor允许设备写，写盘方向相反。发布顺序防止设备看见索引却读到未完成的描述符；普通C++ mutex不能替代MMIO/DMA协议。

## 主题二：完成后再回收

`virtio_disk_intr`确认中断、读取used ring、检查设备status，将 `b->disk=0` 并wakeup。等待者在锁下重查谓词，看到完成才清理info、free_chain。本次新版源码使用 `sleep_prepare → release → sleep → acquire`，不能照搬旧签名。中断是提示，used队列和谓词才是完成依据；多个完成可能对应一次中断。

状态：`FREE → PENDING → COMPLETE → FREE`，最后一步由wait回收。宿主示例使用shared_ptr不可变输入、mutex/CV和worker模拟这三个边界；保留回收责任、假唤醒防护、错误完成和关闭排空，省略真实virtqueue、DMA、IO fence、中断硬件及磁盘持久性。

## 源码与平台差异

[mit-pdos/xv6-riscv](https://github.com/mit-pdos/xv6-riscv)，riscv分支，2026-10-17实际读取 [kernel/virtio_disk.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/virtio_disk.c) 的alloc3_desc/virtio_disk_rw/virtio_disk_intr完整相关段；MIT许可。SHA256及获取记录见[source.json](source.json)。分支+日期固定阅读事实，完整commit待补。没有修改xv6内核，不声称QEMU运行。例子为独立启发，不复制内核代码。Google直接查询失败，知乎查询无合适已读正文；技术依据为原始源码。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-17/run.sh
cd systems_practice/os/2026-10-17
c++ -std=c++17 -O1 -g -fsanitize=thread -pthread src/main.cpp -o build/tsan
./build/tsan
```

`submit`仅占用槽；即使worker极快完成，第二次submit仍拒绝，直到wait回收。`wait`无请求拒绝；设备失败也先释放输入、归还槽再抛异常。析构在解锁后join，Pending请求仍由worker持有租约并排空。单提交者、单waiter合同，未实现取消、多消费者或超时；实际产品需增加有界取消/错误恢复，不能照此保证实时上界。

## 实际结果与验证边界

[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)、[TSan](results/tsan.txt)均通过2000次复用、4类拒绝/失败、噪声通知、关闭后weak_ptr过期。源码阅读是、版本commit待补、Mac编译运行是；xv6编译/QEMU、Linux、板端全部未验，详见[verification.json](verification.json)。不测时间，不把worker耗时当设备或E2E延迟。

若核验原内核，用相同riscv分支的固定提交，在已有riscv交叉工具链/QEMU环境执行 `make qemu`，跟踪virtio_disk_rw与intr；本机未安装/运行。RISC-V屏障与MMIO映射不直接移植成ARM指令。

## 工业故障与迁移

1. 输入偶发串帧：提交后提前写输入或回收descriptor。先记录请求代次/提交/used状态/回收顺序，用不可变租约和busy拒绝定位；修复为完成后回收，代价是占用在途容量。本例输出固定且2000复用正确，不能替代真实DMA验收。
2. 关闭卡死：持锁join阻塞worker完成，或仅通知未更改等待谓词。最小证据为worker等待的锁和stop/Pending状态；本例先设stop再解锁join，谓词包含stop。真实驱动若设备永不完成，还需超时/复位协议，此例未模拟。
3. 通知已到但wait仍睡：不要数通知次数，检查完成谓词在同一锁下发布；噪声notify不应回收槽。回归设备失败、完成先于wait、满槽和关闭。

迁移验收：确认SDK完成事件语义、设备错误回报、DMA cache维护要求、队列上限、所有权及异常排空；Linux设备实测才算验收。与ARM23区别：本课讲系统生命周期，ARM讲位布局和向量消费。

追问：①avail与used职责？②为什么需要三个descriptor？③wakeup能否代替谓词？④CPU mutex为何不够表达DMA完成？⑤错误状态何时释放槽？⑥超时返回后谁持有输入？

## 下一节

OS19：Linux mmap与驻留、首次触页和预热，开始从教学内核迁移到真实Linux观测。
