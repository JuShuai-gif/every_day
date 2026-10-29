#pragma once  // 防止该头文件被同一个编译单元重复包含。

#include <atomic>       // 原子游标、状态字和无锁析构链。
#include <cstddef>      // std::byte、std::size_t。
#include <exception>    // std::terminate。
#include <limits>       // std::numeric_limits。
#include <new>          // placement new。
#include <stdexcept>    // 异常类型。
#include <type_traits>  // 编译期类型约束。
#include <utility>      // std::exchange、std::forward。
#include <vector>       // 预先分配的原始字节存储。

// 借鉴 gRPC Arena 的“原子 bump + ManagedNew 链表”；本练习固定容量，适合实时控制帧。
class FrameArena {
 public:
  class Producer {
   public:
    // 默认构造的 Producer 不关联任何 arena，不能用于 make/managed_new。
    Producer() = default;
    Producer(const Producer&) = delete;
    Producer& operator=(const Producer&) = delete;
    // 租约只能移动，移动后 other 失效，避免两个对象重复归还同一份租约。
    Producer(Producer&& other) noexcept : arena_(std::exchange(other.arena_, nullptr)) {
    }
    Producer& operator=(Producer&& other) noexcept {
      if (this != &other) {
        release();  // 先归还当前租约，再接管 other 的租约。
        arena_ = std::exchange(other.arena_, nullptr);
      }
      return *this;
    }
    // RAII：worker 无论正常返回还是异常展开，都会自动减少活跃计数。
    ~Producer() {
      release();
    }

   private:
    friend class FrameArena;
    explicit Producer(FrameArena* arena) : arena_(arena) {
    }
    void release() noexcept {
      if (arena_ != nullptr) {
        // release 与 reset 的 acquire/CAS 配对：最后一个 producer 离开后才能关闭本帧。
        arena_->state_.fetch_sub(1, std::memory_order_release);
        arena_ = nullptr;
      }
    }
    FrameArena* arena_ = nullptr;
  };

  // 创建固定容量字节池。容量向上取整到 16 字节，保证后续 bump 分配的对齐。
  explicit FrameArena(std::size_t bytes) : storage_(round_up(bytes)) {
    // 仅在创建时申请底层 vector；帧内 allocate 不会触发动态扩容。
    if (bytes == 0) {
      throw std::invalid_argument("arena capacity must be positive");
    }
  }
  // arena 含有原子状态与内部指针，禁止复制，避免两份对象共享同一生命周期。
  FrameArena(const FrameArena&) = delete;
  FrameArena& operator=(const FrameArena&) = delete;
  ~FrameArena() {
    // 对象析构时仍有 worker 属于调用方协议错误；继续释放 storage 会造成 UAF。
    if ((state_.load(std::memory_order_acquire) & ~kClosedBit) != 0) {
      std::terminate();
    }
    close_and_reset();
  }

  // 获取帧生产者租约。reset 只有在所有租约释放后才允许开始。
  Producer acquire_producer() {
    std::uint64_t state = state_.load(std::memory_order_relaxed);
    // 高位为 closed，低 63 位是活跃 producer 数；一次 CAS 同时完成“检查并加一”。
    while ((state & kClosedBit) == 0) {
      if ((state & ~kClosedBit) == kClosedBit - 1) {
        throw std::overflow_error("producer count overflow");
      }
      if (state_.compare_exchange_weak(
              state, state + 1, std::memory_order_acquire, std::memory_order_relaxed)) {
        return Producer(this);
      }
    }
    throw std::logic_error("frame is closing");
  }

  template <typename T, typename... Args>
  T* make(Producer& producer, Args&&... args) {
    // 平凡析构对象不进析构链，适合 command/POD 等纯帧内数据。
    check_producer(producer);
    static_assert(std::is_trivially_destructible_v<T>,
                  "non-trivial types require managed_new so reset can destroy them");
    return construct<T>(std::forward<Args>(args)...);
  }

  template <typename T, typename... Args>
  T* managed_new(Producer& producer, Args&&... args) {
    // 资源型对象走受管路径，reset 才能统一调用其析构函数。
    check_producer(producer);
    static_assert(alignof(T) <= kAlignment, "exercise arena supports up to 16-byte alignment");
    static_assert(std::is_nothrow_constructible_v<T, Args...>,
                  "managed_new requires noexcept construction in this fixed-capacity exercise");
    auto* node = construct<ManagedNode<T>>(std::forward<Args>(args)...);
    // 先构造完整节点，再用 acq_rel CAS 发布到无锁析构栈，避免 reset 看见半对象。
    ManagedNodeBase* head = managed_head_.load(std::memory_order_relaxed);
    do {
      node->next = head;
    } while (!managed_head_.compare_exchange_weak(
        head, node, std::memory_order_acq_rel, std::memory_order_relaxed));
    return &node->value;
  }

  // 关闭帧必须先等待 worker 释放 Producer；成功后析构受管对象并复用全部容量。
  void close_and_reset() noexcept {
    // 析构兜底：只有无人生产时才释放帧内对象；正常业务请调用下面的严格接口。
    std::uint64_t expected = 0;
    if (!state_.compare_exchange_strong(
            expected, kClosedBit, std::memory_order_acq_rel, std::memory_order_relaxed)) {
      return;
    }
    destroy_managed();
    used_.store(0, std::memory_order_relaxed);
    state_.store(0, std::memory_order_release);
  }
  void reset_after_join() {
    // 正常控制线程路径：join 后关闭帧；有活跃 worker 则抛异常暴露协议错误。
    std::uint64_t expected = 0;
    if (!state_.compare_exchange_strong(
            expected, kClosedBit, std::memory_order_acq_rel, std::memory_order_relaxed)) {
      throw std::logic_error("reset requires every Producer to be released");
    }
    destroy_managed();
    used_.store(0, std::memory_order_relaxed);
    state_.store(0, std::memory_order_release);
  }
  // 返回当前帧已占用的字节数，主要供观测和测试使用。
  std::size_t used_bytes() const noexcept {
    return used_.load(std::memory_order_relaxed);
  }

 private:
  static constexpr std::size_t kAlignment = 16;                        // 本练习支持的最大对象对齐。
  static constexpr std::uint64_t kClosedBit = std::uint64_t{1} << 63;  // 状态字最高位。
  struct ManagedNodeBase {
    // 基类让不同 T 共用一条析构链表；destroy 保存正确的静态析构函数。
    ManagedNodeBase* next = nullptr;
    void (*destroy)(ManagedNodeBase*) noexcept = nullptr;
  };
  template <typename T>
  struct ManagedNode final : ManagedNodeBase {
    template <typename... Args>
    explicit ManagedNode(Args&&... args) noexcept : value(std::forward<Args>(args)...) {
      this->destroy = &destroy_node;
    }
    static void destroy_node(ManagedNodeBase* base) noexcept {
      static_cast<ManagedNode*>(base)->~ManagedNode();
    }
    T value;
  };
  static std::size_t round_up(std::size_t bytes) {
    // 16-byte 粒度便于固定对齐 bump；不是所有硬件/DMA 类型的通用对齐策略。
    if (bytes > std::numeric_limits<std::size_t>::max() - (kAlignment - 1)) {
      throw std::bad_alloc();
    }
    return (bytes + kAlignment - 1) & ~(kAlignment - 1);
  }
  void* allocate(std::size_t bytes, std::size_t alignment) {
    if (alignment > kAlignment) {
      throw std::invalid_argument("over-aligned type is unsupported");
    }
    const std::size_t rounded = round_up(bytes);
    std::size_t old = used_.load(std::memory_order_relaxed);
    // CAS 在提交 cursor 前检查容量；不能用 fetch_add 后再失败，否则 cursor 会永久越界。
    do {
      if (old > storage_.size() || rounded > storage_.size() - old) {
        throw std::bad_alloc();
      }
    } while (!used_.compare_exchange_weak(
        old, old + rounded, std::memory_order_relaxed, std::memory_order_relaxed));
    return storage_.data() + old;
  }
  template <typename T, typename... Args>
  T* construct(Args&&... args) {
    // placement new 只开始对象生命周期；字节所有权仍属于 FrameArena，调用者不得 delete。
    static_assert(alignof(T) <= kAlignment, "exercise arena supports up to 16-byte alignment");
    return ::new (allocate(sizeof(T), alignof(T))) T(std::forward<Args>(args)...);
  }
  void check_producer(const Producer& producer) const {
    // 防止误用其他帧或已 move 的租约，避免跨帧写入。
    if (producer.arena_ != this) {
      throw std::logic_error("Producer belongs to another or closed arena");
    }
  }
  void destroy_managed() noexcept {
    // 先摘下整条链，析构函数即使引入新节点也会在外层循环的下一轮被处理。
    while (ManagedNodeBase* node = managed_head_.exchange(nullptr, std::memory_order_acq_rel)) {
      while (node != nullptr) {
        ManagedNodeBase* next = node->next;
        node->destroy(node);
        node = next;
      }
    }
  }
  std::vector<std::byte> storage_;       // 整个 arena 唯一的底层分配。
  std::atomic<std::size_t> used_{0};     // bump 游标；只递增，reset 时归零。
  std::atomic<std::uint64_t> state_{0};  // closed bit + 活跃 producer 计数，保护 reset 边界。
  std::atomic<ManagedNodeBase*> managed_head_{nullptr};
};
