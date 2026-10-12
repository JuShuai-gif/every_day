#include <cstdint>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <vector>

template <class>
inline constexpr bool unsupported = false;
// 工业请求字段编码：运行时内容仍需验证，if constexpr只选择合法类型分支。
template <class T>
void append(std::vector<std::uint8_t>& out, const T& value) {
  std::vector<std::uint8_t> candidate;
  if constexpr (std::is_integral_v<T> && !std::is_same_v<T, bool>) {
    using U = std::make_unsigned_t<T>;
    const U bits = static_cast<U>(value);
    for (std::size_t i = 0; i < sizeof(T); ++i) {
      candidate.push_back(static_cast<std::uint8_t>(bits >> (8 * i)));
    }
  } else if constexpr (std::is_same_v<T, std::string>) {
    if (value.size() > 255) {
      throw std::length_error("field exceeds u8 length");
    }
    candidate.push_back(static_cast<std::uint8_t>(value.size()));
    candidate.insert(candidate.end(), value.begin(), value.end());
  } else {
    static_assert(unsupported<T>, "unsupported wire field type");
  }
  // u8插入不抛元素构造异常；分配失败仍保留原vector，候选保证验证失败不写入。
  out.insert(out.end(), candidate.begin(), candidate.end());
}
#if defined(FAIL_ORDINARY_IF)
template <class T>
int wrong(const T& x) {
  if (std::is_integral_v<T>) {
    return int(x);
  } else {
    return int(x.size());
  }
}
#endif
int main() {
  try {
    std::vector<std::uint8_t> bytes;
    append(bytes, std::uint16_t{0x1234});
    append(bytes, std::string("RK"));
    append(bytes, std::int16_t{-1});
    append(bytes, std::string{});
    const std::vector<std::uint8_t> oracle{0x34, 0x12, 2, 'R', 'K', 255, 255, 0};
    if (bytes != oracle) {
      throw std::runtime_error("wire bytes mismatch");
    }
    const auto before = bytes;
    bool rejected = false;
    try {
      append(bytes, std::string(256, 'x'));
    } catch (const std::length_error&) {
      rejected = true;
    }
    if (!rejected || bytes != before) {
      throw std::runtime_error("transaction failure");
    }
    append(bytes, std::string(255, 'x'));
    if (bytes.size() != before.size() + 256) {
      throw std::runtime_error("max field");
    }
#if defined(FAIL_UNSUPPORTED)
    append(bytes, 1.25);  // 构建脚本期望此分支编译失败，不执行未定义行为。
#endif
#if defined(FAIL_ORDINARY_IF)
    return wrong(3);
#endif
    std::cout << "PASS wire_oracle=8B empty=1 max255=1 reject256_rollback=1\n"
              << "C++17 type dispatch; no performance claim\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
