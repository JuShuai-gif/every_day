# G²PTQ：刷新梯度/Hessian 与 trust region

arXiv:2609.31009，首次提交 2026-09-25，预印本。已读取的摘要说明：方法在 Transformer block 量化前刷新一、二阶统计，并以 trust-region 缩放限制补偿更新，解决固定 Hessian/陈旧梯度。作者报告它在多个模型/位宽改善与全精度模型的对齐；这里不转述未经全文核对的具体数值。作者代码链接为 [G2PTQ](https://github.com/G2PTQ/G2PTQ)，尚未实际读取。

`example.py` 仅可运行地展示“梯度步长必须被半径截断”，不是 GPTQ、不是作者 API、更不代表性能。复现难度高：需要模型、校准语料、GPU和块级统计。Thor SM110 未验证。
