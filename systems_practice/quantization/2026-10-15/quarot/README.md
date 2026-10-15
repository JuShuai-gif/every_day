# 2026-10-15 QuaRot第二轮：在线旋转成本与真实i4导出

## 方法与应用场景

固定随机正交旋转把集中在少量通道的能量分散，降低低位量化难度；算法是QuaRot式旋转PTQ，格式是signed INT4二补码，位宽是W4A4，训练范式为无训练PTQ，四者不能互换。区别于昨天OmniQuant学习裁剪，本例没有梯度更新、校准优化或旋转搜索。随机矩阵种子固定，不用评估集选种子。

本轮新问题是**独立Linear的旋转成本不能靠跨层融合凭空消失**。输入 `[31,32]`、权重 `[16,32]` FP32，Y=XWᵀ；Q正交，则 `(XQ)(WQ)ᵀ=Y`。W离线旋转，X在线旋转；在线计算和Q存储必须计入。整体Transformer的旋转消去还要求RMSNorm、残差、attention、MLP等相容重参数化，不能把单层例直接跨非线性搬走。

## 原仓库与实际读过的实现

[spcl/QuaRot](https://github.com/spcl/QuaRot)，commit `5008669b08c1f11f9b64d52d16fddd47ca754c5a`，Apache-2.0，实际浅拉取2026-10-15。首次网络失败见[source.json](source.json)，成功重试见[source-retry.json](source-retry.json)；精确额外文件/哈希/永久链接见[source-read.json](source-read.json)。未发现仓库迁移。

实际阅读调用链：`hadamard_utils.random_hadamard_matrix→matmul_hadU→get_hadK`产生归一化符号Hadamard；`ActQuantizer.configure/find_params/quantize→sym_quant`获得整数与scale；`pack_i4→two_compl`把偶列低nibble、奇列高nibble打包，`unpack_i4`符号扩展。`rotation_utils.rotate_model→rotate_mlp_input/output/rotate_ov_proj`以及`register_online_rotation/online_rotate`解释全模型与在线边界；`fake_quant/README.md`是官方CLI入口说明。

本例**原样调用上述Hadamard、量化与打包API，单Linear实验编排独立实现**。为减少示例复杂性，把W的每个输出行交给原生ActQuantizer统计；这不是完整QuaRot GPTQ权重优化流程。实际已读setup.py包含固定旧架构列表与自动安装第三方扩展步骤，本任务不执行该安装脚本。

## 如何接入我的代码

工作目录本README目录。已有源码缓存（不入Git）是 `systems_practice/.tmp/quant_sources/quarot-nlnkcd41/source`，包含已读模块；另可在用户准备好的固定commit仓库上运行。原始主仓库setup未固定运行依赖版本，不能编造已验证环境。脚本依赖torch（需支持weights_only加载、CPU FP16矩阵乘）、numpy、transformers、accelerate与fast_hadamard_transform导入包；后者虽然本例调用CPU `matmul_hadU`，原模块仍在import时依赖扩展。Python3.10+、torch2.6+可作为待验证候选，非本次兼容性认证。实际系统Python3.9.6缺torch，详细探针见results。

```sh
# 不安装、不拉模型；QUAROT_SOURCE为你已准备的固定commit源码根目录
QUAROT_SOURCE=/Users/guhaoran/code/EveryDay/systems_practice/.tmp/quant_sources/quarot-nlnkcd41/source sh run.sh
```

`example.py`：生成固定Q与随机W→检查QᵀQ→原生absmax/旋转W量化→原生pack_i4→torch.save真实文件→重载unpack→评估浮点GEMM。输出在忽略的`build/native`。权重scale逐输出行，激活scale逐token；signed范围[-8,7]，scale=absmax/7，零行scale=1；反量化为q×scale，矩阵乘采用浮点累加，不声称INT32/Tensor Core。X与W都真实产生i4码，权重实际打包导出；在线激活在此例只QDQ，不谎称packed激活kernel。

已有`torch.nn.Linear`接入点：用`linear.weight.detach().float().cpu()`替换weight，设置N/K；K须偶数且当前Hadamard分解可支持（本例32），bias保留加回。推理在原输入处施加XQ，再用重载的WQ反量化权重；不改变输出坐标，因此bias无需旋转。若跨层融合，必须另验证完整图等价。代码提供随机评估集及分布变化集，均不用于选参数；本期无训练集、校准搜索/调参集并不是遗漏流程，而是固定随机PTQ不使用这些阶段。后续裁剪/GPTQ搜索要另划分数据。

## 量化前后比较

同输入评估FP32、实际FP16 GEMM、未旋转absmax W4A4 QDQ、旋转W4A4 QDQ。脚本输出NRMSE/max_abs/cosine、码端点占比（不等同真实饱和率）、packed payload/scale/文件容器字节、Q的额外字节；零行与非法code8边界。21次CPU框架请求中位耗时，5次预热，含在线旋转/激活量化与浮点GEMM，不含离线权重解码、导出和文件I/O。

| 指标 | 本次状态 |
| --- | --- |
| 原生误差、真实文件字节、CPU时间 | 缺torch，未运行；无数值 |
| W仅payload理论大小 | 256B i4 +64B scale，对比1024B FP16权重；这不是实测文件 |
| 独立Q理论大小 | 32×32×4=4096B，可能远超权重节省；完整模型融合条件不可省略 |
| Thor低位kernel与E2E | 未验证 |

不保证旋转一定改善；脚本保留shift退化和torch保存的小张量容器开销。不将CPU浮点QDQ耗时称为原生低位性能。

## Thor SM110 与优化

已核对[CUDA13 Thor官方说明](https://developer.nvidia.com/blog/whats-new-in-cuda-toolkit-13-0-for-jetson-thor-unified-arm-ecosystem-and-more)：JetPack7提供CUDA13基础。原仓库setup.py `get_cuda_arch_flags`硬编码旧SM，`TORCH_CUDA_ARCH_LIST`可能无法覆盖显式gencode，故**原后端不能直接按本例宣称支持Thor**。

迁移计划：在独立源码副本把该函数唯一返回项改为 `['-gencode','arch=compute_110,code=sm_110']`，审计fast-hadamard-transform/CUTLASS子依赖目标及CUDA13/torch ABI，再只生成sm_110产物；不能擅自用a/f后缀，也不能照抄旧多目标构建。此次不提供未读的fast-hadamard-transform构建参数、不自动安装。候选验证顺序为CPU原生算法→Thor浮点QDQ等价→原生packing ABI→kernel/端到端测量；精确依赖commit及扩展兼容性仍待补。

本栏目没有自写/执行CUDA kernel，勿把主课转置的ncu数据当QuaRot GEMM证据。真正接入低位后端时须重新补其kernel基线/优化、SM110 PTX/SASS和ncu，不以fake_quant通过替代验收。

## 故障链与追问

1. 未量化旋转后输出就错：Q方向、归一化或W布局错误→先断言QᵀQ及浮点等价→核对F.linear的转置语义→再量化；不能调clip掩盖代数错位。
2. 压缩权重却内存更大/更慢：独立Q和torch容器、在线dense旋转主导→分项字节/耗时→满足图合同后融合或结构化Hadamard→回归真实E2E，不按4bit预言提速。
3. 安装后找不到合适kernel：构建只有旧SM/子依赖不兼容→审查实际fatbin、编译日志→固定sm_110重建与验证，缺设备保持未验。

追问：①算法/格式/位宽/PTQ如何区分？②XQ/WQ为何等价？③何时旋转不能跨非线性？④int4符号与nibble顺序怎样核验？⑤独立Q成本怎样计入？⑥如何验证低位后端实际执行路径？

## 验证与待补

[source获取/阅读/示例/CPU/Thor五项](verification.json)为 **是/是/是/否/否**。CPU原生在import torch处失败，未生成压缩文件/误差/性能。AST和shell检查不算原生执行。历史SpinQuant只重试获取一次，固定commit但旧rotation路径缺失，记录[retry](spinquant-backlog-retry.json)，不推进SpinQuant或谎称阅读成功。下一方法SpinQuant；当日QuaRot游标仅推进一次。
