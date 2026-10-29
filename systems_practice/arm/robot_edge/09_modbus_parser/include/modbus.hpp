#pragma once

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstring>
#include <vector>

#include "edge_bench.hpp"

namespace modbus {

using Bytes = std::vector<std::uint8_t>;

struct Response {
  std::uint16_t transaction = 0;
  std::uint8_t unit = 0;
  std::uint8_t exception = 0;
  std::size_t count = 0;
  std::array<std::uint16_t, 125> registers{};
};

inline std::uint16_t big_endian(const std::uint8_t* data) {
  return static_cast<std::uint16_t>((static_cast<unsigned>(data[0]) << 8) | data[1]);
}

// MBAP 的 Length 包含 Unit Identifier 和整个 PDU，不包含前六字节。
// 本项目是 0x03 响应接收器；非法连接直接报错，不猜测下一帧边界。
inline std::size_t frame_size(const std::uint8_t* header) {
  edge::require(big_endian(header + 2) == 0, "nonzero Modbus protocol identifier");
  const auto length = big_endian(header + 4);
  edge::require(length >= 2 && length <= 254, "invalid Modbus MBAP length");
  return 6 + length;
}

inline Response decode(const std::uint8_t* frame, std::size_t size) {
  edge::require(size >= 8 && frame_size(frame) == size, "incomplete Modbus frame");
  Response response;
  response.transaction = big_endian(frame);
  response.unit = frame[6];

  if (frame[7] == 0x83) {
    edge::require(size == 9 && frame[8] != 0, "invalid exception response");
    response.exception = frame[8];
    return response;
  }

  edge::require(frame[7] == 0x03, "unsupported Modbus function");
  edge::require(size >= 11, "missing register response data");
  const auto byte_count = frame[8];
  edge::require(byte_count >= 2 && byte_count <= 250 && byte_count % 2 == 0,
                "invalid register byte count");
  edge::require(size == 9 + static_cast<std::size_t>(byte_count),
                "PDU byte count disagrees with MBAP length");
  response.count = byte_count / 2;
  for (std::size_t i = 0; i < response.count; ++i) {
    response.registers[i] = big_endian(frame + 9 + 2 * i);
  }
  return response;
}

// baseline: 每帧复制出独立 vector，再 erase 已处理的前缀。
// stage1: 保留读取游标，直接解码，每次 feed 结束只整理一次未完成尾部。
class BufferedParser {
 public:
  explicit BufferedParser(bool cursor) : cursor_(cursor) {
    buffer_.reserve(772);
  }

  template <class Consumer>
  void feed(const std::uint8_t* data, std::size_t size, Consumer&& consume) {
    edge::require(size <= 512, "receive chunk exceeds configured 512-byte bound");
    buffer_.insert(buffer_.end(), data, data + size);
    peak_ = std::max(peak_, buffer_.size());
    std::size_t cursor = 0;
    while (buffer_.size() - cursor >= 7) {
      const auto total = frame_size(buffer_.data() + cursor);
      if (buffer_.size() - cursor < total) {
        break;
      }
      if (cursor_) {
        consume(decode(buffer_.data() + cursor, total));
        cursor += total;
      } else {
        Bytes frame(buffer_.begin(), buffer_.begin() + static_cast<std::ptrdiff_t>(total));
        consume(decode(frame.data(), frame.size()));
        buffer_.erase(buffer_.begin(), buffer_.begin() + static_cast<std::ptrdiff_t>(total));
      }
    }
    if (cursor != 0) {
      buffer_.erase(buffer_.begin(), buffer_.begin() + static_cast<std::ptrdiff_t>(cursor));
    }
  }

  void finish() const {
    edge::require(buffer_.empty(), "connection closed with truncated frame");
  }

  std::size_t peak() const {
    return peak_;
  }

 private:
  bool cursor_;
  Bytes buffer_;
  std::size_t peak_ = 0;
};

// optimized: 最多保存一个 260 字节 ADU。完整帧直接在接收块上解码；
// 跨块帧按 Header -> Body 状态积累，不做前缀移动，也不创建逐帧 vector。
class StateParser {
 public:
  template <class Consumer>
  void feed(const std::uint8_t* data, std::size_t size, Consumer&& consume) {
    edge::require(size <= 512, "receive chunk exceeds configured 512-byte bound");
    while (size != 0) {
      if (used_ == 0 && size >= 7) {
        const auto total = frame_size(data);
        if (size >= total) {
          consume(decode(data, total));
          data += total;
          size -= total;
          continue;
        }
      }

      const auto copy_count = std::min(size, wanted_ - used_);
      std::memcpy(frame_.data() + used_, data, copy_count);
      used_ += copy_count;
      data += copy_count;
      size -= copy_count;
      peak_ = std::max(peak_, used_);

      if (used_ == 7 && wanted_ == 7) {
        wanted_ = frame_size(frame_.data());
      }
      if (used_ == wanted_) {
        consume(decode(frame_.data(), used_));
        used_ = 0;
        wanted_ = 7;
      }
    }
  }

  void finish() const {
    edge::require(used_ == 0, "connection closed with truncated frame");
  }

  std::size_t peak() const {
    return peak_;
  }

 private:
  std::array<std::uint8_t, 260> frame_{};
  std::size_t used_ = 0;
  std::size_t wanted_ = 7;
  std::size_t peak_ = 0;
};

struct Dataset {
  Bytes bytes;
  std::vector<Response> expected;
};

inline void append_word(Bytes& bytes, std::uint16_t value) {
  bytes.push_back(static_cast<std::uint8_t>(value >> 8));
  bytes.push_back(static_cast<std::uint8_t>(value));
}

inline Dataset make_dataset(std::size_t frames) {
  Dataset dataset;
  for (std::size_t i = 0; i < frames; ++i) {
    Response expected;
    expected.transaction = static_cast<std::uint16_t>(i);
    expected.unit = 7;
    expected.exception = i % 37 == 0 ? 2 : 0;
    expected.count = expected.exception != 0 ? 0 : 32;

    append_word(dataset.bytes, expected.transaction);
    append_word(dataset.bytes, 0);
    append_word(dataset.bytes, static_cast<std::uint16_t>(expected.exception != 0 ? 3 : 67));
    dataset.bytes.push_back(expected.unit);
    dataset.bytes.push_back(expected.exception != 0 ? 0x83 : 0x03);
    dataset.bytes.push_back(expected.exception != 0 ? expected.exception : 64);
    for (std::size_t j = 0; j < expected.count; ++j) {
      expected.registers[j] = static_cast<std::uint16_t>((i * 31 + j * 17) & 0xffff);
      append_word(dataset.bytes, expected.registers[j]);
    }
    dataset.expected.push_back(expected);
  }
  return dataset;
}

struct Result {
  std::vector<Response> responses;
  std::size_t buffer_peak = 0;
};

template <class Parser>
inline Result replay(Parser& parser,
                     const Bytes& bytes,
                     std::size_t expected_count,
                     const std::vector<std::size_t>& chunks) {
  edge::require(!chunks.empty(), "empty chunk schedule");
  Result result;
  result.responses.reserve(expected_count);
  std::size_t offset = 0;
  std::size_t chunk_index = 0;
  while (offset < bytes.size()) {
    const auto requested = chunks[chunk_index++ % chunks.size()];
    edge::require(requested >= 1 && requested <= 512, "chunk size must be 1..512");
    const auto count = std::min(requested, bytes.size() - offset);
    parser.feed(bytes.data() + offset, count, [&](const Response& response) {
      result.responses.push_back(response);
    });
    offset += count;
  }
  parser.finish();
  result.buffer_peak = parser.peak();
  return result;
}

inline Result run(const Bytes& bytes,
                  int stage,
                  std::size_t expected_count,
                  const std::vector<std::size_t>& chunks = {1, 2, 7, 31, 509, 3, 127}) {
  if (stage == 2) {
    StateParser parser;
    return replay(parser, bytes, expected_count, chunks);
  }
  edge::require(stage == 0 || stage == 1, "invalid parser stage");
  BufferedParser parser(stage == 1);
  return replay(parser, bytes, expected_count, chunks);
}

inline void compare(const std::vector<Response>& actual, const std::vector<Response>& expected) {
  edge::require(actual.size() == expected.size(), "response count differs");
  for (std::size_t i = 0; i < actual.size(); ++i) {
    const auto& a = actual[i];
    const auto& e = expected[i];
    edge::require(a.transaction == e.transaction && a.unit == e.unit &&
                      a.exception == e.exception && a.count == e.count,
                  "response metadata differs");
    for (std::size_t j = 0; j < a.count; ++j) {
      edge::require(a.registers[j] == e.registers[j], "register value differs");
    }
  }
}

inline std::uint64_t checksum(const Result& result) {
  std::uint64_t hash = 1469598103934665603ULL;
  for (const auto& response : result.responses) {
    hash = (hash ^ response.transaction ^ response.unit ^ response.exception) * 1099511628211ULL;
    for (std::size_t i = 0; i < response.count; ++i) {
      hash = (hash ^ response.registers[i]) * 1099511628211ULL;
    }
  }
  return hash;
}

inline void self_test() {
  // 手写 golden：事务 0x1234，单元 1，两个寄存器 42、0x1234。
  const Bytes golden{0x12, 0x34, 0, 0, 0, 7, 1, 3, 4, 0, 42, 0x12, 0x34};
  Response expected;
  expected.transaction = 0x1234;
  expected.unit = 1;
  expected.count = 2;
  expected.registers[0] = 42;
  expected.registers[1] = 0x1234;
  const Bytes exception{0, 8, 0, 0, 0, 3, 1, 0x83, 2};
  Response expected_exception;
  expected_exception.transaction = 8;
  expected_exception.unit = 1;
  expected_exception.exception = 2;
  const auto dataset = make_dataset(2048);

  for (int stage = 0; stage < 3; ++stage) {
    for (std::size_t split = 1; split <= golden.size(); ++split) {
      compare(run(golden, stage, 1, {split, 512}).responses, {expected});
    }
    compare(run(exception, stage, 1, {1}).responses, {expected_exception});
    compare(run({}, stage, 0).responses, {});
    Bytes coalesced = golden;
    coalesced.insert(coalesced.end(), exception.begin(), exception.end());
    coalesced.insert(coalesced.end(), golden.begin(), golden.end());
    compare(run(coalesced, stage, 3, {512}).responses, {expected, expected_exception, expected});

    auto reject = [&](const Bytes& bad) {
      bool rejected = false;
      try {
        (void)run(bad, stage, 1, {1});
      } catch (const std::exception&) {
        rejected = true;
      }
      edge::require(rejected, "malformed or truncated Modbus frame accepted");
    };
    for (std::size_t size = 1; size < golden.size(); ++size) {
      reject(Bytes(golden.begin(), golden.begin() + static_cast<std::ptrdiff_t>(size)));
    }
    for (const auto& mutation : std::vector<std::pair<std::size_t, std::uint8_t>>{
             {2, 1}, {5, 1}, {5, 255}, {7, 4}, {8, 3}, {8, 2}, {8, 0}}) {
      auto invalid = golden;
      invalid[mutation.first] = mutation.second;
      reject(invalid);
    }
    auto invalid_exception = exception;
    invalid_exception[8] = 0;
    reject(invalid_exception);

    const auto result = run(dataset.bytes, stage, dataset.expected.size());
    compare(result.responses, dataset.expected);
    edge::require(result.buffer_peak <= (stage == 2 ? 260 : 772), "parser memory bound exceeded");

    Bytes maximum{0, 1, 0, 0, 0, 253, 1, 3, 250};
    maximum.resize(259, 0xff);
    const auto max_result = run(maximum, stage, 1, {1});
    edge::require(max_result.responses.size() == 1 && max_result.responses[0].count == 125,
                  "maximum register count rejected");
    for (auto value : max_result.responses[0].registers) {
      edge::require(value == 65535, "maximum register decode differs");
    }
  }
}

}  // namespace modbus
