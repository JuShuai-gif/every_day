#include <atomic>
#include <cassert>
#include <iostream>
#include <thread>
struct Slot {
  int value = 0;
  std::atomic<bool> ready{false};
};
int main() {
  Slot s;
  std::thread p([&] {
    s.value = 42;
    s.ready.store(true, std::memory_order_release);
  });
  while (!s.ready.load(std::memory_order_acquire)) {
  }
  p.join();
  assert(s.value == 42);
  std::cout << "release_acquire_pass value=" << s.value << "\n";
}
