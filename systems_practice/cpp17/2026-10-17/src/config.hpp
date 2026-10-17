#pragma once
#include <atomic>
#include <optional>
#include <stdexcept>
struct Config {
  int slots;
};
// C++17 inline定义可以放头文件；跨TU同一对象并不使普通成员自动线程安全。
inline constexpr Config config{4};
inline std::atomic<int> accepted{0};
static const Config local_config{4};  // 安全对照：每个TU独立对象。
inline bool reserve(int requested) {
  if (requested < 0) {
    throw std::invalid_argument("negative slots");
  }
  if (requested > config.slots) {
    return false;
  }
  accepted.fetch_add(requested, std::memory_order_relaxed);
  return true;
}
const Config* other_config();
const Config* other_local();
const std::nullopt_t* other_nullopt();
void other_increment();
