#include <iostream>
#include <memory>
#include <stdexcept>
#include <type_traits>
struct Frame {
  static int alive;
  int id;
  explicit Frame(int x) : id(x) {
    ++alive;
  }
  ~Frame() {
    --alive;
  }
};
int Frame::alive = 0;
using Owner = std::unique_ptr<Frame>;
void require(bool b) {
  if (!b) {
    throw std::runtime_error("ownership contract");
  }
}
class Slot {
  Owner queued_;

 public:
  // 两阶段接收：拒绝时调用者仍持有；通过全部可失败检查后才移动。
  bool offer(Owner& source, bool inject = false) {
    if (!source || queued_) {
      return false;
    }
    if (inject) {
      throw std::runtime_error("injected validation failure");
    }
    queued_ = std::move(source);
    return true;
  }
  Owner take() {
    return std::move(queued_);
  }
};
static_assert(!std::is_copy_constructible<Owner>::value, "one owner");
static_assert(std::is_nothrow_move_constructible<Owner>::value, "nothrow handoff");
int main() {
  try {
    for (int i = 0; i < 1000; ++i) {
      Slot slot;
      Owner first = std::make_unique<Frame>(i), second = std::make_unique<Frame>(-1), empty;
      Frame* borrowed = first.get();
      bool caught = false;
      try {
        slot.offer(first, true);
      } catch (const std::runtime_error&) {
        caught = true;
      }
      require(caught && first.get() == borrowed && Frame::alive == 2);
      require(!slot.offer(empty));
      require(slot.offer(first) && !first);
      require(!slot.offer(second) && second);
      Owner next = slot.take();
      require(next.get() == borrowed && next->id == i && !slot.take());
      // 移动后对象地址没变，旧借用只在新owner销毁前有效；不解引用悬空指针。
      second = std::move(next);
      require(!next && second.get() == borrowed && Frame::alive == 1);
      second.reset();
      require(Frame::alive == 0);
    }
    std::cout << "PASS 1000 reject/throw/accept/take/move-assign/reset cycles; alive="
              << Frame::alive << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
