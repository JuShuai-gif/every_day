#pragma once

#include <sys/stat.h>
#include <unistd.h>

#include <algorithm>
#include <array>
#include <cerrno>
#include <charconv>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <limits>
#include <locale>
#include <sstream>
#include <string>
#include <system_error>
#include <vector>

#include "edge_bench.hpp"

namespace event_log {

enum class Level { info, warning, error };

struct Event {
  std::uint64_t timestamp_us;
  std::uint64_t sequence;
  Level level;
  std::uint32_t code;
  std::int64_t value;
};

inline const char* level_name(Level level) {
  switch (level) {
    case Level::info:
      return "INFO";
    case Level::warning:
      return "WARN";
    case Level::error:
      return "ERROR";
  }
  throw std::runtime_error("invalid event level");
}

// 临时文件在创建后立即 unlink，进程异常退出也不会遗留数据文件。
// 写入仍是普通文件系统 write；没有 fsync，因此测量 page-cache 接收而非断电持久性。
class FileSink {
 public:
  FileSink() {
    auto pattern = (std::filesystem::temp_directory_path() / "robot-edge-log-XXXXXX").string();
    std::vector<char> path(pattern.begin(), pattern.end());
    path.push_back('\0');
    fd_ = ::mkstemp(path.data());
    if (fd_ == -1) {
      throw std::system_error(errno, std::generic_category(), "mkstemp");
    }
    if (::unlink(path.data()) != 0) {
      const int error = errno;
      ::close(fd_);
      fd_ = -1;
      throw std::system_error(error, std::generic_category(), "unlink temporary log");
    }
  }

  ~FileSink() {
    if (fd_ != -1) {
      ::close(fd_);
    }
  }

  FileSink(const FileSink&) = delete;
  FileSink& operator=(const FileSink&) = delete;

  void reset() {
    if (::ftruncate(fd_, 0) != 0 || ::lseek(fd_, 0, SEEK_SET) == -1) {
      throw std::system_error(errno, std::generic_category(), "reset log file");
    }
  }

  ssize_t write_some(const char* data, std::size_t count) {
    return ::write(fd_, data, count);
  }

  std::string read_back() const {
    struct stat status{};
    if (::fstat(fd_, &status) != 0) {
      throw std::system_error(errno, std::generic_category(), "fstat log");
    }
    std::string output(static_cast<std::size_t>(status.st_size), '\0');
    std::size_t offset = 0;
    while (offset < output.size()) {
      const auto received =
          ::pread(fd_, output.data() + offset, output.size() - offset, static_cast<off_t>(offset));
      if (received < 0 && errno == EINTR) {
        continue;
      }
      if (received <= 0) {
        throw std::runtime_error("log readback failed or ended early");
      }
      offset += static_cast<std::size_t>(received);
    }
    return output;
  }

 private:
  int fd_ = -1;
};

struct Stats {
  std::uint64_t hash = 1469598103934665603ULL;
  std::size_t bytes = 0;
  std::size_t events = 0;
  std::size_t write_calls = 0;
  std::size_t buffer_peak = 0;
};

template <class Sink>
inline void write_all(Sink& sink, const char* data, std::size_t size, Stats& stats) {
  while (size != 0) {
    ++stats.write_calls;
    const auto written = sink.write_some(data, size);
    if (written < 0 && errno == EINTR) {
      continue;
    }
    if (written < 0) {
      throw std::system_error(errno, std::generic_category(), "write event log");
    }
    edge::require(written > 0 && static_cast<std::size_t>(written) <= size,
                  "log sink made no valid progress");
    data += written;
    size -= static_cast<std::size_t>(written);
  }
}

template <class Sink>
class Writer {
 public:
  Writer(Sink& sink, bool buffered, std::size_t capacity)
      : sink_(sink), buffered_(buffered), capacity_(capacity) {
    edge::require(capacity >= 1 && capacity <= buffer_.size(),
                  "log buffer capacity must be 1..65536");
  }

  void append(const char* data, std::size_t size) {
    ++stats_.events;
    stats_.bytes += size;
    for (std::size_t i = 0; i < size; ++i) {
      stats_.hash = (stats_.hash ^ static_cast<unsigned char>(data[i])) * 1099511628211ULL;
    }
    if (!buffered_) {
      write_all(sink_, data, size, stats_);
      return;
    }

    while (size != 0) {
      const auto count = std::min(size, capacity_ - used_);
      std::memcpy(buffer_.data() + used_, data, count);
      used_ += count;
      data += count;
      size -= count;
      stats_.buffer_peak = std::max(stats_.buffer_peak, used_);
      if (used_ == capacity_) {
        flush();
      }
    }
  }

  Stats finish() {
    flush();  // 显式 finish 传播错误；析构函数不能替业务吞掉 flush 失败。
    return stats_;
  }

 private:
  void flush() {
    if (used_ != 0) {
      write_all(sink_, buffer_.data(), used_, stats_);
      used_ = 0;
    }
  }

  Sink& sink_;
  bool buffered_;
  std::size_t capacity_;
  std::array<char, 65536> buffer_{};
  std::size_t used_ = 0;
  Stats stats_;
};

inline std::string stream_format(const Event& event) {
  std::ostringstream output;
  output.imbue(std::locale::classic());
  output << event.timestamp_us << ',' << event.sequence << ',' << level_name(event.level) << ','
         << event.code << ',' << event.value << '\n';
  return output.str();
}

// 最长一条记录小于 100 字节；明确检查边界，不使用可能截断的 sprintf。
class Line {
 public:
  template <class Integer>
  void number(Integer value) {
    const auto result = std::to_chars(bytes_.data() + used_, bytes_.data() + bytes_.size(), value);
    edge::require(result.ec == std::errc{}, "event line numeric overflow");
    used_ = static_cast<std::size_t>(result.ptr - bytes_.data());
  }

  void literal(const char* text) {
    const auto length = std::strlen(text);
    edge::require(length <= bytes_.size() - used_, "event line buffer overflow");
    std::memcpy(bytes_.data() + used_, text, length);
    used_ += length;
  }

  const char* data() const {
    return bytes_.data();
  }

  std::size_t size() const {
    return used_;
  }

 private:
  std::array<char, 128> bytes_{};
  std::size_t used_ = 0;
};

inline Line fixed_format(const Event& event) {
  Line line;
  line.number(event.timestamp_us);
  line.literal(",");
  line.number(event.sequence);
  line.literal(",");
  line.literal(level_name(event.level));
  line.literal(",");
  line.number(event.code);
  line.literal(",");
  line.number(event.value);
  line.literal("\n");
  return line;
}

template <class Sink>
inline Stats run(Sink& sink,
                 const std::vector<Event>& events,
                 int stage,
                 std::size_t buffer_capacity = 65536) {
  edge::require(stage >= 0 && stage <= 2, "invalid event log stage");
  sink.reset();
  Writer<Sink> writer(sink, stage != 0, buffer_capacity);
  for (const auto& event : events) {
    if (stage == 2) {
      const auto line = fixed_format(event);
      writer.append(line.data(), line.size());
    } else {
      const auto line = stream_format(event);
      writer.append(line.data(), line.size());
    }
  }
  return writer.finish();
}

inline std::vector<Event> make_events(std::size_t count) {
  std::vector<Event> events;
  events.reserve(count);
  for (std::size_t i = 0; i < count; ++i) {
    events.push_back({1'000'000 + 250 * i,
                      i,
                      static_cast<Level>(i % 3),
                      static_cast<std::uint32_t>(100 + i % 19),
                      static_cast<std::int64_t>(i % 2001) - 1000});
  }
  return events;
}

inline std::string reference(const std::vector<Event>& events) {
  std::string output;
  for (const auto& event : events) {
    output += std::to_string(event.timestamp_us) + "," + std::to_string(event.sequence) + ",";
    // 参考路径显式枚举标签，不复用被测格式器。
    output += event.level == Level::info      ? "INFO"
              : event.level == Level::warning ? "WARN"
                                              : "ERROR";
    output += "," + std::to_string(event.code) + "," + std::to_string(event.value) + "\n";
  }
  return output;
}

struct FaultSink {
  std::string bytes;
  std::size_t max_write = 3;
  bool interrupt_once = true;
  bool fail = false;
  bool no_progress = false;

  void reset() {
    bytes.clear();
  }

  ssize_t write_some(const char* data, std::size_t size) {
    if (interrupt_once) {
      interrupt_once = false;
      errno = EINTR;
      return -1;
    }
    if (fail) {
      errno = ENOSPC;
      return -1;
    }
    if (no_progress) {
      return 0;
    }
    const auto count = std::min(size, max_write);
    bytes.append(data, count);
    return static_cast<ssize_t>(count);
  }
};

inline void self_test() {
  const std::vector<Event> known{{0, 0, Level::info, 7, -5}, {12, 1, Level::error, 42, 9}};
  const std::string golden = "0,0,INFO,7,-5\n12,1,ERROR,42,9\n";
  auto extremes = known;
  extremes.push_back({std::numeric_limits<std::uint64_t>::max(),
                      std::numeric_limits<std::uint64_t>::max(),
                      Level::warning,
                      std::numeric_limits<std::uint32_t>::max(),
                      std::numeric_limits<std::int64_t>::min()});
  extremes.push_back({0, 0, Level::info, 0, std::numeric_limits<std::int64_t>::max()});

  for (int stage = 0; stage < 3; ++stage) {
    FileSink sink;
    const auto small = run(sink, known, stage, 7);
    edge::require(sink.read_back() == golden, "golden log content differs");
    edge::require(small.events == 2 && small.bytes == golden.size(), "log counters differ");

    for (const auto& events : std::vector<std::vector<Event>>{{}, extremes, make_events(4096)}) {
      const auto stats = run(sink, events, stage);
      const auto expected = reference(events);
      edge::require(sink.read_back() == expected, "full file bytes differ");
      edge::require(stats.bytes == expected.size() && stats.events == events.size(),
                    "file byte or event count differs");
      edge::require(stats.buffer_peak <= 65536, "log buffer exceeded bound");
      if (stage != 0) {
        edge::require(stats.write_calls == (stats.bytes + 65535) / 65536,
                      "buffer flush accounting differs");
      }
    }

    FaultSink short_writes;
    (void)run(short_writes, known, stage, 7);
    edge::require(short_writes.bytes == golden, "short write or EINTR lost bytes");

    // 小缓冲覆盖中途写失败；大缓冲使失败发生在 finish() 的最终 flush。
    for (std::size_t capacity : {std::size_t{7}, std::size_t{65536}}) {
      for (bool no_progress : {false, true}) {
        FaultSink failing;
        failing.interrupt_once = false;
        failing.fail = !no_progress;
        failing.no_progress = no_progress;
        bool rejected = false;
        try {
          (void)run(failing, known, stage, capacity);
        } catch (const std::exception&) {
          rejected = true;
        }
        edge::require(rejected, "write failure was silently ignored");
      }
    }
  }
}

}  // namespace event_log
