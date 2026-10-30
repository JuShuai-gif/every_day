# 2026-10-30 AWQ：激活感知通道缩放与真实打包边界

## 方法定位

AWQ 是 PTQ 搜索，INT4 是存储格式，W4A16 是权重/激活位宽，QAT 是训练范式；本日只深入通道缩放，不做训练更新。对 `Y=XW^T` 选正 scale `s`，把输入通道除以 `s`、对应权重列乘以 `s`，浮点函数保持等价，再用校准激活和独立调参集搜索 ratio，最后才量化与打包。

## 原仓库实现阅读

实际阅读 `mit-han-lab/llm-awq` 固定提交 `d6e797a42b9ef7778de8ee2352116e0f48a78d61`：`auto_scale.py:get_act_scale/scale_ln_fcs` 统计激活并融合 LayerNorm 与后继 Linear；`quantizer.py:pseudo_quantize_tensor/real_quantize_model_weight` 产生 qparams 与 WQLinear；`qmodule.py:pack_intweight/WQLinear.from_linear/forward` 负责交错 u4 打包和 batch 分支；`gemv_cuda.cu:gemv_kernel/gemv_forward_cuda_new` 展示 float4、half2、warp reduce 的低 batch GEMV。原场景是 TinyChat/LLM decoder；本课改成单层随机矩阵，保留 scale 方向、评估隔离和打包重载，省略完整 decoder、auto_clip 和模型下载。获取尝试见 `source-fetch.json`，网页阅读日期与永久链接在 `source.json`；不能把独立例子当作原生运行。

## 使用示例

`native_example.py` 在用户已有匹配环境时调用真实 `get_act_scale`、`scale_ln_fcs`、`pseudo_quantize_tensor`、`WQLinear.from_linear`，随机生成 `[tokens=32,K=128]` 校准/调参/评估输入，保存并重载单层权重。不要为了通过 import 安装依赖。`example.py` 是无依赖独立对照：K=33、N=7、group=16、offset-8 signed INT4，显式 pack/reload、评估集与 shift 集分离。

```sh
sh run.sh independent                 # 今日已运行
AWQ_ROOT=/path/to/llm-awq sh run.sh native  # 仅已有固定 checkout
# Thor 扩展候选（唯一目标）
TORCH_CUDA_ARCH_LIST=11.0 python3 setup.py build_ext --inplace
```

## 结果与边界

独立例实际输出保存在 `results/run-final.txt`：ratio=0.30；测试 NRMSE absmax `0.051529`→AWQ-inspired `0.022090`，shift 集却 `0.021850`→`0.032630`，说明搜索分布外会退化。真实 packed 文件 332 B（u4 116 B + group scales 84 B + channel scales 132 B），FP16 payload 462 B，metadata 在小层抵消压缩；decoded 重载逐值一致。Python 循环 P50 约 FP32 0.1652 ms、decoded 0.1591 ms，不是低位 kernel 加速。

## Thor SM110 专项

`src/gemv.cu` 为独立 W4A16 SIMT baseline/warp 候选，明确不是上游 WQLinear 格式、不是原生 Tensor Core 低位性能。`thor.sh`、`profile.sh`、`THOR.md` 给出 `-arch=sm_110`、ncu 筛选/采集、`cuobjdump`/`nvdisasm` 和源码关联；需目标 Thor CUDA13+ 工具链。Mac 无 nvcc/GPU，native torch、扩展、Thor、ncu、PTX/SASS 均未验证；不得填理论收益。对照架构仅解释 Hopper 的异步/矩阵路径差异。

## 故障链与接入点

1. 融合后浮点输出变化：scale 方向反了或遗漏 LayerNorm 的其他消费者；先做未量化等价检查，再量化。
2. 校准低误差、线上退化：重要通道统计分布漂移；固定 shift 集，失败时回退或重新校准。
3. checkpoint 能加载但输出错：u4 交错顺序、group scale 或零点语义与 kernel 不同；逐元素小矩阵回归，格式和后端一起版本化。

追问：为何按输入列缩放？量化后为何不再严格等价？group scale 怎样耦合通道？metadata 何时抵消压缩？W4A16 能否直接替换 W4A4 Tensor Core？QDQ Python 时间为什么不能外推 GEMV？

## 验证状态

源码阅读、示例交付、独立 CPU 运行已完成；上游浅克隆记录在 `source-fetch.json`（DNS/网络失败时不宣称 fetched）。原生 Python/torch、Thor 编译运行、ncu、真实 PTX/SASS 与性能待补。详见 `verification.json`。
