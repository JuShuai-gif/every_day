#include <iostream>

#include "edge_bench.hpp"
#include "event_log.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      event_log::self_test();
      std::cout << "correctness=PASS\n";
    }
    if (options.test_only) {
      return;
    }

    const auto events = event_log::make_events(4096);
    event_log::FileSink sink;
    std::cout << "scenario=ordered_industrial_event_file_sink\n"
              << "events=" << events.size() << '\n'
              << "buffer_capacity_bytes=65536\n"
              << "durability=page_cache_no_fsync\n"
              << "timing_scope=file_reset_format_hash_write_and_final_buffer_flush\n"
              << "units=events\n";

    if (!options.profile) {
      for (int stage = 0; stage < 3; ++stage) {
        const auto stats = event_log::run(sink, events, stage);
        std::cout << "diagnostic_stage=" << stage << " bytes=" << stats.bytes
                  << " write_calls=" << stats.write_calls << " buffer_peak=" << stats.buffer_peak
                  << '\n';
      }
    }

    auto invoke = [&](int stage) {
      const auto stats = event_log::run(sink, events, stage);
      edge::escape(stats);
      return stats.hash;
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
                    events.size());
  });
}
