# C++17 第28课：综合配置与推理服务的生命周期和有界发布

候选配置先由 `unique_ptr` 独占构造，校验成功后移动到发布槽；构造异常不会泄漏，移动后的源指针为空。实际阅读 LLVM libc++ `include/memory`（llvmorg-20.1.8，2026-10-30）中 `unique_ptr` 的析构/移动实现；示例改编为推理服务配置发布，未加入并发队列。Mac C++17 已运行并输出 `published=7 moved_from=1`；ASan/UBSan、动态库和板端未验。
