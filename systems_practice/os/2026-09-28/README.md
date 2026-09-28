# 2026-09-28 OS 第01节：系统调用边界与FD共享状态

## 承接与边缘问题

OS栏目从今天开始；每天两个相关小主题，本节为01a“用户态/内核态调用边界”、01b“FD表与共享文件偏移”。估计阅读观察10–15分钟，例子已经写好，不增加主课之外的必做作业。

场景：两个模型文件读取器都想从开头读数据。把已有FD用dup复制给第二个读取器，会得到两个独立读取位置吗？今天用8字节文件观察这个问题，不加载真实模型。

## 主题一：用户态调用怎样进入内核接口

进程不能把一个整数当作任意内核文件指针。xv6的syscall()从保存的调用号选择处理函数，再把结果写回返回寄存器；sys_read()经argfd()检查FD范围和当前进程表项，才进入fileread()。参数和资源校验属于内核边界的一部分。

这里只跟踪分派到文件接口的路径，不展开trapframe保存全过程。RISC-V调用寄存器属于xv6目标细节，不是Linux ARM64/macOS的共同ABI。宿主例子的open/read/dup由系统库提供入口；它实际运行的是宿主内核，不是xv6。POSIX失败通常通过返回值与errno报告；不能把宿主EBADF数值套到xv6的-1返回约定。

## 主题二：FD编号、打开状态和C++所有权

xv6的sys_dup()把同一个struct file放进另一FD槽，再由filedup()增加引用；fileread()推进file内的off。两FD共享打开状态，因此一个读取后，另一个从更新后的位置继续。sys_close()移除当前槽，fileclose()减少引用，其他引用仍可存活。

```text
FD a ─┐
      ├─ 同一打开状态：offset、引用 ─ 文件内容
FD b ─┘                    （dup）
FD c ─── 独立打开状态：offset ───── 同一文件内容（再次open）
```

C++移动包装器只转移一个FD的关闭责任，不调用dup；RAII解决用户态生命周期，并不自动给底层文件创建独立偏移。今日用单线程串行读取观察语义，不推断并发时先后顺序。

## 源码与平台差异

实际阅读日期2026-09-28，[MIT xv6-riscv](https://github.com/mit-pdos/xv6-riscv)的riscv分支：

| 文件 | 本次读取符号 | 保留机制 |
| --- | --- | --- |
| [kernel/syscall.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/syscall.c) | syscall、syscalls映射 | 调用号分派及返回值 |
| [kernel/sysfile.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/sysfile.c) | argfd、fdalloc、sys_dup/read/close/open | FD校验、分配与接口串联 |
| [kernel/file.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/file.c) | filedup、fileclose、fileread | 共享状态、引用与读取偏移 |

上游许可MIT，已读取LICENSE。精确commit未解析：git ls-remote因DNS失败，网页实现可读。链接是分支链接，未伪称永久链接；固定版本重现列入backlog。具体状态见[source.json](source.json)。

关系：从上述实现提炼“引用与偏移共享”，宿主C++程序为独立观察实现，不复制xv6内核、不模拟Linux内部结构、不声称完成xv6移植。省略文件系统、inode锁、设备后端和进程切换实现。[Linux dup手册](https://man7.org/linux/man-pages/man2/dup.2.html)另外确认了打开状态与偏移共享合同；Linux实际运行仍待验。

## 现成观察示例与命令

依赖：已安装的C++17编译器、Bash和POSIX文件接口。Mac或Linux均可尝试：

```bash
cd /Users/guhaoran/code/EveryDay
bash systems_practice/os/2026-09-28/run.sh release
bash systems_practice/os/2026-09-28/run.sh sanitize
```

文件：[fd_observe.cpp](src/fd_observe.cpp)、[build.sh](build.sh)、[run.sh](run.sh)。每次在忽略的build目录生成8字节ABCDEFGH夹具与二进制，结果独立归档，不覆盖旧运行记录。

观察：first读AB，dup接着读CD，重新open仍读AB；关闭first后dup可继续读EF；移动包装器后继续读GH，再得到EOF；非法FD返回EBADF；异常展开后关闭临时副本，独立读取器仍可使用。检查不依赖可被Release禁用的assert。read处理短读/EINTR，close失败报告且不盲目重试；不同OS对中断close的细节需另核实。

xv6/QEMU准备命令（本机未执行，不安装依赖）：

```bash
cd /Users/guhaoran/code/EveryDay
command -v qemu-system-riscv64
command -v riscv64-unknown-elf-gcc
# 在已有工具链的环境获取源码；缓存仅放忽略目录，先确保路径未占用。
git clone --depth 1 --branch riscv https://github.com/mit-pdos/xv6-riscv.git systems_practice/.tmp/xv6-riscv
cd systems_practice/.tmp/xv6-riscv
git rev-parse HEAD
# 核对选定版本Makefile与工具链前缀后构建；不是宿主C++例子的构建命令。
make TOOLPREFIX=riscv64-unknown-elf- qemu
```

上述只启动未改动的教学内核，不能据此宣称宿主例子已在xv6验证。本节没有xv6补丁；后续真正修改内核的课另交付固定版本补丁及运行结果。

## 实际结果与验证边界

Mac arm64已运行Release与ASan/UBSan，五组语义检查全部通过。记录见[verification.json](verification.json)和[results目录](results/)。没有测量性能，本节没有GPU/NPU或端到端数据。

已读网页源码；Git版本固定未完成；没有RISC-V工具链和QEMU，xv6编译/运行未验证；Linux ARM64和RK3588/Jetson未运行。本机POSIX结果不冒充xv6/Linux/目标板证据。

## 工业故障与迁移

| 触发与信号 | 根因或假设 | 诊断与修复取舍 |
| --- | --- | --- |
| 两读取器通过dup共享输入，第二路从意外位置开始 | 打开状态的偏移共享 | 记录每次偏移与读取量；需要独立游标时分别open，或核实pread等显式偏移接口 |
| 包装器复制同一FD整数，某一路析构后另一条路径失败 | 用户态所有权重复，未增加内核引用 | 禁止所有者拷贝，使用移动；确需独立引用时显式dup并考虑共享偏移 |
| 异常路径漏关FD，持续运行后open失败 | 清理责任缺失 | 资源上界观测与失败注入；RAII并检查错误，宿主例子只覆盖一个异常路径 |

以上为可复现机制和工程迁移场景，不是已发生于用户板卡的生产事故。设备FD、DMA-BUF或SDK句柄还有各自合同，不直接套普通文件语义。

## 下一节

OS02：fork复制哪些状态、exec替换程序映像。沿着今天的FD层次，观察推理worker启动时哪些状态继承、哪些被替换。
