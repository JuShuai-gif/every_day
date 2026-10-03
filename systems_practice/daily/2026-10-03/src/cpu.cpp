#include <iostream>

#include "contract.hpp"
int main() {
  try {
    int cases = 0;
    for (int r : {1, 3, 4, 5, 31, 394}) {
      for (int c : {1, 7, 31, 32, 33, 127, 128, 129, 1025}) {
        for (int pad : {0, 7}) {
          Shape s{r, c, c + pad};
          auto a = input(s);
          auto gold = oracle(a, s);
          for (int width : {32, 128}) {
            compare(model(a, s, width), gold);
            ++cases;
          }
        }
      }
    }
    int rejected = 0;
    for (Shape s : std::vector<Shape>{{0, 1, 1}, {1, 0, 1}, {1, 5, 4}, {4097, 1, 1}}) {
      try {
        validate(s);
      } catch (const std::exception&) {
        ++rejected;
      }
    }
    require(rejected == 4, "invalid shape accepted");
    Shape z{5, 33, 40};
    std::vector<float> a(200, 0);
    compare(model(a, z, 32), oracle(a, z));
    std::cout << "PASS comparisons=" << cases << " invalid=4 zero=1 exact_index_coverage=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
