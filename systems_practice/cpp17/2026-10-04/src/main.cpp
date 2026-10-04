#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <utility>
struct Record {
  int pending = 0;
  inline static int copies = 0;
  inline static bool fail = false;
  Record() = default;
  explicit Record(int n) : pending(n) {
  }
  Record(const Record& r) : pending(r.pending) {
    if (fail) {
      throw std::runtime_error("copy failed");
    }
    ++copies;
  }
  Record(Record&&) = default;
};
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("binding check failed");
  }
}
int main() {
  try {
    std::map<std::string, Record> requests;
    requests.try_emplace("camera0", 3);
    requests.try_emplace("camera1", 5);
    // 值绑定复制隐藏的pair，修改的是副本。
    for (auto [name, record] : requests) {
      record.pending = 0;
      check(!name.empty());
    }
    check(requests.at("camera0").pending == 3 && Record::copies == 2);
    // 引用绑定直接引用map节点；key仍是const。
    for (auto& [name, record] : requests) {
      static_assert(std::is_const_v<std::remove_reference_t<decltype(name)>>);
      static_assert(std::is_same_v<decltype(record), Record>);
      static_assert(std::is_same_v<decltype((record)), Record&>);
      record.pending = 0;
    }
    check(requests.at("camera1").pending == 0 && Record::copies == 2);
    Record::fail = true;
    bool rejected = false;
    try {
      auto [key, value] = *requests.begin();
      (void)key;
      (void)value;
    } catch (const std::runtime_error&) {
      rejected = true;
    }
    check(rejected && requests.size() == 2 && requests.begin()->second.pending == 0);
    Record::fail = false;
    std::map<std::string, Record> empty;
    for (auto& [key, value] : empty) {
      (void)key;
      value.pending = 99;
    }
    auto [it, inserted] = requests.try_emplace("camera0", 88);
    check(!inserted && it->second.pending == 0);
    // 延长临时pair寿命到引用变量作用域；不把这些引用逃逸出去。
    const auto& [id, status] = std::make_pair(7, std::string("ready"));
    check(id == 7 && status == "ready");
    std::cout << "PASS value bindings copies=2; reference edits=2 copies=0; throwing copy leaves "
                 "map unchanged; empty; duplicate insert; temporary lifetime; decltype checks\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
