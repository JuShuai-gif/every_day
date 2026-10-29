#pragma once

#include <chrono>
#include <condition_variable>
#include <cstddef>
#include <cstdint>
#include <mutex>
#include <vector>

namespace camera {

enum class Mode { baseline, stage1, optimized };

struct Frame {
  std::size_t width, height, stride;
  std::vector<std::uint8_t> pixels;
};

struct Roi {
  std::size_t x, y, width, height;
};

struct Workspace {
  std::vector<std::uint8_t> downsampled;
  std::vector<float> normalized;
};

struct Result {
  std::uint64_t digest = 0;
  std::size_t processed = 0;
  std::size_t queue_high_water = 0;
  std::vector<double> frame_us;
};

// 索引交接，不复制图像；输入帧由调用方持有，直到所有线程 join。
class FrameQueue {
 public:
  using Clock = std::chrono::steady_clock;

  struct Item {
    std::size_t index = 0;
    Clock::time_point captured;
  };

  explicit FrameQueue(std::size_t capacity);
  bool push(Item item);
  bool pop(Item& item);
  void close();
  std::size_t high_water() const;

 private:
  std::vector<Item> slots_;
  std::size_t head_ = 0, count_ = 0, high_water_ = 0;
  bool closed_ = false;
  mutable std::mutex mutex_;
  std::condition_variable readable_, writable_;
};

Frame make_frame(std::size_t width, std::size_t height, std::size_t padding, unsigned seed);
// 报告 optimized 完整块使用的后端；奇数边缘与不足 8 个输出的尾部仍走标量。
const char* optimized_backend();
void preprocess(const Frame& frame, Roi roi, Mode mode, Workspace& workspace);
Result pipeline(const std::vector<Frame>& frames, Roi roi, Mode mode, std::size_t queue_capacity);
void self_test();

}  // namespace camera
