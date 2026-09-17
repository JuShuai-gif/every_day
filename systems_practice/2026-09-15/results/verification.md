# 本次验证记录

## 环境与成功验证

- 日期来源：实际执行 `TZ=Asia/Shanghai date +%F`，得到 `2026-09-15`。
- 本地时区实查：`2026-09-15 09:41:29 CST +0800`。
- Darwin 25.6.0、arm64；Apple clang 21.0.0；CMake 4.4.3。
- `bash run.sh` 最终退出码 0；成功输出在 `run-2m3zbaM3/output.log`。
- `bash -n run.sh` 成功；CPU Release 编译成功，无编译告警，四种形状与负 Batch 检查通过。
- ASan/UBSan 单独构建并实际执行成功，未报告错误，见 `sanitizers.log`。该构建的耗时包含插桩开销，未用作性能结论。

Sanitizer 复现命令（工作目录为当日练习目录）：

```bash
mkdir -p build/tmp
export TMPDIR="$PWD/build/tmp"
clang++ -std=c++17 -O1 -g -Wall -Wextra -Wpedantic -Werror \
  -fsanitize=address,undefined -fno-omit-frame-pointer \
  src/cpu_check.cpp -o build/cpu_check_sanitized
./build/cpu_check_sanitized
```

## 失败与修复

1. 初始日志重定向使用 Bash process substitution，沙箱返回 `/dev/fd/62: Operation not permitted`，退出码 1。直接原因是受限环境禁止该文件描述符访问；改为子进程加普通管道 `tee`，保留 `pipefail`，无需扩大权限。
2. 第一次普通管道版本在切换目录后使用原相对脚本路径，返回 `bash: systems_practice/2026-09-15/run.sh: No such file or directory`，退出码 127。改为当前脚本目录的绝对路径递归启动 worker，随后编译与测试成功。失败日志目录保留，无覆盖。
3. CMake 明确输出 `Looking for a CUDA compiler - NOTFOUND`。这不是 CUDA 编译成功，也不是 CUDA 代码编译失败；本机没有执行该编译阶段。`nvcc`、`nvidia-smi`、`nsys`、`ncu` 均未在 PATH 找到。

## 尚未验证

完整 `.cu` 已生成并人工静态审阅，但本机缺少 CUDA 工具链与 NVIDIA 设备，未验证 CUDA 语法编译、目标架构兼容性、GPU 运行/精度、真实显存峰值、GPU 时间、功耗与 Nsight 输出。CPU 索引校验及 Sanitizer 不能替代这些检查。
