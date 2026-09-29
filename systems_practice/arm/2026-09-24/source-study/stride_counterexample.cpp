#include <array>
#include <cstddef>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>

// 独立编写的反例；研究行主序接口的地址合同，不复制第三方 GEMM 实现。
class Matrix {
 public:
  Matrix(std::size_t rows, std::size_t cols, std::size_t stride)
      : rows_(rows), cols_(cols), stride_(stride) {
    if (cols > stride || (rows != 0 && stride > std::numeric_limits<std::size_t>::max() / rows)) {
      throw std::invalid_argument("invalid matrix extent");
    }
    data_.assign(rows * stride, 1000.0F);
  }

  float& at(std::size_t row, std::size_t col) {
    if (row >= rows_ || col >= cols_) {
      throw std::out_of_range("logical matrix index");
    }
    return data_.at(row * stride_ + col);
  }

  float at(std::size_t row, std::size_t col) const {
    if (row >= rows_ || col >= cols_) {
      throw std::out_of_range("logical matrix index");
    }
    return data_.at(row * stride_ + col);
  }

  // 仅反例需要物理读取：越过分配边界会抛异常，但读到 padding 不会。
  float physical(std::size_t offset) const {
    return data_.at(offset);
  }
  std::size_t stride() const {
    return stride_;
  }

 private:
  std::size_t rows_;
  std::size_t cols_;
  std::size_t stride_;
  std::vector<float> data_;  // RAII 管理包含 padding 的真实存储。
};

using Output = std::array<float, 4>;

Output multiply(const Matrix& a, const Matrix& b, std::size_t depth, bool wrong_stride) {
  Output out{};
  for (std::size_t row = 0; row < 2; ++row) {
    for (std::size_t col = 0; col < 2; ++col) {
      for (std::size_t p = 0; p < depth; ++p) {
        // 错误候选故意使用 A.stride；正确分支按 B 的二维合同访问。
        const float rhs = wrong_stride ? b.physical(p * a.stride() + col) : b.at(p, col);
        out[row * 2 + col] += a.at(row, p) * rhs;
      }
    }
  }
  return out;
}

void require(bool value, const char* message) {
  if (!value) {
    throw std::runtime_error(message);
  }
}

void print(const char* label, const Output& values) {
  std::cout << label;
  for (float value : values) {
    std::cout << ' ' << value;
  }
  std::cout << '\n';
}

void rectangular_case() {
  Matrix a(2, 3, 5);
  Matrix b(3, 2, 4);
  for (std::size_t row = 0; row < 2; ++row) {
    for (std::size_t col = 0; col < 3; ++col) {
      a.at(row, col) = static_cast<float>(row * 3 + col + 1);
    }
  }
  for (std::size_t row = 0; row < 3; ++row) {
    for (std::size_t col = 0; col < 2; ++col) {
      b.at(row, col) = static_cast<float>(row * 2 + col + 7);
    }
  }
  // 手算 oracle 独立于循环实现。所有整数结果均可由 FP32 精确表示。
  const Output expected{58, 64, 139, 154};
  const Output wrong = multiply(a, b, 3, true);
  const Output correct = multiply(a, b, 3, false);
  require(correct == expected, "correct rectangular result differs from oracle");
  require(wrong != expected, "counterexample failed to distinguish the wrong stride");
  print("rectangular expected:", expected);
  print("rectangular wrong:", wrong);
  print("rectangular corrected:", correct);
}

void square_control() {
  Matrix a(2, 2, 2);
  Matrix b(2, 2, 2);
  for (std::size_t row = 0; row < 2; ++row) {
    for (std::size_t col = 0; col < 2; ++col) {
      a.at(row, col) = static_cast<float>(row * 2 + col + 1);
      b.at(row, col) = static_cast<float>(row * 2 + col + 5);
    }
  }
  const Output expected{19, 22, 43, 50};
  require(multiply(a, b, 2, false) == expected, "square reference failed");
  require(multiply(a, b, 2, true) == expected, "square control did not mask the bug");
  std::cout << "square equal-stride control: wrong candidate also passes\n";
  require(multiply(a, b, 0, false) == Output{}, "zero-depth result must be zero");
}

int main() {
  try {
    rectangular_case();
    square_control();
    bool rejected = false;
    try {
      const Matrix invalid(2, 3, 2);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    require(rejected, "short stride was accepted");
    std::cout << "PASS: semantic bug detected without out-of-bounds access; "
                 "zero-depth/invalid-stride checked\n";
    return 0;
  } catch (const std::exception& error) {
    std::cerr << "FAIL: " << error.what() << '\n';
    return 1;
  }
}
