#include <iostream>
#include <stdexcept>
// 仅检查所有权状态机；不冒充 CUDA 事件或 TensorRT 验证。
struct Lease {
  bool submitted = false, consumed = false, complete = false;
  void submit() {
    if (submitted) {
      throw std::logic_error("context busy");
    }
    submitted = true;
  }
  void input_ready() {
    if (!submitted) {
      throw std::logic_error("not submitted");
    }
    consumed = true;
  }
  void done() {
    if (!submitted) {
      throw std::logic_error("not submitted");
    }
    consumed = true;
    complete = true;
  }
  bool can_recycle_input() const {
    return !submitted || consumed;
  }
  bool can_recycle_output() const {
    return !submitted || complete;
  }
};
int main() {
  try {
    int checked = 0;
    for (int order = 0; order < 2; ++order) {
      Lease s;
      s.submit();
      if (s.can_recycle_input() || s.can_recycle_output()) {
        throw std::runtime_error("early reuse");
      }
      if (order == 0) {
        s.input_ready();
        if (!s.can_recycle_input() || s.can_recycle_output()) {
          throw std::runtime_error("boundary");
        }
      }
      s.done();
      if (!s.can_recycle_input() || !s.can_recycle_output()) {
        throw std::runtime_error("late reuse");
      }
      ++checked;
    }
    bool invalid = false;
    try {
      Lease s;
      s.submit();
      s.submit();
    } catch (const std::logic_error&) {
      invalid = true;
    }
    if (!invalid) {
      return 1;
    }
    std::cout << "CPU lease PASS " << checked
              << " completion orders, context reentry rejected; CUDA/TRT untested\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
