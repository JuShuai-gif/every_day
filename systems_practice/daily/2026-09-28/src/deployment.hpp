#pragma once
#include <atomic>
#include <cmath>
#include <cstdint>
#include <istream>
#include <limits>
#include <memory>
#include <mutex>
#include <stdexcept>
#include <string>
#include <vector>

namespace edge {
// 小型 CPU 模型仅充当部署控制面的验收夹具，不替代 GPU/NPU 推理。
class Model {
 public:
  Model(std::uint64_t version, std::vector<float> weights)
      : version_(version), weights_(std::move(weights)) {
  }
  std::uint64_t version() const {
    return version_;
  }
  float infer(const std::vector<float>& input) const {
    if (input.size() != weights_.size()) {
      throw std::invalid_argument("request shape mismatch");
    }
    float result = 0;
    for (std::size_t i = 0; i < input.size(); ++i) {
      if (!std::isfinite(input[i])) {
        throw std::invalid_argument("nonfinite input");
      }
      result += input[i] * weights_[i];
    }
    if (!std::isfinite(result)) {
      throw std::runtime_error("nonfinite output");
    }
    return result;
  }

 private:
  const std::uint64_t version_;
  const std::vector<float> weights_;
};
using Snapshot = std::shared_ptr<const Model>;

// 在发布锁外完成解析、形状合同和金丝雀验证；失败不会修改当前版本。
inline Snapshot stage(std::istream& stream) {
  std::string magic;
  std::uint64_t version = 0;
  int count = 0;
  double expected = 0;
  if (!(stream >> magic >> version >> count >> expected) || magic != "EDGE1" || version == 0 ||
      count != 8 || !std::isfinite(expected)) {
    throw std::invalid_argument("invalid manifest/schema/shape");
  }
  std::vector<float> weights(static_cast<std::size_t>(count));
  for (auto& value : weights) {
    if (!(stream >> value) || !std::isfinite(value)) {
      throw std::invalid_argument("invalid/truncated weights");
    }
  }
  std::string extra;
  if (stream >> extra) {
    throw std::invalid_argument("trailing artifact data");
  }
  auto model = std::make_shared<const Model>(version, std::move(weights));
  const double actual = model->infer(std::vector<float>(8, 1.0F));
  if (std::abs(actual - expected) > 1e-5 * (1 + std::abs(expected))) {
    throw std::runtime_error("canary mismatch");
  }
  return model;
}

class Registry {
 public:
  std::uint64_t begin() {
    std::lock_guard<std::mutex> lock(writer_);
    if (closed_ || epoch_ == std::numeric_limits<std::uint64_t>::max()) {
      throw std::runtime_error("closed/epoch exhausted");
    }
    return ++epoch_;
  }
  bool publish(std::uint64_t ticket, Snapshot candidate) {
    if (!candidate) {
      throw std::invalid_argument("null candidate");
    }
    Snapshot retired;
    {
      std::lock_guard<std::mutex> lock(writer_);
      // 最新请求获胜；即使新请求失败，也不允许旧的慢加载迟到覆盖。
      if (closed_ || ticket == 0 || ticket != epoch_ || ticket == published_) {
        return false;
      }
      retired =
          std::atomic_exchange_explicit(&active_, std::move(candidate), std::memory_order_acq_rel);
      published_ = ticket;
    }
    // 释放旧指针在锁外；请求快照仍可延长旧模型寿命。
    return true;
  }
  Snapshot acquire() const {
    auto snapshot = std::atomic_load_explicit(&active_, std::memory_order_acquire);
    if (!snapshot) {
      throw std::runtime_error("service not ready");
    }
    return snapshot;
  }
  void close() {
    Snapshot retired;
    {
      std::lock_guard<std::mutex> lock(writer_);
      closed_ = true;
      retired = std::atomic_exchange_explicit(&active_, Snapshot{}, std::memory_order_acq_rel);
    }
  }

 private:
  mutable std::mutex writer_;
  Snapshot active_;
  std::uint64_t epoch_ = 0;
  std::uint64_t published_ = 0;
  bool closed_ = false;
};
}  // namespace edge
