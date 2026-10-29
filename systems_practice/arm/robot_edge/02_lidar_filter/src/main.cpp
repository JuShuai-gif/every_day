#include <cstdint>
#include <iostream>

#include "../tests/self_test.hpp"
#include "edge_bench.hpp"
#include "lidar.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      lidar::self_test();
      std::cout << "correctness=PASS\n";
    }
    if (options.test_only) {
      return;
    }

    lidar::Calibration calibration;
    const auto scan = lidar::fixture(65536);
    lidar::Processor baseline(calibration, scan.beams.size());
    lidar::Processor stage1(calibration, scan.beams.size());
    lidar::Processor optimized(calibration, scan.beams.size());
    if (!options.profile) {
      const auto& preview = optimized.run(scan, lidar::Mode::optimized);
      std::cout << "workload=65536_beams_per_scan sectors=36 accepted=" << preview.points.size()
                << " rejected=" << preview.rejected
                << " workspace_reserved_bytes=" << optimized.reserved_bytes()
                << " transport=synthetic_in_memory\n";
    }

    edge::benchmark(options,
                    {{"baseline",
                      [&]() -> std::uint64_t {
                        const auto& output = baseline.run(scan, lidar::Mode::baseline);
                        edge::escape(output.points.data());
                        return lidar::digest(output);
                      }},
                     {"stage1",
                      [&]() -> std::uint64_t {
                        const auto& output = stage1.run(scan, lidar::Mode::stage1);
                        edge::escape(output.points.data());
                        return lidar::digest(output);
                      }},
                     {"optimized",
                      [&]() -> std::uint64_t {
                        const auto& output = optimized.run(scan, lidar::Mode::optimized);
                        edge::escape(output.points.data());
                        return lidar::digest(output);
                      }}},
                    scan.beams.size());
  });
}
