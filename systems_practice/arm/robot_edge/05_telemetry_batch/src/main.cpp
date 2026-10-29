#include <iostream>

#include "../tests/cases.hpp"
#include "edge_bench.hpp"
#include "pipeline.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      telemetry::self_test();
      std::cout << "correctness=PASS\n";
    }
    if (options.test_only) {
      return;
    }

    const auto events = telemetry::make_events(8192);
    telemetry::Sink sink;
    std::cout << "workload=telemetry_replay events=" << events.size()
              << " bytes_per_event=" << telemetry::kFrameBytes
              << " sink=bounded_memory_model max_write_bytes=173"
              << " batching_max_age_us=" << telemetry::kMaxAgeUs << '\n';
    // perf 单阶段模式只执行所选算法，避免诊断预跑污染 PMU 统计。
    if (!options.profile) {
      const auto batch_stats = telemetry::run(events, telemetry::Mode::Batched, sink);
      std::cout << "modeled_max_wait_us=" << batch_stats.max_wait_us
                << " optimized_flushes=" << batch_stats.flushes
                << " optimized_write_calls=" << sink.calls()
                << " optimized_backpressure=" << sink.blocked() << '\n';
    }

    edge::benchmark(options,
                    {{"baseline",
                      [&] {
                        return telemetry::run(events, telemetry::Mode::Allocated, sink).digest;
                      }},
                     {"stage1",
                      [&] {
                        return telemetry::run(events, telemetry::Mode::Fixed, sink).digest;
                      }},
                     {"optimized",
                      [&] {
                        return telemetry::run(events, telemetry::Mode::Batched, sink).digest;
                      }}},
                    events.size());
  });
}
