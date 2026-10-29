#pragma once

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>

namespace pointcloud {

constexpr std::size_t kSide = 128;
constexpr std::size_t kCells = kSide * kSide;
constexpr std::size_t kBlock = 256;
constexpr std::size_t kMaxPoints = 1U << 20;
constexpr std::int32_t kEmptyHeight = std::numeric_limits<std::int32_t>::min();

// 模拟驱动送来的 AoS 记录。ring/time 等元数据使只取 xyz 的遍历带入额外字节。
struct Point {
  float x;
  float y;
  float z;
  float intensity;
  std::uint32_t offset_us;
  std::uint16_t ring;
  std::uint16_t flags;
  std::uint64_t stamp;
};

static_assert(sizeof(Point) == 32, "point packet layout must stay 32 bytes");

struct Transform {
  // 绕 z 轴旋转 90 度，再平移；默认输入与系数可精确二进制表示，方便比较栅格边界。
  std::array<float, 12> m{0, -1, 0, 0.25f, 1, 0, 0, -0.5f, 0, 0, 1, 0.125f};
};

struct Grid {
  std::array<std::uint32_t, kCells> counts{};
  std::array<std::int32_t, kCells> max_height_mm{};
  std::uint64_t accepted = 0;
  std::uint64_t rejected = 0;
  std::uint64_t invalid = 0;

  void reset() {
    counts.fill(0);
    max_height_mm.fill(kEmptyHeight);
    accepted = rejected = invalid = 0;
  }
};

struct Workspace {
  explicit Workspace(std::size_t capacity) {
    if (capacity > kMaxPoints) {
      throw std::invalid_argument("scan exceeds workspace capacity limit");
    }
    transformed.reserve(capacity);
    cropped.reserve(capacity);
  }

  std::vector<Point> transformed;
  std::vector<Point> cropped;
  std::array<float, kBlock> x{};
  std::array<float, kBlock> y{};
  std::array<float, kBlock> z{};
  std::array<float, kBlock> intensity{};
};

enum class Mode { AllocatedAoS, ReusedAoS, BlockedSoA };

inline bool finite(float x, float y, float z, float intensity) {
  return std::isfinite(x) && std::isfinite(y) && std::isfinite(z) && std::isfinite(intensity);
}

inline bool inside(float x, float y, float z, float intensity) {
  return x >= -32 && x < 32 && y >= -32 && y < 32 && z >= -3 && z < 3 && intensity >= 0.2f;
}

inline Point transformed(Point point, const Transform& t) {
  const float x = point.x;
  const float y = point.y;
  const float z = point.z;
  point.x = ((t.m[0] * x + t.m[1] * y) + t.m[2] * z) + t.m[3];
  point.y = ((t.m[4] * x + t.m[5] * y) + t.m[6] * z) + t.m[7];
  point.z = ((t.m[8] * x + t.m[9] * y) + t.m[10] * z) + t.m[11];
  return point;
}

inline void insert(Grid& grid, float x, float y, float z) {
  // 必须先转 double 再平移：float 的 nextafter(32, 0) 加 32 会舍入成 64，
  // 使本应位于最后一格的合法点变成第 128 格。double 保留边界内的距离。
  const auto column = static_cast<std::size_t>((static_cast<double>(x) + 32.0) * 2.0);
  const auto row = static_cast<std::size_t>((static_cast<double>(y) + 32.0) * 2.0);
  const auto index = row * kSide + column;
  ++grid.counts[index];
  const auto height = static_cast<std::int32_t>(std::floor(z * 1000.0f));
  grid.max_height_mm[index] = std::max(grid.max_height_mm[index], height);
  ++grid.accepted;
}

inline void aos_pipeline(const std::vector<Point>& points,
                         const Transform& transform,
                         std::vector<Point>& transformed_points,
                         std::vector<Point>& cropped,
                         Grid& grid) {
  transformed_points.clear();
  cropped.clear();
  for (const auto& point : points) {
    transformed_points.push_back(transformed(point, transform));
  }
  for (const auto& point : transformed_points) {
    if (!finite(point.x, point.y, point.z, point.intensity)) {
      ++grid.invalid;
    } else if (!inside(point.x, point.y, point.z, point.intensity)) {
      ++grid.rejected;
    } else {
      cropped.push_back(point);
    }
  }
  for (const auto& point : cropped) {
    insert(grid, point.x, point.y, point.z);
  }
}

inline void blocked_pipeline(const std::vector<Point>& points,
                             const Transform& t,
                             Workspace& scratch,
                             Grid& grid) {
  for (std::size_t begin = 0; begin < points.size(); begin += kBlock) {
    const auto count = std::min(kBlock, points.size() - begin);

    // AoS -> 局部 SoA 每帧发生，明确包含在计时中；无整帧 SoA 预转换捷径。
    for (std::size_t i = 0; i < count; ++i) {
      const auto& point = points[begin + i];
      scratch.x[i] = point.x;
      scratch.y[i] = point.y;
      scratch.z[i] = point.z;
      scratch.intensity[i] = point.intensity;
    }

    // 连续数组给自动向量化机会；是否向量化、是否提速由编译器报告与测量验证。
    for (std::size_t i = 0; i < count; ++i) {
      const auto x = scratch.x[i];
      const auto y = scratch.y[i];
      const auto z = scratch.z[i];
      scratch.x[i] = ((t.m[0] * x + t.m[1] * y) + t.m[2] * z) + t.m[3];
      scratch.y[i] = ((t.m[4] * x + t.m[5] * y) + t.m[6] * z) + t.m[7];
      scratch.z[i] = ((t.m[8] * x + t.m[9] * y) + t.m[10] * z) + t.m[11];
    }

    // 过滤后直接更新固定栅格，省掉中间的 AoS 压缩数组与再次读取。
    for (std::size_t i = 0; i < count; ++i) {
      const auto x = scratch.x[i];
      const auto y = scratch.y[i];
      const auto z = scratch.z[i];
      const auto intensity = scratch.intensity[i];
      if (!finite(x, y, z, intensity)) {
        ++grid.invalid;
      } else if (!inside(x, y, z, intensity)) {
        ++grid.rejected;
      } else {
        insert(grid, x, y, z);
      }
    }
  }
}

inline void run(const std::vector<Point>& points,
                const Transform& transform,
                Mode mode,
                Workspace& scratch,
                Grid& output) {
  if (points.size() > kMaxPoints) {
    throw std::invalid_argument("scan exceeds one million point limit");
  }
  for (const auto coefficient : transform.m) {
    if (!std::isfinite(coefficient) || std::abs(coefficient) > 100) {
      throw std::invalid_argument("transform coefficients must be finite and bounded");
    }
  }
  output.reset();
  if (mode == Mode::AllocatedAoS) {
    std::vector<Point> moved;
    std::vector<Point> cropped;
    moved.reserve(points.size());
    cropped.reserve(points.size());
    aos_pipeline(points, transform, moved, cropped, output);
  } else if (mode == Mode::ReusedAoS) {
    if (scratch.transformed.capacity() < points.size() ||
        scratch.cropped.capacity() < points.size()) {
      throw std::invalid_argument("preallocated workspace too small");
    }
    aos_pipeline(points, transform, scratch.transformed, scratch.cropped, output);
  } else {
    blocked_pipeline(points, transform, scratch, output);
  }
}

inline std::vector<Point> make_scan(std::size_t count) {
  if (count > kMaxPoints) {
    throw std::invalid_argument("scan too large");
  }
  std::vector<Point> points(count);
  std::uint32_t random = 0x12345678;
  const auto next = [&random] {
    random = random * 1664525U + 1013904223U;
    return random;
  };
  for (std::size_t i = 0; i < count; ++i) {
    const float x = static_cast<float>(static_cast<int>(next() % 1280) - 640) / 16;
    const float y = static_cast<float>(static_cast<int>(next() % 1280) - 640) / 16;
    const float z = static_cast<float>(static_cast<int>(next() % 160) - 80) / 16;
    const float intensity = static_cast<float>(next() % 256) / 256;
    points[i] = {x,
                 y,
                 z,
                 intensity,
                 static_cast<std::uint32_t>(i % 100000),
                 static_cast<std::uint16_t>(i % 32),
                 0,
                 1000000 + i};
  }
  if (!points.empty()) {
    points[0].x = std::numeric_limits<float>::quiet_NaN();
  }
  return points;
}

inline std::uint64_t digest(const Grid& grid) {
  // 栅格大小固定，发布端消费全部格子；其成本计入每一版本，不能只检查点数。
  std::uint64_t hash = 14695981039346656037ULL;
  for (std::size_t i = 0; i < kCells; ++i) {
    hash = (hash ^ grid.counts[i]) * 1099511628211ULL;
    hash = (hash ^ static_cast<std::uint32_t>(grid.max_height_mm[i])) * 1099511628211ULL;
  }
  return hash ^ grid.accepted ^ (grid.rejected << 16) ^ (grid.invalid << 32);
}

}  // namespace pointcloud
