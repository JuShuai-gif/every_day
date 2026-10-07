#include <any>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
void check(bool x, const char* s) {
  if (!x) {
    throw std::runtime_error(s);
  }
}
struct Payload {
  static int alive;
  static bool fail;
  std::vector<int> values;
  explicit Payload(int n) : values(n, 7) {
    if (fail) {
      throw std::runtime_error("construct");
    }
    ++alive;
  }
  Payload(const Payload& other) : values(other.values) {
    if (fail) {
      throw std::runtime_error("copy");
    }
    ++alive;
  }
  Payload(Payload&& other) noexcept : values(std::move(other.values)) {
    ++alive;
  }
  ~Payload() {
    --alive;
  }
};
int Payload::alive = 0;
bool Payload::fail = false;
int main() {
  try {
    std::any empty;
    check(!empty.has_value() && std::any_cast<int>(&empty) == nullptr, "empty");
    std::any config = 32;
    check(std::any_cast<long>(&config) == nullptr, "no numeric conversion");
    bool bad = false;
    try {
      (void)std::any_cast<std::string>(config);
    } catch (const std::bad_any_cast&) {
      bad = true;
    }
    check(bad, "value cast throws");
    int* borrowed = std::any_cast<int>(&config);
    check(borrowed && *borrowed == 32, "borrow");
    // reset/赋值后旧borrowed失效，之后不解引用它。
    config.reset();
    borrowed = nullptr;
    for (int i = 0; i < 1000; ++i) {
      std::any active = std::string("old");
      {
        Payload source(128);
        Payload::fail = true;
        bool failed = false;
        try {
          active = source;
        } catch (const std::runtime_error&) {
          failed = true;
        }
        Payload::fail = false;
        check(failed && std::any_cast<const std::string&>(active) == "old",
              "assignment strong guarantee");
        std::any candidate = source;
        active.swap(candidate);
        check(std::any_cast<const Payload&>(active).values.size() == 128, "candidate commit");
        Payload::fail = true;
        failed = false;
        try {
          active.emplace<Payload>(1);
        } catch (const std::runtime_error&) {
          failed = true;
        }
        Payload::fail = false;
        check(failed && !active.has_value(), "emplace failure empties any");
      }
      check(Payload::alive == 0, "all payload owners released");
    }
    std::cout << "PASS iterations=1000 exact_type=1 bad_any_cast=1 assignment_rollback=1 "
                 "emplace_empty=1 alive="
              << Payload::alive << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
