#pragma once

#include "edge_bench.hpp"
#include "lidar.hpp"

namespace lidar {

inline void same_output(const Output& a, const Output& b) {
  edge::require(a.rejected == b.rejected && a.points.size() == b.points.size(), "lidar counts");
  for (std::size_t i = 0; i < a.points.size(); ++i) {
    const auto& x = a.points[i];
    const auto& y = b.points[i];
    edge::require(x.source_index == y.source_index && x.range_mm == y.range_mm &&
                      x.x_mm == y.x_mm && x.y_mm == y.y_mm,
                  "lidar stable compaction/coordinates");
  }
  for (std::size_t i = 0; i < kSectors; ++i) {
    edge::require(a.sectors[i].count == b.sectors[i].count &&
                      a.sectors[i].nearest_mm == b.sectors[i].nearest_mm,
                  "lidar sector summary");
  }
}

inline void self_test() {
  Calibration calibration;
  const Scan known{100,
                   200,
                   {{300, 0, 20, 100},
                    {8000, 900, 255, 200},
                    {299, 0, 255, 150},
                    {8001, 0, 255, 150},
                    {500, 3600, 255, 150},
                    {500, 0, 19, 150},
                    {500, 0, 255, 99},
                    {500, 0, 255, 201},
                    {400, 99, 255, 150}}};

  for (const auto mode : {Mode::baseline, Mode::stage1, Mode::optimized}) {
    Processor processor(calibration, 64);
    const auto& output = processor.run(known, mode);
    edge::require(output.points.size() == 3 && output.rejected == 6, "lidar known counts");
    edge::require(output.points[0].x_mm == 300.0f && output.points[0].y_mm == 0.0f,
                  "lidar known zero-angle point");
    edge::require(std::abs(output.points[1].x_mm) < 0.001f &&
                      std::abs(output.points[1].y_mm - 8000.0f) < 0.001f,
                  "lidar known right-angle point");
    edge::require(output.points[2].source_index == 8 && output.sectors[0].count == 2 &&
                      output.sectors[0].nearest_mm == 300 && output.sectors[9].count == 1,
                  "lidar known sector/index");

    const auto& empty = processor.run(Scan{0, 0, {}}, mode);
    edge::require(empty.points.empty() && empty.rejected == 0 && empty.sectors[0].count == 0 &&
                      empty.sectors[0].nearest_mm == std::numeric_limits<std::uint32_t>::max(),
                  "lidar reset and empty scan");

    bool rejected = false;
    try {
      processor.run(Scan{2, 1, {}}, mode);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    edge::require(rejected, "lidar invalid interval rejected");
  }

  for (const auto count :
       {std::size_t{0}, std::size_t{1}, std::size_t{37}, std::size_t{8192}, kMaxBeams}) {
    const auto scan = fixture(count);
    Processor reference(calibration, count);
    Processor stage1(calibration, count);
    Processor optimized(calibration, count);
    const auto& expected = reference.run(scan, Mode::baseline);
    same_output(expected, stage1.run(scan, Mode::stage1));
    same_output(expected, optimized.run(scan, Mode::optimized));
    same_output(expected, optimized.run(scan, Mode::optimized));
  }

  Processor bounded(calibration, 1);
  bool overflow = false;
  try {
    bounded.run(fixture(2), Mode::optimized);
  } catch (const std::invalid_argument&) {
    overflow = true;
  }
  edge::require(overflow, "lidar oversize scan rejected before processing");
}

}  // namespace lidar
