# 2026-10-26 TensorRT：CUDA Graph重放与缓冲区寿命

## 工业场景

机器人视觉编码器的固定shape路径，CPU连续提交许多小kernel；今天以`[1,N]`连续FP32特征、`N∈[1,65539]`构造无需模型下载的完整TensorRT网络。预处理`0.5*x+0.25`后ReLU，关注提交开销与在途资源一致性。单槽有界内存，不能重放旧shape或提前复用buffer。仅CPU辅助验证已完成，GPU目标唯一Thor SM110。

## 概念回顾

CUDA Graph把一次推理的设备工作记录为可重放图，但它保存的是一次具体执行的参数和资源关系，并不是以后自动重新解释所有主机变量。TensorRT的动态形状更新包含状态准备；直接把第一次执行放进捕获区间，可能捕获不支持的初始化工作。因此本例先设置优化配置、输入形状和地址，普通执行一次并等待完成，再开始捕获。输入内容可以逐帧变化，只要更新发生在本次设备读取之前，地址、布局和对象身份仍满足捕获时的合同。

与图重放紧密耦合的是资源寿命。主机提交成功只表示工作已经排入流，不能证明GPU已读完输入或写完输出。单槽实现用同一流排序拷贝、预处理、推理和回传，最终同步完成后才解除忙碌状态。异常路径也需要先排空再释放图、页锁定内存和设备缓冲区；否则正常路径看似正确，偶发错误却可能在另一帧才暴露。缓存键因此包括形状、配置、上下文身份、地址和代次；即使地址数值被分配器复用，也不能据此认定是同一份资源。

算法融合与Graph应独立评价。把缩放和偏置合并，消除一次中间张量读写并减少一个kernel启动；四元素向量化则改变每线程工作量和寄存器需求。Graph沿用相同融合kernel，主要改变提交方式。比较时必须保持输入、精度、预热、采样和计时范围一致，分别记录CPU提交、设备管线和包含传输同步的请求子区间。小张量可能因有效线程不足而退化，多shape场景也可能无法摊薄捕获成本。没有目标设备计数器和原生编译证据，只能称为优化候选，CPU合同检查无法证明GPU同步、编译或性能。

## 知识图谱

```text
shape/profile → TensorRT内部状态准备 → capture → 图实例
context/buffer/generation ────────────────┘       ↓
输入内容更新 → 同流H2D → affine → TRT ReLU → D2H → 完成后复用
                             ↑
                     两kernel基线/融合float4候选
```

前置：流顺序、异步API、RAII、动态profile。区别：图对象不拥有业务buffer；CPU互斥不替代CUDA完成；Graph不是kernel融合；CPU event提交时间不是GPU event区间。内部pre/tmp随槽整体拥有，任何槽资源替换都必须换代重捕获。

## 编码练习

唯一25分钟任务：在现成两kernel基线和完整优化候选上，扩展`ReplayGate`，使缓存键任意一项变化均拒绝重放，并证明改输入内容不需要重捕获。5分钟读合同，10分钟实现/检查key，5分钟运行CPU例，5分钟审查Thor命令和完成回收位置。没有Thor时保留设备验收任务，不能把CPU执行当作完成GPU实验。现成最终版包含这些检查，供对照。

kernel优化路径与公平对照见[GPU_GUIDE](GPU_GUIDE.md)。默认程序依次运行baseline、fused、fused+graph；不依据未测结果自动选择最快版本。

## 文件说明

- [contract.hpp](src/contract.hpp)、[CPU检查](src/cpu_check.cpp)：状态与数值合同。
- [trt_graph.cpp](src/trt_graph.cpp)、[kernels.cu](src/kernels.cu)、[RAII](src/cuda_raii.hpp)：完整Thor实现。
- [来源](source.json)、[验证](verification.json)、[分析指南](GPU_GUIDE.md)、[profile.sh](profile.sh)、[export-isa.sh](export-isa.sh)。
- 固定附加栏目：[KIVI](../../quantization/2026-10-26/kivi/README.md)、[ARM集成02](../../arm/2026-10-26/README.md)、[OS25](../../os/2026-10-26/README.md)、[C++24](../../cpp17/2026-10-26/README.md)、[Minima-KV与CompressKV](../../paper/2026-10-26/README.md)。均为现成阅读例，不增加必做任务。

## 编译与运行

从仓库根执行：

```sh
sh systems_practice/daily/2026-10-26/run.sh cpu
sh systems_practice/daily/2026-10-26/run.sh sanitize
# 已有CUDA13/TensorRT10.13环境的Thor：
sh systems_practice/daily/2026-10-26/run.sh thor
```

Mac为Apple Clang21/C++17、Darwin arm64；未安装依赖。Thor编译使用`-arch=sm_110 -lineinfo`，运行检查cc11.0；真实SDK组合仍需板端核实。没有sm_110支持就终止，不切换其他执行目标。

## 正确性验证

CPU检查10个shape×20变值帧，共200帧；283次拒绝覆盖未捕获、忙碌重入、六类键变更、无提交却完成、非法shape。有限输入与FP32独立标量参考误差<1e-6。Thor同样10个shape，每模式20预热+31采样，逐次回传检查；没有把未执行设备用例计为通过。向量尾部不越界，释放顺序由最后构造的Drain保障。

## 性能分析

基线预处理逻辑读写16N B，融合8N B；这是源码模型，不是DRAM实测。Graph重放与fused直接enqueue比较保持相同kernel。详见[计量边界、ncu、PTX/SASS与Ampere对照](GPU_GUIDE.md)。目前GPU、NPU、完整端到端和功耗均无数字。ARM附栏的Mac数据属于另一CPU算子，不能用于推断本课收益。

## 实际运行结果

[初次CPU](results/cpu-initial.txt)及[初次sanitizer](results/sanitize-initial.txt)均输出`PASS frames=200 rejected=283`；最终格式化后记录见verification。实际[Thor构建](results/thor-initial.txt)失败为`nvcc: command not found`。TensorRT链接、CUDA编译、设备数值、ncu、真实PTX/SASS全部未验证；源内手写PTX不是生成产物。

## 工程注意事项

实际读[NVIDIA/TensorRT release/10.13 sampleInference.cpp](https://github.com/NVIDIA/TensorRT/blob/release/10.13/samples/common/sampleInference.cpp)的`IterationStd::createEnqueueFunction`：先enqueue/synchronize，再capture，失败结束capture并回退普通enqueue。读取2026-10-26，Apache-2.0；blob和范围见source。原场景是trtexec多流推理，本例为**独立启发实现**，保留初始化顺序和绑定寿命，省略多流/多图缓存/动态输出；捕获失败直接退出，没有伪装成自动fallback。

图销毁并不能等待所有业务请求；Drain必须先于资源析构。禁止在捕获期间调用同步拷贝或未经审查的默认流操作。生产多shape缓存应每项拥有独立context和资源，限制常驻容量，频繁miss时可选择普通enqueue。

## 工业故障与面试追问

| 触发→现象 | 根因与最小诊断 | 修复及代价 |
| --- | --- | --- |
| shape变化后旧图→输出错或越界 | 打印key/context/地址代次，与capture记录比对 | 拒绝旧图并新建槽，增加常驻内存与捕获成本 |
| 异常后立即释放→下一帧异步错误 | 检查最后成功提交点，compute-sanitizer定位 | 异常退出也排空，牺牲退出延迟保证寿命 |
| 第一次enqueue进捕获→capture失败 | 比较一次预执行前后错误码 | 将内部状态准备移出捕获；不支持模型回退普通路径 |
| fused微基准快但请求慢 | 分别看主机提交、设备event和拷贝同步 | 判断是否传输/排队主导，再决定是否采用 |

追问：①Graph捕获哪些状态？②为什么先执行一次？③同地址为何仍要generation？④event与CPU墙钟分别计什么？⑤float4何时不合法？⑥如何限制多shape图缓存的资源与冷启动成本？

## 自测问题

若输入shape和设备地址完全相同，但服务热更新后替换了TensorRT engine/context，同时还有旧请求在途，应如何决定旧图是否可重放，以及旧资源何时允许释放？
