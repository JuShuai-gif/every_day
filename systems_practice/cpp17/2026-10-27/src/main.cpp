#include <future>
#include <iostream>
#include <stdexcept>
#include <thread>
std::future<int> submit(int v) {
  std::promise<int> p;
  auto f = p.get_future();
  std::thread([p = std::move(p), v]() mutable {
    try {
      if (v < 0)
        throw std::invalid_argument("negative");
      p.set_value(v * v);
    } catch (...) {
      p.set_exception(std::current_exception());
    }
  }).detach();
  return f;
}
int main() {
  if (submit(7).get() != 49)
    return 2;
  auto f = submit(-1);
  try {
    (void)f.get();
    return 3;
  } catch (const std::invalid_argument& e) {
    std::cout << "PASS value=49 exception=" << e.what() << "\n";
  }
}
