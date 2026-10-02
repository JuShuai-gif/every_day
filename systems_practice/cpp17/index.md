# 每日 C++17 索引

独立随每日北京时间08:30任务运行，同日不重复推进，不改变12个主方向。路线及完整28课见[课程说明](../docs/cpp17/README.md)，状态见[progress.json](progress.json)。此前主轮换中的C++课程保留原位，不倒填为本栏目的历史交付。

下一课：**05 字符串视图与借用**。

| 日期 | 课号 | 两个机制 | 实际验证 | 阅读入口 |
| --- | --- | --- | --- | --- |
| 2026-09-29 | 01 | optional状态 / 失败回滚 | Mac C++17 Release、ASan/UBSan通过；7类非法更新保留旧值，无性能结论 | [配置热更新](2026-09-29/README.md) |
| 2026-09-30 | 02 | 部分构造回滚 / Rule of Zero | Mac Release/ASan/UBSan：1000构造失败+1000移动和重复reset，2000资源均回收；无性能结论 | [对象寿命与RAII](2026-09-30/README.md) |
| 2026-10-01 | 03 | unique_ptr唯一所有权 / 移动后状态 | Release/ASan/UBSan 1000拒绝/异常/移动/reset循环，alive=0 | [所有权](2026-10-01/README.md) |

2026-10-02正式交付：[04 noexcept与vector扩容](2026-10-02/session-02/README.md)。Mac Release/ASan/UBSan通过；源码已读，Linux/板端未验。[并发旧游标补充](2026-10-02/README.md)保留但不计新课。
