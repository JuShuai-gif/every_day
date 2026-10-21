#include <chrono>
#include <iostream>
#include <string>
#include <vector>

#include "../../../daily/2026-10-21/src/quantize.hpp"
int main(int argc, char** argv) {
  try {
    if (argc != 2 || (std::string(argv[1]) != "scalar" && std::string(argv[1]) != "neon")) {
      throw std::invalid_argument("usage: probe scalar|neon");
    }
    const std::size_t n = 1048576;
    std::vector<float> x(n);
    for (std::size_t i = 0; i < n; ++i) {
      x[i] = static_cast<float>(i % 511) / 2 - 127;
    }
    std::vector<std::int8_t> q(n), expected(n);
    practice::scalar(x.data(), expected.data(), n, 1);
    auto fn = std::string(argv[1]) == "scalar" ? practice::scalar : practice::neon;
    for (int j = 0; j < 8; ++j) {
      fn(x.data(), q.data(), n, 1);
    }
    const auto begin = std::chrono::steady_clock::now();
    for (int j = 0; j < 1000; ++j) {
      fn(x.data(), q.data(), n, 1);
      asm volatile("" : : "r"(q.data()) : "memory");
    }
    const auto end = std::chrono::steady_clock::now();
    if (q != expected) {
      throw std::runtime_error("mismatch");
    }
    std::cout << "PASS mode=" << argv[1] << " elements=" << n << " repeats=1000 hot_loop_ms="
              << std::chrono::duration<double, std::milli>(end - begin).count()
              << " PMU=not_collected_by_program\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
