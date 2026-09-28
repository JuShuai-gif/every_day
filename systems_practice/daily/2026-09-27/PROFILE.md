# TensorRT 输入/输出边界与 Thor SM110 热点

构建/运行始终Thor SM110。[前一课完整ncu/PTX/SASS教程](../2026-09-26/PROFILE.md)适用于本课 `build/thor/softmax`，同一源码、同一形状、同一正确性与计时边界，基线serial、最终候选warp，优化收益未验证。源码、手写laneid PTX和生成命令均保留在该课；不声称这是TensorRT私有实现。

TensorRT的120帧示例有20预热100采样；CPU提交用steady_clock，GPU引擎区间用event，request包含传输、输入清零和等待。清零是所有权验收开销，不能将request值和前课不清零的request直接当引擎速度比较。只有相同输入和区间的GPU计算时间可作初步比较，还应报告引擎调度开销与策略不同。NPU未参与，无功耗结果。

```sh
bash run.sh thor
ncu --version
ncu --list-sections > build/trt-sections.txt
ncu --query-metrics > build/trt-metrics.txt
# 先扫描，不假定TensorRT内核名字。将GUI中实际匹配的名字填入后续环境变量。
ncu --profile-from-start off --set basic --launch-count 5 -o build/trt-discovery build/thor/trt --profile
# 程序在20次预热后调用cudaProfilerStart，因而排除建引擎/预热launch。
# 根据discovery核名筛选；不是假定每帧只有一个kernel。
: "${TRT_KERNEL_REGEX:?set from discovery}"
ncu --profile-from-start off --kernel-name-base function --kernel-name "regex:$TRT_KERNEL_REGEX" --launch-count 1 --set full -o build/trt-focus build/thor/trt --profile
ncu --import build/trt-focus.ncu-rep --page details > build/trt-focus.txt
ncu-ui build/trt-focus.ncu-rep
```

`--profile`明确调用cudaProfilerStart/Stop，普通运行不调用；与[官方CLI的profile-from-start控制](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html#command-line-options)组合，排除构建和预热（读取2026-09-28，实际板端未验）。先检查捕获的shape与核名，需要时增加discovery计数；不要使用disable-profiler-start-stop忽略程序边界。Profiler附加时打印的主机基准不可与正常运行混作性能结论。私有TensorRT kernel不保证源码/PTX可得。自写softmax使用前课 `-lineinfo`、`nvcc -arch=sm_110`、cuobjdump命令；`cuobjdump --dump-sass build/thor/softmax`只能说明自写候选。缺工具链时不提供伪造SASS。内核可能的耗时依赖是load/max/exp/sum/div，生命周期事件主要影响流水线等待，事件本身不会改进softmax算术。

今日原理对照轮到Hopper：PTX8.0起的`cp.async.bulk`组提交/等待要求SM90或更高，张量形式还要求合法tensor map、对齐、barrier完成语义。[官方PTX说明](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#data-movement-and-conversion-instructions-cp-async-bulk-commit-group)。固定Thor SM110执行路径在此不引入TMA；本课问题是运行时缓冲区所有权，bulk-group完成与TensorRT输入消费事件不是同一层协议，不能互相替代。新专属指令后缀不自动启用，实际驱动/ncu版本仍未板验。
