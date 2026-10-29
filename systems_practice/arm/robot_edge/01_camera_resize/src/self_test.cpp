#include <algorithm>
#include <cmath>
#include <future>
#include <limits>

#include "camera.hpp"
#include "edge_bench.hpp"

namespace camera {
namespace {
template <typename F>
void rejects(F&& f) {
  bool rejected = false;
  try {
    f();
  } catch (const std::runtime_error&) {
    rejected = true;
  }
  edge::require(rejected, "invalid camera input accepted");
}
}  // namespace

void self_test() {
  const Mode modes[] = {Mode::baseline, Mode::stage1, Mode::optimized};
  Frame known{3, 3, 5, {0, 4, 8, 255, 255, 12, 16, 20, 255, 255, 24, 28, 32, 255, 255}};
  // 独立手算 2x2 均值：8、14、26、32；padding 255 不参与计算。
  for (auto mode : modes) {
    Workspace w;
    preprocess(known, {0, 0, 3, 3}, mode, w);
    const unsigned expected[] = {8, 14, 26, 32};
    edge::require(w.normalized.size() == 4, "wrong output shape");
    for (std::size_t i = 0; i < 4; ++i) {
      edge::require(std::abs(w.normalized[i] - expected[i] / 255.0f) < 1e-7f, "box mean mismatch");
    }
    preprocess(known, {2, 2, 1, 1}, mode, w);
    edge::require(std::abs(w.normalized[0] - 32 / 255.0f) < 1e-7f, "single pixel ROI");
    rejects([&] {
      preprocess(known, {2, 2, 2, 1}, mode, w);
    });
    rejects([&] {
      preprocess(known, {0, 0, 0, 1}, mode, w);
    });
    auto truncated = known;
    truncated.pixels.resize(10);
    rejects([&] {
      preprocess(truncated, {0, 0, 3, 3}, mode, w);
    });
  }
  // 16 个输入像素是一个 SIMD 块；覆盖块前后、无 padding 的最后一行以及奇数边缘。
  for (std::size_t width : {1U, 2U, 3U, 7U, 15U, 16U, 17U, 31U, 32U, 33U}) {
    for (std::size_t height : {1U, 2U, 3U, 9U}) {
      for (std::size_t padding : {0U, 7U}) {
        auto frame = make_frame(width, height, padding, 42);
        Workspace reference, candidate;
        preprocess(frame, {0, 0, width, height}, Mode::baseline, reference);
        for (auto mode : modes) {
          preprocess(frame, {0, 0, width, height}, mode, candidate);
          edge::require(reference.normalized == candidate.normalized, "full-image mismatch");
        }

        // 非对齐 ROI 起点与整图 stride 不一致，不能把 ROI 当作紧密排列的新图像。
        auto offset = make_frame(width + 3, height + 2, padding, 93);
        preprocess(offset, {1, 1, width, height}, Mode::baseline, reference);
        preprocess(offset, {1, 1, width, height}, Mode::optimized, candidate);
        edge::require(reference.normalized == candidate.normalized, "offset ROI mismatch");
      }
    }
  }

  // 覆盖四个 uint8 的全部可能总和 0..1020，独立校验整数除法与最大值不溢出。
  // 每个总和放进 8 条 SIMD lane，所有 lane 都和手算结果比较，而不仅检查首尾。
  Frame sums{16, 2, 16, std::vector<std::uint8_t>(32)};
  for (unsigned total = 0; total <= 1020; ++total) {
    for (std::size_t lane = 0; lane < 8; ++lane) {
      unsigned remaining = (total + static_cast<unsigned>(lane)) % 1021;
      for (std::size_t y = 0; y < 2; ++y) {
        for (std::size_t x = 0; x < 2; ++x) {
          const auto value = std::min(remaining, 255U);
          sums.pixels[y * 16 + lane * 2 + x] = static_cast<std::uint8_t>(value);
          remaining -= value;
        }
      }
    }
    Workspace reference, candidate;
    preprocess(sums, {0, 0, 16, 2}, Mode::baseline, reference);
    preprocess(sums, {0, 0, 16, 2}, Mode::optimized, candidate);
    edge::require(reference.normalized == candidate.normalized, "SIMD full-value mismatch");
    for (std::size_t lane = 0; lane < 8; ++lane) {
      const auto average = ((total + static_cast<unsigned>(lane)) % 1021) / 4;
      edge::require(candidate.normalized[lane] == average * (1.0f / 255.0f),
                    "SIMD integer box quantization mismatch");
    }
  }
  rejects([] {
    FrameQueue invalid(0);
  });
  FrameQueue q(1);
  edge::require(q.push({7, {}}), "initial push failed");
  auto blocked = std::async(std::launch::async, [&] {
    return q.push({8, {}});
  });
  q.close();
  edge::require(!blocked.get(), "closed queue accepted a producer");
  FrameQueue::Item item;
  edge::require(q.pop(item) && item.index == 7 && !q.pop(item), "close must drain existing item");
  FrameQueue empty(1);
  auto reader = std::async(std::launch::async, [&] {
    FrameQueue::Item x;
    return empty.pop(x);
  });
  empty.close();
  edge::require(!reader.get(), "empty close did not wake reader");

  std::vector<Frame> frames(12, known);
  const auto reference = pipeline(frames, {0, 0, 3, 3}, Mode::baseline, 1);
  for (auto mode : modes) {
    const auto r = pipeline(frames, {0, 0, 3, 3}, mode, 1);
    edge::require(r.digest == reference.digest && r.processed == 12 && r.queue_high_water <= 1,
                  "pipeline equivalence/backpressure failure");
    edge::require(pipeline({}, {0, 0, 1, 1}, mode, 1).processed == 0, "empty replay failure");
    rejects([&] {
      pipeline(frames, {2, 2, 4, 4}, mode, 1);
    });
  }
  std::cout << "tests=camera_golden,stride,odd_tail,roi,simd_boundary,all_box_sums,"
               "invalid_shape,queue_close,drain,backpressure\n";
}
}  // namespace camera
