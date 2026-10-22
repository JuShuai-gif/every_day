# 2026-10-22 C++17 第21课：filesystem错误与路径检查时差

## 本课目标与前置

模型版本发布时，`exists(path)`成功能否保证下一次open仍得到同一份文件？前置20课的资源寿命，今天用C++17新增filesystem和error_code说明路径状态与已打开对象的区别。示例只在本课build里的私有临时目录创建极小文本文件，不触碰模型或用户文件。

## 源码阅读

2026-10-22实际读取[LLVM libc++ llvmorg-20.1.8 operations.cpp](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/src/filesystem/operations.cpp)：`__file_size`查询posix_stat并拒绝非普通文件，`__rename`转发平台rename并报告错误，`__status`返回路径状态。许可证Apache-2.0 WITH LLVM-exception。原场景是标准库跨平台filesystem实现，本例是独立POSIX宿主实验，保留错误报告/对象寿命，省略Windows与平台ABI实现。[source.json](source.json)含hash及失败记录；尝试`filesystem_common.h`返回404，未声称阅读其ErrorHandler定义。Google入口失败、知乎未找到适合的一手案例，采用实际标准库源码。

## 机制与知识图谱

`path → status/exists`是某时刻路径查询；`path → open → stream`持有打开对象；`rename(candidate,active)`改变名字绑定；`file_size(path,ec)`返回数值或错误。它们之间没有自动事务。

[src/main.cpp](src/main.cpp)先打开旧active作为lease，再把candidate重命名为active。POSIX下旧流读旧内容，新流读新内容。接着在exists成功之后，顺序执行remove再open，确定性构造检查与使用之间的时差；无线程、无UB，也不需要概率性抢占。不存在的file_size使用error_code重载得到错误和`uintmax_t(-1)`，抛异常重载得到filesystem_error；两者错误语义相同，调用风格不同。

错误码需要检查，不能把失败哨兵转成分配长度；新成功调用会清理传入的ec，本例以create_directory检查这一点。RAII清理目录，析构错误只记录不抛出。已打开文件不是内容不可变的万能证明：若另一个进程原地覆盖同一inode，读者仍可能看到改变。因此生产发布应使用不可变版本文件/rename，并校验真正打开的内容；这里不解决不可信目录的符号链接安全，也不承诺rename掉电持久。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-22/run.sh
sh systems_practice/cpp17/2026-10-22/run.sh sanitize
```

Apple clang C++17，标准库加POSIX mkdtemp。初始化时由mkdtemp创建唯一私有目录；fstream开启写入异常并检查close，读取检查open/bad状态；filesystem用ec重载检查返回。输入是old/new两条文本、空文件、空目录和不存在路径。所有二进制与临时目录留build；析构删除本例创建的私有目录。

## 故障链路与面试追问

| 故障链 | 最小证据与修复取舍 |
| --- | --- |
| exists成功但open失败→路径被移走/删除 | 日志记录两次操作及系统错误→直接执行目标操作并处理失败，避免把预检查当保证；重试需有限次数 |
| file_size失败后分配巨大数组→忽略error_code | 同时打印ec与返回值→先检查错误，再检查业务大小上限；失败不修改现有活跃模型 |
| rename后旧请求继续读旧内容→误以为所有读者立即切换 | 已打开lease与新open输出对比→接受版本化读者寿命，发布后保留旧资源直到读者退出 |

迁移验收：Linux实际重跑、版本文件不可变、同文件系统rename条件、失败回滚、权限/磁盘满等额外故障注入；若需要掉电一致性，另验证文件与目录fsync合同。

1. filesystem是哪个标准新增的，POSIX rename语义是否等于所有平台？
2. exists为何不能授予文件租约？
3. error_code与异常重载怎样选择？
4. file_size的失败哨兵为何危险？
5. 路径替换与原地修改对旧读者有什么不同？
6. 原子可见与持久化有什么区别？

## 验证结果与边界

[Release](results/release.txt)和[ASan/UBSan](results/sanitize.txt)通过旧流/新路径、TOCTOU、缺失错误、抛异常、空目录/零长度和rename失败。首次编译缺mkdtemp声明，补`unistd.h`后重跑通过，[首次失败](results/release-initial-failure.txt)保留。无性能数据；Linux/Windows/板端与掉电恢复未验，[verification.json](verification.json)分开记录。

## 下一课

22课：scoped_lock与多锁死锁顺序。
