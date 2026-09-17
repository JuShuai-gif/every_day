#pragma once

#include <cstddef>
#include <memory>
#include <new>
#include <stdexcept>
#include <type_traits>
#include <utility>
#include <vector>

// 单帧独占的单调内存池：初始化后不触发堆分配，reset 时统一回收。
class FrameArena {
 public:
  explicit FrameArena(std::size_t bytes, std::size_t destructor_capacity)
      : storage_(bytes), destructors_(destructor_capacity) {}

  FrameArena(const FrameArena&) = delete;
  FrameArena& operator=(const FrameArena&) = delete;

  ~FrameArena() {
    reset();
  }

  void* allocate(std::size_t bytes, std::size_t alignment) {
    if (alignment == 0 || (alignment & (alignment - 1)) != 0) {
      throw std::invalid_argument("alignment must be a non-zero power of two");
    }
    void* candidate = storage_.data() + cursor_;
    std::size_t remaining = storage_.size() - cursor_;
    if (std::align(alignment, bytes, candidate, remaining) == nullptr) {
      throw std::bad_alloc();
    }
    cursor_ = storage_.size() - remaining + bytes;
    return candidate;
  }

  template <typename T, typename... Args>
  T* make(Args&&... args) {
    static_assert(!std::is_array_v<T>, "FrameArena does not construct arrays");
    if constexpr (!std::is_trivially_destructible_v<T>) {
      if (destructor_count_ == destructors_.size()) {
        throw std::bad_alloc();  // 先检查，避免失败时消耗数据区容量。
      }
    }
    const std::size_t mark = cursor_;
    void* memory = allocate(sizeof(T), alignof(T));
    T* object = nullptr;
    try {
      // placement new 只构造对象；所有权仍由 arena 持有。
      object = ::new (memory) T(std::forward<Args>(args)...);
    } catch (...) {
      cursor_ = mark;  // 构造抛异常时回滚本次 bump，维持基本异常安全。
      throw;
    }
    if constexpr (!std::is_trivially_destructible_v<T>) {
      destructors_[destructor_count_++] = {object, &destroy<T>};
    }
    return object;
  }

  void reset() noexcept {
    // 逆序析构模拟普通作用域的对象销毁顺序，然后一次复用整块空间。
    while (destructor_count_ != 0) {
      const DestructorRecord& record = destructors_[--destructor_count_];
      record.destroy(record.object);
    }
    cursor_ = 0;
  }

  std::size_t used_bytes() const noexcept {
    return cursor_;
  }
  std::size_t capacity_bytes() const noexcept {
    return storage_.size();
  }

 private:
  struct DestructorRecord {
    void* object = nullptr;
    void (*destroy)(void*) noexcept = nullptr;
  };

  template <typename T>
  static void destroy(void* object) noexcept {
    static_cast<T*>(object)->~T();
  }

  std::vector<std::byte> storage_;
  std::vector<DestructorRecord> destructors_;
  std::size_t cursor_ = 0;
  std::size_t destructor_count_ = 0;
};
