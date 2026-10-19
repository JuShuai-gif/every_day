#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <vector>

using Clock = std::chrono::steady_clock;
void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
size_t extent(size_t rows, size_t cols, size_t stride) {
  if (stride < cols) {
    throw std::invalid_argument("stride < cols");
  }
  if (rows == 0 || cols == 0) {
    return 0;
  }
  if (rows - 1 > (std::numeric_limits<size_t>::max() - cols) / stride) {
    throw std::overflow_error("extent overflow");
  }
  return (rows - 1) * stride + cols;
}
struct Matrix {
  size_t rows, cols, stride;
  std::vector<float> data;
  Matrix(size_t r, size_t c, size_t s) : rows(r), cols(c), stride(s), data(extent(r, c, s), -999) {
  }
};
void contract(const Matrix& a, const Matrix& b) {
  if (&a == &b || a.rows != b.cols || a.cols != b.rows) {
    throw std::invalid_argument("separate ownership and transposed shape required");
  }
}
__attribute__((noinline)) void plain(const Matrix& a, Matrix& b, size_t) {
  contract(a, b);
  for (size_t i = 0; i < a.rows; ++i) {
    for (size_t j = 0; j < a.cols; ++j) {
      b.data[j * b.stride + i] = a.data[i * a.stride + j];
    }
  }
}
__attribute__((noinline)) void blocked(const Matrix& a, Matrix& b, size_t tile) {
  contract(a, b);
  if (tile == 0 || tile > 256) {
    throw std::invalid_argument("tile must be 1..256");
  }
  // 分块限制同时活跃的目标行；行尾仅访问有效元素，不复制 padding。
  for (size_t ii = 0; ii < a.rows; ii += tile) {
    for (size_t jj = 0; jj < a.cols; jj += tile) {
      const size_t ie = ii + std::min(tile, a.rows - ii), je = jj + std::min(tile, a.cols - jj);
      for (size_t i = ii; i < ie; ++i) {
        for (size_t j = jj; j < je; ++j) {
          b.data[j * b.stride + i] = a.data[i * a.stride + j];
        }
      }
    }
  }
}
void fill(Matrix& a) {
  for (size_t i = 0; i < a.rows; ++i) {
    for (size_t j = 0; j < a.cols; ++j) {
      a.data[i * a.stride + j] = static_cast<float>((i * 31 + j * 17) % 1024);
    }
  }
}
void check(const Matrix& a, const Matrix& b) {
  if (a.rows == 0 || a.cols == 0) {
    return;
  }
  for (size_t j = 0; j < b.rows; ++j) {
    for (size_t i = 0; i < b.cols; ++i) {
      require(b.data[j * b.stride + i] == a.data[i * a.stride + j], "transpose mismatch");
    }
    if (j + 1 < b.rows) {
      for (size_t i = b.cols; i < b.stride; ++i) {
        require(b.data[j * b.stride + i] == -999, "padding overwritten");
      }
    }
  }
}
using Kernel = void (*)(const Matrix&, Matrix&, size_t);
// 空 asm 是编译器屏障，不是 CPU 内存屏障；防止基准重复写被消除。
void escape(const Matrix& b) {
  asm volatile("" : : "g"(b.data.data()) : "memory");
}
double sample(Kernel f, const Matrix& a, Matrix& b, size_t tile, int repeats, bool allocation) {
  auto t = Clock::now();
  for (int r = 0; r < repeats; ++r) {
    if (allocation) {
      Matrix out(b.rows, b.cols, b.stride);
      f(a, out, tile);
      escape(out);
    } else {
      f(a, b, tile);
      escape(b);
    }
  }
  return std::chrono::duration<double, std::micro>(Clock::now() - t).count() / repeats;
}
void bench(size_t m, size_t n, size_t pad) {
  Matrix a(m, n, n + pad), b(n, m, m + pad), c(n, m, m + pad);
  fill(a);
  for (int w = 0; w < 3; ++w) {
    plain(a, b, 32);
    blocked(a, c, 32);
  }
  check(a, b);
  check(a, c);
  const int reps = m * n > 100000 ? 5 : 100;
  for (bool alloc : {false, true}) {
    std::vector<double> p, q;
    for (int r = 0; r < 11; ++r) {
      // 交替先后顺序，仍是热缓存/固定线程的批均值，非独立请求P95。
      if (r % 2 == 0) {
        p.push_back(sample(plain, a, b, 32, reps, alloc));
        q.push_back(sample(blocked, a, c, 32, reps, alloc));
      } else {
        q.push_back(sample(blocked, a, c, 32, reps, alloc));
        p.push_back(sample(plain, a, b, 32, reps, alloc));
      }
    }
    std::sort(p.begin(), p.end());
    std::sort(q.begin(), q.end());
    std::cout << "shape=" << m << "x" << n << " pad=" << pad
              << " scope=" << (alloc ? "allocation_init_transpose_free" : "transpose_only")
              << " batch_mean_us plain_p50=" << p[5] << " blocked32_p50=" << q[5]
              << " plain_p95=" << p[10] << " blocked32_p95=" << q[10] << "\n";
  }
}
int main(int argc, char** argv) {
  try {
    size_t cases = 0;
    for (size_t m : {0, 1, 3, 31, 32, 33, 65}) {
      for (size_t n : {0, 1, 5, 31, 32, 33, 129}) {
        for (size_t pad : {0, 7}) {
          Matrix a(m, n, n + pad), b(n, m, m + pad);
          fill(a);
          plain(a, b, 32);
          check(a, b);
          for (size_t tile : {1, 16, 32, 64}) {
            std::fill(b.data.begin(), b.data.end(), -999);
            blocked(a, b, tile);
            check(a, b);
            ++cases;
          }
        }
      }
    }
    int rejected = 0;
    auto rejects = [&](auto f) {
      try {
        f();
      } catch (const std::exception&) {
        ++rejected;
      }
    };
    rejects([] {
      Matrix a(2, 3, 2);
    });
    rejects([] {
      extent(std::numeric_limits<size_t>::max(), 4, 4);
    });
    rejects([] {
      Matrix a(2, 2, 2);
      blocked(a, a, 32);
    });
    rejects([] {
      Matrix a(2, 3, 3), b(2, 3, 3);
      plain(a, b, 32);
    });
    rejects([] {
      Matrix a(2, 3, 3), b(3, 2, 2);
      blocked(a, b, 0);
    });
    require(rejected == 5, "missing rejection");
    std::cout << "PASS candidates=" << cases << " rejections=" << rejected
              << " padding/int_exact/empty\n";
    if (argc == 2 && std::string(argv[1]) == "--bench") {
      bench(17, 19, 0);
      bench(1024, 1024, 0);
      bench(1024, 1024, 7);
      bench(1023, 769, 7);
    } else if (argc != 1) {
      throw std::invalid_argument("usage: practice [--bench]");
    }
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << "\n";
    return 1;
  }
}
