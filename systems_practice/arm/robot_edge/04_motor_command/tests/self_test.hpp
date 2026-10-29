#pragma once

#include <limits>

#include "edge_bench.hpp"
#include "motor.hpp"

namespace motor {

inline std::uint64_t read_le(const Packet& packet, std::size_t offset, unsigned count) {
  std::uint64_t value = 0;
  for (unsigned i = 0; i < count; ++i) {
    value |= static_cast<std::uint64_t>(packet.bytes[offset + i]) << (8u * i);
  }
  return value;
}

inline Cycle valid_cycle() {
  Cycle cycle{0x12345678, 10000, 9000, false, {}};
  for (std::size_t axis = 0; axis < kAxes; ++axis) {
    cycle.commands.push_back(
        Command{static_cast<std::uint8_t>(kAxes - axis - 1), -1, 2000, -300, true});
  }
  return cycle;
}

inline void assert_safe(const Packet& packet) {
  edge::require(packet.bytes[3] != ok, "motor unsafe frame must have error status");
  for (std::size_t axis = 0; axis < kAxes; ++axis) {
    const auto offset = 17 + axis * 14;
    edge::require(packet.bytes[offset] == axis, "motor safe frame axis order");
    for (std::size_t field = 1; field < 14; ++field) {
      edge::require(packet.bytes[offset + field] == 0,
                    "motor fail-closed frame contains nonzero setpoint");
    }
  }
}

inline void same_output(const Output& a, const Output& b) {
  edge::require(a.safe_stop_frames == b.safe_stop_frames && a.late_frames == b.late_frames &&
                    a.packets.size() == b.packets.size(),
                "motor output counters");
  for (std::size_t i = 0; i < a.packets.size(); ++i) {
    edge::require(a.packets[i].bytes == b.packets[i].bytes,
                  "motor packet byte-for-byte equivalence");
  }
}

inline void self_test() {
  const std::array<std::uint8_t, 9> check{{'1', '2', '3', '4', '5', '6', '7', '8', '9'}};
  CrcTable crc;
  edge::require(crc_bitwise(check.data(), check.size()) == 0x29b1 &&
                    crc.run(check.data(), check.size()) == 0x29b1 &&
                    crc.run(check.data(), 0) == 0xffff,
                "motor CRC known answers");

  for (const auto mode : {Mode::baseline, Mode::stage1, Mode::optimized}) {
    Processor processor(32);
    const auto& known = processor.run({valid_cycle()}, mode);
    const auto& packet = known.packets.front();
    edge::require(packet.bytes[0] == 0xa5 && packet.bytes[1] == 0x5a && packet.bytes[2] == 1 &&
                      packet.bytes[3] == ok && read_le(packet, 4, 4) == 0x12345678 &&
                      read_le(packet, 8, 8) == 10000 && packet.bytes[16] == 12,
                  "motor known header layout");
    edge::require(packet.bytes[17] == 0 && read_le(packet, 18, 4) == 0xffffffffu &&
                      read_le(packet, 22, 4) == 2000 && read_le(packet, 26, 4) == 0xfffffed4u &&
                      packet.bytes[30] == 1,
                  "motor known canonical axis and signed wire encoding");
    edge::require(
        read_le(packet, kPacketBytes - 2, 2) == crc_bitwise(packet.bytes.data(), kPacketBytes - 2),
        "motor packet checksum span");

    for (unsigned failure = 0; failure < 11; ++failure) {
      auto cycle = valid_cycle();
      switch (failure) {
        case 0:
          cycle.issued_us = cycle.now_us - kMaxAgeUs - 1;
          break;
        case 1:
          cycle.issued_us = cycle.now_us + 1;
          break;
        case 2:
          cycle.commands[1].axis = cycle.commands[0].axis;
          break;
        case 3:
          cycle.commands[0].axis = 255;
          break;
        case 4:
          cycle.commands[0].position_mdeg = std::numeric_limits<std::int32_t>::min();
          break;
        case 5:
          cycle.commands[0].torque_mnm = 12001;
          break;
        case 6:
          cycle.commands.pop_back();
          break;
        case 7:
          cycle.commands[0].velocity_mdeg_s = -360001;
          break;
        case 8:
          cycle.commands[0].torque_mnm = -12001;
          break;
        case 9:
          cycle.commands.push_back(cycle.commands.back());
          break;
        default:
          cycle.emergency_stop = true;
          break;
      }
      const auto& failed = processor.run({cycle}, mode);
      edge::require(failed.safe_stop_frames == 1, "motor error frame counter");
      assert_safe(failed.packets.front());
    }

    auto boundary = valid_cycle();
    boundary.issued_us = boundary.now_us - kMaxAgeUs;
    boundary.commands[0].position_mdeg = -180000;
    boundary.commands[0].velocity_mdeg_s = 360000;
    boundary.commands[0].torque_mnm = -12000;
    edge::require(processor.run({boundary}, mode).safe_stop_frames == 0, "motor inclusive limits");
    edge::require(processor.run({}, mode).packets.empty(), "motor empty replay reset");
  }

  const auto cycles = fixture(4096);
  Processor reference(cycles.size());
  Processor stage1(cycles.size());
  Processor optimized(cycles.size());
  const auto& expected = reference.run(cycles, Mode::baseline);
  same_output(expected, stage1.run(cycles, Mode::stage1));
  same_output(expected, optimized.run(cycles, Mode::optimized));
  same_output(expected, optimized.run(cycles, Mode::optimized));

  Processor bounded(1);
  bool too_many = false;
  try {
    bounded.run(fixture(2), Mode::optimized);
  } catch (const std::invalid_argument&) {
    too_many = true;
  }
  edge::require(too_many, "motor oversized replay rejected");
  auto cycle = valid_cycle();
  cycle.commands.resize(kAxes + 2);
  bool oversize_list = false;
  try {
    bounded.run({cycle}, Mode::optimized);
  } catch (const std::invalid_argument&) {
    oversize_list = true;
  }
  edge::require(oversize_list, "motor oversized command list rejected");
}

}  // namespace motor
