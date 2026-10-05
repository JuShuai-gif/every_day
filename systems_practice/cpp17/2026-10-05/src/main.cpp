#include <iostream>
#include <map>
#include <memory>
#include <mutex>
#include <stdexcept>
#include <string>
#include <string_view>
struct Config {
  int batch;
};
class Registry {
  std::mutex mutex_;
  std::map<std::string, std::shared_ptr<const Config>, std::less<>> entries_;

 public:
  void set(std::string key, int batch) {
    if (key.empty() || batch < 1 || batch > 4) {
      throw std::invalid_argument("invalid config");
    }
    auto candidate = std::make_shared<const Config>(Config{batch});
    std::lock_guard<std::mutex> lock(mutex_);
    entries_.insert_or_assign(std::move(key), std::move(candidate));
  }
  std::shared_ptr<const Config> lookup(std::string_view key) {
    std::lock_guard<std::mutex> lock(mutex_);
    // C++17 if初始化限制迭代器作用域；透明比较器避免构造临时string。
    if (auto it = entries_.find(key); it != entries_.end()) {
      return it->second;
    }
    return {};  // 复制shared_ptr后解锁，不能把借用迭代器交给调用者。
  }
  std::size_t size() {
    std::lock_guard<std::mutex> lock(mutex_);
    return entries_.size();
  }
};
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("registry contract failed");
  }
}
int main() {
  try {
    Registry r;
    check(!r.lookup("missing") && r.size() == 0);
    r.set("camera", 2);
    auto retained = r.lookup("camera");
    for (int i = 0; i < 1000; ++i) {
      r.set("camera", i % 4 + 1);
      check(retained->batch == 2);
    }
    const auto before = r.lookup("camera");
    bool failed = false;
    try {
      r.set("camera", 0);
    } catch (const std::invalid_argument&) {
      failed = true;
    }
    check(failed && r.lookup("camera") == before);
    for (auto k : {"", "camer", "cameraX"}) {
      check(!r.lookup(k));
    }
    check(r.size() == 1);
    // 安全反例：operator[]是插入操作，缺失查找会让表增长。
    std::map<std::string, int> bad;
    int value = bad["missing"];
    check(value == 0 && bad.size() == 1);
    std::cout << "PASS missing lookup no insertion; 1000 replacements retain snapshot; invalid "
                 "update rollback; empty/prefix keys; operator[] counterexample\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
