# Thor SM110：从布局正确到性能证据

## 公平定位与采集

`profile.sh`先检查ncu版本、`--list-sections`、`--query-metrics`；本机已尝试但无ncu。脚本在Thor编译固定sm_110，保留二进制hash。程序先校验一次、预热20次，再用cudaProfilerStart/Stop圈住一个指定kernel；ncu `--profile-from-start off --kernel-name-base demangled --kernel-name 'regex:.*(quant_baseline|quant_tiled|fp32_gemm).*' --launch-count 1`避免猜测launch编号。一次只选一个格式/方法/变体，baseline和tiled分别生成报告。

```sh
sh profile.sh W4A4 outlier baseline
sh profile.sh W4A4 outlier tiled
# 打开脚本打印的实际路径
ncu-ui build/ncu-XXXXXX/report.ncu-rep
ncu --import build/ncu-XXXXXX/report.ncu-rep --page source --print-source cuda,sass
```

最后一条源码导出选项需以目标机`ncu --help`核对版本；GUI Source页选择quant_tiled，看CUDA→PTX→SASS行关联，当前无report不可假称关联成功。默认replay与缓存控制影响计数，先读报告配置，速度以不挂profiler的event基准为准。权限失败记录ERR_NVGPUCTRPERM，由设备管理员按策略处理，不自动改权限。

| 假设 | 查什么 | 可支持/否定什么 |
| --- | --- | --- |
| 重复解码/读取减少 | SourceCounters执行量、MemoryWorkloadAnalysis事务和bytes、SpeedOfLight | 384 vs4096是逻辑模型，不能直接当DRAM读减少10倍 |
| 分块屏障代价显著 | WarpStateStats barrier stall、SchedulerStats eligible warps | 小K同步可能压过复用收益；停顿采样不等于每指令固定耗时 |
| 寄存器限制并发 | LaunchStats寄存器、Occupancy、shared | occupancy提高不保证更快；共同看运行时间 |
| 读等待形成依赖 | Source视图global load→bfe→MAC的依赖与long scoreboard | stall落在消费者，不必然是MAC本身慢 |

所有section已由脚本按实际列表核验，缺任意项即停，不猜跨版本metric名。可在metrics.txt检索`sector|dram|l1tex|stall`，只添加当前设备实际存在的指标。

## ISA生成与阅读

`export-isa.sh`保留nvcc版本、CMake参数、source/binary hash；用`cuobjdump --dump-ptx/--dump-sass`读真实可执行文件，另用`nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx src/quant_gemm.cu`生成虚拟ISA。后者优化参数与CMake实际产物可能不同，应以可执行文件SASS为性能依据。没有nvcc/ptxas，今天不附假汇编。

唯一手写PTX是`bfe.s32 result, byte, offset, 4`，offset=0/4，把四位符号位扩展为32位。它是合法候选源代码，尚未经本机汇编。潜在热点分三段：全局load与地址计算；bfe/整数MAC或half转换与FP32依赖链；shared加载和barrier。编译器可以重写bfe，因此不承诺出现同名SASS；记录实际指令地址/行、执行次数、stall证据后才能判因，不能编造周期表。

## 架构对照：固定Thor，对照Turing SM75

上次主题研究cp.async流水，这次比较低位Tensor Core与SIMT解码。实际读取[NVIDIA Turing tuning guide 13.0](https://docs.nvidia.com/cuda/archive/13.0.0/turing-tuning-guide/index.html)及[PTX ISA9.0](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html)。Turing新增INT8/INT4 Tensor Core运算能力，矩阵形状、lane布局与warp共同执行合同并不等于“内存是INT4”；CUDA10时代支持Turing，本文无SM75构建命令。Thor baseline sm_110使用CUDA13/PTX9工具链，PTX区分baseline、a专属和f家族特性，不能从Blackwell产品名推断所有特殊矩阵指令可用于baseline。

`dp4a`是PTX5.0、SM61起的四个8位整数点积，Turing/Thor沿用而非独有；它也不是Tensor Core。若下一步用它优化，必须先把同一K group内四对有符号码组成32位寄存器，处理K尾与当前W按N连续导致的跨K取数；只有布局重排成本可摊销时才可能获益。当前没有调用dp4a/mma/tcgen05，只用SIMT与shared，明确不声称低位矩阵硬件吞吐。

[NVIDIA Thor说明](https://developer.nvidia.com/blog/whats-new-in-cuda-toolkit-13-0-for-jetson-thor-unified-arm-ecosystem-and-more/)核实JetPack7.0 CUDA13.0起点；当前driver/L4T/ncu组合未有实机证据。未来在板端记录`cat /etc/nv_tegra_release; nvcc --version; ncu --version`、运行时版本与device属性，确认后运行，而非把Toolkit安装成功当验证完成。
