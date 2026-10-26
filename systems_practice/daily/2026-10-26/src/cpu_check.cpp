#include <iostream>

#include "contract.hpp"
int main() {
  try {
    int frames = 0, rejected = 0;
    for (int n : {1, 3, 4, 5, 31, 32, 33, 257, 4097, 65539}) {
      GraphKey key{n, 0, 1, 2, 3, 1};
      ReplayGate gate(key);
      auto reject = [&](auto operation) {
        try {
          operation();
        } catch (const std::runtime_error&) {
          ++rejected;
          return;
        }
        throw std::runtime_error("expected rejection");
      };
      reject([&] {
        gate.submit(key);
      });
      gate.captured();
      for (int i = 0; i < 20; ++i) {
        auto x = inputs(n, i);
        std::vector<float> y(n);
        gate.submit(key);
        reject([&] {
          gate.submit(key);
        });
        // 独立标量对照只证明数值合同，不模拟CUDA调度或设备性能。
        for (int j = 0; j < n; ++j) {
          y[j] = std::max(0.0f, x[j] * 0.5f + 0.25f);
        }
        check(x, y.data());
        gate.complete();
        ++frames;
      }
      for (int field = 0; field < 6; ++field) {
        auto bad = key;
        if (field == 0) {
          ++bad.n;
        }
        if (field == 1) {
          ++bad.profile;
        }
        if (field == 2) {
          ++bad.context;
        }
        if (field == 3) {
          ++bad.input;
        }
        if (field == 4) {
          ++bad.output;
        }
        if (field == 5) {
          ++bad.generation;
        }
        reject([&] {
          gate.submit(bad);
        });
      }
      reject([&] {
        gate.complete();
      });
    }
    for (int n : {0, -1, 65540}) {
      try {
        checked_size(n);
        throw std::logic_error("missing rejection");
      } catch (const std::runtime_error&) {
        ++rejected;
      }
    }
    std::cout << "PASS frames=" << frames << " rejected=" << rejected << " no_GPU_claim\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
