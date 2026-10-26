# 2026-10-26 OS25：模型加载与文件生命周期

## 承接与边缘问题

承接OS24部署/库边界，今天25a“映射/读取选择”与25b“文件更新/读者寿命”。机器人服务加载权重时，新版本必须完整发布，旧请求继续读旧版本，不能把路径当作对象身份。现成例只操作临时小文件，全部位于本课忽略的build中。

## 主题一

read把字节复制到调用方管理的内存；mmap建立文件支持的虚拟映射，首次访问仍可能缺页，成功返回不表示全部页面驻留。映射减少显式用户拷贝，但页缓存、缺页、地址空间、内存峰值仍需测量。映射的文件对象由内核引用维持，路径删除不是立即销毁对象。

实际阅读Linux v6.12 `mm/mmap.c` 中`mmap_region`创建VMA的片段：`vma->vm_file = get_file(file)`再`mmap_file(file,vma)`，失败路径须归还引用。它是内核文件引用，不是C++ shared_ptr；用户RAII的munmap是释放映射的接口。源码读取范围见[source.json](source.json)，没有声称阅读全部MM子系统。

## 主题二

准备新文件→完整写入/检查→fsync文件→同文件系统rename替换路径；新open获得新版本，已存在映射继续指向旧对象。本例打印的旧/new内容不同就是身份边界。`MAP_PRIVATE`不是不可变文件快照：原地修改/截短同一个inode不能靠它保证旧读者安全，截短后的页访问可能SIGBUS。因此采用新文件发布，绝不拿故意触发SIGBUS当通过用例。

可见性与断电持久化不同：Linux生产协议通常还需要对父目录fsync并检查错误，结合文件系统和存储语义验收；本课Mac例只验证同进程可见性和寿命，不证明崩溃恢复。峰值可能同时保留新旧权重；最后一个旧请求结束后才允许回收它所拥有的映射。

## 源码与平台差异

已读[Linux v6.12 mmap.c](https://github.com/torvalds/linux/blob/v6.12/mm/mmap.c) VMA引用片段和[fs/namei.c](https://github.com/torvalds/linux/blob/v6.12/fs/namei.c) `vfs_rename`权限检查/子inode锁定片段4910–4980；GPL-2.0-only，2026-10-26，blob见source。独立POSIX例受引用与目录更新机制启发，不复制内核代码，不宣称完整复现Linux rename实现。macOS syscall实现不同；xv6不是Linux且本课没有xv6 mmap实现/QEMU实验。

本地ARM资料使用规则已读；本题研究文件对象和目录发布，不引用页表位域或未经核实PDF配方。Google/知乎检索渠道未得到采用的一手案例，技术依据为实际内核源与宿主观察。

## 现成观察示例与命令

```sh
# 仓库根；Apple Clang21，C++17
sh systems_practice/os/2026-10-26/run.sh release
sh systems_practice/os/2026-10-26/run.sh sanitize
# Linux板端另执行相同run.sh；若c++为GCC，无需Mac专用标志。
```

[完整实现](src/main.cpp)：Fd/Mapping/Directory各自RAII；write处理短写/EINTR；空文件拒绝；候选rename后检查旧映射和新映射；unlink后新映射仍有效，新open应ENOENT。拒绝大小≤0或≥4096的输入属于本课小文件合同，生产权重需重新设计边界。

## 实际结果与验证边界

Release与ASan/UBSan通过，[最终日志](results/verified-release.txt)、[sanitizer](results/verified-sanitize.txt)、[验证记录](verification.json)。输出旧`model-v1`、新`model-v2-longer`，unlink后存活、空文件拒绝、ENOENT均通过。未测性能、缺页、PSS/RSS、断电持久化；Linux运行、xv6/QEMU、RK3588/Thor板端均未验。

## 工业故障与迁移

| 条件→症状 | 最小辨别证据 | 修复/代价与回归 |
| --- | --- | --- |
| 原地truncate权重→旧请求崩溃/错误 | inode身份、fstat大小、SIGBUS地址与映射范围 | 新文件原子发布，测试旧/新读者并存；付出峰值内存 |
| rename返回成功但重启丢新版 | 保存fsync文件/父目录返回值及文件系统信息 | 明确持久化协议、故障注入；不能靠普通进程日志证明断电安全 |
| 版本更新过快→RSS不降 | 统计映射租约引用和旧版本数量 | 限制常驻代次/准入，长请求仍不能被强行悬空 |

迁移清单：板端OS/FS/挂载点；同文件系统候选路径；完整大小/校验；多请求持有独立映射；发布错误保留旧版；进程重启/断电回归；峰值和分阶段时间实测。Linux用`strace -e openat,mmap,munmap,rename,fsync`观察本例；Mac无strace未运行，不把缺工具当零系统调用。

追问：为何close fd后映射仍能存活？MAP_PRIVATE为何不等于快照？rename原子性保证哪个对象？文件fsync与目录fsync有什么区别？映射和read如何比较首帧延迟？如何限制旧权重并存峰值？

## 下一节

OS26：计算/等待/复制分段，以及分位数/跟踪扰动；独立游标，未把本课视为板端部署闭环。
