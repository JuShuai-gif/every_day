# 2026-11-09 SmoothQuant：alpha选择与校准覆盖

## 方法与应用场景

接入共享LayerNorm后的Linear时，固定alpha可能在当前分布很好、换一种输入就退化。今天深入同一个SmoothQuant方法的校准覆盖：独立校准集统计通道范围，独立调参集选alpha，独立评估集/漂移集报告误差；不把测试输入回灌校准。本课延续11月7日共享投影基础，新增覆盖通道的校准对照，11月8日AWQ后选本方法；外组LLM.int8游标保留待补，不冒充Han Lab原创。

算法是PTQ等价缩放，格式示例为对称有符号INT8，位宽W8A8，训练更新0；算法/存储格式/训练范式不同。s_j=max|X_j|^alpha/max|W_:j|^(1-alpha)，折叠LayerNorm权重和bias除s、全部共享Linear权重乘s。随后权重每输出通道absmax，激活每token absmax。原生W8A8Linear执行QDQ后的浮点F.linear，绝非原生INT8 Tensor Core。

## 原仓库与实际读过的实现

从[课程](https://hanlab.mit.edu/courses/2026-fall-65940)量化方向进入[Han Lab项目](https://hanlab.mit.edu/projects/smoothquant)，核对Guangxuan Xiao、Ji Lin、Song Han的MIT署名和MIT/NVIDIA合作。原论文[2211.10438](https://arxiv.org/abs/2211.10438)，量化栏目不套论文栏目时效窗口。

本日真实浅拉取[mit-han-lab/smoothquant](https://github.com/mit-han-lab/smoothquant)，固定commit `c61476d728e42ae0d8a35e7e78494edcac3237b5`，MIT许可。初次DNS失败和批准重试成功分别保留source-fetch*.json。实读smooth.py的smooth_ln_fcs、fake_quant.py的per-channel/per-token量化、W8A8Linear.from_float/forward、LICENSE；新拉取四文件与历史已读快照只差末尾换行，原生实现一致，真实SHA256见source.json。

调用链：示例prepare→smooth_ln_fcs→W8A8Linear.from_float→forward→F.linear。from_float原地修改传入权重，act_quant原地修改输入，故候选深拷贝、共享消费者输入clone是必要条件。示例编排与SQ81导出格式独立实现，未把它说成原仓库导出标准。

## 如何接入我的代码

在课目录运行`sh run.sh`，依赖已有torch、transformers；run.sh通过PYTHONPATH加载固定源码，不安装、不下载模型。可设置`SMOOTHQUANT_SOURCE=/path/to/source PYTHON=/path/to/python QUANT_OUTPUT=/path/to/writable/output`。默认导出到忽略的build/weights.bin。

输入float32：LayerNorm32，两个Linear32→24/16；cal64、tune32、test31、shift31样本分别生成，额外covered_cal64放大第7通道，训练为空。种子1109。alpha候选0/0.25/0.5/0.75/1，只以tune误差选取；覆盖校准对照保留同一alpha，以区分alpha和覆盖影响。输出打印普通/漂移/零输入、absmax/原SmoothQuant/覆盖校准/FP16对照。已有模型应替换同一LayerNorm后全部Linear，真实网络的残差/融合层须重新核查。

导出包括INT8权重、FP32 scale/bias及LayerNorm、头部与shape；export_reload真实读回文件并验证输出。该格式先还原FP32后计算，不可直接交给不匹配的INT8 backend。权重真实存储减少不等于执行时内存或速度减少。

## 量化前后比较与失败边界

results记录真实运行。只在执行成功后报告误差和字节数；计时是CPU LayerNorm+clone+QDQ+FP32 Linear，3轮预热、11个批均值取中位，每批20次，不是请求P95或GPU时间。metadata全部计入文件字节数。更广校准会增大scale并压低小值分辨率，可能有退化，不预设所有输入改善。

校准遗漏通道→漂移误差上升→对照独立covered_cal并观察普通输入退化；直接在原权重重复from_float→基线污染→深拷贝并导出重载核对。形状不匹配/非有限/非正scale和非法alpha由prepare拒绝；零激活在上游clamp合同下处理。

追问：alpha控制什么？为何不能用test选alpha？覆盖更广为何可能更差？from_float是否复制权重？SQ81能否直接喂Tensor Core？批均值中位数说明什么？

## Thor SM110与验证

Mac缺torch，host.txt为真实失败。Thor原生API、导出重载以results/thor.txt为准；源码SHA256和环境见当日validation目录。上游QDQ API运行与原生低位kernel是两项状态；本课没有新GPU kernel，不伪造ncu/PTX/SASS或量化加速。后端编译执行仍只允许C++17、sm_110，不能改为sm_110a；原生整数GEMM后端尚待集成验证。一个历史AutoRound依赖重试另存，不推进旧游标。

实测：Thor既有镜像Python3.12.3/torch2.12.0a0+5aff3928d8.nv26.05/transformers5.14.1原生API与重载通过。alpha=0.5；普通eval NRMSE absmax0.015222→smooth0.004058，覆盖校准0.004096略退化；shift smooth0.004873→covered0.003810。文件1876B（FP32参考5536B、FP16参考2768B）。CPU框架批均值P50 FP32约21.74µs、两种QDQ约50.96µs，QDQ更慢，不能声称INT8加速。原始数值见results/thor.txt。

新checkout没有本机缓存时，在仓库根目录执行`python3 systems_practice/quantization/fetch_source.py smoothquant --record systems_practice/.tmp/smoothquant-fetch.json`，核对输出commit为上述固定值；从该JSON的cache字段找到其source目录，再用`SMOOTHQUANT_SOURCE="$(pwd)/systems_practice/缓存相对路径/source" sh systems_practice/quantization/2026-11-09/smoothquant/run.sh`。若HEAD已变，须另取固定commit并核对source.json哈希，不静默跑新版本。不会安装torch/transformers。
