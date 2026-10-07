# Thor SM110：NVFP4解码基线、候选和证据计划

执行目标始终Jetson Thor SM110；本期理论轮换对照Ada SM89（前一期Hopper）。核实依据：[JetPack7.0官方发布](https://forums.developer.nvidia.com/t/jetpack-7-0-jetson-linux-38-2-for-nvidia-jetson-thor-is-now-live/343127)列出Jetson Linux38.2、CUDA13、TensorRT10.13；[CUDA13/PTX9.0](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html)添加sm_110。不是声称当前板卡安装了该组合。实际驱动、JetPack更新版、PyTorch wheel、ncu版本/权限均待板端核查；不沿用桌面驱动安装指令。

## 构建与公平对照

从本目录执行，已有兼容工具链时：

```sh
cat /etc/nv_tegra_release
nvcc --version
nvcc --list-gpu-code
ncu --version
sh thor.sh build
sh thor.sh run
compute-sanitizer --tool memcheck ./build/decode
sh thor.sh isa
```

先确认list包含sm_110；没有就停止，不能回退其他SM。默认run同时验证基线和最终pairs候选，13种n含0/1/15/16/17/255/256/257与1,048,577；device0运行时也检查11.0。两版使用同一packed字节/scale/global、相同FP32输出、1e-6相对/绝对混合容限。global=.125确保基准数据中乘法重关联不引入额外缩放舍入干扰。所有CUDA返回值、launch错误与析构清理都检查，构造失败时已完成对象由RAII释放。

10次预热后21个样本，每样本100次launch，CUDA event区间包含这一批设备执行及可能的提交空隙，除以100得到批平均kernel区间；不是单请求P95。P50第11项、P95第20项。分配/CPU生成/H2D/D2H/校验在计时之外；不使用profiled时间计算收益。候选默认是pairs，不保证最快；若未附加profiler实测退化，运行端应保留baseline。

## ncu定位、筛选、采集与源码关联

```sh
sh thor.sh query > build/ncu-capabilities.txt
./build/decode profile
sh thor.sh profile
ncu --import build/pairs.ncu-rep --page details
ncu-ui build/pairs.ncu-rep
```

先在查询输出中确认section名字可用，再执行profile。profile模式只有代表shape：各kernel先1次正确性launch＋10次预热，`--kernel-name-base function --kernel-name regex:decode_pairs --launch-skip 11 --launch-count 1`只采其首个计时launch；baseline另采。核对报告的名称/grid/n，如果本地版本过滤计数语义不同，用launch列表确认再调skip，禁止混入尾部小例子。完整CLI参数见[官方指南](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)。

| 要回答的问题 | 已选section及进一步metric查询 | 支持/否定假设的信号 |
| --- | --- | --- |
| 输出带宽是否主导 | SpeedOfLight/MemoryWorkloadAnalysis；查询dram吞吐、global load/store sectors | pairs减少逻辑load不代表事务减半；n值固定且FP32 store仍为4nB |
| 两个store是否改变合并 | MemoryWorkloadAnalysis的sectors/request与源码行 | 同一store指令可能为lane隔一值，需核对合并而非只数源码load |
| 线程减少是否损伤并行度 | LaunchStats/Occupancy；register/shared/active warps | 寄存器上涨或block减少，小n延迟可能恶化 |
| 等待来自哪里 | SchedulerStats/WarpStateStats；支持时查询long_scoreboard与eligible warps | stall落在消费者乘法不证明乘法自身慢，向前追scale/global加载 |

不要硬编码未知SM的raw metric；先 `ncu --query-metrics` 后按本机名称选择。ERR_NVGPUCTRPERM等计数器失败记录原文并请求环境管理员配置，本任务不改权限。replay、cache flush/控制策略会改变实验，记录工具默认值，基准必须在无profiler时复测。

用 `-lineinfo` 的产物在ncu Source页选择CUDA/PTX/SASS视图，将decode_pairs循环、位提取、scale解码和store对应到实际行/地址；若无源代码路径，映射回本目录的decode.cu，确认二进制与源码版本一致。`sh thor.sh isa`导出build/decode.ptx和build/decode.sass，报告版本/命令后才摘录文本。报告二进制和ncu-rep保持忽略，验收后可归档必要文本。

## ISA热点与架构对照

当前确有inline `bfe.u32`：取pos=0或4的4位，零扩展输出；它是PTX虚拟ISA，不声称最终SASS也叫BFE。潜在依赖：字节load→bfe→FP4查表/符号；scale load→E4M3指数/ldexp→乘global→乘码值→store。小局部LUT是否被编译为选择/寄存器/本地内存需看真实SASS，不能先宣布spill。没有SM110实测周期、带宽或“最慢指令”排名。

| 架构（仅对照） | 特色与支持约束 | 本课使用情况 |
| --- | --- | --- |
| Thor SM110 | CUDA13/PTX9.0普通target；本例字节解码只需基础SIMT、bfe与FP32 | 全部实际构建命令只有sm_110，无a/f后缀 |
| Thor专属FP4路径 | PTX9.0中FP4转换/块scale矩阵指令有各自a/f目标条件、片段布局/尺度/同步约束 | 不能从硬件支持推出普通target自动支持，未启用专属后缀或tcgen05 |
| Ada SM89 | CUDA11.8/PTX7.8目标支持，第四代Tensor Core加入FP8；FP8 mma有固定片段形状和累加类型 | 只作原理；FP8硬件不等于NVFP4原生支持，本解码也不使用Tensor Core |

[Ada tuning guide](https://docs.nvidia.com/cuda/ada-tuning-guide/index.html)用于核对FP8与memory系统；[PTX9.0的cvt与矩阵指令](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html#data-movement-and-conversion-instructions-cvt)用于核对目标条件。bfe自PTX2.0/SM20起，Thor和Ada均沿用，不是任一代新增专属指令。PTX9.0明确：`cvt.rn.f16x2.e2m1x2`在Thor需要family/专属目标；`tcgen05.mma.kind::mxf4nvf4`的Thor条件为sm_110a，块16的UE4M3 scale使用对应scale-vector布局与矩阵片段，且需遵循tcgen05异步完成/同步协议。本课普通sm_110不使用这些指令，也不切换目标。新增FP8/FP4能力服务计算密集矩阵，解码只有读/转换/写，强行Tensor Core化不适合。

## 当前验证边界

Mac无nvcc/ncu，build实际exit127；没有GPU编译、执行、PTX生成、SASS或ncu证据。原生ModelOpt缺torch，扩展兼容未验。以上为完整可运行候选/采集方案；独立CPU数值结果仅证明自写映射测试，不证明CUDA实现已经正确。
