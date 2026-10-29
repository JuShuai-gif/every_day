#include <arm_neon.h>

#include <chrono>
#include <iostream>

#include "../../../daily/2026-10-25/src/reference.hpp"

// 四个lane分别代表四行；沿列循环累加，绝不能水平归约合并四行。
__attribute__((noinline)) void packed4(const float* x, float* y, int cols) {
  auto sum = vdupq_n_f32(0);
  for (int c = 0; c < cols; ++c) {
    auto v = vld1q_f32(x + 4 * c);
    sum = vfmaq_f32(sum, v, v);
  }
  auto z = vaddq_f32(vdivq_f32(sum, vdupq_n_f32(float(cols))), vdupq_n_f32(1e-5f));
  auto inv = vrsqrteq_f32(z);
  // 两轮Newton修正作用于每个lane，仍没有跨行混合。
  for (int i = 0; i < 2; ++i) {
    inv = vmulq_f32(inv, vrsqrtsq_f32(vmulq_f32(z, inv), inv));
  }
  for (int c = 0; c < cols; ++c) {
    vst1q_f32(y + 4 * c, vmulq_f32(vld1q_f32(x + 4 * c), inv));
  }
}
__attribute__((noinline)) void rowwise(const float* x, float* y, int cols) {
  for (int r = 0; r < 4; ++r) {
    float sum = 0;
    for (int c = 0; c < cols; ++c) {
      float v = x[r * cols + c];
      sum += v * v;
    }
    float inv = 1 / std::sqrt(sum / cols + 1e-5f);
    for (int c = 0; c < cols; ++c) {
      y[r * cols + c] = x[r * cols + c] * inv;
    }
  }
}
void pack(const float* x, float* p, int cols) {
  for (int c = 0; c < cols; ++c) {
    for (int r = 0; r < 4; ++r) {
      p[4 * c + r] = x[r * cols + c];
    }
  }
}
void unpack(const float* p, float* x, int cols) {
  for (int c = 0; c < cols; ++c) {
    for (int r = 0; r < 4; ++r) {
      x[r * cols + c] = p[4 * c + r];
    }
  }
}
volatile float sink = 0;
template <class F>
void bench(const char* name, F f, std::vector<float>& y) {
  for (int i = 0; i < 20; ++i) {
    f();
    sink = y[0];
  }
  std::vector<double> times;
  for (int sample = 0; sample < 31; ++sample) {
    auto a = std::chrono::steady_clock::now();
    for (int i = 0; i < 200; ++i) {
      f();
      sink = y[0];
    }
    auto b = std::chrono::steady_clock::now();
    times.push_back(std::chrono::duration<double, std::micro>(b - a).count() / 200);
  }
  std::sort(times.begin(), times.end());
  std::cout << name << " CPU_batch_mean_us_P50=" << times[15] << " P95=" << times[29] << '\n';
}
int main() {
  try {
    int cases = 0;
    float worst = 0;
    for (int n : {1, 3, 4, 5, 31, 32, 33, 127, 513, 1024}) {
      for (bool zero : {false, true}) {
        auto x = inputs(4, n, n, zero);
        std::vector<float> p(x.size()), q(x.size()), y(x.size());
        rowwise(x.data(), y.data(), n);
        compare(y, reference(x, 4, n, n, 1e-5f));
        pack(x.data(), p.data(), n);
        packed4(p.data(), q.data(), n);
        unpack(q.data(), y.data(), n);
        worst = std::max(worst, compare(y, reference(x, 4, n, n, 1e-5f)));
        ++cases;
      }
    }
    // 已写好的反例：混合四行的一个scale不会等价于逐行scale。
    std::vector<float> x{1, 1, 2, 2, 4, 4, 8, 8};
    auto ref = reference(x, 4, 2, 2, 1e-5f);
    double sum = 0;
    for (float v : x) {
      sum += v * v;
    }
    require(std::abs(x[0] / std::sqrt(sum / 8 + 1e-5) - ref[0]) > 0.5, "axis counterexample");
    int rejected = 0;
    try {
      contract(4, 0, 0, 1e-5f);
    } catch (const std::exception&) {
      ++rejected;
    }
    require(rejected == 1, "empty dimension rejection");
    std::cout << "PASS packed4 cases=" << cases << " reject=" << rejected << " max_abs=" << worst
              << " axis_counterexample=observed\n";
    for (int n : {1, 33, 513, 1024}) {
      std::cout << "cols=" << n << "\n";
      x = inputs(4, n, n);
      std::vector<float> p(x.size()), q(x.size()), y(x.size());
      pack(x.data(), p.data(), n);
      bench(
          "rowwise",
          [&] {
            rowwise(x.data(), y.data(), n);
          },
          y);
      bench(
          "packed_kernel",
          [&] {
            packed4(p.data(), q.data(), n);
          },
          q);
      bench(
          "pack_kernel_unpack",
          [&] {
            pack(x.data(), p.data(), n);
            packed4(p.data(), q.data(), n);
            unpack(q.data(), y.data(), n);
          },
          y);
      compare(y, reference(x, 4, n, n, 1e-5f));
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
