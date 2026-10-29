#pragma once

#include <cmath>
#include <limits>

#include "edge_bench.hpp"
#include "imu.hpp"

namespace imu {

inline Sample uniform(std::uint64_t stamp, std::int32_t value) {
  Sample result{stamp, {}};
  result.axes.fill(value);
  return result;
}

inline void same_output(const Output& a, const Output& b) {
  edge::require(a.rejected == b.rejected && a.gap_resets == b.gap_resets &&
                    a.expired == b.expired && a.evicted == b.evicted &&
                    a.snapshots.size() == b.snapshots.size(),
                "IMU event counters");
  for (std::size_t i = 0; i < a.snapshots.size(); ++i) {
    const auto& x = a.snapshots[i];
    const auto& y = b.snapshots[i];
    edge::require(x.stamp_us == y.stamp_us && x.count == y.count && x.sum == y.sum &&
                      x.square_sum == y.square_sum,
                  "IMU exact per-sample statistics");
  }
}

inline void self_test() {
  for (const auto mode : {Mode::baseline, Mode::stage1, Mode::optimized}) {
    Processor processor(Config{3, 5000, 10000}, 16);
    const auto& known = processor.run(
        {uniform(1000, 1), uniform(2000, 2), uniform(3000, 3), uniform(4000, 4)}, mode);
    const auto& last = known.snapshots.back();
    edge::require(last.count == 3 && last.sum[0] == 9 && last.square_sum[0] == 29 &&
                      last.mean(0) == 3.0 && std::abs(last.variance(0) - 2.0 / 3.0) < 1e-12 &&
                      known.evicted == 1,
                  "IMU known sliding mean/population variance");

    const auto& invalid = processor.run({uniform(1000, 1),
                                         uniform(1000, 9),
                                         uniform(999, 9),
                                         uniform(2000, kSampleLimit + 1),
                                         uniform(3000, -1)},
                                        mode);
    edge::require(invalid.rejected == 3 && invalid.snapshots.back().count == 2 &&
                      invalid.snapshots.back().sum[0] == 0 &&
                      invalid.snapshots.back().square_sum[0] == 2,
                  "IMU rejection does not mutate window");

    const auto& expiry =
        processor.run({uniform(1000, 1), uniform(3000, 2), uniform(6001, 3)}, mode);
    edge::require(expiry.expired == 1 && expiry.snapshots.back().count == 2 &&
                      expiry.snapshots.back().sum[0] == 5,
                  "IMU time horizon expires old samples");

    const auto& gap = processor.run({uniform(1000, 9), uniform(11001, -2)}, mode);
    edge::require(
        gap.gap_resets == 1 && gap.snapshots.back().count == 1 && gap.snapshots.back().sum[0] == -2,
        "IMU acquisition gap starts new window");

    const auto& extreme =
        processor.run({uniform(0, kSampleLimit), uniform(1, -kSampleLimit)}, mode);
    edge::require(extreme.snapshots.back().sum[0] == 0 &&
                      extreme.snapshots.back().square_sum[0] == 20000000000LL,
                  "IMU square is widened before multiplication");
    edge::require(processor.run({}, mode).snapshots.empty(), "IMU empty replay reset");
  }

  for (const auto window : {std::size_t{1}, std::size_t{3}, std::size_t{128}, kMaxWindow}) {
    Config config{window, 256000, 50000};
    const auto samples = fixture(4096);
    Processor reference(config, samples.size());
    Processor stage1(config, samples.size());
    Processor optimized(config, samples.size());
    const auto& expected = reference.run(samples, Mode::baseline);
    same_output(expected, stage1.run(samples, Mode::stage1));
    same_output(expected, optimized.run(samples, Mode::optimized));
    same_output(expected, optimized.run(samples, Mode::optimized));
  }

  bool invalid_config = false;
  try {
    Processor invalid(Config{0, 1000, 1000});
  } catch (const std::invalid_argument&) {
    invalid_config = true;
  }
  edge::require(invalid_config, "IMU zero window rejected");

  Processor bounded(Config{}, 1);
  bool overflow = false;
  try {
    bounded.run(fixture(2), Mode::optimized);
  } catch (const std::invalid_argument&) {
    overflow = true;
  }
  edge::require(overflow, "IMU oversized batch rejected");

  const auto max_stamp = std::numeric_limits<std::uint64_t>::max();
  const auto& tail = bounded.run({uniform(max_stamp, 1)}, Mode::optimized);
  edge::require(tail.snapshots.back().stamp_us == max_stamp, "IMU timestamp boundary");
}

}  // namespace imu
