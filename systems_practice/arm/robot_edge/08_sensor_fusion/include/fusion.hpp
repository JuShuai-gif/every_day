#pragma once

#include <algorithm>
#include <array>
#include <cmath>
#include <condition_variable>
#include <cstdint>
#include <cstring>
#include <deque>
#include <exception>
#include <limits>
#include <mutex>
#include <thread>
#include <vector>

#include "edge_bench.hpp"

namespace fusion {

struct Sample {
  std::uint64_t timestamp_us;
  double value;
};

struct Input {
  std::vector<Sample> imu;
  std::vector<Sample> wheel;
};

struct Result {
  std::vector<Sample> values;
  std::size_t unmatched = 0;
  std::size_t queue_peak = 0;
  std::size_t queue_waits = 0;
};

// 容量达到上限时阻塞生产者，不静默丢样本。close() 唤醒所有等待者；
// pop() 会先排空已有记录，再返回 0。baseline 使用 deque，后两阶段使用固定环。
class Queue {
 public:
  Queue(bool fixed_storage, std::size_t capacity)
      : fixed_storage_(fixed_storage), capacity_(capacity) {
    edge::require(capacity >= 1 && capacity <= ring_.size(), "queue capacity must be 1..64");
  }

  bool push(const Sample* data, std::size_t count) {
    std::size_t sent = 0;
    while (sent < count) {
      std::unique_lock<std::mutex> lock(mutex_);
      if (size_ == capacity_ && !closed_) {
        ++waits_;
      }
      changed_.wait(lock, [&] {
        return closed_ || size_ < capacity_;
      });
      if (closed_) {
        return false;
      }

      const auto available = std::min(count - sent, capacity_ - size_);
      for (std::size_t i = 0; i < available; ++i) {
        if (fixed_storage_) {
          ring_[(head_ + size_) % capacity_] = data[sent++];
        } else {
          dynamic_.push_back(data[sent++]);
        }
        ++size_;
      }
      peak_ = std::max(peak_, size_);
      lock.unlock();
      changed_.notify_all();
    }
    return true;
  }

  std::size_t pop(Sample* output, std::size_t limit) {
    std::unique_lock<std::mutex> lock(mutex_);
    if (size_ == 0 && !closed_) {
      ++waits_;
    }
    changed_.wait(lock, [&] {
      return closed_ || size_ != 0;
    });
    const auto count = std::min(limit, size_);
    for (std::size_t i = 0; i < count; ++i) {
      if (fixed_storage_) {
        output[i] = ring_[head_];
        head_ = (head_ + 1) % capacity_;
      } else {
        output[i] = dynamic_.front();
        dynamic_.pop_front();
      }
      --size_;
    }
    lock.unlock();
    changed_.notify_all();
    return count;
  }

  void close() {
    {
      std::lock_guard<std::mutex> lock(mutex_);
      closed_ = true;
    }
    changed_.notify_all();
  }

  // 调用者只在两个生产者 join 后读取，无须额外原子操作。
  std::size_t peak() const {
    return peak_;
  }

  std::size_t waits() const {
    return waits_;
  }

 private:
  bool fixed_storage_;
  std::size_t capacity_;
  std::array<Sample, 64> ring_{};
  std::deque<Sample> dynamic_;
  std::size_t head_ = 0;
  std::size_t size_ = 0;
  std::size_t peak_ = 0;
  std::size_t waits_ = 0;
  bool closed_ = false;
  std::mutex mutex_;
  std::condition_variable changed_;
};

class Reader {
 public:
  Reader(Queue& queue, std::size_t batch) : queue_(queue), batch_(batch) {
  }

  bool next(Sample& sample) {
    if (cursor_ == available_) {
      available_ = queue_.pop(cache_.data(), batch_);
      cursor_ = 0;
    }
    if (available_ == 0) {
      return false;
    }
    sample = cache_[cursor_++];
    return true;
  }

 private:
  Queue& queue_;
  std::size_t batch_;
  std::array<Sample, 16> cache_{};
  std::size_t cursor_ = 0;
  std::size_t available_ = 0;
};

inline void validate(const Input& input) {
  for (const auto* stream : {&input.imu, &input.wheel}) {
    for (std::size_t i = 0; i < stream->size(); ++i) {
      edge::require(std::isfinite((*stream)[i].value), "nonfinite sensor value");
      edge::require(i == 0 || (*stream)[i - 1].timestamp_us < (*stream)[i].timestamp_us,
                    "timestamps must be strictly increasing per sensor");
    }
  }
}

inline Result run(const Input& input, int stage, std::size_t capacity) {
  validate(input);
  edge::require(stage >= 0 && stage <= 2, "invalid fusion stage");
  const std::size_t batch = stage == 2 ? 16 : 1;
  Queue imu_queue(stage != 0, capacity);
  Queue wheel_queue(stage != 0, capacity);
  std::exception_ptr imu_error;
  std::exception_ptr wheel_error;

  auto produce =
      [batch](
          const std::vector<Sample>& source, Queue& queue, std::exception_ptr& error, double bias) {
        try {
          std::array<Sample, 16> block{};
          for (std::size_t begin = 0; begin < source.size(); begin += batch) {
            const auto count = std::min(batch, source.size() - begin);
            for (std::size_t i = 0; i < count; ++i) {
              block[i] = source[begin + i];
              block[i].value -= bias;  // 统一时钟之后的传感器零偏校正。
            }
            if (!queue.push(block.data(), count)) {
              break;
            }
          }
        } catch (...) {
          error = std::current_exception();
        }
        queue.close();
      };

  Result result;
  result.values.reserve(input.wheel.size());
  std::thread imu_thread;
  std::thread wheel_thread;
  auto stop_and_join = [&] {
    imu_queue.close();
    wheel_queue.close();
    if (imu_thread.joinable()) {
      imu_thread.join();
    }
    if (wheel_thread.joinable()) {
      wheel_thread.join();
    }
  };

  try {
    imu_thread =
        std::thread(produce, std::cref(input.imu), std::ref(imu_queue), std::ref(imu_error), 0.01);
    wheel_thread = std::thread(
        produce, std::cref(input.wheel), std::ref(wheel_queue), std::ref(wheel_error), -0.02);
    Reader imu(imu_queue, batch);
    Reader wheel(wheel_queue, batch);
    Sample lower{};
    Sample upper{};
    Sample observation{};
    bool have_upper = imu.next(upper);
    bool have_lower = false;

    while (wheel.next(observation)) {
      while (have_upper && upper.timestamp_us < observation.timestamp_us) {
        lower = upper;
        have_lower = true;
        have_upper = imu.next(upper);
      }

      double aligned_imu = 0;
      if (have_upper && upper.timestamp_us == observation.timestamp_us) {
        aligned_imu = upper.value;
      } else if (have_lower && have_upper && lower.timestamp_us < observation.timestamp_us) {
        const double fraction = static_cast<double>(observation.timestamp_us - lower.timestamp_us) /
                                static_cast<double>(upper.timestamp_us - lower.timestamp_us);
        aligned_imu = lower.value + fraction * (upper.value - lower.value);
      } else {
        ++result.unmatched;
        continue;  // 不外推无覆盖的时间；显式统计业务丢弃。
      }

      result.values.push_back(
          {observation.timestamp_us, 0.75 * aligned_imu + 0.25 * observation.value});
    }

    // wheel 先结束时仍需消费 IMU 尾部，否则生产者可能一直堵在满队列上。
    while (imu.next(upper)) {
    }
    stop_and_join();
  } catch (...) {
    stop_and_join();
    throw;
  }

  if (imu_error) {
    std::rethrow_exception(imu_error);
  }
  if (wheel_error) {
    std::rethrow_exception(wheel_error);
  }
  result.queue_peak = std::max(imu_queue.peak(), wheel_queue.peak());
  result.queue_waits = imu_queue.waits() + wheel_queue.waits();
  return result;
}

// 参考版本在完整录制数据中二分查询，独立于流式 reader 的游标推进。
inline Result reference(const Input& input) {
  validate(input);
  Result result;
  for (const auto& wheel : input.wheel) {
    const auto next = std::lower_bound(input.imu.begin(),
                                       input.imu.end(),
                                       wheel.timestamp_us,
                                       [](const Sample& s, std::uint64_t t) {
                                         return s.timestamp_us < t;
                                       });
    double value = 0;
    if (next != input.imu.end() && next->timestamp_us == wheel.timestamp_us) {
      value = next->value;
    } else if (next != input.imu.begin() && next != input.imu.end()) {
      const auto& previous = *(next - 1);
      const double fraction = static_cast<double>(wheel.timestamp_us - previous.timestamp_us) /
                              static_cast<double>(next->timestamp_us - previous.timestamp_us);
      value = previous.value + fraction * (next->value - previous.value);
    } else {
      ++result.unmatched;
      continue;
    }
    result.values.push_back(
        {wheel.timestamp_us, 0.75 * (value - 0.01) + 0.25 * (wheel.value + 0.02)});
  }
  return result;
}

inline Input make_input(std::size_t count) {
  Input input;
  for (std::size_t i = 0; i < count; ++i) {
    input.imu.push_back({1000 * i, 0.01 + std::sin(static_cast<double>(i) * 0.002)});
    if (i % 4 == 0) {
      input.wheel.push_back({1000 * i + 250, -0.02 + std::sin(static_cast<double>(i) * 0.002)});
    }
  }
  return input;
}

inline void compare(const Result& actual, const Result& expected) {
  edge::require(actual.unmatched == expected.unmatched, "unmatched count differs");
  edge::require(actual.values.size() == expected.values.size(), "fusion output count differs");
  for (std::size_t i = 0; i < actual.values.size(); ++i) {
    edge::require(actual.values[i].timestamp_us == expected.values[i].timestamp_us,
                  "fusion timestamp differs");
    edge::require(std::abs(actual.values[i].value - expected.values[i].value) <= 1e-12,
                  "fusion value differs");
  }
}

inline std::uint64_t checksum(const Result& result) {
  std::uint64_t hash = 1469598103934665603ULL;
  for (const auto& value : result.values) {
    std::uint64_t bits = 0;
    std::memcpy(&bits, &value.value, sizeof(bits));
    hash = (hash ^ bits ^ value.timestamp_us) * 1099511628211ULL;
  }
  return hash ^ result.unmatched;
}

inline void self_test() {
  const Input known{{{1000, 1.01}, {2000, 3.01}},
                    {{500, 0.98}, {1000, 0.98}, {1500, 0.98}, {2000, 0.98}, {2500, 0.98}}};
  const Result expected{{{1000, 1.0}, {1500, 1.75}, {2000, 2.5}}, 2, 0, 0};
  const Input long_tail = make_input(257);
  const std::vector<Input> cases{known, {}, {{{1000, 1.0}}, {}}, {{}, {{1000, 1.0}}}, long_tail};

  for (int stage = 0; stage < 3; ++stage) {
    compare(run(known, stage, 1), expected);
    for (const auto& input : cases) {
      const auto actual = run(input, stage, 1);
      compare(actual, reference(input));
      edge::require(actual.queue_peak <= 1, "queue exceeded capacity");
    }
    const auto large = make_input(8192);
    compare(run(large, stage, 64), reference(large));
  }

  const std::vector<Input> invalid_inputs{{{{2, 1.0}, {1, 2.0}}, {}},
                                          {{{1, 1.0}, {1, 2.0}}, {}},
                                          {{{1, std::numeric_limits<double>::quiet_NaN()}}, {}},
                                          {{}, {{1, std::numeric_limits<double>::infinity()}}}};
  for (const auto& invalid : invalid_inputs) {
    bool rejected = false;
    try {
      (void)run(invalid, 2, 64);
    } catch (const std::exception&) {
      rejected = true;
    }
    edge::require(rejected, "invalid sensor data accepted");
  }

  Queue closed(true, 1);
  closed.close();
  Sample sample{};
  edge::require(!closed.push(&sample, 1) && closed.pop(&sample, 1) == 0,
                "closed queue did not terminate operations");
}

}  // namespace fusion
