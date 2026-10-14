# 2026-10-14 OS16：块身份引用与内容互斥

## 承接与边缘问题

承接OS15的名字/引用寿命：推理服务缓存模型分片时，缓存命中仍可能等待内容锁。今天16a“缓存查找和引用”、16b“每块互斥与复用”，现成示例约10–15分钟；不增加作业。

## 主题一

实际[xv6 kernel/bio.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/bio.c) `bread→bget`：先持bcache.lock查(dev,blockno)，找到就增加refcnt，然后释放全局锁，再获取块的sleep lock。关键是**等待内容锁的人也持有引用**。不先pin，第三者可能把同一槽换成另一个块，等待者醒来后读错模型分片。

## 主题二

refcnt保护身份，sleep lock保护内容，valid表示内容已填充。这三个状态不可互换。`brelse`先释放sleep lock，再在全局锁下递减refcnt；引用变0才可作为LRU复用候选。`bread`在内容锁下检查valid并读盘；复用时清valid。`bpin/bunpin`还允许日志事务延长身份寿命。命中只保证身份已找到，不保证无锁等待或内容I/O已完成。

状态示意：`key7 refs1 owner`→第二读者`refs2 waiter`→首读者释放`refs1 owner2`→末读者释放`refs0 reusable`。主机测试另持key8占满第二槽，第三key9请求必须失败。

## 源码与平台差异

仓库mit-pdos/xv6-riscv，riscv分支，实际读取2026-10-14，MIT许可证；文件`kernel/bio.c`全文及LICENSE已读，符号binit/bget/bread/bwrite/brelse/bpin/bunpin。精确commit未固定，文件哈希见[source.json](source.json)。练习为独立C++17模型，保留全局元数据锁→先pin→块内容锁与反序释放；用2槽、first-idle代替LRU，没有磁盘、日志或xv6中断上下文。Linux page cache、macOS缓存和设备DMA并非此教学缓存的实现。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-14/run.sh
SANITIZE=1 sh systems_practice/os/2026-10-14/run.sh
SANITIZE=thread sh systems_practice/os/2026-10-14/run.sh
```

[src/main.cpp](src/main.cpp) Lease用unique_lock管理内容锁，析构先unlock再递减refs；异常释放也遵守同一顺序。构造内容锁失败会回滚pin。测试用条件变量观察refs=2后再请求另一块，避免依赖sleep时序；4线程×5000更新验证内容互斥；复用必须重置valid和value。拒绝负块号。缓存对象必须比所有租约活得久，示例作用域保证，不提供运行期关闭接口。

## 实际结果与验证边界

首轮输出`pinned waiter refs=3 eviction rejected`（key7两个引用+key8一个引用），20000更新、异常refs归零、复用清状态通过。最终[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)、[TSan](results/tsan.txt)与[verification.json](verification.json)保存实际状态。没有采集I/O或推理性能，没有xv6编译/QEMU/Linux/板端运行。

## 工业故障与迁移

①命中后偶发读错块→检查等待线程是否在全局锁内先pin→观察同槽key/ref变化→先pin再等待，牺牲可回收槽数量→回归满缓存与等待者身份。②缓存命中率高却延迟长→区分内容锁队列/首次填充I/O与CPU计算→分段记录查找、锁等待、填充→分片读或缩短持锁时间；不能靠扩大缓存解决所有锁串行。③回收后残留旧数据→确认valid复位与新填充完成点→重新填充后再暴露内容→回归不同key复用。

迁移清单：有界容量、引用上限、异常回滚、内容访问锁、关闭排空、磁盘错误和超时。当前示例耗尽直接报错，不能在生产无界等锁。面试追问：①命中为什么仍要refcnt？②引用与内容锁分别保护什么？③全局锁为何不能跨sleep等待？④valid在哪个锁下读写？⑤first-idle和LRU差在哪里？⑥pin会怎样影响事务与背压？

## 下一节

OS17：日志事务与提交、恢复与持久化边界；把今天的缓存引用连接到掉电后的模型发布。
