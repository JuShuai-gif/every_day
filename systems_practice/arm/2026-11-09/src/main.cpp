#include <arm_neon.h>

#include <array>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <vector>
// 四行planar输入转换为逐像素四通道，尾部只访问有效像素。
void pack(const std::vector<float>& in, size_t w, size_t stride, std::vector<float>& out) {
  if (stride < w || in.size() / 4 < stride || out.size() / 4 < w) {
    throw std::invalid_argument("short buffer");
  }
  size_t x = 0;
  for (; x + 4 <= w; x += 4) {
    float32x4x4_t lanes;
    for (size_t c = 0; c < 4; ++c) {
      lanes.val[c] = vld1q_f32(&in[c * stride + x]);
    }
    vst4q_f32(&out[x * 4], lanes);
  }
  for (; x < w; ++x) {
    for (size_t c = 0; c < 4; ++c) {
      out[4 * x + c] = in[c * stride + x];
    }
  }
}

class Pool {
  std::array<std::shared_ptr<std::vector<float>>, 2> slots;

 public:
  explicit Pool(size_t width) {
    if (width > 8193) {
      throw std::invalid_argument("capacity");
    }
    for (auto& s : slots) {
      s = std::make_shared<std::vector<float>>(4 * width);
    }
  }
  std::shared_ptr<const std::vector<float>> acquire(const std::vector<float>& in, size_t width) {
    for (auto& s : slots) {
      // pool本身持有一份，消费者仍持有时禁止复用。仅单线程使用。
      if (s.use_count() == 1) {
        pack(in, width, width, *s);
        return s;
      }
    }
    return {};
  }
};
int main() {
  try {
    int cases = 0;
    for (size_t w : {0, 1, 3, 4, 5, 17, 8193}) {
      Pool pool(w);
      std::vector<float> a(w * 4), b(w * 4);
      for (size_t i = 0; i < a.size(); ++i) {
        a[i] = float(i % 31);
        b[i] = a[i] + 100;
      }
      auto x = pool.acquire(a, w);
      auto y = pool.acquire(b, w);
      if (!x || !y || pool.acquire(a, w)) {
        throw std::logic_error("capacity lease");
      }
      for (size_t c = 0; c < 4; ++c) {
        for (size_t i = 0; i < w; ++i) {
          if ((*x)[4 * i + c] != a[c * w + i] || (*y)[4 * i + c] != b[c * w + i]) {
            throw std::logic_error("oracle");
          }
        }
      }
      auto address = x.get();
      x.reset();
      auto z = pool.acquire(b, w);
      if (z.get() != address || *z != *y) {
        throw std::logic_error("reclamation");
      }
      ++cases;
    }
    int rejected = 0;
    try {
      Pool bad(8194);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    try {
      Pool p(1);
      p.acquire({}, 1);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    if (rejected != 2) {
      return 1;
    }
    std::cout << "PASS " << cases
              << " widths: two leases, busy rejection, reclaim, NEON oracle; 2 invalid inputs\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
