#include <array>
#include <charconv>
#include <cstdint>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <string_view>
#include <system_error>

struct Shape {
  std::uint32_t rows = 1, cols = 1;
  std::size_t bytes = 4;
};
// 严格消费整个视图；候选值避免部分解析或业务越界污染已发布配置。
bool parse(std::string_view s, std::uint32_t& out) {
  if (s.empty()) {
    return false;
  }
  std::uint32_t v = 0;
  const auto r = std::from_chars(s.data(), s.data() + s.size(), v, 10);
  if (r.ec != std::errc{} || r.ptr != s.data() + s.size() || v == 0 || v > 4096) {
    return false;
  }
  out = v;
  return true;
}
bool update(std::string_view rows, std::string_view cols, Shape& live) {
  Shape candidate;
  if (!parse(rows, candidate.rows) || !parse(cols, candidate.cols)) {
    return false;
  }
  const std::size_t a = candidate.rows, b = candidate.cols;
  if (a > std::numeric_limits<std::size_t>::max() / b / sizeof(float)) {
    return false;
  }
  candidate.bytes = a * b * sizeof(float);
  if (candidate.bytes > 4 * 1024 * 1024) {
    return false;
  }
  live = candidate;
  return true;
}
void check(bool b) {
  if (!b) {
    throw std::runtime_error("parse contract");
  }
}
int main() {
  try {
    Shape s;
    for (unsigned n = 1; n <= 4096; ++n) {
      check(update(std::to_string(n), "1", s));
      check(s.bytes == n * 4);
    }
    const auto old = s;
    for (const std::string& v : std::array<std::string, 11>{"",
                                                            "0",
                                                            "-1",
                                                            "+1",
                                                            " 2",
                                                            "2 ",
                                                            "2x",
                                                            "0x10",
                                                            "4294967296",
                                                            "4097",
                                                            std::string("2\0x", 3)}) {
      check(!update(v, "2", s));
      check(s.rows == old.rows && s.bytes == old.bytes);
    }
    check(!update("4096", "4096", s));
    check(s.bytes == old.bytes);
    unsigned v = 77;
    std::string bad = "4294967296";
    auto r = std::from_chars(bad.data(), bad.data() + bad.size(), v);
    check(r.ec == std::errc::result_out_of_range && v == 77);
    std::string partial = "12ms";
    r = std::from_chars(partial.data(), partial.data() + partial.size(), v);
    check(r.ec == std::errc{} && v == 12 && r.ptr == partial.data() + 2);
    std::cout << "PASS 4096 valid, 11 lexical rejects, budget rollback, overflow preserves value, "
                 "partial parse consumes2\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
