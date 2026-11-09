# Quant VideoGen: Auto-Regressive Long Video Generation via 2-Bit KV-Cache Quantization

首次2026-02-03；阅读v1，当前修订2026-05-05 v5，读取2026-11-09。[一手全文](https://arxiv.org/html/2602.02958v1) · [版本历史](https://arxiv.org/abs/2602.02958) · [Han Lab项目与作者单位](https://hanlab.mit.edu/projects/quant-videogen) · [官方仓库](https://github.com/svg-project/Quant-VideoGen)。论文作者含Song Han及MIT成员；完整署名见项目/原文，符合Han Lab规则。

问题是视频历史KV占用增长。核心：按语义聚类减去中心，反复分解残差，最后只量化末级残差；重建时逐层加回中心。公式为R(t)=R(t-1)-C(t)[id(t)]，Xhat=QDQ(R(T))+ΣC(t)[id(t)]。读v1 §3–5、表1；该版本表1的LongCat-Video-13B/480p/INT2下，QVG报告6.94倍KV压缩、PSNR28.716，RTN为20.872；这些是作者结果，非Thor实测。当前arXiv注明ICML2026接收。

独立例用一维两中心和8次聚类迭代，比较0/1/2级，真实2bit残差打包并把中心/索引计入字节数；省略多维KV、流式centroid缓存、融合kernel与视频评估。小输入metadata可能抵消压缩，不能只报位宽。

复现难：需要作者支持的视频模型、权重、固定视频/提示与相应GPU环境。最小路线先固定KV张量核对编码/重建，再测长视频质量与额外延迟；不自动下载。失效链：簇太多→metadata膨胀→记录总字节；漂移导致centroid失配→误差上升→重聚类并计入开销。追问：中心占多少存储？为什么只量化末级？K/V能否共用簇？MSE能否替代视频指标？

运行：本目录`sh run.sh`。Python标准库；results保留输出。源码获取/阅读与运行状态见source.json、verification.json；作者全仓训练/评估完整性尚未审计，不把仓库存在当全流程可复现。无ncu/PTX/SASS结果，今后CUDA执行仅Thor SM110。

源码补充：2026-11-09实际阅读main分支`quant_videogen/compress.py`的get_quantize_fn, get_quantize_type, compress_kv_cache，许可Repository root has no LICENSE; not confirmed。只读相关入口，不代表全仓审计。Mac与Thor独立CPU例均通过，见results/host.txt、thor.txt。

作者compress_kv_cache分别对K/V选择centroid数量，按quant_type路由PRQ或Triton路径；get_quantize_fn中部分路径属于sim模块，不能只见int2名称就判断真实打包。本文独立示例确实构造bytes，但没有运行作者kernel。
