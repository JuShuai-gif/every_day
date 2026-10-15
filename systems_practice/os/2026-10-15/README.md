# 2026-10-15 OS17：日志事务提交与崩溃恢复

## 承接与边缘问题

承接OS16缓存pin。17a讲日志事务与提交，17b讲恢复与持久化边界。边缘模型发布更新多个文件块时，掉电可能留下新旧混合状态；仅有进程互斥不能提供持久化原子性。本课提供现成状态机，不增加编码任务。

## 主题一：什么时候才算提交

实际读取xv6 `kernel/log.c` 的 `begin_op/end_op/log_write/commit/write_log/write_head`。begin_op按最坏块数预留容量，多系统调用可同批提交；log_write只登记blockno并pin，重复块吸收为同一条。最后一个end_op发起commit：**日志数据块 → 非空header → 安装home块 → 清空header**。header写是教学协议提交点，提交后home只写一半也可恢复。

`log_write→bpin`连接上一课：缓存项不能在日志真正写出前被复用；`install_trans(0)`写home后bunpin。持锁不能睡眠，所以commit在log.lock外执行，committing状态阻止新事务混入。不要把每个write系统调用都当成独立已落盘事务。

## 主题二：重放与假设

`initlog→recover_from_log→read_head→install_trans(1)→write_head`。非空header表示有效redo，重放覆盖home，清零以后再恢复也不改变结果。日志重放必须幂等；不是把“加11”再执行一次，而是写完整的新块内容。

| 崩溃点 | 恢复结果 |
| --- | --- |
| 日志数据已写、header尚空 | 旧home |
| header有效、home未装/装一半 | 新home，重放补齐 |
| home完整、header尚未清 | 再写相同新home |

教学推导假定块写原子、顺序持久化、header可信。真实设备有写缓存、重排、torn write与介质错误；本C++模型不能证明fsync或掉电保障。xv6没有因此自动获得生产journal的校验、barrier协议和完整损坏恢复。

## 源码与平台差异

2026-10-15读 [mit-pdos/xv6-riscv riscv分支 log.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/log.c)，MIT，SHA256 `62c1a96498b2e345f24ddf13bc81b7bdee89f845d6d8d553f07dbb43ff498f71`；源码日期/哈希固定，commit待补。文件含新版sleep_prepare/sleep分离，不套旧版sleep接口。来源细节见[source.json](source.json)。本例是**独立启发**持久状态机，保留写序和幂等，省略并发缓存/QEMU/磁盘驱动。

Linux模型发布应另核实文件系统与设备承诺：同目录创建临时文件、完整写入、同步文件、rename、同步父目录是候选协议；rename只解决名字可见性，不能单独证明掉电持久性。macOS的同步语义、Linux目录fsync和设备缓存不同，不能用本例PASS替代真实电源切断测试。

## 现成观察示例与命令

```sh
# 本课目录，clang++或目标Linux g++，均C++17
sh run.sh release
sh run.sh sanitize
```

[src/main.cpp](src/main.cpp)枚举7个崩溃点；old=[1,2]、new=[11,22]，检查原子代际与二次恢复幂等。反例先提交header再写完数据，得到[11,0]，安全重现错误协议而非执行UB。非法header拒绝属于本例防御合同，**上游read_head并无本例同款校验**，不能归因给xv6。

## 实际结果与验证边界

[release](results/release.txt)与[sanitize](results/sanitize.txt)均通过。源码读取是、版本哈希是、宿主编译运行是；xv6编译/QEMU/Linux实机/目标板/真实持久性均否，见[verification](verification.json)。无I/O或设备时间，未测性能。观察模型中的状态复制不涉及真实块设备。

## 工业故障与迁移

1. 模型重启后新旧块混合：候选是数据没落盘而header先持久化；保留写顺序trace/校验和，区分程序中顺序与设备实际顺序；修复flush/barrier协议，回归各阶段崩溃注入及真实掉电，代价是同步延迟。
2. 恢复后越重启越错误：redo记录的是增量非幂等操作，或header清理时机错；重复同一日志两次比对；改为完整块映像或加入序号/应用幂等合同，不能只靠锁。
3. 并发写卡住：检查outstanding、committing、预留上界与被pin缓存，不能只调大日志。确认所有失败路径end_op，避免资源泄漏；扩大日志会增加恢复与提交尾延迟。

验收要求：固定FS/挂载/驱动/介质版本，保存文件+目录同步返回值，测试空间耗尽、短写、失败回滚、旧读者句柄和每个发布阶段崩溃；真实板端另验。Google检索页面未作来源正文，知乎403；采用依据为上述真实源码。

追问：①为何先日志后header？②提交与安装有什么差别？③日志吸收为何需要pin？④幂等如何验证？⑤rename和持久性为什么是两层合同？⑥设备缓存怎样使教学假设失效？

## 下一节

OS18：virtio请求队列与中断唤醒，继续区分主机提交、设备完成及持久化。
