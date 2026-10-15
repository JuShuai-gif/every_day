#include <arm_neon.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <iostream>
#include <stdexcept>
#include <vector>
using V = std::vector<float>;
volatile float sink = 0;
void require(bool b) {
  if (!b) {
    throw std::runtime_error("validation failed");
  }
}
// 原始W为[N,K]；面板按[N/4,K,4]排列，末尾不足4列补零。
V pack(const V& w, int n, int k) {
  if (n < 1 || k < 1 || w.size() != std::size_t(n) * k) {
    throw std::invalid_argument("shape");
  }
  V p(std::size_t((n + 3) / 4) * k * 4);
  for (int j = 0; j < n; ++j) {
    for (int t = 0; t < k; ++t) {
      p[std::size_t(j / 4) * k * 4 + t * 4 + j % 4] = w[std::size_t(j) * k + t];
    }
  }
  return p;
}
__attribute__((noinline)) void scalar(const V& a, const V& w, V& y, int m, int n, int k) {
  for (int i = 0; i < m; ++i) {
    for (int j = 0; j < n; ++j) {
      float z = 0;
      for (int t = 0; t < k; ++t) {
        z += a[std::size_t(i) * k + t] * w[std::size_t(j) * k + t];
      }
      y[std::size_t(i) * n + j] = z;
    }
  }
}
__attribute__((noinline)) void neon(const V& a, const V& p, V& y, int m, int n, int k, int mr) {
  // mr=2复用同一权重向量，分别更新两行输出；小M不存在第二行时使用1行。
  for (int i = 0; i < m; i += mr) {
    for (int j = 0; j < n; j += 4) {
      float32x4_t c0 = vdupq_n_f32(0), c1 = vdupq_n_f32(0);
      for (int t = 0; t < k; ++t) {
        auto w = vld1q_f32(p.data() + std::size_t(j / 4) * k * 4 + t * 4);
        c0 = vfmaq_n_f32(c0, w, a[std::size_t(i) * k + t]);
        if (mr == 2 && i + 1 < m) {
          c1 = vfmaq_n_f32(c1, w, a[std::size_t(i + 1) * k + t]);
        }
      }
      float tmp[4];
      vst1q_f32(tmp, c0);
      for (int z = 0; z < std::min(4, n - j); ++z) {
        y[std::size_t(i) * n + j + z] = tmp[z];
      }
      if (mr == 2 && i + 1 < m) {
        vst1q_f32(tmp, c1);
        for (int z = 0; z < std::min(4, n - j); ++z) {
          y[std::size_t(i + 1) * n + j + z] = tmp[z];
        }
      }
    }
  }
}
template <class F>
double bench(F f, V& y) {
  for (int i = 0; i < 5; ++i) {
    f();
    sink = y[0];
  }
  std::vector<double> ts;
  for (int s = 0; s < 21; ++s) {
    auto t = std::chrono::steady_clock::now();
    for (int i = 0; i < 50; ++i) {
      f();
      sink = y[0];
    }
    ts.push_back(
        std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t).count() /
        50);
  }
  std::sort(ts.begin(), ts.end());
  return ts[10];
}
int main() {
  try {
    int cases = 0;
    for (int m : {1, 2, 3, 8}) {
      for (int n : {1, 7, 32, 65}) {
        for (int k : {1, 15, 64, 129}) {
          V a(m * k), w(n * k), ref(m * n), y(m * n);
          for (std::size_t i = 0; i < a.size(); ++i) {
            a[i] = float(int(i % 23) - 11) / 16;
          }
          for (std::size_t i = 0; i < w.size(); ++i) {
            w[i] = float(int(i % 31) - 15) / 19;
          }
          auto p = pack(w, n, k);
          scalar(a, w, ref, m, n, k);
          for (int mr : {1, 2}) {
            neon(a, p, y, m, n, k, mr);
            for (int i = 0; i < m * n; ++i) {
              require(std::abs(y[i] - ref[i]) <= 2e-4f * (1 + std::abs(ref[i])));
            }
            ++cases;
          }
        }
      }
    }
    bool rejected = false;
    try {
      pack({}, 0, 1);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    require(rejected);
    std::cout << "PASS cases=" << cases << " zero shape rejected\n";
    for (int m : {1, 2, 8}) {
      int n = 65, k = 129;
      V a(m * k, .25f), w(n * k, .125f), y(m * n);
      auto p = pack(w, n, k);
      double s = bench(
          [&] {
            scalar(a, w, y, m, n, k);
          },
          y);
      double n1 = bench(
          [&] {
            neon(a, p, y, m, n, k, 1);
          },
          y);
      double n2 = bench(
          [&] {
            neon(a, p, y, m, n, k, 2);
          },
          y);
      double e = bench(
          [&] {
            auto fresh = pack(w, n, k);
            neon(a, fresh, y, m, n, k, 2);
          },
          y);
      std::cout << "M=" << m << " N=65 K=129 CPU_batch_mean_p50_us scalar=" << s << " neon1=" << n1
                << " neon2=" << n2 << " pack_alloc_plus_neon2=" << e << '\n';
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
