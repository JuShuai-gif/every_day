#include <cstdint>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>

// stride 以元素计数；只访问逻辑列，不能把行末 padding 当成像素。
__attribute__((noinline)) std::uint64_t sum_rows(const std::uint16_t* data,
                                                 std::size_t rows,
                                                 std::size_t cols,
                                                 std::size_t stride,
                                                 std::size_t count) {
  if (cols > stride || (rows && stride > std::numeric_limits<std::size_t>::max() / rows) ||
      rows * stride > count || (rows && cols && !data)) {
    throw std::invalid_argument("invalid span/stride");
  }
  std::uint64_t sum = 0;
  for (std::size_t row = 0; row < rows; ++row) {
    for (std::size_t col = 0; col < cols; ++col) {
      sum += data[row * stride + col];
    }
  }
  return sum;
}
int main() {
  try {
    std::size_t cases = 0;
    for (std::size_t rows : {0U, 1U, 3U}) {
      for (std::size_t cols : {0U, 1U, 7U, 17U}) {
        for (std::size_t pad : {0U, 1U, 8U}) {
          const auto stride = cols + pad;
          std::vector<std::uint16_t> frame(rows * stride, 60000);
          std::uint64_t expected = 0;
          for (std::size_t r = 0; r < rows; ++r) {
            for (std::size_t c = 0; c < cols; ++c) {
              auto v = static_cast<std::uint16_t>(r * 20 + c);
              frame[r * stride + c] = v;
              expected += v;
            }
          }
          if (sum_rows(frame.data(), rows, cols, stride, frame.size()) != expected) {
            throw std::runtime_error("padding included or bad address");
          }
          ++cases;
        }
      }
    }
    unsigned rejected = 0;
    auto invalid = [&](const std::uint16_t* p,
                       std::size_t r,
                       std::size_t c,
                       std::size_t stride,
                       std::size_t n) {
      try {
        sum_rows(p, r, c, stride, n);
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    };
    invalid(nullptr, 1, 1, 1, 1);
    invalid(nullptr, 1, 2, 1, 1);
    invalid(nullptr, 2, 1, std::numeric_limits<std::size_t>::max(), 0);
    const std::uint16_t value = 1;
    invalid(&value, 2, 1, 1, 1);
    if (rejected != 4) {
      throw std::runtime_error("invalid span accepted");
    }
    std::cout << "stride cases=" << cases << " invalid=" << rejected << " PASS\n";
  } catch (const std::exception& error) {
    std::cerr << error.what() << '\n';
    return 1;
  }
}
