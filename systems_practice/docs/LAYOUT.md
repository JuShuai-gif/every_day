# 目录布局与 2026-09-22 迁移记录

```text
systems_practice/
├── README.md                     总入口
├── daily/                        每日知识轮换
│   ├── index.md
│   └── YYYY-MM-DD/[session-NN/]
├── quantization/                 每日量化方法
│   ├── index.md、catalog.json、progress.json
│   ├── fetch_source.py
│   └── YYYY-MM-DD/METHOD/
├── arm/                          每日 ARM
│   ├── index.md、curriculum.json、progress.json
│   └── YYYY-MM-DD/
├── paper/                        每日两篇论文
│   ├── index.md、progress.json
│   └── YYYY-MM-DD/论文目录/
├── os/                           每日两个OS主题（2026-09-28新增）
│   ├── index.md、curriculum.json、progress.json
│   └── YYYY-MM-DD/
├── cpp17/                        每日独立C++17（2026-09-29补齐）
│   ├── index.md、curriculum.json、progress.json
│   └── YYYY-MM-DD/
└── docs/                         通用说明
    ├── PRACTICE_SPEC.md
    ├── daily/
    ├── quantization/             栏目说明与模板
    ├── arm/                      学习路线与板卡说明
    ├── os/                        OS路线与模板
    ├── cpp17/                     C++17路线与模板
    ├── paper/
    ├── references/               已归档参考资料
    └── migrations/               目录整理的验证记录
```

文章 README、源码、构建配置、运行脚本及实际结果仍在同一课程目录。说明文件夹集中存放跨课程规则、路线和模板；栏目 README 只保留简短导航。

## 记录保留

按用户2026-09-22要求，来源、验证、实验输出、失败/重试及历史JSON和日志都保留。README汇总并链接，results/保存原始结果和历史快照，栏目层维护进度；不为简化目录删除记录，也不用Git历史替代现有证据。规则见 [完整规范](PRACTICE_SPEC.md)。

## 旧目录对应关系

| 原位置 | 新位置 |
| --- | --- |
| systems_practice/YYYY-MM-DD/ | systems_practice/daily/YYYY-MM-DD/ |
| systems_practice/YYYY-MM-DD/quantization/METHOD/ | systems_practice/quantization/YYYY-MM-DD/METHOD/ |
| systems_practice/index.md 中的主课历史 | systems_practice/daily/index.md |
| systems_practice/PRACTICE_SPEC.md 正文 | systems_practice/docs/PRACTICE_SPEC.md |
| arm/README.md 中的学习路线、arm/BOARDS.md | docs/arm/README.md、docs/arm/BOARDS.md |
| quantization/LESSON_TEMPLATE.md 正文 | docs/quantization/LESSON_TEMPLATE.md |
| paper/README.md 中的栏目说明 | docs/paper/README.md |
| references/ | docs/references/ |

根目录的旧规范、旧索引以及 quantization/ 下的旧模板文件只保留跳转说明，以兼容既有任务里固定的读取路径。任务读取后必须继续读取新正文，后续内容按新路径归档；没有创建第二个定时任务或复制第二份课程。

## 迁移验证

9 个日期目录、10 个主课工程（含一个同日 session）已迁移；4 天的量化栏目已拆出。迁移后 10 个主课的 CPU 构建/运行入口均成功，ARM 环境查询、源码工具帮助入口与 AdaRound 独立打包检查通过。4 个原生量化入口仍按原设计报缺源码/依赖，没有把预检退出当作算法执行成功。

主课、量化、ARM 和论文的进度没有推进。C/C++/CUDA 与 CMake 内容保持原字节；99 个历史原始日志/结果或第三方快照保持原字节，文档命令、导航链接与可操作进度路径已更新。上游 README 快照中的相对链接仍保持原文，须按上游仓库解释，不属于本站导航。

旧 CMake 缓存包含绝对源码路径，16 个缓存根目录已保留到忽略目录 `.tmp/layout-migration/old-builds/`，没有删除；当前课程可以按新路径重新构建。历史日志里出现旧目录是运行时的原始事实，不回写成新的路径。

[验证记录](migrations/2026-09-22/verification.json) · [路径映射与原始文件哈希](migrations/2026-09-22/pathmap.json) · [运行日志](migrations/2026-09-22/results/) · [返回总入口](../README.md)

## 2026-09-28 新增 OS

按用户要求新增os/独立栏目，随原任务每日交付两个相关主题；原四栏目保留。该新增不改变上面的2026-09-22迁移统计和历史记录。[OS入口](../os/index.md)。

## 2026-09-29 补齐独立 C++17

新增cpp17/，独立课号与游标；随既有每日任务交付，当前六栏目并行。此前C++主课继续保留在daily，未倒填为本栏目已交付记录。[入口](../cpp17/index.md)。
