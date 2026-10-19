#include <array>
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <vector>

void require(bool ok, const char* s) {
  if (!ok) {
    throw std::runtime_error(s);
  }
}
struct alignas(128) Slot {
  static inline int alive = 0;
  std::array<float, 16> values{};
  explicit Slot(bool fail = false) {
    if (fail) {
      throw std::runtime_error("injected constructor failure");
    }
    ++alive;
  }
  ~Slot() {
    --alive;
  }
  Slot(const Slot& other) : values(other.values) {
    ++alive;
  }
  Slot(Slot&& other) noexcept : values(other.values) {
    ++alive;
  }
  Slot& operator=(const Slot&) = default;
  Slot& operator=(Slot&&) = default;
};
static_assert(alignof(Slot) == 128 && sizeof(Slot) % 128 == 0);
void aligned(const Slot* p) {
  require(reinterpret_cast<uintptr_t>(p) % alignof(Slot) == 0, "misaligned object");
}
int main() {
  try {
    for (size_t n : {0, 1, 3, 257}) {
      std::vector<Slot> slots(n);
      for (auto& s : slots) {
        aligned(&s);
      }
      slots.emplace_back();
      for (auto& s : slots) {
        aligned(&s);
      }
    }
    require(Slot::alive == 0, "vector leak");
    {
      auto slot = std::make_unique<Slot>();
      aligned(slot.get());
    }
    bool caught = false;
    try {
      auto slot = std::make_unique<Slot>(true);
    } catch (const std::runtime_error&) {
      caught = true;
    }
    require(caught && Slot::alive == 0, "constructor rollback");
    // std::align 只找空间，不创建对象；避免故意解引用未对齐指针的UB。
    alignas(128) std::array<std::byte, 256> storage{};
    void* ptr = storage.data() + 1;
    size_t space = 255;
    require(std::align(128, sizeof(Slot), ptr, space) != nullptr, "alignment should fit");
    require(ptr == storage.data() + 128 && space == 128, "padding accounting");
    void* tight = storage.data() + 1;
    size_t small = 127;
    require(std::align(128, sizeof(Slot), tight, small) == nullptr, "tight buffer must fail");
    require(tight == storage.data() + 1 && small == 127, "failure mutated state");
    std::cout << "PASS vector_sizes=0,1,3,257 growth aligned=128 sizeof=" << sizeof(Slot)
              << " constructor_failure=1 align_failure=1 alive=" << Slot::alive << "\n";
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << "\n";
    return 1;
  }
}
