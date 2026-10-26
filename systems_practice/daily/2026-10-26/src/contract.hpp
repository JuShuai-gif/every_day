#pragma once
#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <stdexcept>
#include <vector>
inline void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
inline int checked_size(int n) {
  require(n > 0 && n <= 65539, "shape outside profile [1,65539]");
  return n;
}
// 捕获键绑定对象身份和地址；地址内容可以更新，身份和形状不可暗换。
struct GraphKey {
  int n, profile;
  std::uintptr_t context, input, output;
  std::uint64_t generation;
  bool operator==(const GraphKey& b) const {
    return n == b.n && profile == b.profile && context == b.context && input == b.input &&
           output == b.output && generation == b.generation;
  }
};
class ReplayGate {
  GraphKey key_;
  bool ready_ = false, busy_ = false;

 public:
  explicit ReplayGate(GraphKey key) : key_(key) {
    checked_size(key.n);
  }
  void captured() {
    require(!busy_, "capture while busy");
    ready_ = true;
  }
  void submit(GraphKey key) {
    require(ready_ && !busy_ && key == key_, "stale or busy graph");
    busy_ = true;
  }
  void complete() {
    require(busy_, "completion without submission");
    busy_ = false;
  }
  bool busy() const {
    return busy_;
  }
};
inline float reference(float x) {
  return std::max(0.0f, std::fma(x, 0.5f, 0.25f));
}
inline std::vector<float> inputs(int n, int frame) {
  checked_size(n);
  std::vector<float> x(n);
  for (int i = 0; i < n; ++i) {
    x[i] = float((i + frame * 7) % 71 - 35) / 8;
  }
  return x;
}
inline void check(const std::vector<float>& x, const float* y) {
  for (std::size_t i = 0; i < x.size(); ++i) {
    require(std::isfinite(y[i]) && std::abs(y[i] - reference(x[i])) < 1e-6f, "output mismatch");
  }
}
