#include <arm_neon.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <iostream>
#include <stdexcept>
#include <vector>
void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
void shape(int rows, int cols) {
  require(rows > 0 && rows <= 1024 && cols > 0 && cols <= 4097, "shape");
}
__attribute__((noinline)) void scalar(const float* x, float* y, int rows, int cols) {
  for (int r = 0; r < rows; ++r) {
    float sum = 0;
    for (int c = 0; c < cols; ++c) {
      float a = x[r * cols + c];
      sum += a * a;
    }
    float inv = 1 / std::sqrt(sum / cols + 1e-5f);
    for (int c = 0; c < cols; ++c) {
      y[r * cols + c] = std::max(0.0f, x[r * cols + c] * inv);
    }
  }
}
// 打包空间为ceil(rows/4)*cols*4；最后几行显式补零，lane统计互不混合。
void pack(const float* x, float* p, int rows, int cols) {
  for (int r = 0; r < rows; r += 4) {
    for (int c = 0; c < cols; ++c) {
      for (int lane = 0; lane < 4; ++lane) {
        p[(r / 4 * cols + c) * 4 + lane] = r + lane < rows ? x[(r + lane) * cols + c] : 0;
      }
    }
  }
}
__attribute__((noinline)) void packed_relu(const float* p, float* y, int rows, int cols) {
  for (int r = 0; r < rows; r += 4) {
    auto sum = vdupq_n_f32(0);
    const float* block = p + r / 4 * cols * 4;
    for (int c = 0; c < cols; ++c) {
      auto v = vld1q_f32(block + 4 * c);
      sum = vfmaq_f32(sum, v, v);
    }
    auto z = vaddq_f32(vdivq_f32(sum, vdupq_n_f32(float(cols))), vdupq_n_f32(1e-5f));
    auto inv = vrsqrteq_f32(z);
    for (int i = 0; i < 2; ++i) {
      inv = vmulq_f32(inv, vrsqrtsq_f32(vmulq_f32(z, inv), inv));
    }
    // ReLU直接消费packed布局；不在两个算子之间反复pack/unpack。
    for (int c = 0; c < cols; ++c) {
      vst1q_f32(y + (r / 4 * cols + c) * 4,
                vmaxq_f32(vmulq_f32(vld1q_f32(block + 4 * c), inv), vdupq_n_f32(0)));
    }
  }
}
void unpack(const float* p, float* y, int rows, int cols) {
  for (int r = 0; r < rows; ++r) {
    for (int c = 0; c < cols; ++c) {
      y[r * cols + c] = p[(r / 4 * cols + c) * 4 + r % 4];
    }
  }
}
volatile float sink = 0;
template <class F>
void bench(const char* name, F f, float* y) {
  for (int i = 0; i < 20; ++i) {
    f();
    sink = y[0];
  }
  std::vector<double> t;
  for (int s = 0; s < 31; ++s) {
    auto a = std::chrono::steady_clock::now();
    for (int i = 0; i < 200; ++i) {
      f();
      sink = y[0];
    }
    auto b = std::chrono::steady_clock::now();
    t.push_back(std::chrono::duration<double, std::micro>(b - a).count() / 200);
  }
  std::sort(t.begin(), t.end());
  std::cout << name << " CPU_batch_mean_us_P50=" << t[15] << " P95=" << t[29] << '\n';
}
int main() {
  try {
    int count = 0;
    double worst = 0;
    for (int rows : {1, 2, 3, 4, 5, 7, 8, 9}) {
      for (int cols : {1, 3, 4, 5, 31, 513, 4097}) {
        shape(rows, cols);
        std::vector<float> x(rows * cols), y(x.size()), ref(x.size());
        std::vector<float> p((rows + 3) / 4 * cols * 4, -999), q(p.size(), -999);
        for (std::size_t i = 0; i < x.size(); ++i) {
          x[i] = float(int(i % 41) - 20) / 8;
        }
        pack(x.data(), p.data(), rows, cols);
        packed_relu(p.data(), q.data(), rows, cols);
        unpack(q.data(), y.data(), rows, cols);
        scalar(x.data(), ref.data(), rows, cols);
        for (int r = 0; r < rows; ++r) {
          double sum = 0;
          for (int c = 0; c < cols; ++c) {
            sum += double(x[r * cols + c]) * x[r * cols + c];
          }
          for (int c = 0; c < cols; ++c) {
            double expected = std::max(0.0, double(x[r * cols + c]) / std::sqrt(sum / cols + 1e-5));
            auto i = r * cols + c;
            worst = std::max(worst, std::abs(y[i] - expected));
            require(std::abs(y[i] - expected) < 2e-5 && std::abs(ref[i] - expected) < 2e-5,
                    "oracle");
          }
        }
        if (rows % 4) {
          for (int c = 0; c < cols; ++c) {
            for (int lane = rows % 4; lane < 4; ++lane) {
              require(q[((rows / 4) * cols + c) * 4 + lane] == 0, "padding lane polluted");
            }
          }
        }
        ++count;
      }
    }
    int rejected = 0;
    for (auto s : {std::pair<int, int>{0, 1}, {1, 0}, {1025, 4}}) {
      try {
        shape(s.first, s.second);
      } catch (const std::runtime_error&) {
        ++rejected;
      }
    }
    require(rejected == 3, "rejections");
    std::cout << "PASS shapes=" << count << " rejects=" << rejected << " max_abs=" << worst << '\n';
    for (int rows : {1, 5, 32}) {
      int cols = 513;
      std::vector<float> x(rows * cols, 0.5f), y(x.size()), p((rows + 3) / 4 * cols * 4),
          q(p.size());
      pack(x.data(), p.data(), rows, cols);
      std::cout << "shape=" << rows << "x" << cols << '\n';
      bench(
          "scalar_relu",
          [&] {
            scalar(x.data(), y.data(), rows, cols);
          },
          y.data());
      bench(
          "packed_kernel_relu",
          [&] {
            packed_relu(p.data(), q.data(), rows, cols);
          },
          q.data());
      bench(
          "pack_kernel_unpack",
          [&] {
            pack(x.data(), p.data(), rows, cols);
            packed_relu(p.data(), q.data(), rows, cols);
            unpack(q.data(), y.data(), rows, cols);
          },
          y.data());
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
