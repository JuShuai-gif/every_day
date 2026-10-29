#include <chrono>
#include <iostream>
#include <thread>
int main() {
  auto a = std::chrono::steady_clock::now();
  std::this_thread::sleep_for(std::chrono::microseconds(20));
  auto b = std::chrono::steady_clock::now();
  volatile long long x = 0;
  for (int i = 0; i < 100000; i++)
    x += i;
  auto c = std::chrono::steady_clock::now();
  auto us = [](auto x) {
    return std::chrono::duration_cast<std::chrono::microseconds>(x).count();
  };
  std::cout << "PASS wait_us=" << us(b - a) << " compute_us=" << us(c - b)
            << " trace_overhead_unmeasured\n";
  return x < 0;
}
