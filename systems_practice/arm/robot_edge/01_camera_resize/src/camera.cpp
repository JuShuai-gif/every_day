#include "camera.hpp"

#include <algorithm>
#include <cstring>
#include <limits>
#include <stdexcept>
#include <thread>

#include "edge_bench.hpp"

#if defined(__ARM_NEON) && !defined(EDGE_DISABLE_NEON)
#include <arm_neon.h>
#endif

namespace camera {
namespace {

void validate(const Frame& f, Roi r) {
  edge::require(f.width > 0 && f.height > 0 && f.stride >= f.width, "invalid frame shape");
  edge::require(f.height <= std::numeric_limits<std::size_t>::max() / f.stride,
                "frame size overflow");
  edge::require(f.pixels.size() >= f.stride * f.height, "truncated frame");
  edge::require(r.width > 0 && r.height > 0 && r.x <= f.width && r.y <= f.height,
                "invalid ROI origin");
  edge::require(r.width <= f.width - r.x && r.height <= f.height - r.y, "ROI outside frame");
}

// 2x2 box 平均，边缘不足 2x2 时仅取有效像素；先量化到 uint8 再归一化。
std::uint8_t sample(const Frame& f, Roi r, std::size_t ox, std::size_t oy) {
  unsigned total = 0, count = 0;
  for (std::size_t dy = 0; dy < 2 && oy * 2 + dy < r.height; ++dy) {
    for (std::size_t dx = 0; dx < 2 && ox * 2 + dx < r.width; ++dx) {
      total += f.pixels[(r.y + oy * 2 + dy) * f.stride + r.x + ox * 2 + dx];
      ++count;
    }
  }
  return static_cast<std::uint8_t>(total / count);
}

std::uint64_t digest(const std::vector<float>& output) {
  std::uint64_t value = 1469598103934665603ULL;
  for (float f : output) {
    std::uint32_t bits = 0;
    std::memcpy(&bits, &f, sizeof(bits));
    value = (value ^ bits) * 1099511628211ULL;
  }
  return value;
}
}  // namespace

FrameQueue::FrameQueue(std::size_t capacity) : slots_(capacity) {
  edge::require(capacity > 0, "queue capacity must be positive");
}

bool FrameQueue::push(Item item) {
  std::unique_lock<std::mutex> lock(mutex_);
  writable_.wait(lock, [&] {
    return closed_ || count_ < slots_.size();
  });
  if (closed_)
    return false;
  slots_[(head_ + count_) % slots_.size()] = item;
  high_water_ = std::max(high_water_, ++count_);
  readable_.notify_one();
  return true;
}

bool FrameQueue::pop(Item& item) {
  std::unique_lock<std::mutex> lock(mutex_);
  readable_.wait(lock, [&] {
    return closed_ || count_ != 0;
  });
  if (count_ == 0)
    return false;
  item = slots_[head_];
  head_ = (head_ + 1) % slots_.size();
  --count_;
  writable_.notify_one();
  return true;
}

void FrameQueue::close() {
  std::lock_guard<std::mutex> lock(mutex_);
  closed_ = true;
  readable_.notify_all();
  writable_.notify_all();
}

std::size_t FrameQueue::high_water() const {
  std::lock_guard<std::mutex> lock(mutex_);
  return high_water_;
}

Frame make_frame(std::size_t w, std::size_t h, std::size_t padding, unsigned seed) {
  edge::require(w > 0 && h > 0 && w <= 4096 && h <= 4096 && padding <= 256,
                "fixture dimensions exceed bounded workload");
  Frame frame{w, h, w + padding, std::vector<std::uint8_t>((w + padding) * h, 0xa5)};
  for (std::size_t y = 0; y < h; ++y) {
    for (std::size_t x = 0; x < w; ++x) {
      seed = seed * 1664525U + 1013904223U;
      frame.pixels[y * frame.stride + x] = static_cast<std::uint8_t>(seed >> 24);
    }
  }
  return frame;
}

const char* optimized_backend() {
#if defined(__ARM_NEON) && !defined(EDGE_DISABLE_NEON)
  return "NEON_8_box_outputs_with_scalar_tail";
#else
  return "scalar_fused";
#endif
}

void preprocess(const Frame& frame, Roi roi, Mode mode, Workspace& work) {
  validate(frame, roi);
  const auto w = (roi.width + 1) / 2, h = (roi.height + 1) / 2;
  constexpr float scale = 1.0f / 255.0f;

  if (mode == Mode::baseline) {
    std::vector<std::uint8_t> image(w * h);
    std::vector<float> output(w * h);
    for (std::size_t x = 0; x < w; ++x) {
      for (std::size_t y = 0; y < h; ++y)
        image[y * w + x] = sample(frame, roi, x, y);
    }
    for (std::size_t i = 0; i < image.size(); ++i)
      output[i] = image[i] * scale;
    work.normalized = std::move(output);
    return;
  }

  work.normalized.resize(w * h);
  if (mode == Mode::stage1) {
    work.downsampled.resize(w * h);
    // 此阶段保持列式循环，先单独观察复用内存的收益。
    for (std::size_t x = 0; x < w; ++x) {
      for (std::size_t y = 0; y < h; ++y)
        work.downsampled[y * w + x] = sample(frame, roi, x, y);
    }
    for (std::size_t i = 0; i < w * h; ++i)
      work.normalized[i] = work.downsampled[i] * scale;
    return;
  }

  // 最终阶段融合 downsample/normalize 并连续写出，省去中间图像的一读一写。
  // 融合、遍历顺序与 NEON 同时变化，不能把全部速度差独立归因于其中一项。
  // 使用 EDGE_DISABLE_NEON 可保留同一融合路径，仅关闭显式 NEON 做对照。
  const auto full_rows = roi.height / 2;
  const auto full_columns = roi.width / 2;
  for (std::size_t y = 0; y < full_rows; ++y) {
    const auto* top = frame.pixels.data() + (roi.y + 2 * y) * frame.stride + roi.x;
    const auto* bottom = top + frame.stride;
    auto* output = work.normalized.data() + y * w;
    std::size_t x = 0;
#if defined(__ARM_NEON) && !defined(EDGE_DISABLE_NEON)
    for (; x + 8 <= full_columns; x += 8) {
      // AArch64 NEON 一次处理 8 个 2x2 box：每行读 16 字节，vld2 拆出偶/奇列。
      // full_columns/full_rows 保证两行和 16 列都在 ROI 内，不借用 padding 越界读。
      const auto top_pairs = vld2_u8(top + 2 * x);
      const auto bottom_pairs = vld2_u8(bottom + 2 * x);
      const auto top_sum = vaddl_u8(top_pairs.val[0], top_pairs.val[1]);
      const auto bottom_sum = vaddl_u8(bottom_pairs.val[0], bottom_pairs.val[1]);
      const auto sum = vaddq_u16(top_sum, bottom_sum);

      // 四个 uint8 最大和为 1020，uint16 足够；右移 2 位先完成整数向下取整。
      // 不能改成 FP32 sum / 4，否则会改变先量化再归一化的参考语义。
      const auto mean = vshrq_n_u16(sum, 2);
      const auto low = vcvtq_f32_u32(vmovl_u16(vget_low_u16(mean)));
      const auto high = vcvtq_f32_u32(vmovl_u16(vget_high_u16(mean)));
      vst1q_f32(output + x, vmulq_n_f32(low, scale));
      vst1q_f32(output + x + 4, vmulq_n_f32(high, scale));
    }
#endif
    for (; x < full_columns; ++x) {
      const unsigned sum = top[2 * x] + top[2 * x + 1] + bottom[2 * x] + bottom[2 * x + 1];
      output[x] = (sum / 4) * scale;
    }
    if (full_columns != w)
      output[w - 1] = sample(frame, roi, w - 1, y) * scale;
  }
  if (full_rows != h) {
    for (std::size_t x = 0; x < w; ++x) {
      work.normalized[(h - 1) * w + x] = sample(frame, roi, x, h - 1) * scale;
    }
  }
}

Result pipeline(const std::vector<Frame>& frames, Roi roi, Mode mode, std::size_t capacity) {
  FrameQueue queue(capacity);
  Workspace workspace;
  Result result;
  result.frame_us.reserve(frames.size());
  // 工作缓冲在本次任务开始分配，帧间复用；整个初始化仍包含在 E2E 计时中。
  if (mode != Mode::baseline && !frames.empty()) {
    validate(frames.front(), roi);
    workspace.normalized.reserve(((roi.width + 1) / 2) * ((roi.height + 1) / 2));
    if (mode == Mode::stage1)
      workspace.downsampled.reserve(workspace.normalized.capacity());
  }

  std::thread producer([&] {
    for (std::size_t i = 0; i < frames.size(); ++i) {
      if (!queue.push({i, FrameQueue::Clock::now()}))
        break;
    }
    queue.close();
  });
  try {
    FrameQueue::Item item;
    while (queue.pop(item)) {
      preprocess(frames[item.index], roi, mode, workspace);
      // 完整输出作为模拟推理消费者输入；hash 成本对所有版本相同并计入 E2E。
      result.digest = (result.digest * 131) ^ digest(workspace.normalized);
      result.frame_us.push_back(
          std::chrono::duration<double, std::micro>(FrameQueue::Clock::now() - item.captured)
              .count());
      ++result.processed;
    }
  } catch (...) {
    queue.close();  // 唤醒可能因背压阻塞的生产者，保证异常路径也能 join。
    producer.join();
    throw;
  }
  producer.join();
  result.queue_high_water = queue.high_water();
  edge::require(result.processed == frames.size(), "pipeline lost frames");
  return result;
}
}  // namespace camera
