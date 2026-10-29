#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <stdexcept>
#include <vector>

namespace imu {

constexpr std::size_t kAxes = 6;
constexpr std::size_t kMaxWindow = 1024;
constexpr std::size_t kMaxBatch = 32768;
constexpr std::int32_t kSampleLimit = 100000;

enum class Mode { baseline, stage1, optimized };

struct Sample {
  std::uint64_t stamp_us;
  // 前三项是加速度原始定点读数，后三项是角速度原始定点读数。
  // 不在统计阶段混合单位；真实设备接入时应先完成标定。
  std::array<std::int32_t, kAxes> axes;
};

struct Config {
  std::size_t window = 128;
  std::uint64_t max_age_us = 256000;
  std::uint64_t gap_reset_us = 50000;
};

struct Snapshot {
  std::uint64_t stamp_us = 0;
  std::size_t count = 0;
  std::array<std::int64_t, kAxes> sum{};
  std::array<std::int64_t, kAxes> square_sum{};

  double mean(std::size_t axis) const {
    return static_cast<double>(sum[axis]) / static_cast<double>(count);
  }

  double variance(std::size_t axis) const {
    const double average = mean(axis);
    return static_cast<double>(square_sum[axis]) / static_cast<double>(count) - average * average;
  }
};

struct Output {
  std::vector<Snapshot> snapshots;
  std::size_t rejected = 0;
  std::size_t gap_resets = 0;
  std::size_t evicted = 0;
  std::size_t expired = 0;
};

inline void accumulate(Snapshot& stats, const Sample& sample, std::int64_t sign) {
  for (std::size_t axis = 0; axis < kAxes; ++axis) {
    const std::int64_t value = sample.axes[axis];
    stats.sum[axis] += sign * value;
    stats.square_sum[axis] += sign * value * value;
  }
}

class Processor {
 public:
  explicit Processor(Config config, std::size_t batch_capacity = kMaxBatch)
      : config_(config), batch_capacity_(batch_capacity) {
    if (config.window == 0 || config.window > kMaxWindow || config.max_age_us == 0 ||
        config.gap_reset_us == 0 || batch_capacity > kMaxBatch) {
      throw std::invalid_argument("invalid IMU window, age, gap or batch capacity");
    }
    linear_.reserve(config.window);
    output_.snapshots.reserve(batch_capacity);
  }

  // 每次调用重放一段完整记录。输出每个有效输入之后的窗口统计，保留时间轴。
  [[gnu::noinline]] const Output& run(const std::vector<Sample>& samples, Mode mode) {
    if (samples.size() > batch_capacity_) {
      throw std::invalid_argument("IMU batch exceeds configured capacity");
    }
    reset_window();
    output_.snapshots.clear();
    output_.rejected = 0;
    output_.gap_resets = 0;
    output_.evicted = 0;
    output_.expired = 0;
    bool have_previous = false;
    std::uint64_t previous = 0;

    for (const auto& sample : samples) {
      if (!valid_values(sample) || (have_previous && sample.stamp_us <= previous)) {
        ++output_.rejected;
        continue;  // 无效输入不能推进时间戳，也不能改变窗口。
      }
      if (have_previous && sample.stamp_us - previous > config_.gap_reset_us) {
        reset_window();
        ++output_.gap_resets;
      }
      previous = sample.stamp_us;
      have_previous = true;

      Snapshot snapshot;
      if (mode == Mode::baseline) {
        while (!linear_.empty() &&
               sample.stamp_us - linear_.front().stamp_us > config_.max_age_us) {
          linear_.erase(linear_.begin());
          ++output_.expired;
        }
        if (linear_.size() == config_.window) {
          linear_.erase(linear_.begin());
          ++output_.evicted;
        }
        linear_.push_back(sample);
        snapshot.count = linear_.size();
        for (const auto& entry : linear_) {
          accumulate(snapshot, entry, 1);
        }
      } else {
        while (size_ > 0 && sample.stamp_us - ring_[head_].stamp_us > config_.max_age_us) {
          pop_front(mode);
          ++output_.expired;
        }
        if (size_ == config_.window) {
          pop_front(mode);
          ++output_.evicted;
        }
        ring_[(head_ + size_) % config_.window] = sample;
        ++size_;

        if (mode == Mode::optimized) {
          accumulate(running_, sample, 1);
          snapshot = running_;
        } else {
          // Stage 1 只改变容器，仍逐样本扫描窗口，隔离“免搬移”的收益。
          for (std::size_t i = 0; i < size_; ++i) {
            accumulate(snapshot, ring_[(head_ + i) % config_.window], 1);
          }
        }
        snapshot.count = size_;
      }
      snapshot.stamp_us = sample.stamp_us;
      output_.snapshots.push_back(snapshot);
    }
    return output_;
  }

  std::size_t reserved_bytes() const {
    return sizeof(ring_) + linear_.capacity() * sizeof(Sample) +
           output_.snapshots.capacity() * sizeof(Snapshot);
  }

 private:
  static bool valid_values(const Sample& sample) {
    for (const auto value : sample.axes) {
      if (value < -kSampleLimit || value > kSampleLimit) {
        return false;
      }
    }
    return true;
  }

  void reset_window() {
    linear_.clear();
    head_ = 0;
    size_ = 0;
    running_ = {};
  }

  void pop_front(Mode mode) {
    if (mode == Mode::optimized) {
      accumulate(running_, ring_[head_], -1);
    }
    head_ = (head_ + 1) % config_.window;
    --size_;
  }

  Config config_;
  std::size_t batch_capacity_;
  std::vector<Sample> linear_;
  std::array<Sample, kMaxWindow> ring_{};
  std::size_t head_ = 0;
  std::size_t size_ = 0;
  Snapshot running_;
  Output output_;
};

inline std::vector<Sample> fixture(std::size_t count, std::uint32_t seed = 29) {
  std::vector<Sample> samples;
  samples.reserve(count);
  std::uint64_t stamp = 1000000;
  for (std::size_t i = 0; i < count; ++i) {
    stamp += (i != 0 && i % 997 == 0) ? 100000 : 1000;
    Sample sample{stamp, {}};
    for (auto& axis : sample.axes) {
      seed = seed * 1664525u + 1013904223u;
      axis = static_cast<std::int32_t>(seed % 20001u) - 10000;
    }
    if (i != 0 && i % 127 == 0) {
      sample.axes[2] = kSampleLimit + 1;
    } else if (i != 0 && i % 191 == 0) {
      sample.stamp_us = samples.back().stamp_us;
    }
    samples.push_back(sample);
  }
  return samples;
}

inline std::uint64_t digest(const Output& output) {
  std::uint64_t hash = 1469598103934665603ull;
  const auto fold = [&](std::uint64_t value) {
    hash = (hash ^ value) * 1099511628211ull;
  };
  fold(output.rejected);
  fold(output.gap_resets);
  fold(output.evicted);
  fold(output.expired);
  for (const auto& snapshot : output.snapshots) {
    fold(snapshot.stamp_us);
    fold(snapshot.count);
    for (std::size_t axis = 0; axis < kAxes; ++axis) {
      fold(static_cast<std::uint64_t>(snapshot.sum[axis]));
      fold(static_cast<std::uint64_t>(snapshot.square_sum[axis]));
    }
  }
  return hash;
}

}  // namespace imu
