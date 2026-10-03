#include <array>
#include <cstdint>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <vector>
using U = std::uint64_t;
constexpr U Page = 4096, MaxVA = U(1) << 38, V = 1, Rd = 2, Wr = 4, User = 16;
struct Node {
  std::array<std::unique_ptr<Node>, 512> next{};
  std::array<U, 512> pte{};
};
// 教学Sv39低半地址模型：不把宿主指针当作真实物理地址。
class Table {
  Node root_;
  U* walk(U va, bool allocate) {
    if (va >= MaxVA) {
      throw std::invalid_argument("va out of xv6 low half");
    }
    Node* n = &root_;
    for (int level = 2; level > 0; --level) {
      auto i = (va >> (12 + 9 * level)) & 511;
      if (!n->next[i]) {
        if (!allocate) {
          return nullptr;
        }
        n->next[i] = std::make_unique<Node>();
      }
      n = n->next[i].get();
    }
    return &n->pte[(va >> 12) & 511];
  }

 public:
  void map(U va, U pa, U flags) {
    if (va % Page || pa % Page || pa >= (U(1) << 56) || (flags & ~(Rd | Wr | User)) ||
        !(flags & Rd)) {
      throw std::invalid_argument("alignment or permissions");
    }
    auto* p = walk(va, true);
    if (*p & V) {
      throw std::logic_error("remap");
    }
    *p = ((pa >> 12) << 10) | flags | V;
  }
  U translate(U va, bool write) {
    auto* p = walk(va, false);
    if (!p || !(*p & V) || !(*p & User) || !(*p & Rd) || (write && !(*p & Wr))) {
      throw std::runtime_error("page/permission fault");
    }
    return ((*p >> 10) << 12) | (va & 4095);
  }
  void unmap(U va) {
    if (va % Page) {
      throw std::invalid_argument("unaligned unmap");
    }
    auto* p = walk(va, false);
    if (p) {
      *p = 0;
    }
  }
};
void check(bool b) {
  if (!b) {
    throw std::runtime_error("check failed");
  }
}
int main() {
  try {
    Table t;
    U va = (U(1) << 30) + (U(2) << 21) + (U(3) << 12);
    t.map(va, 0x9000, Rd | User);
    check(t.translate(va + 0xabc, false) == 0x9abc);
    int faults = 0;
    try {
      t.translate(va, true);
    } catch (const std::runtime_error&) {
      ++faults;
    }
    try {
      t.map(va, 0xa000, Rd | Wr | User);
    } catch (const std::logic_error&) {
      ++faults;
    }
    t.unmap(va);
    t.unmap(va);
    try {
      t.translate(va, false);
    } catch (const std::runtime_error&) {
      ++faults;
    }
    for (U i = 0; i < 1025; ++i) {
      t.map(i * Page, 0x100000 + i * Page, Rd | Wr | User);
      check(t.translate(i * Page + 4095, true) == 0x100000 + i * Page + 4095);
    }
    for (U i = 0; i < 1025; ++i) {
      t.unmap(i * Page);
    }
    for (U bad : {MaxVA, U(1)}) {
      try {
        t.map(bad, 0x2000, Rd | User);
      } catch (const std::invalid_argument&) {
        ++faults;
      }
    }
    t.map(0, 0x3000, Rd);
    try {
      t.translate(0, false);
    } catch (const std::runtime_error&) {
      ++faults;
    }
    check(faults == 6);
    std::cout << "PASS VPN=[1,2,3] offset=0xabc PA=0x9abc cross_leaf_pages=1025 faults=6 "
                 "repeated_unmap=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
