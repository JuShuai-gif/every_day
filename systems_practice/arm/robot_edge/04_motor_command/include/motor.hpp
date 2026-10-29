#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <stdexcept>
#include <utility>
#include <vector>

namespace motor {

constexpr std::size_t kAxes = 12;
constexpr std::size_t kPacketBytes = 17 + kAxes * 14 + 2;
constexpr std::size_t kMaxCycles = 8192;
constexpr std::uint64_t kMaxAgeUs = 5000;

enum class Mode { baseline, stage1, optimized };

enum Status : std::uint8_t { ok = 0, stale = 1, bad_axis = 2, limit = 4, stop = 8, bad_count = 16 };

struct Command {
  std::uint8_t axis = 0;
  std::int32_t position_mdeg = 0;
  std::int32_t velocity_mdeg_s = 0;
  std::int32_t torque_mnm = 0;
  bool enabled = false;
};

struct Cycle {
  std::uint32_t sequence;
  std::uint64_t now_us;
  std::uint64_t issued_us;
  bool emergency_stop;
  std::vector<Command> commands;
};

struct Packet {
  std::array<std::uint8_t, kPacketBytes> bytes{};
};

struct Output {
  std::vector<Packet> packets;
  std::size_t safe_stop_frames = 0;
  std::size_t late_frames = 0;
};

// 自定义演示协议的 CRC：poly=0x1021，init=0xffff，无反射，无末尾异或。
// 它不代表 EtherCAT、CANopen 或任一厂商电机协议。
inline std::uint16_t crc_bitwise(const std::uint8_t* bytes, std::size_t size) {
  std::uint16_t crc = 0xffff;
  for (std::size_t i = 0; i < size; ++i) {
    crc ^= static_cast<std::uint16_t>(bytes[i]) << 8u;
    for (unsigned bit = 0; bit < 8; ++bit) {
      crc = static_cast<std::uint16_t>((crc << 1u) ^ ((crc & 0x8000u) ? 0x1021u : 0u));
    }
  }
  return crc;
}

struct CrcTable {
  std::array<std::uint16_t, 256> entries{};

  CrcTable() {
    for (std::size_t i = 0; i < entries.size(); ++i) {
      std::uint16_t value = static_cast<std::uint16_t>(i << 8u);
      for (unsigned bit = 0; bit < 8; ++bit) {
        value = static_cast<std::uint16_t>((value << 1u) ^ ((value & 0x8000u) ? 0x1021u : 0u));
      }
      entries[i] = value;
    }
  }

  std::uint16_t run(const std::uint8_t* bytes, std::size_t size) const {
    std::uint16_t crc = 0xffff;
    for (std::size_t i = 0; i < size; ++i) {
      const auto index = static_cast<std::uint8_t>((crc >> 8u) ^ bytes[i]);
      crc = static_cast<std::uint16_t>((crc << 8u) ^ entries[index]);
    }
    return crc;
  }
};

template <typename Container>
std::uint8_t validate(const Cycle& cycle, Container& canonical) {
  std::uint8_t status = ok;
  if (cycle.issued_us > cycle.now_us || cycle.now_us - cycle.issued_us > kMaxAgeUs) {
    status |= stale;
  }
  if (cycle.emergency_stop) {
    status |= stop;
  }
  if (cycle.commands.size() != kAxes) {
    status |= bad_count;
  }

  std::uint32_t seen = 0;
  for (const auto& command : cycle.commands) {
    if (command.axis >= kAxes || (seen & (1u << command.axis)) != 0) {
      status |= bad_axis;
      continue;
    }
    seen |= 1u << command.axis;
    if (command.position_mdeg < -180000 || command.position_mdeg > 180000 ||
        command.velocity_mdeg_s < -360000 || command.velocity_mdeg_s > 360000 ||
        command.torque_mnm < -12000 || command.torque_mnm > 12000) {
      status |= limit;
    }
    canonical[command.axis] = command;
  }
  if (seen != (1u << kAxes) - 1u) {
    status |= bad_axis;
  }

  // 任意错误使整个周期变成全轴失能、零设定值。不能发送“部分更新”的命令。
  // 此处只是软件消息语义；硬件急停、认证和总线看门狗需要独立实现。
  if (status != ok) {
    for (std::size_t axis = 0; axis < kAxes; ++axis) {
      canonical[axis] = Command{static_cast<std::uint8_t>(axis), 0, 0, 0, false};
    }
  }
  return status;
}

inline void write_le(std::uint8_t* bytes,
                     std::size_t& offset,
                     std::uint64_t value,
                     unsigned count) {
  for (unsigned i = 0; i < count; ++i) {
    bytes[offset++] = static_cast<std::uint8_t>(value >> (8u * i));
  }
}

template <typename Container>
void serialize(const Cycle& cycle,
               const Container& canonical,
               std::uint8_t status,
               std::uint8_t* bytes,
               const CrcTable* table) {
  std::size_t offset = 0;
  bytes[offset++] = 0xa5;
  bytes[offset++] = 0x5a;
  bytes[offset++] = 1;
  bytes[offset++] = status;
  write_le(bytes, offset, cycle.sequence, 4);
  write_le(bytes, offset, cycle.now_us, 8);
  bytes[offset++] = static_cast<std::uint8_t>(kAxes);

  for (const auto& command : canonical) {
    bytes[offset++] = command.axis;
    write_le(bytes, offset, static_cast<std::uint32_t>(command.position_mdeg), 4);
    write_le(bytes, offset, static_cast<std::uint32_t>(command.velocity_mdeg_s), 4);
    write_le(bytes, offset, static_cast<std::uint32_t>(command.torque_mnm), 4);
    bytes[offset++] = command.enabled ? 1 : 0;
  }
  const auto crc = table ? table->run(bytes, offset) : crc_bitwise(bytes, offset);
  write_le(bytes, offset, crc, 2);
}

class Processor {
 public:
  explicit Processor(std::size_t capacity) : capacity_(capacity) {
    if (capacity > kMaxCycles) {
      throw std::invalid_argument("motor replay exceeds maximum cycle count");
    }
    output_.packets.reserve(capacity);
  }

  [[gnu::noinline]] const Output& run(const std::vector<Cycle>& cycles, Mode mode) {
    if (cycles.size() > capacity_) {
      throw std::invalid_argument("motor replay exceeds configured capacity");
    }
    // 首先检查每周期输入上限，避免攻击性或损坏输入导致无界验证时间。
    for (const auto& cycle : cycles) {
      if (cycle.commands.size() > kAxes + 1) {
        throw std::invalid_argument("motor command list exceeds validation bound");
      }
    }

    output_.packets.clear();
    output_.safe_stop_frames = 0;
    output_.late_frames = 0;
    for (const auto& cycle : cycles) {
      Packet packet;
      std::uint8_t status = ok;
      if (mode == Mode::baseline) {
        // 模拟上层每周期建立消息容器，再复制到传输缓冲的常见写法。
        std::vector<Command> canonical(kAxes);
        std::vector<std::uint8_t> bytes(kPacketBytes);
        status = validate(cycle, canonical);
        serialize(cycle, canonical, status, bytes.data(), nullptr);
        for (std::size_t i = 0; i < bytes.size(); ++i) {
          packet.bytes[i] = bytes[i];
        }
      } else {
        std::array<Command, kAxes> canonical{};
        status = validate(cycle, canonical);
        serialize(cycle,
                  canonical,
                  status,
                  packet.bytes.data(),
                  mode == Mode::optimized ? &table_ : nullptr);
      }
      output_.safe_stop_frames += status != ok;
      output_.late_frames += (status & stale) != 0;
      output_.packets.push_back(packet);
    }
    return output_;
  }

  std::size_t reserved_bytes() const {
    return sizeof(table_) + output_.packets.capacity() * sizeof(Packet);
  }

 private:
  std::size_t capacity_;
  CrcTable table_;
  Output output_;
};

inline std::vector<Cycle> fixture(std::size_t count) {
  std::vector<Cycle> cycles;
  cycles.reserve(count);
  for (std::size_t i = 0; i < count; ++i) {
    Cycle cycle{static_cast<std::uint32_t>(i), 1000000 + i * 1000, 999000 + i * 1000, false, {}};
    cycle.commands.reserve(kAxes);
    for (std::size_t axis = 0; axis < kAxes; ++axis) {
      const auto id = static_cast<std::uint8_t>((axis + i) % kAxes);
      cycle.commands.push_back(Command{id,
                                       static_cast<std::int32_t>(i % 1000) * 100 - 50000,
                                       static_cast<std::int32_t>(axis) * 1000 - 6000,
                                       static_cast<std::int32_t>(i % 2000) - 1000,
                                       true});
    }
    if (i % 101 == 0) {
      cycle.issued_us = cycle.now_us - 6000;
    }
    if (i % 127 == 0) {
      cycle.commands[3].torque_mnm = 12001;
    }
    if (i % 191 == 0) {
      cycle.emergency_stop = true;
    }
    if (i % 251 == 0) {
      cycle.commands[1].axis = cycle.commands[0].axis;
    }
    cycles.push_back(std::move(cycle));
  }
  return cycles;
}

inline std::uint64_t digest(const Output& output) {
  std::uint64_t hash = 1469598103934665603ull;
  hash = (hash ^ output.safe_stop_frames) * 1099511628211ull;
  hash = (hash ^ output.late_frames) * 1099511628211ull;
  for (const auto& packet : output.packets) {
    for (const auto byte : packet.bytes) {
      hash = (hash ^ byte) * 1099511628211ull;
    }
  }
  return hash;
}

}  // namespace motor
