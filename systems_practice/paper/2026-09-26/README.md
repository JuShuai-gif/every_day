# 2026-09-26 · 两篇论文补课

实际阅读与运行2026-09-28，主课之外的现成阅读材料，不另加作业。

- [AlphaQ: Calibration-Free Bit Allocation for Mixture-of-Experts Quantization](01-alphaq/README.md)：从权重谱估计Hill指数，构造重要性加权噪声eta=(median(alpha)/alpha)^gamma*Var(W)*2^(-2b)，在全局位预算内选择各层位宽。免校准指位分配，论文后续GPTQ仍用了校准样本。
- [Q-DEQ: Discrete Solving and Quantization for Deep Equilibrium Models in Time Series Forecasting under Edge Deployment Coding Constraints](02-qdeq/README.md)：在DEQ固定点附近用有限差分近似残差方向变化，编码局部系数为二进制，最小化二次能量。固定点求解保持连续精度，W8A8只加在re-forward，是另一阶段。

两篇独立小例子实际运行；完整模型/作者代码/Thor验收边界分别见各自source与verification。
