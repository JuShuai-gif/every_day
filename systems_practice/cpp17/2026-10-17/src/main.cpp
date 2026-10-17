#include <iostream>

#include "config.hpp"
int main() {
  try {
    if (other_config() != &config || other_local() == &local_config ||
        other_nullopt() != &std::nullopt) {
      throw std::runtime_error("identity");
    }
    if (!reserve(0) || !reserve(4) || reserve(5)) {
      throw std::runtime_error("boundary");
    }
    int rejected = 0;
    try {
      reserve(-1);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    other_increment();
    if (accepted != 5 || rejected != 1) {
      throw std::runtime_error("shared state");
    }
    std::cout << "PASS inline_identity=shared static_identity=distinct nullopt_identity=shared "
                 "count=5 rejected=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
