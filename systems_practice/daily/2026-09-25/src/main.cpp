#include <array>
#include <cstddef>
#include <iostream>
#include <stdexcept>
#include <type_traits>
#include <utility>
#include <vector>

// LLVM scope_exit 机制启发的独立实现：收窄为不可抛出移动/清理的回调。
template <class F>
class Rollback {
  static_assert(std::is_nothrow_invocable_v<F&>, "cleanup must be noexcept");
  static_assert(std::is_nothrow_move_constructible_v<F>, "move must be noexcept");
  F cleanup_;
  bool armed_ = true;

 public:
  explicit Rollback(F f) noexcept : cleanup_(std::move(f)) {
  }
  Rollback(const Rollback&) = delete;
  Rollback& operator=(const Rollback&) = delete;
  Rollback& operator=(Rollback&&) = delete;
  Rollback(Rollback&& other) noexcept
      : cleanup_(std::move(other.cleanup_)), armed_(std::exchange(other.armed_, false)) {
  }
  ~Rollback() noexcept {
    if (armed_) {
      cleanup_();
    }
  }
  void commit() noexcept {
    armed_ = false;
  }
};
template <class F>
Rollback(F) -> Rollback<F>;

struct Pool {
  std::array<bool, 4> used{};
  std::size_t live = 0;
  int acquire() {
    for (int i = 0; i < 4; ++i) {
      if (!used[i]) {
        used[i] = true;
        ++live;
        return i;
      }
    }
    throw std::runtime_error("pool full");
  }
  void release(int id) noexcept {
    // 资源错误不可从析构抛出：失败即终止，避免默默双重归还。
    if (id < 0 || id >= 4 || !used[id]) {
      std::terminate();
    }
    used[id] = false;
    --live;
  }
};
class Request {
  Pool* pool_;
  int slot_;
  std::vector<float> data_;

 public:
  Request(Pool& p, int slot, std::vector<float> data) noexcept
      : pool_(&p), slot_(slot), data_(std::move(data)) {
  }
  Request(const Request&) = delete;
  Request& operator=(const Request&) = delete;
  Request& operator=(Request&&) = delete;
  Request(Request&& r) noexcept
      : pool_(std::exchange(r.pool_, nullptr)), slot_(r.slot_), data_(std::move(r.data_)) {
  }
  ~Request() noexcept {
    if (pool_) {
      pool_->release(slot_);
    }
  }
  float sum() const {
    float r = 0;
    for (float x : data_) {
      r += x;
    }
    return r;
  }
};
Request prepare(Pool& p, int fail_at) {
  const int slot = p.acquire();
  auto guard = Rollback([&p, slot]() noexcept {
    p.release(slot);
  });
  if (fail_at == 1) {
    throw std::runtime_error("decode failed");
  }
  std::vector<float> data(128, 2.0F);
  if (fail_at == 2) {
    throw std::runtime_error("validation failed");
  }
  Request request(p, slot, std::move(data));
  // 此后只有 noexcept 移动；撤销 guard 后由 Request 唯一负责归还。
  guard.commit();
  return request;
}
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("contract failed");
  }
}
int main() {
  try {
    Pool pool;
    for (int trial = 0; trial < 1000; ++trial) {
      for (int failure : {1, 2}) {
        bool caught = false;
        try {
          auto r = prepare(pool, failure);
          (void)r;
        } catch (const std::runtime_error&) {
          caught = true;
        }
        check(caught && pool.live == 0);
      }
      {
        auto r = prepare(pool, 0);
        check(pool.live == 1 && r.sum() == 256.0F);
        auto moved = std::move(r);
        check(moved.sum() == 256.0F);
      }
      check(pool.live == 0);
    }
    int calls = 0;
    {
      auto a = Rollback([&calls]() noexcept {
        ++calls;
      });
      auto b = std::move(a);
      (void)b;
    }
    check(calls == 1);
    {
      auto a = Rollback([&calls]() noexcept {
        ++calls;
      });
      a.commit();
      a.commit();
    }
    check(calls == 1);
    {
      std::vector<Request> active;
      for (int i = 0; i < 4; ++i) {
        active.push_back(prepare(pool, 0));
      }
      bool full = false;
      try {
        auto extra = prepare(pool, 0);
        (void)extra;
      } catch (const std::runtime_error&) {
        full = true;
      }
      check(full && pool.live == 4);
    }
    check(pool.live == 0);
    std::cout
        << "PASS 2000 injected failures, 1000 success/move, guard move/commit, pool saturation\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
