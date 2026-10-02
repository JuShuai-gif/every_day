#include <array>
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <utility>
#include <vector>
void ck(bool b, const char* m) {
  if (!b)
    throw std::runtime_error(m);
}
// 用户态、单线程的页寿命模型；并非宿主物理页、DMA内存或xv6运行。
class Pool {
  struct alignas(4096) Page {
    std::array<unsigned char, 4096> data{};
  };
  std::array<Page, 8> pages_{};
  std::array<int, 8> next_{};
  std::array<bool, 8> used_{};
  int head_ = 0;

 public:
  int gets = 0, puts = 0, failures = 0;
  Pool() {
    for (int i = 0; i < 8; ++i)
      next_[i] = (i == 7 ? -1 : i + 1);
  }
  Pool(const Pool&) = delete;
  Pool& operator=(const Pool&) = delete;
  ~Pool() {
    if (gets != puts)
      std::terminate();
  }
  int acquire() {
    if (head_ < 0) {
      ++failures;
      return -1;
    }
    int i = head_;
    head_ = next_[i];
    used_[i] = true;
    pages_[i].data.fill(5);
    ++gets;
    return i;
  }
  void release(int i) {
    if (i < 0 || i >= 8 || !used_[i])
      throw std::invalid_argument("invalid/double release");
    pages_[i].data.fill(1);
    used_[i] = false;
    next_[i] = head_;
    head_ = i;
    ++puts;
  }
  std::uintptr_t address(int i) const {
    return reinterpret_cast<std::uintptr_t>(&pages_.at(i));
  }
  int available() const {
    return 8 - (gets - puts);
  }
};
class Lease {
  Pool* p_;
  int id_;

 public:
  explicit Lease(Pool& p) : p_(&p), id_(p.acquire()) {
    if (id_ < 0)
      throw std::bad_alloc();
  }
  ~Lease() {
    if (p_)
      p_->release(id_);
  }
  Lease(const Lease&) = delete;
  Lease& operator=(const Lease&) = delete;
  Lease(Lease&& o) noexcept : p_(std::exchange(o.p_, nullptr)), id_(o.id_) {
  }
};
// 返回前始终由局部RAII持有；第N页失败时此前页自动归还。
std::vector<Lease> load(Pool& p, int n) {
  std::vector<Lease> candidate;
  candidate.reserve(n);
  for (int i = 0; i < n; ++i)
    candidate.emplace_back(p);
  return candidate;
}
int main() {
  try {
    Pool p;
    for (int i = 0; i < 8; ++i)
      ck(p.address(i) % 4096 == 0, "alignment");
    {
      auto live = load(p, 3);
      ck(p.available() == 5, "live");
      bool failed = false;
      try {
        auto pending = load(p, 6);
      } catch (const std::bad_alloc&) {
        failed = true;
      }
      ck(failed && p.available() == 5, "partial allocation rollback");
      auto replacement = load(p, 5);
      ck(p.available() == 0, "exact capacity");
    }
    ck(p.available() == 8, "leases returned");
    int id = p.acquire();
    p.release(id);
    bool rejected = false;
    try {
      p.release(id);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    ck(rejected, "double release detected");
    for (int i = 0; i < 1000; ++i) {
      auto candidate = load(p, 8);
    }
    ck(p.gets == p.puts, "balanced");
    std::cout << "PASS gets=" << p.gets << " puts=" << p.puts << " failures=" << p.failures
              << " free=" << p.available() << " double_free_rejected=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
