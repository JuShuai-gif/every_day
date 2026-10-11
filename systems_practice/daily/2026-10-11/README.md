# 2026-10-11 TensorRT：动态 shape 合同与异步缓冲区寿命

## 工业场景

机器人双相机编码器输出连续 FP32 `[B,K]` 特征；B=1–8、K=1–4097，执行 `y=max(0,x*0.5+0.25)`。尺寸随有效目标数改变，不能把 engine 中的 `-1` 当作可分配元素数。本课将 TensorRT profile/上下文形状与同一 stream 上的设备缓冲区寿命耦合起来。输入只接受有限值；输出同 shape，误差不超过 1e-6。性能目标是在正确性相同前提下降低启动与中间写回成本，尚无 Thor 延迟预算验收结果。

## 概念回顾

动态输入不是运行时任意改变网络。构建时的负一维度表示占位，优化配置给出允许的最小、常用和最大形状；运行时先选择配置，再设置具体输入尺寸，最后查询输出尺寸。常用尺寸指导策略选择，不是唯一合法尺寸。尺寸落在范围内也不代表所有关联维度都自洽，因此提交前仍须验证布局、元素数量和容量。本例所有数据连续，最大容量一次分配，输入改变时只更新有效区域，避免热路径重新分配。输出元素数从执行上下文解析，不能直接读取仍含占位值的网络定义。

尺寸正确之后，第二个条件是资源活到设备完成。异步提交返回只说明主机提交成功，不意味着设备已不再访问指针。同一流依次执行输入复制、推理、输出复制，再同步，才能安全读取结果或复用缓冲区。异常路径也必须先排空；否则局部数组或设备内存会先于在途任务释放。资源守卫按逆序析构，因此本例把排空守卫放在缓冲区和每次请求的主机数组之后构造。配置对象由构建器持有，不能因为习惯使用智能指针就重复释放它。

优化也必须服从这两个条件。独立正确性基线用仿射与激活两次启动，融合候选让每个线程处理四个连续元素，消除中间数组的一读一写，末尾不足四项走标量路径。浮点语义和有效输出数量不变，但向量化可能降低小输入的并行度；减少逻辑流量不等于实测带宽提升。TensorRT可能自行融合网络，本课不假定它调用自写候选。CPU只验证合同，设备事件测两次启动或融合的设备区间，包含复制同步的请求耗时另记，三者不能互相替代。

## 知识图谱

`profile(min/opt/max) → setInputShape → getTensorShape → 容量检查 → setTensorAddress → enqueueV3 → stream完成 → 缓冲区复用`。

- 主机制：动态形状解析；前置是连续 FP32 与有界容量。
- 耦合机制：异步所有权/异常排空；前置是所有提交使用同一 stream。
- 硬件连接：线程连续地址→合并访存；两 kernel 中间 global 写回→融合寄存器值。
- 不能混淆：engine shape 与 context shape、enqueue返回与完成、逻辑字节与DRAM事务、CPU验证与GPU验收。

## 编码练习

唯一任务，20–30分钟：阅读已经写好的 `launch` 与 `affine_relu_fused`，给调用端加一个经过测量的选择阈值（小输入可选基线），并保持24组形状、3/4/5尾部和越界拒绝通过。5分钟确认合同，10分钟改选择，10分钟检查与计时。缺Thor时完成修改和CPU合同检查，将阈值标为未测，不能填想象的加速比。

基线 `affine_baseline`→`relu_baseline` 逻辑流量16N字节，候选 `affine_relu_fused` 8N字节；不含分配、传输、缓存重用。默认交付完整融合候选，但基准依次测两个版本，没有宣称候选更快。TensorRT独立构建相同网络，是同语义运行时对照，不能将其内部kernel归因为本课代码。

## 文件说明

- `src/contract.hpp` / `cpu_check.cpp`：输入合同与CPU oracle。
- `src/trt.cpp`：无ONNX/模型下载的TensorRT 10.13网络、profile、24形状执行。
- `src/kernels.cu` / `cuda_raii.hpp`：基线/融合候选、真实inline PTX、资源与计时。
- [Profiler与ISA](PROFILE.md)、[来源](source.json)、[验证](verification.json)。
- 现成附加材料：[AdaRound](../../quantization/2026-10-11/adaround/README.md) · [ARM18](../../arm/2026-10-11/README.md) · [OS13](../../os/2026-10-11/README.md) · [C++17第12课](../../cpp17/2026-10-11/README.md) · [WRP / TOGA两篇论文](../../paper/2026-10-11/README.md)。不增加必做任务。

## 编译与运行

从仓库根目录执行：

```sh
sh systems_practice/daily/2026-10-11/run.sh cpu
sh systems_practice/daily/2026-10-11/run.sh sanitize
# 以下仅在装好匹配JetPack的Thor上运行，无自动安装。
sh systems_practice/daily/2026-10-11/run.sh thor
```

C++17；CUDA唯一目标 `sm_110` / CMake `110`，运行时拒绝非11.0设备。官方[Thor CUDA指引](https://docs.nvidia.com/jetson/agx-thor-devkit/user-guide/latest/setup_cuda.html)给出CUDA13.0与计算能力11.0实例；[L4T38.2发布说明](https://docs.nvidia.com/jetson/archives/r38.2/ReleaseNotes/Jetson_Linux_Release_Notes_r38.2.pdf)列出JetPack7.0、CUDA13、TRT10.13。参考[TRT10.13.2说明](https://docs.nvidia.com/deeplearning/tensorrt/10.x.x/getting-started/release-notes-10/10.13.2.html)核对SBSA包，具体板端补丁/驱动/ncu组合仍待查询。不得将桌面最新TRT包直接假定支持Jetson；本课接口以实际读过的release/10.13为准。

## 正确性验证

Mac已通过24组参考合同与5拒绝：B={1,4,8}、K={1,3,4,5,31,32,33,4097}；零B、越界B、零K、越界K、非有限输入被拒绝。CPU测试不是CUDA kernel执行。Thor运行入口对24组输入分别核对基线/候选/TRT，TRT直接调用超profile的B=9并要求失败。上线还需 `compute-sanitizer --tool memcheck build/thor/kernels 8 4097`、重复执行/异常排空、SDK升级回归；这里均未执行。

## 性能分析

[PROFILE.md](PROFILE.md)给出ncu版本查询、名称/launch筛选、section与metric匹配、报告与源码关联、PTX/SASS生成。自写GPU测量20次预热，11个样本，每样本100次操作；P50/P95是**批均值分位数**，不是单请求尾延迟。基线每次包含两kernel，候选每次一个，均排除H2D/D2H。TRT输出只是一条含复制同步的冷shape诊断，不用于稳态加速比较。没有GPU/NPU/E2E性能结论。

## 实际运行结果

Mac Release与ASan/UBSan均退出0，见[CPU日志](results/cpu.txt)与[Sanitizer日志](results/sanitize.txt)。本机缺nvcc、ncu、TensorRT与Thor；GPU编译、执行、精度、PTX/SASS与性能全部未验证。宿主工具版本见[environment.txt](results/environment.txt)。

## 工程注意事项

实际阅读[NVIDIA/TensorRT](https://github.com/NVIDIA/TensorRT)，release/10.13，2026-10-11；Apache-2.0。文件 `samples/sampleDynamicReshape/sampleDynamicReshape.cpp` 的 `buildPreprocessorEngine/infer`：原场景是动态图像缩放后接MNIST；保留profile范围/执行上下文形状解析，省略数据集、INT8校准、双engine。另读 `include/NvInferRuntime.h` 的 `setInputShape/setOptimizationProfileAsync/setTensorAddress/enqueueV3` 与 `NvInfer.h::createOptimizationProfile` 所有权说明。代码是受其启发的独立实现，改用name API、常量小网络、同流异步与RAII；不是拷贝原sample。源文件哈希、链接、获取失败与重试保存在source.json。

配置对象由builder管理，其他TRT对象用unique_ptr依赖逆序回收。每次主机数组之后再建Drain，保证异常时数组寿命。最大缓冲区策略有固定峰值开销；多context并发必须每个在途请求独占资源，本例串行不能冒充线程安全服务。

## 工业故障与面试追问

| 触发→信号 | 根因候选与最小诊断 | 修复/代价与回归 |
| --- | --- | --- |
| B=9→shape设置失败 | 记录输入和profile min/max；不要继续enqueue | 路由到合法profile或明确拒绝；增加边界回归 |
| 改K后输出越界 | 比较context输出与buffer容量，memcheck定位 | 按最大容量或安全重分配；付出常驻内存 |
| enqueue后异常→偶发坏数据 | 检查析构顺序与stream轨迹 | 先排空后回收；异常路径承担同步延迟 |
| 向量化后小N更慢 | 同流event与occupancy/waves核对 | 保留小shape回退；按目标实测确定阈值 |

追问：1. opt形状与max分别约束什么？2. profile指针为什么不归用户删除？3. setInputShape成功是否足够证明输出可分配？4. 为什么异常时也要排空？5. float4尾部/对齐由谁保证？6. 两kernel与一kernel怎样公平计时？7. 为什么合并读写量不能直接推加速倍数？

## 自测问题

现在有两个stream分别处理B=1与B=8，却共享同一个执行上下文和输出缓冲区；即使每次setInputShape都返回成功，会出现哪些时序风险？请给出一套资源划分及目标设备验收方案，不改变计算语义。
