#include <cstdint>
#include <iostream>

#include "../tests/self_test.hpp"
#include "edge_bench.hpp"
#include "imu.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      imu::self_test();
      std::cout << "correctness=PASS\n";
    }
    if (options.test_only) {
      return;
    }

    const auto samples = imu::fixture(4096);
    const imu::Config config{128, 256000, 50000};
    imu::Processor baseline(config, samples.size());
    imu::Processor stage1(config, samples.size());
    imu::Processor optimized(config, samples.size());
    if (!options.profile) {
      const auto& preview = optimized.run(samples, imu::Mode::optimized);
      std::cout << "workload=4096_imu_samples axes=6 window=128 rejected=" << preview.rejected
                << " gap_resets=" << preview.gap_resets << " expired=" << preview.expired
                << " evicted=" << preview.evicted
                << " workspace_reserved_bytes=" << optimized.reserved_bytes()
                << " transport=synthetic_replay\n";
    }

    edge::benchmark(options,
                    {{"baseline",
                      [&]() -> std::uint64_t {
                        const auto& output = baseline.run(samples, imu::Mode::baseline);
                        edge::escape(output.snapshots.data());
                        return imu::digest(output);
                      }},
                     {"stage1",
                      [&]() -> std::uint64_t {
                        const auto& output = stage1.run(samples, imu::Mode::stage1);
                        edge::escape(output.snapshots.data());
                        return imu::digest(output);
                      }},
                     {"optimized",
                      [&]() -> std::uint64_t {
                        const auto& output = optimized.run(samples, imu::Mode::optimized);
                        edge::escape(output.snapshots.data());
                        return imu::digest(output);
                      }}},
                    samples.size());
  });
}
