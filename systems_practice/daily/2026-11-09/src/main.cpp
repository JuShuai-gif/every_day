#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <vector>
struct Resource {
  inline static int live = 0;
  int id;
  explicit Resource(int i) : id(i) {
    ++live;
  }
  ~Resource() {
    --live;
  }
  Resource(const Resource&) = delete;
  Resource& operator=(const Resource&) = delete;
};
struct Session {
  std::unique_ptr<Resource> input;
  std::unique_ptr<Resource> output;
  std::vector<int> shape;
  Session(int id, int fail) : input(std::make_unique<Resource>(id)) {
    if (fail == 1) {
      throw std::runtime_error("output allocation");
    }
    output = std::make_unique<Resource>(id + 1);
    shape = {1, 3, 224, 224};
    if (fail == 2) {
      throw std::runtime_error("backend validation");
    }
  }
};
class Service {
  std::unique_ptr<Session> current;

 public:
  void reload(int id, int fail) {
    if (id < 0 || fail < 0 || fail > 2) {
      throw std::invalid_argument("config");
    }
    // 完成所有可能抛出的准备，再以 noexcept swap 发布。
    auto candidate = std::make_unique<Session>(id, fail);
    current.swap(candidate);
  }
  int id() const {
    return current ? current->input->id : -1;
  }
};
int main() {
  try {
    int failures = 0;
    for (int trial = 0; trial < 100; ++trial) {
      Service service;
      service.reload(10, 0);
      for (int fail : {1, 2}) {
        try {
          service.reload(20, fail);
        } catch (const std::runtime_error&) {
          ++failures;
        }
        if (service.id() != 10 || Resource::live != 2) {
          throw std::logic_error("rollback");
        }
      }
      service.reload(30, 0);
      if (service.id() != 30 || Resource::live != 2) {
        throw std::logic_error("commit");
      }
      try {
        service.reload(-1, 0);
      } catch (const std::invalid_argument&) {
        ++failures;
      }
    }
    if (Resource::live != 0 || failures != 300) {
      return 1;
    }
    std::cout << "PASS 100 commits, 200 injected rollback, 100 invalid configs, live=0\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
