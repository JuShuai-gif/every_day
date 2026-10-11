# TOGA：联合决定剪枝和混合位宽

[论文元数据](https://arxiv.org/abs/2606.07819) · [实际阅读v1全文](https://arxiv.org/html/2606.07819v1)

Hoang-Loc La、Truong-Thanh Le、Amir Taherkordi、Phuong Hoai Ha；arXiv:2606.07819，2026-06-05首发v1，本次未发现更新版本/已核实发表状态，按预印本处理。论文CC BY-NC-ND4.0；只保存原创讲解与自写例子，不分发论文改版。2026-10-11读§2.3、§3.1–3.2、§4.1、§4.6/Table3及§6限制。

## 问题、方法与关键公式

先剪掉通道再独立挑位宽可能错过组合解；只按每层误差优化也不能看到误差沿整个模型传播。TOGA通过supernet同时编码结构选择与高低精度mask。`Fquant(W,M)=Qh(W)*M+Ql(W)*(1-M)`，输入也按匹配通道mask选择位宽；剪枝mask再决定保留的结构。hypernetwork使用Gumbel-Softmax/STE形成离散决策，并优化端到端CE与预算罚项 `|log(B/b)|`。虽然作者称PTQ，hypernetwork确实需要训练；不能把“基础权重未全面finetune”解释为没有梯度更新。

作者还按校准激活量重排通道，并用GPTQ修正。本课例子没有这些步骤。论文§4.1报告单A10080GB、batch1、量化2000步或联合10000步；§6指出全模型驻留使70B等规模困难。作者Table3在Llama2-7B上给出WikiText2 PPL：12.5%高精度通道方案6.03，加重排5.78，再加GPTQ5.38；这是多机制组合，不能把最终数字当作仅mask优化贡献。

## 现成预算反例与真实结果

```sh
sh systems_practice/paper/2026-10-11/02-toga/run.sh
```

[example.py](example.py)是Python标准库四通道线性模型，枚举每通道{删除,2bit,4bit,8bit}，预算<=12逻辑bit，在独立calibration上选解，再看heldout与shifted。统一[-1,1]范围简化量化，含零预算log拒绝。**没有hypernetwork、autograd或训练更新**；这只是联合离散搜索空间的可运行说明，不是作者训练复现，也没有真实打包或低位kernel。

[输出](results/cpu.txt)保留无收益：联合与先剪后均匀4bit都选[4,4,4,0]；calibration MSE0.01067857，heldout0.09300340，shifted14.44。删除第4通道在原分布看似便宜，但测试把该通道放大20倍后误差放大。12bit仅是数值模型预算，metadata/索引/scale不在其中，不能作真实文件大小或速度声明。

## 复现难度、失效链路与迁移

难：完整训练需预先存在本地LLM、数据与GPU显存，超网络/STE细节、结构重写和作者混精kernel都要匹配。精确标题GitHub检索和全文未确认可读作者仓库，训练/导出/评估实现可得性保留未知，不编造原生API。先在小模型实现真实训练并记录参数更新，再做结构导出/重载和packed存储，再独立评估任务；本次未自动安装或下载。

故障链一：预算罚项下降但实际文件不小→理论平均bit忽略scale/索引与对齐→逐文件统计和部署算子可用性→改按真实成本约束，付出更复杂搜索。故障链二：校准均值好但新场景差→被剪通道在偏移输入重要→保留shifted测试不反调参→增加校准覆盖/降低剪枝比，并用heldout确认。故障链三：mask的位宽/形状与kernel不符→后端回退或重排错误→检查通道顺序、打包和输出oracle→只有原生路径实际执行后才能写吞吐收益。

迁移验收：训练、校准、调参、评估数据分离；真实更新日志；所有零预算/全剪边界受控；导出后精度；文件总字节；预处理/重排/kernel/端到端计时。未来CUDA仅Thor SM110，不能照搬论文A100命令或在Mac冒充GPU性能。

追问：联合空间比顺序法多哪些解？预算罚项为何拒绝0？STE更新的是谁？通道重排为何影响scale？mixed-bit为何可能比均匀位宽更慢？无收益结果怎样影响采用决策？

[source.json](source.json)和[verification.json](verification.json)：全文选段与CPU例子是；作者源码、实际训练、packed存储、模型任务精度、Thor均否。后续缺项已入backlog。
