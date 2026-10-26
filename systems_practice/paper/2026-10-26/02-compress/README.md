# CompressKV：检索head与token淘汰

Xiaolin Lin、Jingcun Wang、Olga Kondrateva、Yiyu Shi、Bing Li、Grace Li Zhang，[arXiv:2606.24467v1](https://arxiv.org/html/2606.24467v1)，首发/本版本2026-06-23；2026-10-26读取，预印本，接收状态未核实。实际读§3.1–3.4、§4.3–4.5、表2/3选段。

## 核心收获与作者证据

离线利用答案span内注意力质量识别检索head，再用这些head给token打分；层预算依据相对输出误差分配。作者在Mistral-7B、256-token预算下，表3报告SnapKV43.76、加head选择44.96、再加层分配45.43；这是作者特定任务平均值，不是本机结果。[原文](https://arxiv.org/html/2606.24467v1)

实际读[作者源码snapkv_utils.py](https://github.com/TUDa-HWAI/CompressKV/blob/4838455a7b0d32e130b96953a7487703d3af4ca4/methods/compresskv/snapkv_utils.py)，commit`4838455a7b0d32e130b96953a7487703d3af4ca4`。`init_compresskv→compresskvCluster.update_kv→get_important_head_kv`：近期window注意力、pool、selected-head平均、topk、gather历史KV并拼接近期窗口。根目录清单与该文件未见许可证，许可待核实；没有复制代码。未读完整离线head发现/预算训练路径，不能称全部开源算法已审查。

## 独立现成示例

[example.py](example.py)是标准库独立简化：三个head、六token、budget2，独立cal/tune-free eval/shift；只演示span选head如何改变token排名，省略作者pooling、GQA、近期window与层预算。没有训练更新，也不是原生API调用。

```sh
sh systems_practice/paper/2026-10-26/02-compress/run.sh
```

实际[输出](results/cpu.txt)：全部head选[0,5]，校准选head1后保留[2,3]；常规保留attention质量0.7，分布偏移后0.04。真实写出并解析FP16 K/V及uint16位置，24B原KV payload变为12B（含位置）；仅六token数据，不包含生产页表/allocator/文件格式开销。2个非法预算拒绝。无模型任务分数或GPU时间。

## 复现难度与迁移验收

完整复现中到难：作者源码提供消费端，但需要核实许可、依赖、head分数文件产生过程及数据集。先固定commit，审查离线校准与层预算，再用随机小attention检查GQA索引/近期窗口，之后才在授权本地模型和独立评估集上测试。缺torch/模型/设备，本次不运行作者API；没有自动安装或下载。

故障链一：所有head平均→边界token淹没中部→比较每head与聚合排名→离线选择检索head，但新任务可能失效。故障链二：校准分布变化→关键token被不可逆删除→保留shift评估与完整KV对照→提高budget/回退完整缓存，牺牲容量。故障链三：query head当KV head索引→GQA错位→核对`head//num_key_value_groups`→按实际映射回归，不能从head数量猜。

迁移验收需分开校准/调参/评估、记录实际缓存字节与生成长度、保留无收益结果。Thor后端编译运行必须单独sm_110验证，不照抄论文A100时间。追问：span质量和top1命中有何不同？GQA如何映射？保留质量能否等同任务准确率？token被删后分布变化如何恢复？

[验证](verification.json)：论文选段/作者selected实现已读，独立CPU例通过；原生模型/完整算法/Thor与端到端未复现。
