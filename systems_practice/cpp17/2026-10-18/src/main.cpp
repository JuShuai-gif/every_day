#include <iostream>
#include <optional>
#include <stdexcept>
#include <utility>
#include <vector>

void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("check failed");
  }
}
struct Frame {
  static int alive;
  static std::size_t checked_size(int n) {
    if (n < 0 || n > 4096) {
      throw std::invalid_argument("invalid size");
    }
    return static_cast<std::size_t>(n);
  }
  explicit Frame(int n) : data(checked_size(n), 7) {
    ++alive;
  }
  ~Frame() {
    --alive;
  }
  Frame(const Frame&) = delete;
  Frame(Frame&&) = delete;
  std::vector<int> data;
};
int Frame::alive = 0;
Frame direct(int n) {
  return Frame(n);
}
std::optional<Frame> factory(int n) {
  // 直接构造optional中的对象，无需Frame可移动。
  return std::make_optional<Frame>(n);
}
struct Movable {
  static int moves;
  int n;
  explicit Movable(int x) : n(x) {
  }
  Movable(const Movable&) = delete;
  Movable(Movable&& x) noexcept : n(std::exchange(x.n, -1)) {
    ++moves;
  }
};
int Movable::moves = 0;
Movable named(int n) {
  Movable value(n);
  return value;
}
Movable forced(int n) {
  Movable value(n);
  return std::move(value);
}
#ifdef NEGATIVE_NRVO
Frame invalid_named() {
  Frame value(1);
  return value;
}
#endif
#ifdef NEGATIVE_MOVE
Frame invalid_move() {
  return std::move(Frame(1));
}
#endif
int main() {
  try {
    for (int n : {0, 1, 4096}) {
      auto f = direct(n);
      auto o = factory(n);
      check(f.data.size() == static_cast<std::size_t>(n) && o->data == f.data && Frame::alive == 2);
    }
    check(Frame::alive == 0);
    int errors = 0;
    for (int n : {-1, 4097}) {
      try {
        auto f = factory(n);
      } catch (const std::invalid_argument&) {
        ++errors;
      }
      check(Frame::alive == 0);
    }
    auto a = named(3);
    const int nrvo_moves = Movable::moves;
    auto b = forced(4);
    check(a.n == 3 && b.n == 4 && Movable::moves == nrvo_moves + 1 && errors == 2);
    std::cout << "PASS immovable direct/optional sizes=0,1,4096 rejects=2 alive=0 nrvo_moves="
              << nrvo_moves << " forced_move_delta=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
