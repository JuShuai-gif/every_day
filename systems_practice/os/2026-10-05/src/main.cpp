#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <memory>
#include <stdexcept>
constexpr std::size_t Page = 4096;
using Bytes = std::array<unsigned char, Page>;
// 安全宿主状态模型，不是实际页表；sz增长与物理页存在分开。
class Heap {
  std::size_t size_ = 0, budget_;
  std::map<std::size_t, std::unique_ptr<Bytes>> pages_;

 public:
  explicit Heap(std::size_t budget) : budget_(budget) {
  }
  std::size_t size() const {
    return size_;
  }
  std::size_t resident() const {
    return pages_.size();
  }
  bool grow(std::size_t bytes) {
    if (bytes > 16 * Page - size_) {
      return false;
    }
    size_ += bytes;
    return true;
  }
  void shrink(std::size_t n) {
    if (n > size_) {
      throw std::out_of_range("shrink");
    }
    size_ -= n;
    auto end = (size_ + Page - 1) / Page;
    pages_.erase(pages_.lower_bound(end), pages_.end());
  }
  unsigned char& touch(std::size_t address, bool mapping_failure = false) {
    if (address >= size_) {
      throw std::out_of_range("outside reservation");
    }
    auto key = address / Page;
    if (auto it = pages_.find(key); it != pages_.end()) {
      return (*it->second)[address % Page];
    }
    if (pages_.size() >= budget_) {
      throw std::bad_alloc();
    }
    auto page = std::make_unique<Bytes>();  // 值初始化为0，失败前由RAII持有。
    if (mapping_failure) {
      throw std::runtime_error("injected mapping failure");
    }
    auto it = pages_.emplace(key, std::move(page)).first;
    return (*it->second)[address % Page];
  }
};
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("state oracle failed");
  }
}
int main() {
  try {
    Heap heap(2);
    check(heap.grow(3 * Page + 1));
    check(heap.resident() == 0);
    check(heap.touch(0) == 0);
    heap.touch(0) = 42;
    check(heap.touch(Page - 1) == 0);
    check(heap.resident() == 1);
    bool injected = false;
    try {
      heap.touch(Page, true);
    } catch (const std::runtime_error&) {
      injected = true;
    }
    check(injected && heap.resident() == 1);
    check(heap.touch(Page) == 0);
    bool oom = false;
    try {
      heap.touch(2 * Page) = 1;
    } catch (const std::bad_alloc&) {
      oom = true;
    }
    check(oom && heap.size() == 3 * Page + 1 && heap.resident() == 2);
    heap.shrink(2 * Page + 1);
    check(heap.resident() == 1);
    check(heap.grow(Page));
    check(heap.touch(Page) == 0);
    check(heap.touch(0) == 42);
    bool range = false;
    try {
      heap.touch(heap.size());
    } catch (const std::out_of_range&) {
      range = true;
    }
    check(range);
    check(!heap.grow(std::size_t(-1)));
    heap.shrink(heap.size());
    check(heap.resident() == 0);
    for (std::size_t n = 0; n <= Page + 1; ++n) {
      Heap h(2);
      check(h.grow(n));
      if (n) {
        h.touch(n - 1) = 5;
        check(h.resident() == 1);
      }
      h.shrink(n);
      check(h.resident() == 0);
    }
    std::cout << "PASS 4098 sizes; reserve!=resident; zero-fill; mapping rollback; deferred OOM; "
                 "shrink holes; overflow; exact end rejected\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
