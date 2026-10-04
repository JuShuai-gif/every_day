# 2026-10-04 OS07：copyin/copyout与跨页边界

## 承接与边缘问题

承接walk与映射权限，今天07a讲用户指针拷贝，07b讲跨页访问。推理服务的控制请求结构体恰好跨页时，为什么返回失败仍可能改了目标前半段？本课给独立C++17状态模型，非xv6内核移植；10–15分钟速览，现成代码不增加作业。

## 主题一：地址不是已验证的对象

实际读[xv6 vm.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/vm.c)的copyin/copyout/copyinstr/vmfault及[syscall.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/syscall.c)的argaddr/fetchaddr。读取2026-10-04 riscv分支，MIT许可证读过，未固定commit。当前接口含`psz`，不同于旧教材签名；argaddr只取寄存器参数，fetchaddr再检查进程范围并调用copyin。源码链说明“把整数转指针”不能证明用户地址可用。

## 主题二：分段复制不是事务

一段跨页copy按`min(剩余长度,页大小-页内偏移)`分段；每轮重新翻译并检查。当前源码还可能vmfault分配延迟页，copyout拒绝只读页。返回0/-1的合同不表示失败会回滚前缀。模型用16字节页代替真实4096：从14复制4字节，首轮2字节，第二页缺失则停，前缀已更新。生产请求若必须全有或全无，先复制到候选对象、完整验证后swap提交；输出到用户空间的事务性不是一个vector swap就能保证。

## 源码与平台差异

[来源记录](source.json)；本课独立模型保留逐页权限/部分进度，省略真实PTE、多级walk、页分配/缺页重试、并发撤销映射和MMU异常。模型返回已复制字节，以显示部分失败；不是xv6 API的返回类型。user与write是模型布尔，不对应AArch64位号。

[Linux用户访问文档](https://docs.kernel.org/core-api/mm-api.html#user-space-memory-access)说明get_user/put_user在允许缺页时可能睡眠，不能因指针检查成功就在持自旋锁的路径任意拷贝。macOS宿主程序没有调用内核copyin。xv6 RISC-V、ARM页表和Linux uaccess不能互换。

本地辅助读物：`ARM-MMU/MMUAdvanced/MMU-Chapter 05 PAGE TABLE LEVELS AND DESCRIPTOR FORMATS.pdf`，物理第1页/5.1，SHA256 `9f5d73354fd147afe02a5101fb3e7a313da2aa8465635fac1ffa1fc87d63e187`，实际渲染阅读。该页把层级与granule/VA位数关联，未给copyin接口；仅作地址翻译提纲，不用其推断权限位或拷贝原子性。已知四处勘误见[约束](../../docs/arm/LOCAL_LIBRARY.md)，本次没有审完该PDF。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-04/run.sh release
sh systems_practice/os/2026-10-04/run.sh sanitize
```

[src/main.cpp](src/main.cpp)包含2450个start/length组合、最大整数地址、空拷贝、用户权限拒绝、只读页拒绝写、缺页后两字节前缀与业务snapshot回滚。源码没有解引用不可信真实地址，失败演示不执行C++未定义行为。

若已有xv6 checkout与RISC-V工具链，在该checkout执行`git rev-parse HEAD; make qemu`，进入shell执行`usertests`观察原测试；本课没有内核补丁、不声称目标测试通过。不要把当前分支签名改成旧教材签名。

## 实际结果与验证边界

[Release](results/final-release.txt)/[ASan/UBSan](results/final-sanitize.txt)均退出0，[verification](verification.json)。实际源码已读、本地PDF一页已读、宿主已运行；xv6编译/QEMU/Linux uaccess/板端未运行，没有任何设备或内核性能数字。

## 工业故障与迁移

1. 请求只有跨页才损坏：先看失败返回和实际复制前缀，区分长度错误与第二页权限/存在性；入站用候选缓冲提交，代价一次临时存储，回归14+4及所有页界。
2. 用户声称地址有效而内核失败：argaddr只提取整数，映射可缺失/只读/撤销；记录操作方向和目标页状态，再选正确uaccess及失败返回；不能增加一次预检查就消除TOCTOU。
3. 最后一页长度异常：避免先做无约束addr+len溢出；先比较addr上界，再用`len<=size-addr`。本模型按页界提前停止，UINT64_MAX用例不访问数组。

迁移验收：明确成功/部分失败合同，输入验证后业务对象无部分提交；目标内核版本签名与缺页策略核实；锁上下文允许睡眠；目标板分别验证，不把模型bool当硬件权限位。追问：①为什么argaddr不验证内存？②copy失败是否回滚？③只读页与未映射页路径有何不同？④检查后撤销映射怎么办？⑤候选提交能解决输出到用户的事务吗？⑥为什么空copy不一定验证地址？

## 下一节

08：地址空间增长＋首次触页/延迟分配，解释模型第一次请求的延迟。
