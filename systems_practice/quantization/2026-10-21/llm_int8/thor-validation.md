# Thor SM110：离群列解码与共享内存复用

## 合同与来源

执行目标永远是Thor SM110。CUDA13 nvcc支持sm_110、官方Jetson T4000/T5000为cc11.0，但具体JetPack/L4T、驱动与PyTorch/bnb二进制组合没有设备验证。保存`uname -a`、`cat /etc/nv_tegra_release`、`nvcc --version`和驱动信息；不能仅凭编译目标证明完整SDK兼容。

`mixed.cu`的独立数学合同：A原始FP16和量化QA[M,K]、行scale sx；QW[K,N] INT8及列scale sw；mask[K]为整个batch共同离群列。有效A=mask?FP16原值:QA*sx，W=QW*sw，输出按K递增FP32 FMA。权重真实一字节存储，原始A为教学简化整体保留（生产可只收集离群列）。没有zero-point；INT32并非本候选累加类型。误差参照**相同已解码输入**的FP64 oracle，不是原始未量化Linear，因此它证明实现一致性，不能证明量化精度；原生example.py另测后者。

baseline每输出读取K次。tiled每CTA生成16×16输出，共享A/B每元素在CTA内复用16次，scale解码也复用；两次barrier分别保护生产和下次覆盖。尾部线程不提前返回，越界读补0、越界写屏蔽。共享使用2048B/CTA、256threads；寄存器/实际occupancy须由ptxas和ncu核实。小M/N或K时barrier和空线程可能让优化退化；不承诺速度。

本日实际读[NVIDIA cuda-samples v13.0 MatrixMulCUDA](https://github.com/NVIDIA/cuda-samples/blob/v13.0/Samples/0_Introduction/matrixMul/matrixMul.cu#L58)，文件blob `957be0f7e56d435edc3e394fdd660bab6d3695e2`，2026-10-21。原场景浮点矩阵乘共享分块；本例按其tile/双barrier结构改编，新增离群解码、尾块屏蔽、RAII和oracle，未复用SDK helper。保留[NVIDIA BSD-3-Clause版权与免责声明](NVIDIA-LICENSE.txt)。算法分解受本课固定commit的bnb实现启发，但bnb原生INT32/FP16恢复和分派未复刻。

## 可直接运行的目标命令

从EveryDay根目录，在已配置CUDA13的Thor上：

```sh
bash systems_practice/quantization/2026-10-21/llm_int8/build-thor.sh
systems_practice/quantization/2026-10-21/llm_int8/build/mixed
bash systems_practice/quantization/2026-10-21/llm_int8/profile-thor.sh
ncu-ui systems_practice/quantization/2026-10-21/llm_int8/build/mixed_tiled.ncu-rep
```

build脚本分别生成sm_110二进制、真实PTX、cubin、SASS与lineinfo。当前真实构建失败是`nvcc: command not found`，见[日志](results/thor-build.txt)；没有伪造PTX/SASS。默认18组fixture含M/N/K尾块、M1、无/部分/全部离群列，FP64参考误差阈值abs0.002+rel0.0002；这些GPU检查均**待运行**。未提供通用零shape/任意尺寸API，入口只接受固定安全shape及`--profile`。

计时先正确性、每版warm5，再11批×20launch交替顺序，CUDA event给GPU批均值P50/P95；P95不是请求级尾延迟，包含批内调度间隙。输出额外单次pageable H2D+kernel+D2H子流水线时间，排除预量化/分配，不是模型端到端。mask固定、输入/scale/shape/容限一致；保存功耗、温度、时钟、后台负载。不用profiler运行中的时间作为优化收益。

## ncu从定位到源码关联

profile脚本先记录版本、list-sections/query-metrics，再basic捕获两次检查launch定位`mixed_baseline`与`mixed_tiled`。随后以demangled精确名称正则筛选，各跳过6次匹配launch（1检查+5warm），采集相同128×128×256及相同mask的第一批次。若版本改变skip语义，在discover报告核对，不能凭名字猜shape。section不支持时先从本机list-sections选择对应项，不隐藏错误。

依次看SpeedOfLight与MemoryWorkloadAnalysis的读事务/缓存，再看LaunchStats寄存器和共享内存、Occupancy、SchedulerStats发射与WarpStateStats等待。确认shared复用是否减少global读，是否增加barrier、寄存器spill或低occupancy。Source页用lineinfo对应`decode_a/decode_w`与FMA循环；报告与源码目录一起保存。原生bnb需另用`ncu --target-processes all --set basic --launch-count 8`包裹README的CUDA运行，再根据实际库kernel名筛选；本例kernel名不能套在cuBLASLt上。

build/mixed.ptx与build/mixed.lines.sass.txt由真实工具生成后，检查整数加载/符号扩展→float转换→scale乘→FMA、mask分支/谓词、shared load→FMA与barrier。概念上的PTX `cvt.rn.f32.s32`、`fma.rn.f32`、`ld.shared`、`bar.sync`是待查指令类别，不是本机生成结果；编译器可能折叠/改写。单累加器FMA形成长依赖链，load等待也可能归因到其消费者；stall样本不能直接换算某条指令周期。用真实执行次数、依赖、缓存和流水线吞吐共同解释热点，无设备不填周期或收益。

## Thor与Ada：只比较原理

| 维度 | 固定执行Thor SM110 | 本次理论对照Ada SM89 |
| --- | --- | --- |
| 本实验路径 | 通用CUDA shared/barrier/FP32 FMA；不需a/f后缀 | 相同机制有原理可比性，本期不编译或运行Ada |
| 特色Tensor指令 | 不能从Blackwell家族名称推断sm_100a或sm_120a指令可在sm_110使用 | Ada第四代Tensor Core新增FP8，适合缩放受控且shape对齐矩阵乘 |
| PTX条件 | 通用sm_89+允许的FP8 mma形态需逐条核查PTX版本、dtype、shape；本候选未采用 | PTX8.4加入相关FP8 mma形态，目标要求sm_89+，warp协作与布局均有约束 |
| 不可偷换 | PTX对e2m1等新窄位mma列出sm_120a/f等特定条件，不能据此给Thor添加后缀 | FP8不是INT8，不是把本课字节权重直接换指令即可 |

依据：[Ada官方调优指南§1.4.1.2](https://docs.nvidia.com/cuda/archive/13.0.0/ada-tuning-guide/index.html)、[PTX9.0 mma说明/Target ISA Notes](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html)。本课不调用这些特色指令，架构对照用于拒绝不满足条件的“优化”。下一次对照Turing。原生bnb、CUDA候选、ncu、PTX/SASS和板端兼容性均在backlog分别待验。
