# Thor SM110：融合与Graph是两个独立对照轴

## 平台与构建合同

执行目标唯一为Thor、cc11.0、`sm_110`。2026-10-26实际阅读[NVIDIA Thor CUDA Setup](https://docs.nvidia.com/jetson/agx-thor-devkit/user-guide/latest/setup_cuda.html)的deviceQuery输出，列出CUDA13.0/cc11.0；[NVIDIA说明](https://docs.nvidia.com/cuda/archive/13.4.2/nvcompdx/0.1.2/release_notes.html)注明CUDA13起Thor命名为sm_110。代码API基线为TensorRT release/10.13，C++17；不混用TensorRT-RTX的Graph自动策略API。

在已有JetPack环境先保存 `cat /etc/nv_tegra_release`、`nvcc --version`、`nvcc --list-gpu-code`、`dpkg-query -W 'libnvinfer*'`、`ncu --version`、`uname -a`；确认版本属于同一受支持SDK组合及设备属性11.0。官方示例组合不是用户板端实测，当前缺整套SDK/驱动版本、nvcc、ncu及Thor设备。不要把最新版11.x文档等同10.13二进制兼容证明。后续在板端编译运行后才能补齐该证据。

```sh
# 仓库根目录，已配置TensorRT头文件/库搜索路径的Thor
sh systems_practice/daily/2026-10-26/run.sh thor
cd systems_practice/daily/2026-10-26
./build/thor 65539 0  # 两个预处理kernel + TRT
./build/thor 65539 1  # 融合向量预处理 + TRT
./build/thor 65539 2  # 同一融合管线的Graph重放
compute-sanitizer --tool memcheck ./build/thor 4097 1
compute-sanitizer --tool memcheck ./build/thor 4097 2
```

## 优化思路与公平对照

`scale_baseline→bias_baseline`处理连续FP32 `[1,N]`，理论逻辑流量16N B；`affine_fused4`变为8N B并减少一次launch。不是实测DRAM字节：缓存、事务粒度、尾部、TRT与输出传输还会产生其他流量。融合一次读取float4、一次写出float4；4元素对齐来自cudaMalloc起点和4倍索引，尾部标量处理。两者输入、0.5/0.25常量、输出和精度完全相同。输入为可精确表示的八分数，避免用融合舍入差异掩盖错误。

可能代价：每线程4元素增加寄存器，小N减少有效warp，向量类型不保证最终128位机器访存。默认演示三种模式而不预判赢家；“优化版”是完整候选，未验证更快。Graph仅优化提交/执行调度；不改变kernel算法、数学语义或让浮点单指令变快。它还引入捕获/实例化成本及常驻context/buffer，shape多且重用少时可能更差。

20预热+31单请求样本，P50/P95索引15/29；三条计时分别是CPU提交、CUDA event覆盖预处理+TRT管线、H2D+管线+D2H+同步墙钟子区间。最后另测预处理event区间：基线是两个kernel合计，候选是一个kernel。构建/捕获/主机生成/队列均不计入上述区间，不能称完整机器人E2E。未固定频率、散热和执行顺序有混杂；板端验收需交替次序复测，报告小N及冷启动退化。NPU不参与。

## ncu定位、筛选与源码关联

1. 先脱离profiler运行上述三模式记录分位数。必要时用 `nsys profile -t cuda,nvtx -o build/pipeline ./build/thor 65539 1` 分辨主机空隙/设备忙碌；nsys缺失记待验。
2. `sh profile.sh`保存ncu版本、section与metric清单。若section不存在，从本机`--list-sections`选择对应项，不照抄其他架构raw metric。
3. fused过滤匹配函数名；跳过初始化一次和20预热，共21个匹配launch。baseline过滤两个函数，跳过40个预热launch，采两个。只对mode1/0普通enqueue采集，避免Graph replay差异。先用 `ncu --set basic --kernel-name-base function --kernel-name regex:affine_fused4 --launch-count 1 ./build/thor 65539 1` 检查名称与计数，再正式采样；不同版本捕获显示方式如改变，按实际launch列表修正skip并记录。
4. 吞吐/MemoryWorkloadAnalysis：核对global load/store sectors、请求有效字节及L1/L2/DRAM流量，判断融合是否减少真实事务。LaunchStats/Occupancy：核对寄存器、静态shared（本kernel不使用）、block数量、理论/实际驻留。SchedulerStats/WarpStateStats：确认eligible warps、issue活跃与long scoreboard等待是否支持访存依赖假设。短kernel中的采样噪声不得当周期表。
5. `ncu-ui build/fused.ncu-rep`打开Source页，关联`src/kernels.cu`、PTX和SASS。用 `-lineinfo`，不要用`-G`测性能。CLI导出见脚本；GUI需本机已有安装，可在其他机器阅读报告但不切换执行目标。
6. replay与cache控制影响命中条件；profile前后的频率/温度、缓存模式、replay次数记录在报告旁。计数器无权限时保留ERR_NVGPUCTRPERM，不擅自修改系统权限。最终加速结论使用无profiler测量。

## PTX / SASS与潜在热点

`sh export-isa.sh`生成真实sm_110 PTX、cubin、带行号SASS；当前没有这些实际产物。源中`affine()`含真实手写`fma.rn.f32`，只是可编译候选PTX，不是已验证机器码。核对PTX的`.target sm_110`，保存编译器/ptxas版本和寄存器报告。

源码地址计算→global load→FMA→global store是一条依赖链。向量化后检查load/store是否合并为期望宽度、是否出现local spill、尾分支是否占主导。潜在耗时来自数据就绪、访存事务、启动成本，而不是断言FMA“最慢”。SASS采样停在消费者可能是前一load造成等待；延迟、吞吐、指令执行次数和stall占比不同，不编周期数。TRT生成的ReLU kernel只能在目标runtime报告中解析，不能用本文件反汇编代替它。

## 架构对照：Thor固定，对照Ampere

[Ampere tuning guide](https://docs.nvidia.com/cuda/ampere-tuning-guide/index.html)1.4.1.2与[PTX7.0原始规范](https://docs.nvidia.com/cuda/archive/11.0_GA/parallel-thread-execution/index.html)说明Ampere新增global→shared异步复制支持：`cp.async`要求SM80+、PTX7.0（CUDA11工具链时代）；4/8/16 B复制有对齐条件，必须正确等待及处理CTA发布/复用。Thor上基础SM110可以使用这一沿用机制，但它不是Thor独有；本例没有跨线程数据复用，强加shared/cp.async会增加同步与搬运，所以采用直接global读写。

FMA、向量访存、CUDA Graph并非Thor新指令。Thor的SM110命名需要CUDA13；不能从“Blackwell”推断支持所有sm_100a/其他专属指令，当前无专属后缀和Tensor Core路径。今天对照Ampere，下次GPU内容对照Hopper；所有执行、生成和反汇编目标始终sm_110。

## 来源与检索边界

实际读TensorRT `samples/common/sampleInference.cpp`，release/10.13，`IterationStd::createEnqueueFunction`先enqueue/同步再capture，失败结束捕获并回退；本练习是独立启发实现，简化为单context/单槽，捕获失败直接报错退出，未实现服务自动fallback。源文件Apache-2.0。[当前官方文档](https://docs.nvidia.com/deeplearning/tensorrt/11.4.0/performance/optimization.html#inference-with-cuda-graphs)只辅助核对shape更新和资源绑定原理。

Google检索页与知乎站内检索页均被工具报告不可访问；站点限定搜索返回内容无直接可用案例，未采用二手技术结论。10.13.3/performance/best-practices和archives/tensorrt-1013路径返回404/不可访问；故API依据实际10.13源码，不能声称读过这些失败页面。具体尝试见[source.json](source.json)。
