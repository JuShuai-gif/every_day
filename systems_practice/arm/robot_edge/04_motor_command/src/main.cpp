#include <cstdint>
#include <iostream>

#include "../tests/self_test.hpp"
#include "edge_bench.hpp"
#include "motor.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      motor::self_test();
      std::cout << "correctness=PASS\n";
    }
    if (options.test_only) {
      return;
    }

    const auto cycles = motor::fixture(2048);
    motor::Processor baseline(cycles.size());
    motor::Processor stage1(cycles.size());
    motor::Processor optimized(cycles.size());
    if (!options.profile) {
      const auto& preview = optimized.run(cycles, motor::Mode::optimized);
      std::cout << "workload=2048_control_cycles axes=12 packet_bytes=" << motor::kPacketBytes
                << " safe_stop_frames=" << preview.safe_stop_frames
                << " late_input_frames=" << preview.late_frames
                << " workspace_reserved_bytes=" << optimized.reserved_bytes()
                << " actuator_io=disabled\n";
    }

    edge::benchmark(options,
                    {{"baseline",
                      [&]() -> std::uint64_t {
                        const auto& output = baseline.run(cycles, motor::Mode::baseline);
                        edge::escape(output.packets.data());
                        return motor::digest(output);
                      }},
                     {"stage1",
                      [&]() -> std::uint64_t {
                        const auto& output = stage1.run(cycles, motor::Mode::stage1);
                        edge::escape(output.packets.data());
                        return motor::digest(output);
                      }},
                     {"optimized",
                      [&]() -> std::uint64_t {
                        const auto& output = optimized.run(cycles, motor::Mode::optimized);
                        edge::escape(output.packets.data());
                        return motor::digest(output);
                      }}},
                    cycles.size());
  });
}
