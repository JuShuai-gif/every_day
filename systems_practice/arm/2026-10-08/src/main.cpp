#include <arm_neon.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <iostream>
#include <stdexcept>
#include <vector>

void check(bool b) {
  if (!b) {
    throw std::runtime_error("packing contract");
  }
}
struct Weights {
  int n, k, stride;
  std::vector<float> data;
  Weights(int nn, int kk, int ss) : n(nn), k(kk), stride(ss) {
    if (n < 0 || k < 0 || n > 2048 || k > 2048 || stride < k || stride > 4096) {
      throw std::invalid_argument("shape/stride");
    }
    data.resize(static_cast<std::size_t>(n) * stride, 0);
    for (int j = 0; j < n; ++j) {
      for (int t = 0; t < k; ++t) {
        data[j * stride + t] = float((j * 7 + t * 3) % 23 - 11) / 16;
      }
    }
  }
};
// P[panel][k][lane]：不足4输出的lane补零，不读取原权重越界区。
std::vector<float> pack(const Weights& w) {
  std::vector<float> p(static_cast<std::size_t>((w.n + 3) / 4) * w.k * 4, 0);
  for (int j = 0; j < w.n; j += 4) {
    for (int t = 0; t < w.k; ++t) {
      for (int l = 0; l < 4 && j + l < w.n; ++l) {
        p[(j / 4 * w.k + t) * 4 + l] = w.data[(j + l) * w.stride + t];
      }
    }
  }
  return p;
}
// 两路径保持相同的NEON FMA累加次序；仅改变每一步4个权重的供给。
__attribute__((noinline)) void compute(
    const float* a, int m, const Weights& w, const float* p, float* out) {
  for (int i = 0; i < m; ++i) {
    for (int j = 0; j < w.n; j += 4) {
      float32x4_t acc = vdupq_n_f32(0);
      for (int t = 0; t < w.k; ++t) {
        float32x4_t b;
        if (p) {
          b = vld1q_f32(p + (j / 4 * w.k + t) * 4);
        } else {
          alignas(16) float lanes[4] = {};
          for (int l = 0; l < 4 && j + l < w.n; ++l) {
            lanes[l] = w.data[(j + l) * w.stride + t];
          }
          b = vld1q_f32(lanes);
        }
        acc = vfmaq_n_f32(acc, b, a[i * w.k + t]);
      }
      float lanes[4];
      vst1q_f32(lanes, acc);
      for (int l = 0; l < 4 && j + l < w.n; ++l) {
        out[i * w.n + j + l] = lanes[l];
      }
    }
  }
}
volatile double sink = 0;
template <class F>
void measure(const char* name, F fn) {
  for (int i = 0; i < 3; ++i) {
    fn();
  }
  std::vector<double> times;
  for (int s = 0; s < 21; ++s) {
    const auto begin = std::chrono::steady_clock::now();
    for (int r = 0; r < 5; ++r) {
      fn();
    }
    const auto end = std::chrono::steady_clock::now();
    times.push_back(std::chrono::duration<double, std::micro>(end - begin).count() / 5);
  }
  std::sort(times.begin(), times.end());
  std::cout << name << " CPU_batch_mean_us P50=" << times[10] << " P95=" << times[19] << '\n';
}
int main() {
  try {
    int cases = 0;
    for (int m : {0, 1, 3}) {
      for (int n : {0, 1, 3, 4, 5, 17}) {
        for (int k : {0, 1, 3, 4, 5, 31, 33}) {
          for (int pad : {0, 7}) {
            Weights w(n, k, k + pad);
            auto p = pack(w);
            std::vector<float> a(static_cast<std::size_t>(m) * k, 0.375f), ref(m * n), got(m * n),
                direct(m * n);
            compute(a.data(), m, w, nullptr, direct.data());
            compute(a.data(), m, w, p.data(), got.data());
            for (int i = 0; i < m; ++i) {
              for (int j = 0; j < n; ++j) {
                double sum = 0;
                for (int t = 0; t < k; ++t) {
                  sum += double(a[i * k + t]) * w.data[j * w.stride + t];
                }
                check(std::abs(got[i * n + j] - sum) <= 1e-5 * (1 + std::abs(sum)));
                check(got[i * n + j] == direct[i * n + j]);
              }
            }
            ++cases;
          }
        }
      }
    }
    bool rejected = false;
    try {
      Weights bad(3, 8, 7);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    check(rejected);
    std::cout << "PASS cases=" << cases << " stride reject; identical direct/packed NEON order\n";
    for (int n : {17, 128}) {
      const int m = 4, k = 257;
      Weights w(n, k, k + 7);
      auto p = pack(w);
      std::vector<float> a(m * k, 0.375f), out(m * n);
      std::cout << "M=" << m << " N=" << n << " K=" << k << " stride=" << w.stride
                << " packed_bytes=" << p.size() * 4 << '\n';
      measure("direct", [&] {
        compute(a.data(), m, w, nullptr, out.data());
        sink += out[0];
      });
      measure("packed_reused", [&] {
        compute(a.data(), m, w, p.data(), out.data());
        sink += out[0];
      });
      measure("pack_only", [&] {
        auto q = pack(w);
        sink += q[0];
      });
      for (int reuse : {1, 8}) {
        std::cout << "reuse=" << reuse << " transaction (pack allocation included)\n";
        measure("direct_R", [&] {
          for (int r = 0; r < reuse; ++r) {
            compute(a.data(), m, w, nullptr, out.data());
            sink += out[0];
          }
        });
        measure("pack_plus_R", [&] {
          auto q = pack(w);
          for (int r = 0; r < reuse; ++r) {
            compute(a.data(), m, w, q.data(), out.data());
            sink += out[0];
          }
        });
      }
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
