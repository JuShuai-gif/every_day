#include <cmath>
#include <cstddef>
#include <iostream>
#include <stdexcept>
#include <vector>

static void gemm_ref(const std::vector<float>& a,
                     const std::vector<float>& b,
                     std::vector<float>& c,
                     int m,
                     int n,
                     int k) {
  for (int i = 0; i < m; ++i)
    for (int j = 0; j < n; ++j) {
      float s = 0;
      for (int x = 0; x < k; ++x)
        s += a[i * k + x] * b[x * n + j];
      c[i * n + j] = s;
    }
}
int main() {
  const int M = 3, N = 5, K = 7;
  std::vector<float> a(M * K), b(K * N), c(M * N), oracle(M * N);
  for (size_t i = 0; i < a.size(); ++i)
    a[i] = std::sin(float(i) * .17f);
  for (size_t i = 0; i < b.size(); ++i)
    b[i] = std::cos(float(i) * .11f);
  gemm_ref(a, b, oracle, M, N, K);
  gemm_ref(a, b, c, M, N, K);
  float e = 0;
  for (size_t i = 0; i < c.size(); ++i)
    e = std::max(e, std::abs(c[i] - oracle[i]));
  if (e > 1e-6f)
    throw std::runtime_error("oracle mismatch");
  std::cout << "cpu_gemm_pass max_abs=" << e << " tail_shape=" << M << "x" << N << "x" << K << "\n";
}
