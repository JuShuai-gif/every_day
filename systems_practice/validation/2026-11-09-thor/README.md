# 2026-11-09 Thor最终源码验收

Old_Thor可达：Jetson Thor、L4T38.4.0、Linux6.8.12-tegra、驱动580.00、CUDA13.0.48（/usr/local/cuda/bin/nvcc，宿主PATH未配置）、GCC13.3。既有ghr-flashrt-thor容器停止，使用相同备份镜像创建一次性无网络容器，pull=never，未安装软件。具体环境见results/environment.txt和tool-versions.txt。

SHA256SUMS列17个最终源码/脚本/上游原生实现；通过scp传到远端systems_practice/.tmp/verify-20261109.*独立目录，先hash、运行、再hash。实际远端路径见results/evidence/*.command.txt；本地与前后hash一致。不通过GitHub传代码，未覆盖远端工作区。

results/evidence/exits.txt：daily/arm/os/cpp17 Release与ASan/UBSan全部0，两篇论文CPU例0，ARM真实汇编生成0，SmoothQuant原生API+真实i8文件重载0。每项command.txt为真实命令，对应txt为原始输出。run_remote.sh可复跑相同输入，首次宿主nvcc PATH失败与停止容器exec失败保留在environment.txt。

SmoothQuant使用torch2.12.0a0+5aff3928d8.nv26.05、transformers5.14.1、Python3.12.3，CPU运行。QDQ API经过已读原仓库，不是独立数学替代；其浮点GEMM不是原生INT8性能。没有新GPU kernel，因此本日ncu/PTX/SASS不适用；CUDA未来仍固定C++17/sm_110。原生整数后端另记backlog，不把QDQ速度冒充低位收益。

单个历史AutoRound依赖重试退出1，仍缺auto_round；它不计今日新课，也不混入今日发布。旧日未验收源码与用户改动保持本地。RK016宿主Release/ASan通过，RK3588无板端连接，按用户允许先生成规则保持board pending，不用Thor代测。

仓库format-cpp.sh在仅含本次5份C++的隔离镜像执行，复制回后重新编译运行；不格式化历史用户改动。git diff --check通过。发布范围只含今日课程、今日验收和索引的今日增量；以前未发布材料不混入。

终端原始尾空白保存在results/raw-whitespace.json（JSON转义无损）；对应txt仅规范尾空白以通过diff检查。RK根导航/PLAN/progress含此前未发布历史，本次只更新本地，不把整份历史状态混入提交；今日RK016直接通过主课链接访问。
