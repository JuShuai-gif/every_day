#include <iostream>

#include "edge_bench.hpp"
#include "fusion.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      fusion::self_test();
      std::cout << "correctness=PASS\n";
    }
    if (options.test_only) {
      return;
    }

    const auto input = fusion::make_input(8192);
    std::cout << "scenario=imu_wheel_timestamp_alignment\n"
              << "imu_samples=" << input.imu.size() << '\n'
              << "wheel_samples=" << input.wheel.size() << '\n'
              << "queue_capacity=64\nworker_threads=2\n"
              << "timing_scope=validate_allocate_thread_start_fuse_drain_join_hash\n"
              << "units=wheel_observations\n";

    if (!options.profile) {
      for (int stage = 0; stage < 3; ++stage) {
        const auto result = fusion::run(input, stage, 64);
        std::cout << "diagnostic_stage=" << stage << " fused=" << result.values.size()
                  << " unmatched=" << result.unmatched << " queue_peak=" << result.queue_peak
                  << " queue_waits=" << result.queue_waits << '\n';
      }
    }

    auto invoke = [&](int stage) {
      auto result = fusion::run(input, stage, 64);
      edge::escape(result.values);
      return fusion::checksum(result);
    };
    edge::benchmark(options,
                    {{"baseline",
                      [&] {
                        return invoke(0);
                      }},
                     {"stage1",
                      [&] {
                        return invoke(1);
                      }},
                     {"optimized",
                      [&] {
                        return invoke(2);
                      }}},
                    input.wheel.size());
  });
}
