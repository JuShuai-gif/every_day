#include <array>
#include <cstdint>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <vector>
void check(bool x) {
  if (!x) {
    throw std::runtime_error("contract");
  }
}
struct Page {
  std::array<uint8_t, 4096> bytes{};
};
struct Mapping {
  std::shared_ptr<Page> page;
  bool writable;
  bool cow;
};
struct Space {
  std::vector<Mapping> maps;
  size_t copies = 0;
  Space fork() {
    Space child;
    child.maps = maps;  // 先完成可能抛异常的容器分配，再修改父权限。
    for (size_t i = 0; i < maps.size(); ++i) {
      if (maps[i].writable) {
        maps[i].writable = false;
        maps[i].cow = true;
        child.maps[i].writable = false;
        child.maps[i].cow = true;
      }
    }
    return child;
  }
  void write(size_t address, uint8_t value, bool inject_oom = false) {
    if (address / 4096 >= maps.size()) {
      throw std::out_of_range("address");
    }
    auto& m = maps[address / 4096];
    if (!m.writable) {
      if (!m.cow) {
        throw std::runtime_error("text write forbidden");
      }
      if (m.page.use_count() > 1) {
        if (inject_oom) {
          throw std::bad_alloc();
        }
        auto candidate = std::make_shared<Page>(*m.page);
        m.page = std::move(candidate);
        ++copies;  // 复制成功才提交映射，旧页引用随后释放。
      }
      m.writable = true;
      m.cow = false;
    }
    m.page->bytes[address % 4096] = value;
  }
  uint8_t read(size_t address) const {
    return maps.at(address / 4096).page->bytes.at(address % 4096);
  }
};
int main() {
  try {
    size_t cases = 0;
    for (size_t offset = 0; offset < 4096; ++offset) {
      Space parent;
      parent.maps.push_back({std::make_shared<Page>(), true, false});
      parent.write(offset, 7);
      auto child = parent.fork();
      check(parent.maps[0].page.use_count() == 2);
      auto original = child.maps[0].page.get();
      bool failed = false;
      try {
        child.write(offset, 9, true);
      } catch (const std::bad_alloc&) {
        failed = true;
      }
      check(failed && child.maps[0].page.get() == original && child.read(offset) == 7 &&
            child.maps[0].cow);
      child.write(offset, 9);
      check(parent.read(offset) == 7 && child.read(offset) == 9 && child.copies == 1);
      child.write(offset, 10);
      check(child.copies == 1);
      parent.write(offset, 11);
      check(parent.copies == 0 && child.read(offset) == 10);
      ++cases;
    }
    Space text;
    text.maps.push_back({std::make_shared<Page>(), false, false});
    auto child = text.fork();
    bool denied = false;
    try {
      child.write(0, 1);
    } catch (const std::runtime_error&) {
      denied = true;
    }
    check(denied);
    bool range = false;
    try {
      child.write(4096, 1);
    } catch (const std::out_of_range&) {
      range = true;
    }
    check(range);
    // 多代共享与最终引用回收。
    std::weak_ptr<Page> weak;
    {
      Space p;
      p.maps.push_back({std::make_shared<Page>(), true, false});
      weak = p.maps[0].page;
      auto c = p.fork();
      auto g = c.fork();
      g.write(0, 3);
      check(p.read(0) == 0 && c.read(0) == 0);
    }
    check(weak.expired());
    std::cout << "PASS offsets=" << cases << " OOM rollback=" << cases
              << " read_only=1 bounds=1 multigeneration=1 released=1\n";
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << "\n";
    return 1;
  }
}
