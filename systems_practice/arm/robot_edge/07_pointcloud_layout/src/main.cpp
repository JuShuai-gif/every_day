#include <iostream>

#include "../tests/cases.hpp"
#include "edge_bench.hpp"
#include "pipeline.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      pointcloud::self_test();
    }
    if (options.test_only) {
      std::cout << "correctness=PASS\n";
      return;
    }

    const auto points = pointcloud::make_scan(131072);
    const pointcloud::Transform transform;
    pointcloud::Workspace workspace(points.size());
    pointcloud::Grid output;
    if (!options.profile) {
      pointcloud::verify(points, transform);
      std::cout << "correctness=PASS\n";
    }
    std::cout << "workload=scan_to_occupancy points=" << points.size()
              << " point_bytes=" << sizeof(pointcloud::Point)
              << " grid_cells=" << pointcloud::kCells << " soa_block=" << pointcloud::kBlock
              << " conversion_in_timing=true\n";
    if (!options.profile) {
      pointcloud::run(points, transform, pointcloud::Mode::BlockedSoA, workspace, output);
      std::cout << "accepted=" << output.accepted << " rejected=" << output.rejected
                << " invalid=" << output.invalid << '\n';
    }

    const auto execute = [&](pointcloud::Mode mode) {
      pointcloud::run(points, transform, mode, workspace, output);
      edge::escape(output.counts.data());
      edge::escape(output.max_height_mm.data());
      edge::clobber();
      return pointcloud::digest(output);
    };
    edge::benchmark(options,
                    {{"baseline",
                      [&] {
                        return execute(pointcloud::Mode::AllocatedAoS);
                      }},
                     {"stage1",
                      [&] {
                        return execute(pointcloud::Mode::ReusedAoS);
                      }},
                     {"optimized",
                      [&] {
                        return execute(pointcloud::Mode::BlockedSoA);
                      }}},
                    points.size());
  });
}
