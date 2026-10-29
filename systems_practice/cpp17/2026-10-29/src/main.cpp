#include <cassert>
#include <iostream>
#include <memory>
#include <string>
struct AbiStamp {
  int version;
  std::string name;
};
int main() {
  auto p = std::make_shared<AbiStamp>(AbiStamp{17, "edge"});
  std::weak_ptr<AbiStamp> w = p;
  auto q = p;
  p.reset();
  assert(!w.expired());
  q.reset();
  assert(w.expired());
  std::cout << "PASS shared_lifetime abi_stamp=17\n";
}
