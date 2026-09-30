# Thor SM110：从双槽假设到ncu与ISA证据

## 先固定执行合同

本课读取了CUTLASS `MmaMultistage`的prologue→gmem_wait→gemm_iters及槽位推进函数；源码关系和未固定commit见README。实现是独立SIMT FP32教学代码，优化维度是global→shared预取时间位置。同步基线用1槽，候选用2槽，因此shared占用与指令数量也是混杂因素。只在下一tile存在时提交；启动等待、每次消费屏障、下一tile等待全部保留，最后无未完成请求。

4B cp.async是实际inline PTX，source-size取4或0。当前无nvcc，不能给真实SASS或指令周期；[PTX规范](https://docs.nvidia.com/cuda/parallel-thread-execution/#data-movement-and-conversion-instructions-cp-async)的non-bulk copy/commit/wait说明已读，不能把bulk async-proxy规则机械套入本课非bulk指令。

## Thor工具链检查

在Thor课目录执行，输出保存到忽略build目录：

```sh
mkdir -p build
cat /etc/nv_tegra_release > build/l4t.txt
uname -a > build/kernel.txt
cat /etc/os-release > build/os.txt
nvcc --version > build/nvcc.txt
nvidia-smi > build/driver.txt
ncu --version > build/ncu.txt
nvcc --list-gpu-code > build/targets.txt
sh build.sh gpu
./build/gemm sweep
```

构建和程序均锁定sm_110/11.0；不使用其他后缀。[JetPack7.0官方归档](https://developer.nvidia.com/embedded/jetpack/downloads/archive-7.0)给出可核实基线CUDA13.0.0+L4T38.2/38.2.1+Ubuntu24.04+T5000。实际driver补丁、当前安装ncu、权限尚未知；缺命令或不同版本需记录原错误并按对应SDK兼容表核实。当前Mac不具备上述能力。

## ncu定位→筛选→采集→关联

1. 先`./build/gemm bench`记录无profiler的两版event与主机区间P50/P95，再运行400组正确性。不要用replay下时间宣称收益。
2. `ncu --list-sections`及`ncu --query-metrics`保存本机支持列表。先看SpeedOfLight、MemoryWorkloadAnalysis、LaunchStats/Occupancy、SchedulerStats/WarpStateStats是否存在；不可用指标不是零。
3. `sh profile.sh sync`和`sh profile.sh async2`。脚本固定`--profile-from-start off`，程序20次预热后以cudaProfilerStart/Stop圈定一次launch；`--kernel-name-base function --kernel-name regex:gemm_async2 --launch-count 1`避免计入oracle、sweep或另一variant。
4. `ncu-ui build/async2.ncu-rep`打开报告；与sync添加baseline比较。Source页选择CUDA/PTX/SASS并设置本课源码搜索路径；`-lineinfo`保留对应关系。`ncu --import build/async2.ncu-rep --page source`导出文本。
5. 报告可能replay kernel并改变cache状态；记录cache-control/replay/warmup设置。计数器权限不足保留ERR_NVGPUCTRPERM，交设备管理员按该版本说明配置；本脚本不改系统权限。

| 证据问题 | 查看什么 | 能/不能推出什么 |
| --- | --- | --- |
| 是否减少可见的global依赖等待 | Source/Scoreboard Dependency、long scoreboard、issue active | 只有时间与等待同时改善才支持掩蔽；stall所在消费者不一定根因 |
| 搬运是否合并 | global sectors/requests与load efficiency类可用指标 | 16列映射让warp跨两行；不能假设32线程天然连续 |
| 双槽是否损害并发 | registers/thread、shared/block、active warps、occupancy限制 | shared翻倍不必然降低occupancy，须看哪一资源实际限制 |
| 是否转为计算/同步受限 | SM吞吐、eligible warps、barrier stall、shared加载 | FMA单依赖链与shared广播/复用可能限制；不是固定指令周期 |

## 导出与逐段阅读

`sh export-isa.sh`生成真实build/gemm.ptx、gemm.sass、resources.txt与工具版本。没有这些文件时不把手写文本称作编译证据。检查PTX的.target sm_110，SASS所属cubin sm_110；从kernel符号找到copy4内联区域、计算循环、两类屏障。

- 搬运段：`cp.async.ca.shared.global`→commit，可能隐藏延迟；并非零开销，尾部仍有地址/谓词工作。
- 到达段：wait_group→CTA barrier，确保数据完成和跨线程消费。若这里等待多，可能计算量不足或global未命中；需用上游加载证据区分。
- 消费段：shared load→FMA累加→下一次FMA，具有循环携带依赖；读取broadcast和bank行为须按实际地址和报告观察。
- 复用段：CTA barrier防止旧读者与下一轮写者冲突。更复杂流水可证明并合并冗余同步，但不能只因某次测试通过就删除。

本课没有实际SASS。不能预写LDGSTS等机器助记符并说它就是Thor编译结果，也不能给出“最慢指令排行”。NVIDIA[CUDA13工具说明](https://developer.nvidia.com/blog/whats-new-and-important-in-cuda-toolkit-13-0/)介绍Nsight2025.3的Instruction Mix/Scoreboard Dependency表，可用于实际采集后的定位。

## 架构对照：Thor与Hopper（不切换执行目标）

| 能力 | 首代引入/条件 | 本课选择 |
| --- | --- | --- |
| non-bulk cp.async | PTX7.0，SM80+；4/8/16B，ca/cg语义不同，cg仅16B | Thor基础sm_110沿用，不是Thor专属；本课用ca4B处理任意尾部 |
| Hopper bulk/TMA家族 | 基础bulk要求SM90+、PTX8.0；tensor map、mbarrier/完成语义及具体操作对齐须逐项满足 | 只作对照，未实现；小16×16tile与单层示例未必抵消描述符/屏障成本 |
| Hopper架构加速特性 | 部分MMA等要求专属目标；不能从“SM90+”推断所有a/f特性跨代可用 | 不生成其命令、不默认移植到Thor，不启用sm_110a |

[PTX官方文档](https://docs.nvidia.com/cuda/parallel-thread-execution/)和[CUTLASS目标说明](https://docs.nvidia.com/cutlass/4.4.0/overview.html)用于条件核查；没有将Hopper的专属MMA或TMA吞吐数字外推到Thor。本次对照焦点为搬运粒度与完成协议，下一GPU课轮换对照架构或Thor特性。
