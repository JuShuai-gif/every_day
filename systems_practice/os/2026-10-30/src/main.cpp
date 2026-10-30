#include <chrono>
#include <iostream>
#include <vector>
int main() {
  std::vector<int> work(4096, 1);
  auto b = std::chrono::steady_clock::now();
  long sum = 0;
  for (int x : work)
    sum += x;
  auto e = std::chrono::steady_clock::now();
  std::cout << "sum=" << sum
            << " host_ns=" << std::chrono::duration_cast<std::chrono::nanoseconds>(e - b).count()
            << "\n";
}
