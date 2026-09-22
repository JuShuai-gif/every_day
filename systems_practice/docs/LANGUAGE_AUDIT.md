# 历史课程 C/C++ 语言审查（2026-09-22）

本次按“底层、计算机体系结构、ARM/CPU的实现、基准与正确性验证使用C/C++，默认C++17”回查所有已交付课程、运行脚本及文档代码入口。目录迁移不变，不增加课次、不推进任何课程游标。

| 范围 | 发现与处理 |
| --- | --- |
| daily 的10个历史项目 | CPU辅助实现、并发、内存、GPU实现已是C++/CUDA C++；无需语言迁移 |
| ARM第01课 | 上轮已改为C++环境查询，本次确认无Python入口 |
| SCULPT论文例子 | 分位数/冻结、统计项、u8实际字节存储迁为C++17 |
| Edge deployment论文例子 | u4分块、FP16回退、物理字节解码、点积迁为C++17 |
| REAL-Q论文例子 | 标量矩阵计算、中心差分验证、冻结列、一次真实Adam更新迁为C++17 |
| ESTS论文例子 | JS/容量分配、专家路由重映射、FP32字节存储、标量推理迁为C++17 |
| AWQ/GPTQ/AdaRound/AutoRound | 自写打包、文件读写/解码、CPU数值基线和计时迁到共用C++后端；删除Python packing.py |
| 原生量化API | 四份example.py改名upstream_api.py；保留已核实上游接口、训练/校准/validation流程；部署验证交给C++ |

当前活跃源码不再有ARM或paper目录下的 `.py`。量化的位打包、内存格式、CPU计时不再由Python实现。GPTQ旧Python GPU/E2E基准已移除，当前只提供C++ CPU部署参考；原生GPTQ算法仍要求Thor SM110，GPU推理基准仍待CUDA C++后端接入，不能把CPU时间替代GPU时间。

## 仍保留 Python 的明确用途

- daily/2026-09-17 的 ONNX 建图和 RKNN 转换：上游模型转换API；板端Runtime和缓冲区处理仍为C++。
- quantization/fetch_source.py：获取公开源码与生成来源记录的管理工具。
- 四课 upstream_api.py：原生算法、训练或校准API，没有自写位打包、CPU内核或推理基准。
- quantization/native_bridge.py：仅将原生张量写成文本并启动C++进程；不实现教学计算。
- docs/references 中第三方原始README、results中的旧日志与历史迁移报告保留原样。它们不是当前课程入口；没有篡改上游快照或历史证据。

## 实际验证

四个论文工程及量化后端在Mac arm64上均完成CMake Release编译运行，启用 `-Wall -Wextra -Werror`；ASan/UBSan编译运行也通过。论文入口、C++源码、输出和历史记录均在 [论文索引](../paper/index.md)。随机样本使用C++生成器，数值会与历史Python样本不同；当前README引用新的真实结果。

[量化后端](../quantization/cpp/README.md)验证已知little-endian字节、u4空/奇数尾部、非法码、损坏/截断/多余字节、元数据、五种分组形状、63,488种有限FP16位模式、ties-to-even、已知GEMM和零行。另用四种课程形状的合成输入检查文本协议→C++打包→磁盘重载→解码→CPU输出与计时。该测试不是AWQ/GPTQ/AdaRound/AutoRound算法运行。

四个原生入口重新尝试，均退出2：缺固定源码/原生依赖，GPTQ还需Thor设备。`cpu_example_run`保持false；没有安装依赖、下载模型，没有RK3588/Jetson硬件测量。旧原始结果未覆盖，当前验证记录与旧记录分开。

## 阅读和运行

从 [论文索引](../paper/index.md) 进入C++例子，或运行 `sh systems_practice/quantization/cpp/run.sh check`。学习物理布局时重点看 [quant_cpu.cpp](../quantization/cpp/src/quant_cpu.cpp) 和 [lesson.hpp](../common/cpp/lesson.hpp)；上游API不代表底层实现。下一步课程仍是主轮换ARM SIMD/NEON、每日ARM第02课、量化HQQ。
