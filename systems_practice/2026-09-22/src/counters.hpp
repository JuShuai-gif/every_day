#pragma once
#include <array>
#include <atomic>
#include <cstddef>
#include <cstdint>
#include <stdexcept>

namespace practice {
constexpr std::size_t max_workers = 8;

// 对齐是布局候选，不声称 128 就是运行设备的缓存行大小。
struct PackedSlot {
  std::atomic<std::uint64_t> value{0};
};
template <std::size_t Spacing>
struct alignas(Spacing) IsolatedSlot {
  static_assert(Spacing >= alignof(std::atomic<std::uint64_t>));
  static_assert((Spacing & (Spacing - 1)) == 0);
  std::atomic<std::uint64_t> value{0};
};

// 外层也对齐，避免 packed 数组起始偏移给每轮试验带来不同分组。
template <class Slot>
class alignas(256) Counters {
 public:
  explicit Counters(std::size_t workers) : workers_(workers) {
    if (workers == 0 || workers > max_workers) {
      throw std::invalid_argument("workers must be in [1,8]");
    }
  }
  std::atomic<std::uint64_t>& at(std::size_t worker) {
    if (worker >= workers_) {
      throw std::out_of_range("worker id");
    }
    return slots_[worker].value;
  }
  void reset() noexcept {
    // 只能在全部写者停止后调用；relaxed 不替你实现生命周期协议。
    for (auto& slot : slots_) {
      slot.value.store(0, std::memory_order_relaxed);
    }
  }
  std::uint64_t sum() const noexcept {
    std::uint64_t result = 0;
    for (std::size_t i = 0; i < workers_; ++i) {
      result += slots_[i].value.load(std::memory_order_relaxed);
    }
    return result;
  }
  static constexpr std::size_t slot_bytes = sizeof(Slot);

 private:
  std::array<Slot, max_workers> slots_{};
  std::size_t workers_;
};

// 独立函数保留在真实汇编中；三种布局调用同一原子递增热循环。
void increment(std::atomic<std::uint64_t>& counter, std::uint64_t iterations) noexcept;
}  // namespace practice
