# 2026-10-03 OS06：多级walk与映射权限/解除映射

## 承接与边缘问题

前置05页分配器；本课06a多级索引、06b权限与unmap。机器人Tensor的虚拟地址连续，并不证明物理页连续，更不能直接当DMA地址。用现成C++17模型手算地址，理解翻译和访问许可是两次不同判断。

## 主题一：walk不是直接得到一个可写字节

2026-10-03实际读[xv6-riscv riscv/kernel/vm.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/vm.c)的`walk → mappages`和`walkaddr → copyout`。Sv39三层每层9位索引，4KiB页偏移12位；xv6限制MAXVA低半空间。`walk`返回叶PTE地址，可按需分配下层页表，尚未证明用户读写许可。宿主模型Node含512入口，unique_ptr管理子表；它只模拟地址关系，没有安装硬件页表。

| 字段 | 示例值 | 作用 |
| --- | --- | --- |
| VPN2 | 1 | VA位30..38 |
| VPN1 | 2 | VA位21..29 |
| VPN0 | 3 | VA位12..20 |
| offset | 0xabc | 页内字节偏移 |
| PA page | 0x9000 | 翻译后地址0x9abc |

模型PTE编码为`(pa>>12)<<10 | flags`，翻译时恢复页号并合并offset。全程用uint64，不把宿主分配指针当真实PA。当前只实现4KiB叶子与低半地址，忽略huge page、ASID和多核TLB。

## 主题二：权限与解除映射

源码`walkaddr`检查V/U；`copyout`还显式检查W。本课模型`translate`集中检查V/U/R和写W，这是教学安全合同，不声称逐字复刻walkaddr。`map`拒绝未对齐、重复映射、非法flags，`unmap`清空叶项；阅读当日上游uvmunmap允许跳过不存在的页，和某些旧教材版本不同。

unmap清PTE不等于设备完成访问，也不自动证明多核TLB不再保留映射。上游`kvminithart`在切换satp附近有sfence_vma；具体运行期释放必须按OS/驱动的同步协议，本模型不演示真实TLB或DMA撤销。模型RAII回收子表，unmap不立即压缩空子表，行为边界需明确。

## 源码与平台差异

仓库[MIT xv6-riscv](https://github.com/mit-pdos/xv6-riscv)，riscv分支/读取日2026-10-03，精确commit未固定，MIT LICENSE正文已读。独立实现保留三级索引、valid/user/write门和解除映射，省略内核分配器、陷入、SFENCE与真实物理页。没有修改内核，因此没有需要交付的xv6补丁；宿主运行不计QEMU/Linux/ARM板端完成。详见[source.json](source.json)。

本地资料复核：`ARM-MMU/MMUAdvanced/MMU-Chapter 19 MMU Performance Optimization Techniques.pdf`物理第5页（19.4），SHA256 `bec29c5ba1ab2ac0169b26c61d789d9d7861b4ff889d5bf9f22b892d89740279`，实际渲染阅读。该页把48-bit VA、4KiB granule写为L0不用/仅L1–L3；本课不采用。经[Linux AArch64内存布局正文](https://docs.kernel.org/arch/arm64/memory.html)复核，传统4KiB配置的三级支持39位、四级支持48位；不能把提前遇到block leaf当成省去根层。新扩展另查配置。pdftotext缺失，pdftoppm可用；PDF仅作带勘误提纲，未复制入仓库，许可待确认。

## 现成观察示例与命令

```sh
sh run.sh
```

[完整源码](src/main.cpp)：手算地址与1025跨叶页映射；拒绝写只读页/用户访问内核页/重复映射/越界VA/未对齐VA；重复unmap不出错。与真实系统接口相比，本例通过异常表示fault而不真的触发SIGSEGV。查看Linux进程maps只能观察VA区段，不能据此推定物理连续；没有提供越权读物理页的操作。

## 实际结果与验证边界

[日志](results/host.txt)：Release和ASan/UBSan均PASS，1025页、6次失败、PA=0x9abc。没有测性能。源码读取是，宿主编译/运行是；xv6/QEMU、Linux、ARM实板、TLB shootdown、DMA均未验证。[verification.json](verification.json)保留分项。

## 工业故障与迁移

1. 输入合法地址却写失败 → 叶项存在但W/U不满足 → 打印VA索引/flags，比对原映射用途 → 不用强制开W掩盖只读数据设计；回归只读文本与可写buffer分别受保护。
2. 释放buffer后设备仍写旧页 → 页面寿命与设备完成不同步 → 结合设备事件/驱动引用跟踪，而非只查PTE → 等待设备完成、撤映射再释放；代价是同步/资源保留，宿主模型不能验收。
3. 从xv6照抄三级到48位ARM → 高位地址失配 → 计算每层覆盖范围并核对granule/VA_BITS → 使用目标内核配置，不以教程简表建生产页表。

迁移验收：核对板型/内核页大小/VA位数；检查SDK内存分配和DMA映射API；注入释放/权限/跨页边界，保存设备同步和失败恢复日志。不得把本例PASS当作板端验收。

追问：1. walk返回PTE还是字节地址？2. offset为何不参与三级索引？3. V/U/W分别控制什么？4. 解除映射何时能释放物理页？5. VA连续为什么不代表PA/DMA连续？6. 页粒度与级数怎样共同决定覆盖范围？

## 下一节

07：用户指针与内核拷贝：copyin/copyout、跨页访问与边界检查，承接映射和权限。
