# 2026-10-27 OS 第26节：端到端延迟归因

## 承接与边缘问题
设备时间稳定但 P95 变坏时，先拆计算、等待、复制，再判断跟踪扰动。两个主题是时间线分段和分位数/跟踪开销。

## 主题一
src/main.cpp 分开 wait 与 compute；生产应继续分出输入复制、Runtime enqueue、设备完成和后处理。Linux perf stat 计数器与 hrtimer 调度边界不同，不能互换。

## 主题二
P50/P95 必须固定样本定义、预热和负载；trace/perf 可能增加唤醒和锁竞争。必须同时保留无跟踪基线。

## 源码与平台差异
实际读取 Linux v6.12 perf-stat 文档和 hrtimer.c，GPL-2.0-only；读取 xv6-riscv trap.c 作对照。代码独立改编；Linux perf、xv6、RK3588 和 Thor 均未在本机验证。

## 现成观察示例与命令
sh systems_practice/os/2026-10-27/run.sh；若 macOS 无 perf，results/perf.txt 记录该事实。

## 实际结果与验证边界
Apple Clang21 C++17 Release/ASan/UBSan 通过；只是一条宿主观察，不报告 P95、NPU 或端到端性能。

## 工业故障与迁移
P95 突增但 NPU run_duration 不变→比较队列、复制和锁；采样后 P95 下降→记录跟踪扰动并降低采样频率。迁移验收要求同一 request id 覆盖 CPU、copy、device event、postprocess。

## 面试追问
perf cycles 为什么不能代替设备事件？等待如何从 compute 分离？P95 样本单位是什么？trace 如何测扰动？不同 CPU 核能否照搬 raw event？

## 下一节
下一节按索引继续；本课不把宿主示例包装成 Linux 或板端证据。
