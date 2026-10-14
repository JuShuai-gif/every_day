#include <array>
#include <iostream>
#include <iterator>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <utility>
#include <vector>
template <class T>
class Batch {
  std::vector<T> items;

 public:
  template <class It>
  Batch(It first, It last) : items(first, last) {
    if (items.empty()) {
      throw std::invalid_argument("empty inference batch");
    }
  }
  const std::vector<T>& values() const {
    return items;
  }
};
// guide决定类实参，实际构造仍由构造函数执行，返回类型不含迭代器自身。
template <class It>
Batch(It, It) -> Batch<typename std::iterator_traits<It>::value_type>;
template <class T>
struct Packet {
  T value;
  explicit Packet(T v) : value(std::move(v)) {};
};
template <std::size_t N>
Packet(const char (&)[N]) -> Packet<std::string>;
int main() {
  try {
    std::array<int, 3> a{4, 8, 15};
    Batch batch(a.begin(), a.end());
    static_assert(std::is_same_v<decltype(batch), Batch<int>>);
    a[0] = 99;
    if (batch.values()[0] != 4) {
      throw std::runtime_error("not owning");
    }
    std::vector range(a.begin(), a.end());
    std::vector braces{a.begin(), a.end()};
    static_assert(std::is_same_v<decltype(range), std::vector<int>>);
    static_assert(std::is_same_v<decltype(braces), std::vector<int*>>);
    if (range.size() != 3 || braces.size() != 2) {
      throw std::runtime_error("overload mismatch");
    }
    // braces是两个指针的容器，绝不解引用end()来制造UB。
    Packet label("camera-left");
    static_assert(std::is_same_v<decltype(label), Packet<std::string>>);
    bool rejected = false;
    try {
      Batch empty(a.end(), a.end());
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    if (!rejected) {
      throw std::runtime_error("empty accepted");
    }
#ifdef NEGATIVE
    Batch bad(1, 2);  // 整数没有iterator_traits::value_type，必须编译失败。
#endif
    std::cout << "PASS CTAD owning range=3; braces pointer count=2; string owner; empty rejected\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
