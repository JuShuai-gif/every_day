#include <iostream>
#include <stdexcept>
#include <type_traits>
#include <utility>
#include <vector>
void ck(bool b, const char* m) {
  if (!b)
    throw std::runtime_error(m);
}
// 仅noexcept不同；记录构造次数，故障在修改源对象之前发生。
template <bool Safe>
struct Item {
  inline static int live = 0, copies = 0, moves = 0, throw_on = -1;
  int value;
  explicit Item(int v) : value(v) {
    ++live;
  }
  Item(const Item& o) : value(o.value) {
    if (copies == throw_on)
      throw std::runtime_error("injected copy failure");
    ++copies;
    ++live;
  }
  Item(Item&& o) noexcept(Safe) : value(o.value) {
    o.value = -1;
    ++moves;
    ++live;
  }
  ~Item() {
    --live;
  }
  Item& operator=(const Item&) = delete;
  Item& operator=(Item&&) = delete;
};
static_assert(std::is_nothrow_move_constructible_v<Item<true>>);
static_assert(!std::is_nothrow_move_constructible_v<Item<false>>);
template <bool Safe>
void normal() {
  using T = Item<Safe>;
  T::copies = T::moves = 0;
  {
    std::vector<T> v;
    v.reserve(4);
    for (int i = 0; i < 4; ++i)
      v.emplace_back(i + 10);
    auto oldcap = v.capacity();
    v.reserve(oldcap + 1);
    for (int i = 0; i < 4; ++i)
      ck(v[i].value == i + 10, "value");
    std::cout << "noexcept=" << Safe << " copies=" << T::copies << " moves=" << T::moves << '\n';
    ck(Safe ? T::moves == 4 && T::copies == 0 : T::copies == 4 && T::moves == 0,
       "observed libc++ relocation branch");
    int before = T::copies + T::moves;
    v.reserve(v.capacity());
    ck(before == T::copies + T::moves, "reserve no-op");
  }
  ck(T::live == 0, "live count");
}
int main() {
  try {
    normal<true>();
    normal<false>();
    using T = Item<false>;
    int failures = 0;
    for (int fail = 0; fail < 4; ++fail) {
      {
        std::vector<T> v;
        v.reserve(4);
        for (int i = 0; i < 4; ++i)
          v.emplace_back(i);
        auto* p = v.data();
        auto cap = v.capacity();
        T::copies = 0;
        T::throw_on = fail;
        try {
          v.reserve(cap + 1);
        } catch (const std::runtime_error&) {
          ++failures;
        }
        T::throw_on = -1;
        ck(v.data() == p && v.capacity() == cap && v.size() == 4 && T::live == 4,
           "strong rollback");
        for (int i = 0; i < 4; ++i)
          ck(v[i].value == i, "original unchanged");
      }
      ck(T::live == 0, "candidate cleanup");
    }
    ck(failures == 4, "injection count");
    std::cout << "PASS copy_failures=" << failures << " no_leaks=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
