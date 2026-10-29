#include <iostream>

#include "edge_bench.hpp"
#include "modbus.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      modbus::self_test();
      std::cout << "correctness=PASS\n";
    }
    if (options.test_only) {
      return;
    }

    const auto dataset = modbus::make_dataset(2048);
    std::cout << "scenario=modbus_tcp_read_holding_registers_response\n"
              << "frames=" << dataset.expected.size() << '\n'
              << "wire_bytes=" << dataset.bytes.size() << '\n'
              << "receive_chunk_limit=512\noptimized_scratch_bytes=260\n"
              << "timing_scope=fragment_replay_parse_decode_and_result_consumption\n"
              << "units=response_frames\n";

    if (!options.profile) {
      for (int stage = 0; stage < 3; ++stage) {
        const auto result = modbus::run(dataset.bytes, stage, dataset.expected.size());
        std::size_t exceptions = 0;
        for (const auto& response : result.responses) {
          exceptions += response.exception != 0;
        }
        std::cout << "diagnostic_stage=" << stage << " responses=" << result.responses.size()
                  << " exception_responses=" << exceptions
                  << " receive_buffer_peak=" << result.buffer_peak << '\n';
      }
    }

    auto invoke = [&](int stage) {
      auto result = modbus::run(dataset.bytes, stage, dataset.expected.size());
      edge::escape(result.responses);
      return modbus::checksum(result);
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
                    dataset.expected.size());
  });
}
