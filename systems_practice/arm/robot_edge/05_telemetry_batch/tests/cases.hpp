#pragma once

#include "../src/pipeline.hpp"
#include "edge_bench.hpp"

namespace telemetry {

inline void self_test() {
  const std::array<std::uint8_t, 9> check{'1', '2', '3', '4', '5', '6', '7', '8', '9'};
  edge::require(crc16(check.data(), check.size()) == 0x4b37, "CRC16 known check value");

  std::array<std::uint8_t, kFrameBytes> encoded{};
  encode({0x01020304, 0x0807060504030201ULL, 0x1234, -2}, encoded.data());
  const std::array<std::uint8_t, 22> known_prefix{
      0xa5, 0x5a, 1, 0, 4, 3, 2, 1, 1, 2, 3, 4, 5, 6, 7, 8, 0x34, 0x12, 0xfe, 0xff, 0xff, 0xff};
  edge::require(std::equal(known_prefix.begin(), known_prefix.end(), encoded.begin()),
                "known frame layout, endianness and signed value bytes");

  for (const auto count : {0U, 1U, 13U, 64U, 65U, 257U}) {
    auto events = make_events(count);
    if (!events.empty()) {
      events.front().value = std::numeric_limits<std::int32_t>::min();
      events.back().value = std::numeric_limits<std::int32_t>::max();
    }
    Sink reference(true);
    run(events, Mode::Allocated, reference);

    for (const auto mode : {Mode::Fixed, Mode::Batched}) {
      Sink candidate(true);
      const auto stats = run(events, mode, candidate);
      edge::require(candidate.captured() == reference.captured(), "all wire bytes equivalent");
      edge::require(decode(candidate.captured()) == events, "decoded events preserve values/order");
      edge::require(stats.max_wait_us <= kMaxAgeUs, "bounded modeled batch dwell");
      edge::require(candidate.bytes() == events.size() * kFrameBytes, "no loss/duplication");
    }
  }

  Sink burst(true);
  auto events = make_events(130);
  for (auto& event : events) {
    event.time_us = 10;
  }
  edge::require(run(events, Mode::Batched, burst).flushes == 3, "capacity flush and tail");
  edge::require(burst.blocked() > 0 && decode(burst.captured()) == events,
                "partial writes and retry preserve complete stream");

  events = make_events(2);
  events[1].time_us = 100000;
  edge::require(run(events, Mode::Batched, burst).max_wait_us == 500, "idle timer flush");

  auto damaged = burst.captured();
  damaged[18] ^= 1;
  bool rejected = false;
  try {
    (void)decode(damaged);
  } catch (const std::invalid_argument&) {
    rejected = true;
  }
  edge::require(rejected, "CRC rejects corruption");
  damaged.pop_back();
  rejected = false;
  try {
    (void)decode(damaged);
  } catch (const std::invalid_argument&) {
    rejected = true;
  }
  edge::require(rejected, "truncation rejected");

  events[0].time_us = 100001;
  rejected = false;
  try {
    (void)run(events, Mode::Batched, burst);
  } catch (const std::invalid_argument&) {
    rejected = true;
  }
  edge::require(rejected, "out-of-order timestamps rejected");
}

}  // namespace telemetry
