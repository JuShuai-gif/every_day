# 2026-10-13 OS15：文件描述符、inode与路径生命周期

## 承接与边缘问题

承接14的睡眠锁，本节15a讲FD/file/inode层级，15b讲引用与路径名生命周期。模型热替换时，旧请求为什么继续读旧文件？本节10–15分钟速览与现成C++17示例，不新增编码作业。输入是两个3字节文件OLD/NEW，输出是对FD偏移、inode与路径移除的真实断言。

## 主题一

xv6进程ofile中的FD指向struct file，它持有偏移、读写权限、引用计数以及inode指针。`filedup`增加file.ref，`fileread`在inode锁内readi后推进file.off；因此dup得到的两个FD共享一个偏移，重新open同一路径获得另一个file偏移。inode描述磁盘对象及其缓存状态，目录项只是名字到inum的映射。多个层级的“引用”不是同一计数。

调用链：sys_dup→filedup；sys_read→fileread→ilock/readi/iunlock。测试old读O，dup随后读L，重新open的independent仍读O，分别验证共享file与独立file。这里只演示顺序调用，不据此推导多线程pread等接口性能。

## 主题二

`sys_unlink`清目录项并减少nlink，未直接把仍被打开的inode销毁。`fileclose`最后一个file引用才在事务中iput；本次读到的新版iput先保存dev/inum，判断最后内存引用且nlink=0，itrunc后减少ref，最后ifree，避免复用期间丢失身份。nlink=0但FD有效是一种正常状态，不是泄漏的充分证据。

| 事件 | 路径model | 旧FD | 新FD |
| --- | --- | --- | --- |
| 初始open | inode A / OLD | A | 无 |
| rename candidate→model | inode B / NEW | A，nlink0仍可读 | 新open得到B |
| unlink model | 路径不存在 | A仍可读 | B仍可读 |
| 最后close | 无名字 | 相应内存引用释放 | 何时持久释放依赖文件系统 |

## 源码与平台差异

2026-10-13实际读取[MIT xv6-riscv riscv分支](https://github.com/mit-pdos/xv6-riscv)，MIT许可；[kernel/file.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/file.c)的filedup/fileclose/fileread，[fs.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/fs.c)的iput/ifree，[sysfile.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/sysfile.c)的sys_unlink。精确commit未固定，保存读取日期与文件SHA：[source.json](source.json)。

原场景是教学内核文件系统；本例为**独立POSIX观察程序**，保留名字/打开对象分离，省略日志、缓存、块分配和并发rename竞争。xv6不提供本课宿主用到的rename系统调用；不要把宿主发布步骤说成xv6已有功能。Mac与Linux的对象生存期可类比，但磁盘持久化、目录fsync和错误语义必须按目标文件系统核实，本例没做断电实验。ARM硬件一致性与文件对象引用是不同层次。

## 现成观察示例与命令

从项目根：

```sh
sh systems_practice/os/2026-10-13/run.sh release
sh systems_practice/os/2026-10-13/run.sh sanitize
# 已有Linux/板端环境，同一课程目录
CXX=g++ sh run.sh release
```

[src/main.cpp](src/main.cpp)用RAII Fd和受控build/fd-XXXXXX临时目录，读写处理EINTR/短传输，清理错误也报告。mkdtemp防重名覆盖。rename后fstat验证新旧ino不同且旧nlink=0，再检查unlink后open失败ENOENT而已打开FD可读。最后安全展示in-place overwrite反例：同inode内容被改，另一个FD看到BAD；持有FD并不提供内容不可变快照。

## 实际结果与验证边界

Mac Release与ASan/UBSan通过dup共享偏移、独立open偏移、rename旧/新版本、nlink0、unlink后存活、ENOENT以及原地改写反例。[最终日志](results/verified-release.txt)、[验证](verification.json)。无时延数据；CPU/GPU/NPU/E2E均不据此声称提升。xv6编译/QEMU、Linux实机、目标板均未运行；未固定commit也单列待补。

## 工业故障与迁移

故障一：发布NEW后部分请求仍读OLD→旧FD持有旧对象，通常是预期而非缓存错误→fstat比对dev/ino和请求代次→接受在途旧版本并延迟回收，代价是双版本磁盘/内存峰值。若必须强切，需请求代次协议，不能只rename。

故障二：旧请求读到半新半旧→直接truncate/覆盖同一inode→检查发布器open flags与旧FD的inode→写完整候选后同文件系统rename；代价是额外存储。rename原子名字替换不等于掉电持久，持久化协议下一日志课深入。

故障三：文件已删除但磁盘未释放→仍有FD/映射引用→Linux查看进程fd及deleted对象，再对照本例nlink0→关掉真正所有者；不要粗暴终止无关请求。

迁移验收：同一文件系统、候选校验完整、短写/失败不发布、旧请求语义明确、存储峰值有界、close可追踪；断电恢复与并发发布另测。Google/知乎组合查询做过但未采用匹配的一手作者案例，技术依据为实际源码，检索记录见source。

追问：①FD和file.ref分别属于哪里？②dup为何共享偏移？③nlink0为何还能读？④rename保留旧FD是否保证内容不可变？⑤为何iput要在事务内？⑥多代模型发布需要哪些额外资源上界？

## 下一节

第16：buffer cache查找/引用与每块互斥/复用，解释“命中缓存”与“无需等待”为什么不同。
