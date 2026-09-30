#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>
extern "C" void transform_auto(std::uint32_t*, const std::uint32_t*, std::size_t);
extern "C" void transform_scalar(std::uint32_t*, const std::uint32_t*, std::size_t);
using Fn = void (*)(std::uint32_t*, const std::uint32_t*, std::size_t);
void verify() {
  int tests = 0;
  for (std::size_t n = 0; n <= 1025; ++n) {
    for (int offset : {0, 1, -1, 8}) {
      std::vector<std::uint32_t> ref(n + 32), got;
      for (std::size_t i = 0; i < ref.size(); ++i) {
        ref[i] = static_cast<std::uint32_t>(i * 123456789u);
      }
      got = ref;
      // 仅在同一已分配数组内重叠；unsigned溢出按模2^32定义。
      auto si = std::size_t(8), di = static_cast<std::size_t>(8 + offset);
      for (std::size_t i = 0; i < n; ++i) {
        ref[di + i] = ref[si + i] * 3u + 1u;
      }
      transform_auto(got.data() + di, got.data() + si, n);
      if (got != ref) {
        throw std::runtime_error("overlap semantic mismatch");
      }
      ++tests;
    }
    std::vector<std::uint32_t> src(n, 0xffffffffu), dst(n), ref(n);
    transform_auto(dst.data(), src.data(), n);
    transform_scalar(ref.data(), src.data(), n);
    if (dst != ref) {
      throw std::runtime_error("disjoint mismatch");
    }
  }
  std::cout << "PASS " << tests << " overlap cases + 1026 disjoint lengths\n";
}
void bench(Fn f, const char* name, std::size_t n) {
  std::vector<std::uint32_t> a(n, 7), b(n);
  for (int i = 0; i < 20; ++i) {
    f(b.data(), a.data(), n);
  }
  std::vector<double> us;
  for (int i = 0; i < 101; ++i) {
    auto t = std::chrono::steady_clock::now();
    // 跨翻译单元且无LTO；每样本128次均值，不是单请求P95。
    for (int j = 0; j < 128; ++j) {
      f(b.data(), a.data(), n);
    }
    us.push_back(
        std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t).count() /
        128);
  }
  for (auto v : b) {
    if (v != 22) {
      throw std::runtime_error("benchmark wrong");
    }
  }
  std::sort(us.begin(), us.end());
  std::cout << name << " n=" << n << " CPU_batch_mean_us p50=" << us[50] << " p95=" << us[95]
            << '\n';
}
int main(int argc, char**) {
  try {
    verify();
    if (argc == 1) {
      for (auto n : {16u, 4096u, 262144u}) {
        bench(transform_scalar, "scalar", n);
        bench(transform_auto, "auto", n);
      }
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
