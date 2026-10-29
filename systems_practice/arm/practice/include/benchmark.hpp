#pragma once

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <string>
#include <vector>

// 所有例子共享同一计时合同：固定输入、预热、重复采样、输出 p50/p95 和校验和。
// 计时只比较 baseline 与 optimized 的目标工作，不把数据初始化算进去。
inline int parse_mode(int argc, char** argv, std::string& mode) {
  mode = "both";
  if (argc == 3 && std::string(argv[1]) == "--mode")
    mode = argv[2];
  if (mode != "baseline" && mode != "optimized" && mode != "both") {
    std::cerr << "usage: " << argv[0] << " [--mode baseline|optimized|both]\n";
    return 1;
  }
  return 0;
}

template <typename F>
std::vector<double> sample_us(F&& f, int warmup = 10, int samples = 40) {
  for (int i = 0; i < warmup; ++i)
    f();
  std::vector<double> values;
  values.reserve(samples);
  for (int i = 0; i < samples; ++i) {
    const auto start = std::chrono::steady_clock::now();
    f();
    values.push_back(
        std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - start)
            .count());
  }
  return values;
}

inline void print_stats(const char* name, std::vector<double> values, std::uint64_t checksum) {
  std::sort(values.begin(), values.end());
  const auto at = [&values](double p) {
    return values[static_cast<std::size_t>((values.size() - 1) * p)];
  };
  std::cout << std::fixed << std::setprecision(3) << name << " p50_us=" << at(.50)
            << " p95_us=" << at(.95) << " checksum=" << checksum << '\n';
}

inline bool require_equal(std::uint64_t baseline, std::uint64_t optimized) {
  if (baseline == optimized)
    return true;
  std::cerr << "FAIL: result mismatch baseline=" << baseline << " optimized=" << optimized << '\n';
  return false;
}

// 防止微基准把本应观察的工作完全折叠为常量；不能用于业务代码的同步。
template <typename T>
inline void do_not_optimize(const T& value) {
  asm volatile("" : : "g"(value) : "memory");
}
