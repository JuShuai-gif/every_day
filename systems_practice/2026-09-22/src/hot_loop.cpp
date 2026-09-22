#include "counters.hpp"
namespace practice {
void increment(std::atomic<std::uint64_t>& counter, std::uint64_t iterations) noexcept {
  for (std::uint64_t i = 0; i < iterations; ++i) {
    // 只统计数量，不发布图像/张量；不需要用计数器建立 payload 的 happens-before。
    counter.fetch_add(1, std::memory_order_relaxed);
  }
}
}  // namespace practice
