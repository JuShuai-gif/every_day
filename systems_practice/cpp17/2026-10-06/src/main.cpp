#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <variant>
#include <vector>
void check(bool x) {
  if (!x) {
    throw std::runtime_error("contract");
  }
}
struct Idle {};
struct Ready {
  std::unique_ptr<std::vector<float>> input;
};
struct Failed {
  std::string message;
};
using State = std::variant<Idle, Ready, Failed>;
static_assert(std::is_nothrow_move_assignable_v<State>);
struct Describe {
  std::string operator()(const Idle&) const {
    return "idle";
  }
  std::string operator()(const Ready& s) const {
    return "ready:" + std::to_string(s.input->size());
  }
  std::string operator()(const Failed& s) const {
    return "failed:" + s.message;
  }
};
void prepare(State& state, size_t n, bool inject = false) {
  if (n == 0 || n > 1024) {
    throw std::invalid_argument("shape");
  }
  if (inject) {
    throw std::bad_alloc();
  }
  auto candidate = std::make_unique<std::vector<float>>(n, 1.f);
  // 候选构造后无抛出提交；不会先销毁旧请求再分配。
  state = Ready{std::move(candidate)};
}
struct Bomb {
  Bomb() = default;
  Bomb(const Bomb&) = delete;
  Bomb(Bomb&&) {
    throw std::runtime_error("move failure");
  }
  Bomb& operator=(Bomb&&) {
    throw std::runtime_error("move assignment failure");
  }
};
int main() {
  try {
    State s = Idle{};
    check(std::visit(Describe{}, s) == "idle");
    for (int i = 0; i < 1000; ++i) {
      prepare(s, 17);
      auto* before = std::get<Ready>(s).input.get();
      bool failed = false;
      try {
        prepare(s, 33, true);
      } catch (const std::bad_alloc&) {
        failed = true;
      }
      check(failed && std::get<Ready>(s).input.get() == before);
      check(std::visit(Describe{}, s) == "ready:17");
    }
    bool bad_shape = false;
    try {
      prepare(s, 0);
    } catch (const std::invalid_argument&) {
      bad_shape = true;
    }
    check(bad_shape);
    check(std::get_if<Failed>(&s) == nullptr);
    bool bad_get = false;
    try {
      (void)std::get<Failed>(s);
    } catch (const std::bad_variant_access&) {
      bad_get = true;
    }
    check(bad_get);
    // 类型改变的抛出move构造给出标准规定的valueless路径。
    std::variant<int, Bomb> dst(1), src(std::in_place_index<1>);
    bool thrown = false;
    try {
      dst = std::move(src);
    } catch (const std::runtime_error&) {
      thrown = true;
    }
    check(thrown && dst.valueless_by_exception());
    bool visit_failed = false;
    try {
      std::visit(
          [](const auto&) {
            return 0;
          },
          dst);
    } catch (const std::bad_variant_access&) {
      visit_failed = true;
    }
    check(visit_failed);
    dst = 7;
    check(std::get<int>(dst) == 7);
    s = Failed{"device unavailable"};
    check(std::visit(Describe{}, s) == "failed:device unavailable");
    std::cout << "PASS transactions=1000 shape_reject=1 bad_get=1 valueless=1 visit_reject=1 "
                 "recovery=1\n";
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << "\n";
    return 1;
  }
}
