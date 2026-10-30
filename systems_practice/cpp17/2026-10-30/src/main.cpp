#include <iostream>
#include <memory>
#include <stdexcept>
struct Service {
  int value;
  explicit Service(int v) : value(v) {
  }
};
int main() {
  auto candidate = std::make_unique<Service>(7);
  if (!candidate || candidate->value != 7)
    throw std::runtime_error("candidate");
  std::unique_ptr<Service> published = std::move(candidate);
  std::cout << "published=" << published->value << " moved_from=" << (candidate == nullptr) << "\n";
}
