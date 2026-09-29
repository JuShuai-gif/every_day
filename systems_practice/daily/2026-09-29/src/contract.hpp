#pragma once
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <stdexcept>
#include <utility>
#include <vector>

inline void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}

// 先提升到int32再减零点，避免int8减法回绕；本例只接受逐张量仿射INT8。
inline std::vector<float> decode(
    const std::int8_t* data, std::size_t count, std::size_t bytes, float scale, int zero) {
  require(count > 0 && count <= bytes && data != nullptr, "invalid output buffer");
  require(std::isfinite(scale) && scale > 0 && zero >= -128 && zero <= 127,
          "invalid affine metadata");
  std::vector<float> out(count);
  for (std::size_t i = 0; i < count; ++i) {
    out[i] = (static_cast<int>(data[i]) - zero) * scale;
  }
  return out;
}

// 获得输出成功后立刻接管释放责任；不可复制，移动后只有一个有效租约。
template <class Release>
class OutputLease {
 public:
  explicit OutputLease(Release release) : release_(std::move(release)) {
  }
  OutputLease(const OutputLease&) = delete;
  OutputLease& operator=(const OutputLease&) = delete;
  OutputLease& operator=(OutputLease&&) = delete;
  OutputLease(OutputLease&& other) noexcept
      : release_(std::move(other.release_)), active_(other.active_) {
    other.active_ = false;
  }
  ~OutputLease() noexcept {
    if (active_) {
      release_();
    }
  }

 private:
  Release release_;
  bool active_ = true;
};

inline std::vector<float> input(unsigned frame) {
  std::vector<float> x(60);
  for (std::size_t i = 0; i < x.size(); ++i) {
    x[i] = frame == 0 ? 0.0F : static_cast<float>((i * 7 + frame * 11) % 101) / 100.0F;
  }
  return x;
}

// ONNX的1x1 Conv：NCHW [1,3,4,5] -> [1,2,4,5]，无需下载模型。
inline std::vector<float> oracle(const std::vector<float>& x) {
  require(x.size() == 60, "input shape");
  const float weights[2][3] = {{0.5F, -0.25F, 0.125F}, {-0.125F, 0.5F, 0.25F}};
  const float bias[2] = {0.1F, -0.2F};
  std::vector<float> y(40);
  for (std::size_t c = 0; c < 2; ++c) {
    for (std::size_t i = 0; i < 20; ++i) {
      y[c * 20 + i] = bias[c];
      for (std::size_t k = 0; k < 3; ++k) {
        y[c * 20 + i] += weights[c][k] * x[k * 20 + i];
      }
    }
  }
  return y;
}
