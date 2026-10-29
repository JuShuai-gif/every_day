#pragma once

#include "../src/pipeline.hpp"
#include "edge_bench.hpp"

namespace pointcloud {

inline void verify(const std::vector<Point>& points, const Transform& transform) {
  Workspace scratch(points.size());
  Grid reference;
  Grid candidate;
  run(points, transform, Mode::AllocatedAoS, scratch, reference);
  for (const auto mode : {Mode::ReusedAoS, Mode::BlockedSoA}) {
    run(points, transform, mode, scratch, candidate);
    edge::require(candidate.counts == reference.counts &&
                      candidate.max_height_mm == reference.max_height_mm &&
                      candidate.accepted == reference.accepted &&
                      candidate.rejected == reference.rejected &&
                      candidate.invalid == reference.invalid,
                  "all occupancy cells, heights and classifications match");
    edge::require(candidate.accepted + candidate.rejected + candidate.invalid == points.size(),
                  "every point classified exactly once");
  }
}

inline void self_test() {
  const Transform transform;
  for (const auto count : {0U, 1U, 255U, 256U, 257U, 1025U}) {
    verify(make_scan(count), transform);
  }

  const Transform identity{{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0}};
  const auto nan = std::numeric_limits<float>::quiet_NaN();
  const auto inf = std::numeric_limits<float>::infinity();
  std::vector<Point> known{{0, 0, 1, 1, 0, 0, 0, 0},
                           {0.25f, 0.25f, 2, 1, 0, 0, 0, 0},
                           {-32, -32, -3, 0.2f, 0, 0, 0, 0},
                           {32, 0, 0, 1, 0, 0, 0, 0},
                           {0, 0, 3, 1, 0, 0, 0, 0},
                           {0, 0, 0, 0.1f, 0, 0, 0, 0},
                           {nan, 0, 0, 1, 0, 0, 0, 0},
                           {0, inf, 0, 1, 0, 0, 0, 0}};
  Workspace scratch(known.size());
  Grid grid;
  run(known, identity, Mode::BlockedSoA, scratch, grid);
  edge::require(grid.accepted == 3 && grid.rejected == 3 && grid.invalid == 2,
                "known crop and invalid counts");
  edge::require(grid.counts[64 * kSide + 64] == 2 && grid.max_height_mm[64 * kSide + 64] == 2000 &&
                    grid.counts[0] == 1 && grid.max_height_mm[0] == -3000 &&
                    grid.max_height_mm[1] == kEmptyHeight,
                "known occupancy and millimeter height output");
  verify(known, identity);
  verify(known, transform);

  const float last_inside = std::nextafter(32.0f, 0.0f);
  const std::vector<Point> near_upper{{last_inside, last_inside, 0, 1, 0, 0, 0, 0}};
  run(near_upper, identity, Mode::BlockedSoA, scratch, grid);
  edge::require(grid.accepted == 1 && grid.counts[127 * kSide + 127] == 1,
                "nextafter upper boundary maps to final valid cell");
  verify(near_upper, identity);

  bool rejected = false;
  auto bad_transform = transform;
  bad_transform.m[0] = nan;
  try {
    run(known, bad_transform, Mode::BlockedSoA, scratch, grid);
  } catch (const std::invalid_argument&) {
    rejected = true;
  }
  edge::require(rejected, "invalid calibration rejected");
  rejected = false;
  Workspace small(0);
  try {
    run(known, transform, Mode::ReusedAoS, small, grid);
  } catch (const std::invalid_argument&) {
    rejected = true;
  }
  edge::require(rejected, "workspace capacity checked before frame processing");
}

}  // namespace pointcloud
