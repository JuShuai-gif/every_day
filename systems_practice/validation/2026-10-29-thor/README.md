# Old_Thor 全仓验证记录（2026-10-29）

测试基线为 Git `4784a33`，修复后的源码在本次变更中。远端克隆位于 `/home/guhaoran/code/EveryDay`。设备为 NVIDIA Thor、Linux aarch64、L4T R38.4.0、驱动 580.00，宿主 GCC 13.3、Python 3.12.3、NumPy 1.26.4、CUDA 13.0.48、Nsight Compute 2025.3；容器 `ghr-flashrt-thor:latest` 为 PyTorch 2.12.0a0 / CUDA 13.2 / ncu 2026.1.1。所有自写 CUDA 编译目标为 `sm_110`。

## 覆盖与结果

- 117 个被跟踪 Python 文件通过 AST 解析；370 个 shell 文件通过 `bash -n`。语法检查不等于运行。
- 233 个 `run.sh` 首轮以宿主 `sh`、GCC 执行，168 通过、65 失败；其中 Bash 解释器错误经 Docker/Bash 复测 9 项通过。剩余非量化脚本用临时 GCC 包装器将 `-fno-vectorize/-fno-slp-vectorize` 映射为 GCC 对应选项，23 项中 20 项通过，另两项 ARM DOTPROD 经修复后通过。`daily/2026-09-15` 由明确 `sm_110` 目标编译和实机运行通过。`arm/2026-09-30` 经临时映射 Clang 参数到 GCC 后通过 4104 overlap 和 1026 disjoint 检查及 sanitizer，并产生 GCC 向量化诊断；Clang 专有诊断仍未运行，见 `arm-vectorizer-gcc.txt`。
- 复用已校验源码快照后，KIVI、SpQR、HQQ、OmniQuant 和 SmoothQuant 的原生 CPU 示例通过；对应日志为 `kivi-native.txt`、`cached-quant-first.txt` 和 `cached-quant-retry.txt`。这些运行使用容器现有 PyTorch，不代表原生低位 GPU 后端通过。10-28 FP8 原生示例在现有 torchao 0.18 镜像修复 dtype 和小 shape 静默回退后通过 `Float8Tensor` 与 FP16 误差检查（最大绝对误差 0.076416）；这是不同于原读 0.13 的兼容验证，不是指令或性能证明。GPTQ 固定 commit 快照的 5 个 SHA256 均匹配，原生 GPU 校准与 QDQ 评估通过（NRMSE 0.09776）；CUDA 打包扩展未安装，不能视为低位 kernel 性能。见 `gptq-native-final.txt`。26 个量化原生入口仍未通过：缺对应固定 commit 的上游 checkout、AIMET/AutoRound/HQQ/bitsandbytes/torchao 等包，或需要已审阅的特定 PyTorch 版本。未安装依赖，也未跳过版本校验。独立教学例子通过不代表原生接口通过；详见 `docker-retry.txt`。
- Git 跟踪的 28 个 `.cu` 文件以 CUDA 13.0、C++17、`-arch=sm_110` 编译；首轮 26 通过，两个 Softmax 缺 `math_constants.h`，修复后两者构建运行通过。28 项 GPU 测试命令均成功退出，含 TensorRT 两个例子、量化 GEMM、codec、内存传输；不同脚本覆盖程度不同，不能把每个退出码当全模型验证。原始批量结果见 `gpu-sweep.txt`。
- 加强后 2026-10-09 Softmax 比较 3 个行数 × 6 个列数 × 两 kernel 共 36 项；2026-10-28 GEMM 比较两个非整 tile shape × 两 kernel 共 4 项。2026-10-29 四位宽、28 个 fixture × 两 kernel 的硬件数值检查通过。`fixed-retests.txt` 与 `qgemm-final.txt` 为最终日志。

## 修复与真实性边界

修复 Softmax 缺常量头文件；10-28 GEMM 使用已初始化输入、二维 launch、独立 CPU oracle 和 RAII；10-09 Softmax 增加独立数值对照和 RAII；GCC 的 string_view/epoll 警告与 AArch64 DOTPROD 属性兼容问题修复。`profile.sh` 改为 CUDA 13 可用的 `cuobjdump --dump-sass`。`results/` 中的历史汇编曾被旧脚本覆盖，已先备份到远端 `.tmp/assembly-snapshots` 后恢复原文件。

`gemm-sm110.ptx.txt` 和 `gemm-sm110.sass.txt` 来自实际 Thor CUDA 13.0 编译；PTX `.target sm_110`，可观察 `bfe.s32`；SASS 可观察 `LDG`、`SHF`、`LOP3`、`STS`、`IMAD` 等指令。它们只能说明生成代码，不能单凭指令顺序推断耗时。ncu 宿主与普通 Docker 均报 `ERR_NVGPUCTRPERM`，无性能计数器报告；`ncu-container.txt` 中带 profiler 的 event 时间不作性能结论。控制频率/温度、E2E、功耗及硬件计数器尚未完成。

部分文本的行尾空白或末尾空行已规范化以通过 Git 检查；相应 `.raw.json` 原样编码原始输出。其余日志保留实际运行内容。所有中间二进制、容器和模型未纳入归档。
