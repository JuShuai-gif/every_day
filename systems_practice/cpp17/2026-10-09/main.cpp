#include <iostream>
#include <stdexcept>
#include <string>
#include <unordered_map>
int main() {
  std::unordered_map<std::string, int> routes;
  auto first = routes.try_emplace("camera", 1);
  auto duplicate = routes.try_emplace("camera", 99);
  if (!first.second || duplicate.second || routes.at("camera") != 1 || routes.find("missing") != routes.end()) throw std::runtime_error("map contract");
  std::cout << "PASS try_emplace inserts once; duplicate preserves mapped value; find does not insert\n";
}
