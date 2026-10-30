# 2026-10-30 GPU访存优化：Thor SM110 转置的向量化搬运与 shared bank 约束

## 工业场景

机器人视觉编码器把带行跨度的 FP32 特征 `[rows=1537, cols=769]` 转为列主序，供小 batch GEMM 消费。输入 stride=772、输出 stride=1540；必须保留 padding 哨兵、尾块和逐元素结果。目标设备固定 Jetson Thor SM110。Mac 只做索引模型与 sanitizer，不能替代 CUDA 验收。

## 概念回顾

本课把两个必须一起看的机制放在一次布局转换里。第一是全局访存合并：warp 中相邻 lane 沿输入行读取时，地址连续，硬件可以把请求合并成较少的 sector；转置后若直接写列，相邻 lane 的目标间隔是输出 stride，写请求会分散。第二是 shared memory 的 bank 映射与 CTA 屏障：tile 先按输入方向写入，再由另一组线程按转置方向读取。32 个 bank 的 FP32 标量访问中，物理行长为 32 时整列落到同一 bank；行长改为 33 后，`(lane*33)%32` 覆盖所有 bank。padding 只改变物理布局，不能改变逻辑 stride 合同。装载和写回都做边界谓词，但线程不能在 `bar.sync` 前提前返回，否则有效线程可能读取尚未写入的共享槽。direct、PAD0、PAD1 三版使用同一输入、同一输出与同一尾块标准，才能区分全局事务、bank 冲突和启动/同步开销。CUDA event 只代表设备区间，H2D+kernel+D2H 是请求时间，不能把任一数字叫完整端到端延迟。Thor 的 PTX/SASS、ncu stall 和真实功耗必须由目标机产生；Mac 的 CPU 结果只证明地址模型。

## 知识图谱

`stride 合同 → lane 地址 → global sector → shared tile → bank 映射 → CTA 屏障 → 输出哨兵`。

|耦合点|实现|边界|
|---|---|---|
|合并读/写|`transpose_direct` 与 `transpose_tile`|逻辑字节量不等于 DRAM 事务量|
|padding/同步|`tile[32][32+PAD]`、`bar.sync 0`|bank 冲突不是数据竞争|
|尾块/生命周期|RAII `Buffer`、双谓词|stride 用元素数；不得原地重叠|

## 编码练习

唯一 20–30 分钟任务：先运行 CPU 合同；再将 PAD0 改为 PAD1，列出一个 warp 的 bank 编号并解释为什么屏障前不能 return；最后在 Thor 上用同一 shape 跑三版并记录 kernel P50/P95。自测不提供答案。

## 文件说明

- `src/transpose.cu`：direct、shared PAD0 与 PAD1，SM110 运行时守卫、CUDA 错误检查与 RAII。
- `src/contract.hpp`、`src/cpu_check.cpp`：独立 oracle、stride/尾块/非法输入检查。
- `PROFILING.md`：ncu 过滤、采集、源码关联、PTX/SASS 生成命令。
- `source.json`、`verification.json`、`results/`：源码与验证边界。

## 编译与运行

```sh
sh run.sh cpu
sh run.sh sanitize
# Thor/Linux NVIDIA 主机：唯一执行目标 sm_110
sh run.sh thor
compute-sanitizer --tool memcheck ./build/transpose check
ncu --set full --kernel-name regex:transpose_tile --launch-skip 10 --launch-count 21 ./build/transpose 2
cuobjdump --dump-sass ./build/transpose
nvdisasm --print-line-info ./build/transpose
```

构建要求 CUDA 13+、支持 Thor 的 nvcc/驱动与 Nsight Compute；不得改成 `sm_110a`。本机 `nvcc` 缺失时只保留命令与失败证据。

## 正确性验证

CPU 模型覆盖 0/1/31/32/33/65 及 stride padding，3 个非法合同必须拒绝；输出 padding 保持 `-999`。Thor 验收要求 150 个 mode/shape 组合逐位等于 oracle，memcheck/racecheck/synccheck 清零。NaN、原地重叠和超 16384 尺寸不在合同内。

## 性能分析

同 shape 预热 10 次，21 批×100 launches；报告 CUDA event kernel P50/P95、逻辑带宽和独立 pageable H2D+kernel+D2H P50。ncu 先用 `--launch-skip/--launch-count` 缩小采集，再看 `sm__sass_thread_inst_executed_op_shared*`、global load/store sector、barrier stall 和 occupancy，`-lineinfo` 关联到两处 tile 访问。真实 PTX/SASS 只在 Thor 产物存在时记录，不猜周期或收益。对照架构只讨论 Hopper 的 TMA/异步拷贝差异，执行仍是 SM110。

## 实际运行结果

Mac 本机：CPU 合同和 ASan/UBSan 可运行；日志写入 `results/cpu.txt` 与 `results/sanitize.txt`。本机无 NVIDIA GPU、nvcc、ncu，因此 Thor 编译、GPU 正确性、PTX/SASS、kernel/端到端/功耗均未验证，原始失败摘要见 `results/environment.txt`。

## 工程注意事项

所有 CUDA API、事件与析构释放都检查；`Buffer` 禁止复制。小 shape 可能由 launch/barrier 主导，PAD1 退化时应以 ncu 证据回退 PAD0。下游若能直接消费行布局，省略转置的端到端方案应单独比较。

## 工业故障与面试追问

1. 33×31 尾块卡死：检查 barrier 前提前 return，使用 synccheck，保留全 CTA 到达屏障。
2. PAD1 无收益：看 shared bank 与 barrier stall，确认不是传输/启动占主导，再决定回退。
3. 矩形输出越界：用哨兵和独立 stride 检查列/行交换，禁止用更大分配掩盖错误。

追问：为什么读合并不代表写合并？32/33 行距如何推导 bank 集合？广播与冲突区别是什么？尾块有效消费者如何对应生产者？shared 增量怎样影响 occupancy？ncu 的 stall 位置为何不一定是根因？

## 自测问题

若每个 lane 一次读取两个 FP16 并用向量写回，你会如何重新推导 bank、对齐、尾部谓词与公平基准，区分向量化收益和减少 launch 的收益？
