#include <iostream>

#include "data.hpp"
int main(int argc, char** argv) {
  try {
    if (argc < 2) {
      throw std::runtime_error("provide fixtures");
    }
    for (int i = 1; i < argc; ++i) {
      auto d = read_data(argv[i]);
      compare(reference(d), d.oracle);
    }
    std::cout << "PASS independent C++ group INT32/FP16 reference fixtures=" << argc - 1 << "\n";
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
