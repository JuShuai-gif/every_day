# 2026-10-28 两篇论文：结构化裁剪与混合量化

- [LayerTrim](01-layertrim/README.md)：arXiv:2610.19121，首发 2026-10-13；保留 attention/decoder depth，裁剪 MLP 特征。全文方法/实验/局限已读，作者代码未核实。
- [HQP](02-hqp/README.md)：arXiv:2602.06069，首发 2026-02-02；Fisher 近似敏感度→结构剪枝→INT8 PTQ。全文选段已读，独立例通过，完整 Jetson 复现未做。

两篇都只是 CPU 机制小例，不能替代模型精度、功耗、Thor/RK3588 设备验证。
