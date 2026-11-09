#include <cmath>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>
std::vector<double> rates(const std::vector<uint64_t>& a,
                          const std::vector<uint64_t>& b,
                          double seconds) {
  if (a.empty() || a.size() != b.size() || !std::isfinite(seconds) || seconds <= 0) {
    throw std::invalid_argument("snapshot/time");
  }
  std::vector<double> out;
  for (size_t i = 0; i < a.size(); ++i) {
    // 重启、计数回绕或CPU列变化必须重采，不能无符号下溢生成巨大速率。
    if (b[i] < a[i]) {
      throw std::invalid_argument("counter reset");
    }
    out.push_back(double(b[i] - a[i]) / seconds);
  }
  return out;
}
int main() {
  auto r = rates({1000000, 20, 30, 40}, {1000000, 24, 30, 40}, 2);
  if (r != std::vector<double>({0, 2, 0, 0})) {
    return 1;
  }
  int rejects = 0;
  for (int i = 0; i < 4; ++i) {
    try {
      if (i == 0) {
        rates({}, {}, 1);
      }
      if (i == 1) {
        rates({1}, {1, 2}, 1);
      }
      if (i == 2) {
        rates({1}, {2}, 0);
      }
      if (i == 3) {
        rates({2}, {1}, 1);
      }
    } catch (const std::invalid_argument&) {
      ++rejects;
    }
  }
  if (rejects != 4) {
    return 1;
  }
  std::cout << "PASS CPU1=2 events/s despite CPU0 largest cumulative count; 4 rejected snapshots\n";
}
