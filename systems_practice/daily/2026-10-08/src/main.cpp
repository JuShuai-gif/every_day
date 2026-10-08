#include <array>
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <memory_resource>
#include <stdexcept>
#include <string>
#include <vector>

void require(bool ok, const char* why) {
  if (!ok) {
    throw std::runtime_error(why);
  }
}
// 记录容器向资源申请的累计字节，非RSS；可在第n次申请前注入失败。
class Audit final : public std::pmr::memory_resource {
  std::pmr::memory_resource* upstream_;
  void* do_allocate(std::size_t n, std::size_t align) override {
    if (calls++ == fail_at) {
      throw std::bad_alloc();
    }
    void* p = upstream_->allocate(n, align);
    bytes += n;
    return p;
  }
  void do_deallocate(void* p, std::size_t n, std::size_t a) override {
    upstream_->deallocate(p, n, a);
  }
  bool do_is_equal(const std::pmr::memory_resource& r) const noexcept override {
    return this == &r;
  }

 public:
  explicit Audit(std::pmr::memory_resource* r) : upstream_(r) {
  }
  std::size_t calls = 0, bytes = 0, fail_at = static_cast<std::size_t>(-1);
};
struct Result {
  std::size_t count = 0, chars = 0;
};
class Request {
  // 成员逆序析构：audit -> arena -> storage；请求不可移动，避免内部地址失效。
  alignas(64) std::array<std::byte, 16384> storage_{};
  std::pmr::monotonic_buffer_resource arena_{
      storage_.data(), storage_.size(), std::pmr::null_memory_resource()};

 public:
  Audit audit{&arena_};
  Request() = default;
  Request(const Request&) = delete;
  Request& operator=(const Request&) = delete;
  bool execute(std::size_t n, bool reserve, Result& published, int bad_index = -1) {
    bool success = false;
    try {
      // vector与嵌套pmr::string都必须使用同一资源；离开try才允许release。
      std::pmr::vector<std::pmr::string> names{&audit};
      if (reserve) {
        names.reserve(n);
      }
      Result candidate;
      for (std::size_t i = 0; i < n; ++i) {
        if (static_cast<int>(i) == bad_index) {
          throw std::invalid_argument("bad label");
        }
        names.emplace_back(80, static_cast<char>('a' + i % 26));
        require(names.back().get_allocator().resource() == &audit, "nested allocator");
        candidate.chars += names.back().size();
      }
      candidate.count = names.size();
      published = candidate;  // 只发布值，不泄露arena中的借用地址。
      success = true;
    } catch (const std::bad_alloc&) {
    } catch (const std::invalid_argument&) {
    }
    arena_.release();
    return success;
  }
};
int main() {
  try {
    Result out{7, 9};
    Request baseline, reserved;
    require(baseline.execute(64, false, out), "growth");
    const auto base_calls = baseline.audit.calls, base_bytes = baseline.audit.bytes;
    require(reserved.execute(64, true, out), "reserve");
    const auto calls = reserved.audit.calls;
    std::cout << "64 labels length80 growth calls=" << base_calls << " bytes=" << base_bytes
              << " reserve calls=" << calls << " bytes=" << reserved.audit.bytes << '\n';
    require(out.count == 64 && out.chars == 5120, "value oracle");
    for (std::size_t failure = 0; failure < calls; ++failure) {
      Request r;
      r.audit.fail_at = failure;
      Result snapshot{7, 9};
      require(!r.execute(64, true, snapshot), "injected allocation failure");
      require(snapshot.count == 7 && snapshot.chars == 9, "rollback");
      r.audit.fail_at = static_cast<std::size_t>(-1);
      require(r.execute(64, true, snapshot), "retry after release");
    }
    for (int i = 0; i < 1000; ++i) {
      require(reserved.execute(64, true, out), "reusable request");
      require(!reserved.execute(64, true, out, 31), "parse failure");
      require(out.count == 64 && out.chars == 5120, "business rollback");
    }
    require(!reserved.execute(1000000, true, out), "bounded exhaustion");
    require(reserved.execute(0, true, out) && out.count == 0, "empty");
    alignas(64) std::array<std::byte, 256> buf{};
    std::pmr::monotonic_buffer_resource mr(
        buf.data(), buf.size(), std::pmr::null_memory_resource());
    void* p = mr.allocate(64, 64);
    require(reinterpret_cast<std::uintptr_t>(p) % 64 == 0, "alignment");
    mr.deallocate(p, 64, 64);
    std::cout << "PASS failure_points=" << calls
              << " reuse=1000 empty/exhaustion/alignment/rollback\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
