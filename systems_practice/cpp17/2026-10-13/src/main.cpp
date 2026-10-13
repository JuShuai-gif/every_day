#include <iostream>
#include <stdexcept>
#include <utility>
#include <vector>
void require(bool x) {
  if (!x) {
    throw std::runtime_error("oracle mismatch");
  }
}
template <class... F>
void ordered(F&&... f) {
  // 强制内建逗号，保证逐个调用；参数表达式本身在进入函数前已求值。
  (static_cast<void>(std::forward<F>(f)()), ...);
}
template <class... F>
bool validate(F&&... f) {
  return (true && ... && static_cast<bool>(std::forward<F>(f)()));
}
template <class... F>
void transaction(std::vector<int>& live, F&&... f) {
  auto candidate = live;  // 修改只落在候选；异常时vector自动释放。
  ordered([&] {
    std::forward<F>(f)(candidate);
  }...);
  live.swap(candidate);
}
int main() {
  try {
    std::vector<int> log;
    ordered(
        [&] {
          log.push_back(1);
        },
        [&] {
          log.push_back(2);
        },
        [&] {
          log.push_back(3);
        });
    require(log == std::vector<int>({1, 2, 3}));
    ordered();
    require(validate());
    int calls = 0;
    require(!validate(
        [&] {
          ++calls;
          return true;
        },
        [&] {
          ++calls;
          return false;
        },
        [&] {
          ++calls;
          return true;
        }));
    require(calls == 2);
    std::vector<int> live{7};
    for (int i = 0; i < 1000; ++i) {
      bool failed = false;
      try {
        transaction(
            live,
            [](auto& v) {
              v.push_back(8);
            },
            [](auto&) {
              throw std::runtime_error("injected");
            },
            [](auto& v) {
              v.push_back(9);
            });
      } catch (const std::runtime_error&) {
        failed = true;
      }
      require(failed && live == std::vector<int>({7}));
    }
    transaction(
        live,
        [](auto& v) {
          v.push_back(8);
        },
        [](auto& v) {
          v.push_back(9);
        });
    require(live == std::vector<int>({7, 8, 9}));
    transaction(live);
    // 安全反例：有序执行并不提供回滚；异常前的外部副作用依然存在。
    log.clear();
    try {
      ordered(
          [&] {
            log.push_back(1);
          },
          [] {
            throw std::runtime_error("stop");
          },
          [&] {
            log.push_back(3);
          });
    } catch (const std::runtime_error&) {
    }
    require(log == std::vector<int>({1}));
    std::cout
        << "PASS ordered=123 empty=ok short_circuit_calls=2 rollback=1000 exception_prefix=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
