#include <iostream>
#include <map>
#include <stdexcept>

void require(bool v, const char* m) {
  if (!v) {
    throw std::runtime_error(m);
  }
}
struct Slot {
  static int alive;
  int resource;
  explicit Slot(int n) : resource(n) {
    ++alive;
  }
  ~Slot() {
    --alive;
  }
  Slot(const Slot&) = delete;
  Slot(Slot&&) = delete;
  Slot& operator=(const Slot&) = delete;
  Slot& operator=(Slot&&) = delete;
};
int Slot::alive = 0;
using Registry = std::map<int, Slot>;
bool rename_slot(Registry& slots, int from, int to) {
  auto node = slots.extract(from);
  if (node.empty()) {
    return false;
  }
  node.key() = to;
  auto result = slots.insert(std::move(node));
  if (result.inserted) {
    return true;
  }
  // 普通insert的冲突节点在返回值里；忽略它会析构资源。
  result.node.key() = from;
  auto rollback = slots.insert(std::move(result.node));
  require(rollback.inserted, "rollback failed");
  return false;
}
int main() {
  try {
    {
      Registry slots;
      slots.try_emplace(1, 100);
      slots.try_emplace(2, 200);
      const Slot* address = &slots.at(1);
      for (int i = 0; i < 1000; ++i) {
        require(!rename_slot(slots, 1, 2), "collision");
        require(slots.at(1).resource == 100 && Slot::alive == 2, "lost owner");
        require(rename_slot(slots, 1, 3), "rename");
        require(&slots.at(3) == address, "moved mapped object");
        require(rename_slot(slots, 3, 1), "restore key");
      }
      require(!rename_slot(slots, 99, 1), "missing key");
      auto absent = slots.extract(99);
      auto empty = slots.insert(std::move(absent));
      require(!empty.inserted && empty.node.empty(), "empty node");
      // 同类型默认分配器相等，才满足跨容器节点转移的前置条件。
      Registry destination;
      auto owned = slots.extract(1);
      auto accepted = destination.insert(std::move(owned));
      require(accepted.inserted && &destination.at(1) == address, "transfer");
    }
    require(Slot::alive == 0, "resource leak");
    std::cout << "PASS 1000 collision rollbacks/renames; empty/missing/transfer; alive=0; mapped "
                 "copy/move deleted\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
