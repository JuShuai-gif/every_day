#include <array>
#include <cstddef>
#include <iostream>
#include <memory_resource>
#include <stdexcept>
#include <vector>

void check(bool value, const char* message) {
  if (!value) {
    throw std::runtime_error(message);
  }
}
class Counting final : public std::pmr::memory_resource {
 public:
  std::size_t live = 0, calls = 0, peak = 0;

 private:
  void* do_allocate(std::size_t n, std::size_t align) override {
    void* p = std::pmr::new_delete_resource()->allocate(n, align);
    live += n;
    ++calls;
    if (live > peak) {
      peak = live;
    }
    return p;
  }
  void do_deallocate(void* p, std::size_t n, std::size_t align) override {
    live -= n;
    std::pmr::new_delete_resource()->deallocate(p, n, align);
  }
  bool do_is_equal(const std::pmr::memory_resource& other) const noexcept override {
    return this == &other;
  }
};
struct Token {
  static inline int alive = 0;
  int value;
  explicit Token(int v) : value(v) {
    if (v < 0) {
      throw std::invalid_argument("negative token");
    }
    ++alive;
  }
  Token(const Token& x) : value(x.value) {
    ++alive;
  }
  Token(Token&& x) noexcept : value(x.value) {
    ++alive;
  }
  ~Token() {
    --alive;
  }
};
int main() {
  try {
    Counting upstream;
    alignas(64) std::array<std::byte, 256> initial{};
    // 声明顺序保证resource先于容器建立，晚于容器销毁。
    std::pmr::monotonic_buffer_resource arena(initial.data(), initial.size(), &upstream);
    {
      std::pmr::vector<Token> tokens(&arena);
      tokens.reserve(1000);
      for (int i = 0; i < 1000; ++i) {
        tokens.emplace_back(i);
      }
      const auto bytes = upstream.live;
      tokens.clear();
      check(Token::alive == 0 && upstream.live == bytes && bytes > 0,
            "clear must destroy but not release arena chunks");
      try {
        tokens.emplace_back(-1);
      } catch (const std::invalid_argument&) {
      }
      check(tokens.empty() && Token::alive == 0, "constructor failure rollback");
      std::cout << "clear_alive=0 retained_upstream_bytes=" << bytes << '\n';
    }
    arena.release();  // 只有所有容器都离开作用域后才可回收。
    check(upstream.live == 0, "release leak");
    alignas(64) std::array<std::byte, 128> bounded{};
    std::pmr::monotonic_buffer_resource finite(
        bounded.data(), bounded.size(), std::pmr::null_memory_resource());
    bool failed = false;
    {
      std::pmr::vector<int> values(&finite);
      values.reserve(8);
      values.push_back(42);
      try {
        values.reserve(4096);
      } catch (const std::bad_alloc&) {
        failed = true;
      }
      check(failed && values.size() == 1 && values[0] == 42, "OOM strong guarantee");
    }
    finite.release();
    {
      std::pmr::vector<int> reuse(&finite);
      reuse.reserve(8);
      reuse.push_back(7);
      check(reuse[0] == 7, "reuse failed");
    }
    std::cout << "PASS allocation_calls=" << upstream.calls << " peak_bytes=" << upstream.peak
              << " live=0 bounded_oom=1 reuse=1 constructor_rollback=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
