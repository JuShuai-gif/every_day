# CPU 实测量化对照

来源：`cpu.txt`，Release，合成独立评估集 M=32、K=65、N=19。百分比为输出 NRMSE，不是分类错误率。

| 格式 | absmax | SmoothQuant | 校准缩放 | 校准+离群残差 | QAT选中结果 |
|---|---:|---:|---:|---:|---:|
| W4A4 | 22.7527% | 10.5821% | 9.4600% | 1.9250% | 1.9250% |
| W4A16 | 6.3435% | 3.3827% | 2.4681% | 1.3144% | 1.3144% |
| W8A8 | 1.9212% | 0.5730% | 0.5730% | 0.1173% | 0.1207% |
| W8A16 | 0.3329% | 0.1643% | 0.1368% | 0.0794% | 0.0794% |

FP16舍入参考的输出 NRMSE：约 0.02987%。CPU计算展开为FP32累加；不能据此声称运行了FP16指令。

| 格式（outlier方法） | 正常 NRMSE | 新离群通道 NRMSE | 权重payload B | 元数据 B | 激活payload B | 总计 B | FP16 payload/总计 |
|---|---:|---:|---:|---:|---:|---:|---:|
| W4A4 | 1.9250% | 63.9467% | 694 | 652 | 1168 | 2514 | 2.637× |
| W4A16 | 1.3144% | 4.7765% | 694 | 652 | 4288 | 5634 | 1.177× |
| W8A8 | 0.1173% | 63.6909% | 1311 | 652 | 2208 | 4171 | 1.590× |
| W8A16 | 0.0794% | 0.2290% | 1311 | 652 | 4288 | 6251 | 1.061× |

总计是部署张量与scale/residual的序列化预算，不是进程RSS或CUDA allocator占用；FP16基准payload为6,630 B。量化模型在实验中还保留FP32训练状态，未把它计为部署文件。

QAT实际训练日志（40步，验证集选择checkpoint；step 0表示保留训练前结果）：

```text
QAT_TRACE W4A4 steps=40 changed_master_updates=47225 changed_final_packed_bytes=278 train_last=0.00746667884 selected_step=0
QAT_TRACE W4A16 steps=40 changed_master_updates=47620 changed_final_packed_bytes=194 train_last=0.00751424481 selected_step=0
QAT_TRACE W8A8 steps=40 changed_master_updates=47164 changed_final_packed_bytes=367 train_last=2.22931813e-05 selected_step=1
QAT_TRACE W8A16 steps=40 changed_master_updates=47496 changed_final_packed_bytes=252 train_last=2.29661224e-05 selected_step=0
```

多数模式没有验证集提升；W8A8选择step 1，但独立评估误差仍略升。完整运行日志同时保存训练前、选中checkpoint与最后一步损失，未隐藏退化。

CPU packed GEMM时间含解码、累加、输出vector分配，排除输入量化/packing、校准和训练；FP32/FP16舍入参考同样包含输出分配。它们是朴素CPU教学实现，不代表优化CPU库或Thor速度。GPU与端到端性能未验证。
