#pragma once

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>

namespace telemetry {

constexpr std::size_t kFrameBytes = 24;
constexpr std::size_t kBatchFrames = 64;
constexpr std::uint64_t kMaxAgeUs = 500;

struct Event {
  std::uint32_t sequence;
  std::uint64_t time_us;
  std::uint16_t sensor;
  std::int32_t value;
};

inline bool operator==(const Event& a, const Event& b) {
  return a.sequence == b.sequence && a.time_us == b.time_us && a.sensor == b.sensor &&
         a.value == b.value;
}

// 教学帧协议的小端布局：magic[2], version[1], flags[1], sequence[4],
// time[8], sensor[2], value[4], CRC[2]。不冒充设备厂商既有协议。
inline std::uint16_t crc16(const std::uint8_t* data, std::size_t bytes) {
  std::uint16_t crc = 0xffff;
  for (std::size_t i = 0; i < bytes; ++i) {
    crc ^= data[i];
    for (int bit = 0; bit < 8; ++bit) {
      crc = static_cast<std::uint16_t>((crc >> 1) ^ ((crc & 1) ? 0xa001 : 0));
    }
  }
  return crc;
}

inline void put(std::uint8_t* out, std::uint64_t value, std::size_t bytes) {
  for (std::size_t i = 0; i < bytes; ++i) {
    out[i] = static_cast<std::uint8_t>(value >> (8 * i));
  }
}

inline std::uint64_t get(const std::uint8_t* in, std::size_t bytes) {
  std::uint64_t value = 0;
  for (std::size_t i = 0; i < bytes; ++i) {
    value |= static_cast<std::uint64_t>(in[i]) << (8 * i);
  }
  return value;
}

inline void encode(const Event& event, std::uint8_t* out) {
  out[0] = 0xa5;
  out[1] = 0x5a;
  out[2] = 1;
  out[3] = 0;
  put(out + 4, event.sequence, 4);
  put(out + 8, event.time_us, 8);
  put(out + 16, event.sensor, 2);
  put(out + 18, static_cast<std::uint32_t>(event.value), 4);
  put(out + 22, crc16(out, 22), 2);
}

inline std::vector<Event> decode(const std::vector<std::uint8_t>& bytes) {
  if (bytes.size() % kFrameBytes != 0) {
    throw std::invalid_argument("truncated telemetry frame");
  }
  std::vector<Event> result;
  result.reserve(bytes.size() / kFrameBytes);
  for (std::size_t offset = 0; offset < bytes.size(); offset += kFrameBytes) {
    const auto* frame = bytes.data() + offset;
    if (frame[0] != 0xa5 || frame[1] != 0x5a || frame[2] != 1 || frame[3] != 0 ||
        get(frame + 22, 2) != crc16(frame, 22)) {
      throw std::invalid_argument("invalid telemetry header or CRC");
    }
    const auto raw_value = get(frame + 18, 4);
    const auto signed_value = raw_value <= 0x7fffffffULL
                                  ? static_cast<std::int64_t>(raw_value)
                                  : static_cast<std::int64_t>(raw_value) - 0x100000000LL;
    result.push_back({static_cast<std::uint32_t>(get(frame + 4, 4)),
                      get(frame + 8, 8),
                      static_cast<std::uint16_t>(get(frame + 16, 2)),
                      static_cast<std::int32_t>(signed_value)});
  }
  return result;
}

// 每 7 次调用拒绝一次，其余最多接受 173 字节；确定性地覆盖短写和背压。
// 生产接入必须用 poll/epoll 等待可写，本模型不模拟真实网络耗时。
class Sink {
 public:
  explicit Sink(bool capture = false) : capture_(capture) {
  }

  void reset() {
    calls_ = 0;
    blocked_ = 0;
    bytes_ = 0;
    digest_ = 14695981039346656037ULL;
    captured_.clear();
  }

  std::size_t write_some(const std::uint8_t* data, std::size_t size) {
    ++calls_;
    if (calls_ % 7 == 0) {
      ++blocked_;
      return 0;
    }
    const auto accepted = std::min<std::size_t>(size, 173);
    for (std::size_t i = 0; i < accepted; ++i) {
      digest_ = (digest_ ^ data[i]) * 1099511628211ULL;
    }
    if (capture_) {
      captured_.insert(captured_.end(), data, data + accepted);
    }
    bytes_ += accepted;
    return accepted;
  }

  std::uint64_t digest() const {
    return digest_;
  }

  std::size_t calls() const {
    return calls_;
  }

  std::size_t blocked() const {
    return blocked_;
  }

  std::size_t bytes() const {
    return bytes_;
  }

  const std::vector<std::uint8_t>& captured() const {
    return captured_;
  }

 private:
  bool capture_;
  std::size_t calls_ = 0;
  std::size_t blocked_ = 0;
  std::size_t bytes_ = 0;
  std::uint64_t digest_ = 14695981039346656037ULL;
  std::vector<std::uint8_t> captured_;
};

inline void drain(Sink& sink, const std::uint8_t* bytes, std::size_t count) {
  std::size_t sent = 0;
  unsigned consecutive_blocked = 0;
  while (sent < count) {
    const auto accepted = sink.write_some(bytes + sent, count - sent);
    if (accepted == 0) {
      if (++consecutive_blocked > 16) {
        throw std::runtime_error("transport stalled");
      }
    } else {
      consecutive_blocked = 0;
      sent += accepted;
    }
  }
}

enum class Mode { Allocated, Fixed, Batched };

struct Stats {
  std::uint64_t digest = 0;
  std::uint64_t max_wait_us = 0;
  std::size_t flushes = 0;
};

inline Stats run(const std::vector<Event>& events, Mode mode, Sink& sink) {
  for (std::size_t i = 1; i < events.size(); ++i) {
    if (events[i].time_us < events[i - 1].time_us) {
      throw std::invalid_argument("timestamps must be monotonic");
    }
  }
  sink.reset();
  Stats stats;
  std::array<std::uint8_t, kFrameBytes * kBatchFrames> batch{};
  std::size_t pending = 0;
  std::uint64_t oldest = 0;

  const auto flush = [&](std::uint64_t now) {
    if (pending == 0) {
      return;
    }
    stats.max_wait_us = std::max(stats.max_wait_us, now - oldest);
    drain(sink, batch.data(), pending * kFrameBytes);
    ++stats.flushes;
    pending = 0;
  };

  for (const auto& event : events) {
    if (mode == Mode::Allocated) {
      std::vector<std::uint8_t> frame(kFrameBytes);
      encode(event, frame.data());
      drain(sink, frame.data(), frame.size());
      ++stats.flushes;
    } else if (mode == Mode::Fixed) {
      encode(event, batch.data());
      drain(sink, batch.data(), kFrameBytes);
      ++stats.flushes;
    } else {
      // 虚拟时钟在 oldest + 500 us 产生 timer 事件，即使下个输入到达很晚也先 flush。
      if (pending != 0 && event.time_us - oldest >= kMaxAgeUs) {
        flush(oldest + kMaxAgeUs);
      }
      if (pending == 0) {
        oldest = event.time_us;
      }
      encode(event, batch.data() + pending * kFrameBytes);
      if (++pending == kBatchFrames) {
        flush(event.time_us);
      }
    }
  }
  if (!events.empty()) {
    flush(events.back().time_us);
  }
  stats.digest = sink.digest();
  return stats;
}

inline std::vector<Event> make_events(std::size_t count) {
  std::vector<Event> events;
  events.reserve(count);
  for (std::size_t i = 0; i < count; ++i) {
    events.push_back({static_cast<std::uint32_t>(i),
                      i * 40,
                      static_cast<std::uint16_t>(i % 32),
                      static_cast<std::int32_t>(i % 20001) - 10000});
  }
  return events;
}

}  // namespace telemetry
