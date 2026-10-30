# Vec-LUT：并行 token 的统一查表与缓存访问

论文 [arXiv:2512.06443](https://arxiv.org/abs/2512.06443)，v1 2025-12-06、v2 2026-04-14，已读摘要、问题定义和评估摘要。论文指出标量 LUT 对多 token 产生重复、非连续访问，提出统一 LUT、向量布局和 cache-aware streamed lookup，并报告在五种边缘设备上的加速；作者数字没有在本机复现。`example.py` 仅将两个 token 的索引组织成一次向量查表并统计访问数，未实现 llama.cpp 后端、未下载模型，也不声称 4.2×。
