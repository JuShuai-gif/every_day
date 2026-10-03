#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("check failed");
  }
}
// 同步解析返回借用，调用者必须在owner存活且不变时使用。
std::string_view value(std::string_view line) {
  auto p = line.find('=');
  if (p == line.npos || p == 0) {
    throw std::invalid_argument("expected nonempty key=value");
  }
  return line.substr(p + 1);
}
class Request {
  std::shared_ptr<const std::string> owner_;
  std::size_t offset_;

 public:
  explicit Request(std::string line)
      : owner_(std::make_shared<const std::string>(std::move(line))), offset_(0) {
    auto v = value(*owner_);
    offset_ = owner_->size() - v.size();
  }
  // 不缓存指向本对象string的view，复制/移动后按不可变owner重建。
  std::string_view get() const {
    if (!owner_) {
      throw std::logic_error("moved-from request");
    }
    return std::string_view(*owner_).substr(offset_);
  }
};
int main() {
  try {
    int rejected = 0;
    for (std::string s : {"", "=x", "missing"}) {
      try {
        Request r(s);
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    check(rejected == 3);
    std::vector<Request> q;
    for (int i = 0; i < 1000; ++i) {
      std::string local = "camera=" + std::to_string(i);
      q.emplace_back(local);
      local.assign(1000, '!');
    }
    for (int i = 0; i < 1000; ++i) {
      check(q[i].get() == std::to_string(i));
    }
    Request empty("k=");
    check(empty.get().empty());
    Request copied = q[3];
    Request moved = std::move(copied);
    check(moved.get() == "3");
    bool failed = false;
    try {
      copied.get();
    } catch (const std::logic_error&) {
      failed = true;
    }
    check(failed);
    const char packet[] = {'k', '=', 'a', '\0', 'b'};
    auto v = value(std::string_view(packet, sizeof(packet)));
    check(v.size() == 3 && v[2] == 'b');
    // view不是C字符串；按长度写出/复制，不把data()交给依赖NUL的API。
    std::string owned(v);
    check(owned.size() == 3);
    bool bounds = false;
    try {
      v.substr(4);
    } catch (const std::out_of_range&) {
      bounds = true;
    }
    check(bounds);
    std::cout << "PASS queued=1000 invalid=3 empty=1 embedded_NUL=1 moved_from_rejected=1 "
                 "substr_range=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
