#pragma once

#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <stdexcept>
#include <utility>
#include <vector>

namespace lidar {

// 单次扫描的硬上限用于限制输入、压缩点集和中间索引的内存。
constexpr std::size_t kMaxBeams = 131072;
constexpr std::size_t kSectors = 36;
constexpr std::size_t kAngles = 3600;  // 角度单位：0.1 度。

enum class Mode { baseline, stage1, optimized };

struct Beam {
  std::uint32_t range_mm;
  std::uint16_t angle;
  std::uint8_t intensity;
  std::uint64_t stamp_us;
};

struct Scan {
  std::uint64_t start_us;
  std::uint64_t end_us;
  std::vector<Beam> beams;
};

struct Point {
  float x_mm;
  float y_mm;
  std::uint32_t range_mm;
  std::uint32_t source_index;
};

struct Sector {
  std::uint32_t count = 0;
  std::uint32_t nearest_mm = std::numeric_limits<std::uint32_t>::max();
};

struct Output {
  std::vector<Point> points;
  std::array<Sector, kSectors> sectors{};
  std::size_t rejected = 0;
};

// 初始化时建立标定表，三个版本共用相同坐标变换和角度量化规则。
// 实际产品应从设备标定文件取得这些参数，本例使用理想二维扫描平面。
struct Calibration {
  std::array<float, kAngles> cosines{};
  std::array<float, kAngles> sines{};

  Calibration() {
    constexpr double pi = 3.14159265358979323846;
    for (std::size_t i = 0; i < kAngles; ++i) {
      const double radians = static_cast<double>(i) * pi / 1800.0;
      cosines[i] = static_cast<float>(std::cos(radians));
      sines[i] = static_cast<float>(std::sin(radians));
    }
  }
};

inline bool accepted(const Beam& beam, const Scan& scan) {
  return beam.range_mm >= 300 && beam.range_mm <= 8000 && beam.angle < kAngles &&
         beam.intensity >= 20 && beam.stamp_us >= scan.start_us && beam.stamp_us <= scan.end_us;
}

inline Point transform(const Beam& beam, std::size_t index, const Calibration& calibration) {
  return {calibration.cosines[beam.angle] * static_cast<float>(beam.range_mm),
          calibration.sines[beam.angle] * static_cast<float>(beam.range_mm),
          beam.range_mm,
          static_cast<std::uint32_t>(index)};
}

inline void update_sector(Output& output, const Beam& beam) {
  auto& sector = output.sectors[beam.angle / 100];
  ++sector.count;
  if (beam.range_mm < sector.nearest_mm) {
    sector.nearest_mm = beam.range_mm;
  }
}

class Processor {
 public:
  Processor(const Calibration& calibration, std::size_t capacity)
      : calibration_(calibration), capacity_(capacity) {
    if (capacity > kMaxBeams) {
      throw std::invalid_argument("lidar capacity exceeds 131072 beams");
    }
    selected_.reserve(capacity);
    output_.points.reserve(capacity);
  }

  // noinline 保留清晰的 perf 热点；返回完整压缩点集，不能只计算点数。
  [[gnu::noinline]] const Output& run(const Scan& scan, Mode mode) {
    if (scan.start_us > scan.end_us || scan.beams.size() > capacity_) {
      throw std::invalid_argument("invalid scan interval or scan capacity");
    }

    if (mode == Mode::baseline) {
      std::vector<std::size_t> selected;
      Output next;
      filter(scan, selected);
      materialize(scan, selected, next);
      summarize(scan, next);
      output_ = std::move(next);
    } else {
      output_.points.clear();
      output_.sectors = {};
      output_.rejected = 0;

      if (mode == Mode::stage1) {
        selected_.clear();
        filter(scan, selected_);
        materialize(scan, selected_, output_);
        summarize(scan, output_);
      } else {
        // 压缩、坐标转换、扇区归约融合为一次扫描，保留原始点序。
        for (std::size_t i = 0; i < scan.beams.size(); ++i) {
          const auto& beam = scan.beams[i];
          if (!accepted(beam, scan)) {
            ++output_.rejected;
            continue;
          }
          output_.points.push_back(transform(beam, i, calibration_));
          update_sector(output_, beam);
        }
      }
    }
    return output_;
  }

  std::size_t reserved_bytes() const {
    return selected_.capacity() * sizeof(std::size_t) + output_.points.capacity() * sizeof(Point);
  }

 private:
  static void filter(const Scan& scan, std::vector<std::size_t>& selected) {
    for (std::size_t i = 0; i < scan.beams.size(); ++i) {
      if (accepted(scan.beams[i], scan)) {
        selected.push_back(i);
      }
    }
  }

  void materialize(const Scan& scan, const std::vector<std::size_t>& selected, Output& output) {
    for (const auto index : selected) {
      output.points.push_back(transform(scan.beams[index], index, calibration_));
    }
    output.rejected = scan.beams.size() - output.points.size();
  }

  static void summarize(const Scan& scan, Output& output) {
    for (const auto& point : output.points) {
      update_sector(output, scan.beams[point.source_index]);
    }
  }

  const Calibration& calibration_;
  std::size_t capacity_;
  std::vector<std::size_t> selected_;
  Output output_;
};

inline Scan fixture(std::size_t count, std::uint32_t seed = 17) {
  Scan scan{1000000, 1100000, {}};
  scan.beams.reserve(count);
  for (std::size_t i = 0; i < count; ++i) {
    seed = seed * 1664525u + 1013904223u;
    Beam beam{100u + seed % 10000u,
              static_cast<std::uint16_t>(i % kAngles),
              static_cast<std::uint8_t>(seed >> 24u),
              scan.start_us + i % 100001};
    if (i % 97 == 0) {
      beam.angle = 3600;  // 设备损坏字段。
    }
    if (i % 101 == 0) {
      beam.stamp_us = scan.start_us - 1;  // 陈旧数据。
    }
    scan.beams.push_back(beam);
  }
  return scan;
}

// 消费全部输出，而非只读最后一个点，避免未使用的坐标计算被删掉。
inline std::uint64_t digest(const Output& output) {
  std::uint64_t hash = 1469598103934665603ull;
  const auto fold = [&](std::uint64_t value) {
    hash = (hash ^ value) * 1099511628211ull;
  };
  fold(output.rejected);
  for (const auto& point : output.points) {
    std::uint32_t x = 0;
    std::uint32_t y = 0;
    std::memcpy(&x, &point.x_mm, sizeof(x));
    std::memcpy(&y, &point.y_mm, sizeof(y));
    fold(x);
    fold(y);
    fold(point.range_mm);
    fold(point.source_index);
  }
  for (const auto& sector : output.sectors) {
    fold(sector.count);
    fold(sector.nearest_mm);
  }
  return hash;
}

}  // namespace lidar
