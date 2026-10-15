#include <functional>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <tuple>
#include <type_traits>
#include <utility>
struct Session {
  int total = 0;
  int submit(std::unique_ptr<int> value, int limit) {
    if (!value || *value < 0 || *value > limit) {
      throw std::invalid_argument("request rejected");
    }
    total += *value;
    return total;
  }
};
void require(bool v) {
  if (!v) {
    throw std::runtime_error("check failed");
  }
}
int main() {
  try {
    Session s;
    // 拥有型tuple负责请求寿命；ref只借用同步调用范围内的Session。
    auto request = std::make_tuple(std::ref(s), std::make_unique<int>(7), 10);
    int out = std::apply(&Session::submit, std::move(request));
    require(out == 7 && !std::get<1>(request) && s.total == 7);
    static_assert(std::is_same_v<decltype(std::invoke(&Session::total, s)), int&>);
    std::invoke(&Session::total, s) = 9;
    require(s.total == 9);
    // tuple复制值与显式借用是两种合同，安全对照不触发悬空访问。
    int x = 3;
    auto owned = std::make_tuple(x);
    auto borrowed = std::tie(x);
    x = 8;
    require(std::get<0>(owned) == 3 && std::get<0>(borrowed) == 8);
    require(std::apply(
                [] {
                  return 42;
                },
                std::tuple<>{}) == 42);
    int rejected = 0;
    for (int v : {-1, 11}) {
      auto args = std::make_tuple(std::ref(s), std::make_unique<int>(v), 10);
      try {
        std::apply(&Session::submit, std::move(args));
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
      require(s.total == 9 && !std::get<1>(args));
    }
    require(rejected == 2);
    static_assert(
        !std::is_invocable_v<decltype(&Session::submit), Session&, std::unique_ptr<int>&, int>);
    std::cout << "PASS invoke member/data; apply empty/move-only; owned=3 borrowed=8; rejected=2 "
                 "total=9\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
