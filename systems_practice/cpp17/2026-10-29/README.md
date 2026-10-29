# 2026-10-29 C++17 第27课：构建与库边界

边缘服务的模型对象跨组件传递时，ABI 边界和所有权边界必须分开验收。实际阅读 LLVM `llvmorg-20.1.8` libc++ `__memory/shared_ptr.h` 的 `shared_ptr/weak_ptr/__shared_count` 路径；本例独立验证控制块的强弱引用寿命，未声称完成跨 DSO ABI 兼容测试。`sh run.sh` 编译 C++17 并验证强引用释放后 weak 仍可观察、最后 strong 释放后过期。Sanitizer、跨编译器/跨 DSO 和板端 SDK 未验证。故障链：不同编译器/运行库的控制块边界不一致→未定义释放；模块卸载仍有 weak 引用→悬空访问。追问：控制块何时销毁？ABI 稳定和 C++ 标准保证有什么差别？为什么必须用同一运行库释放？如何把 sanitizer 结果与真实部署分开？
