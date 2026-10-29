# 2026-10-24 C++17第23课：shared_mutex与解锁后的读者寿命

## 本课目标与前置

推理服务读多写少地切换32元素权重快照。两个机制是共享/独占互斥与读者持有的不可变所有权。承接22课多锁；`std::shared_mutex`是C++17新增，`shared_lock`来自C++14，shared_ptr是早期基础。与23日主课atomic shared_ptr方案形成对照：今天用锁保护指针交换，不比较未经测量的吞吐。

## 源码阅读

实际读取 [LLVM/libc++ llvmorg-20.1.8 shared_mutex.cpp](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/src/shared_mutex.cpp)，2026-10-24～25，blob `61808337369561992274175766b4a724911ba503`，Apache-2.0 WITH LLVM-exception文件头已读。`__shared_mutex_base::lock`先等待无writer、置write_entered、再等待reader归零；`lock_shared`等待无writer标记且计数未满；`unlock_shared`减少读者并唤醒相应gate。原场景为标准库共享锁实现；两个条件变量和内部mutex是该版本实现，不是标准指定的公平策略，也不保证当前Apple系统恰好使用这一源码版本。

本例独立实现业务Store，直接调用标准API；保留“读锁复制快照→解锁后继续持有；独占锁发布”机制，未复制库内部锁算法。[source.json](source.json)记录文件、符号、许可与省略。Google/知乎访问未获得可核验正文，详见[共享研究记录](../../daily/2026-10-24/GPU_GUIDE.md#研究访问边界)，未采用片段中的平台公平性推论。

## 机制与知识图谱

```text
候选构造/校验（锁外、可失败） → unique_lock发布指针 → 当前版本
                                                 ↑
shared_lock读取并复制shared_ptr → 解锁 → 持有const State → 最后读者释放
```

锁保护的是`current_`这个共享指针对象，返回的副本延长State寿命。若返回裸引用，锁析构后writer可使原对象失效；若State还能修改，仅有shared_ptr也不能保证内部数据无竞争。故本例不可变对象+所有权复制同时成立。发布失败前没有改变current；旧版本held保持generation0，后续current到501也不影响held。对象在最后一个所有者退出后析构，live计数末尾归零。

C++同步保证来自正确加解锁；库可用mutex/condvar或平台原语实现，不能把某次实现的writer偏好推广为跨平台无饥饿保证。shared_mutex在读操作极短时也可能比普通mutex更贵；每次快照拷贝仍有引用计数成本，不把共享锁叫无锁读取。当前赋值可能在独占锁内销毁旧State，真实大模型可交换旧指针并在解锁后析构，以缩短写临界区；本例仅32元素，保留这个取舍而不隐藏。

## 运行与观察

```sh
# 从仓库根目录；C++17、现有Clang，不安装依赖
sh systems_practice/cpp17/2026-10-24/run.sh release
sh systems_practice/cpp17/2026-10-24/run.sh sanitize
sh systems_practice/cpp17/2026-10-24/run.sh tsan
```

[完整代码](src/main.cpp)：4个reader各5000次读取，主线程发布500次新版本；每个快照32元素必须等于自己的generation。边界是旧reader跨发布持有；失败是负generation和校验注入异常。线程组RAII在异常退出时join，候选/锁/快照均自动清理。现成10–15分钟阅读材料，不另设作业。

## 故障链路与面试追问

| 触发→现象 | 根因/最小诊断 | 修复/代价 |
| --- | --- | --- |
| 解锁返回裸指针→更新时悬空访问 | 锁寿命短于读者；持有旧版本测试+ASan | 返回拥有型快照，代价为旧版本峰值内存 |
| shared_ptr内对象仍可修改→混合generation | 引用计数安全不保护对象字段；TSan和整包一致性检查 | 发布const快照，更新构造新对象 |
| 长持读锁→写者尾延迟上升 | 工作跨越锁作用域；记录锁持有时间和排队，不凭公平性猜测 | 锁内只复制所有权，锁外计算，必要时比较其他方案 |

追问：①shared_mutex与mutex何时可比较？②共享锁保护哪个对象？③解锁之后谁保证旧数据存活？④shared_ptr线程安全不涵盖什么？⑤校验失败怎样保留旧版本？⑥标准是否保证writer不饥饿？

## 验证结果与边界

最终[Release](results/verified-release.txt)、[ASan/UBSan](results/verified-sanitize.txt)、[TSan](results/verified-tsan.txt)均通过：20000次读、2次拒绝、old_generation0、final501、live0。[verification.json](verification.json)保留状态。无吞吐/锁延迟测量；TSan通过不证明所有交错或公平性。Linux、目标板及真实模型峰值内存未验。日期开始10月24、最终运行10月25，均按实际记录。

## 下一课

第24课条件变量的谓词等待与关闭排空，继续区分资源仍在途与队列已空。独立游标仅本课一次。
