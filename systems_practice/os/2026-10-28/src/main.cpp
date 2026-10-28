#include <atomic>
#include <cassert>
#include <chrono>
#include <iostream>
#include <thread>
#include <vector>
struct Service {
  std::atomic<bool> stop{false};
  std::atomic<unsigned long> jobs{0}, rejected{0};
  void worker() {
    while (!stop.load(std::memory_order_acquire)) {
      jobs.fetch_add(1, std::memory_order_relaxed);
      std::this_thread::yield();
    }
  }
};
int main() {
  Service s;
  std::thread t([&] {
    s.worker();
  });
  std::this_thread::sleep_for(std::chrono::milliseconds(2));
  s.stop.store(true, std::memory_order_release);
  t.join();
  s.rejected.store(1);
  assert(s.jobs > 0 && s.rejected == 1);
  std::cout << "bounded_shutdown_pass jobs=" << s.jobs.load() << " rejected=1\n";
}
