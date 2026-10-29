#include <cstdint>
#include <iostream>
#include <vector>

#include "benchmark.hpp"

// 工作只读取 x、y；AoS 仍把无关字段带入缓存，SoA 把热字段分开放置。
struct Particle {
  float x, y, z;
  std::uint32_t id, flags;
};

std::uint64_t aos(const std::vector<Particle>& particles) {
  std::uint64_t sum = 0;
  for (const auto& particle : particles)
    sum += static_cast<std::uint64_t>(particle.x + particle.y);
  return sum;
}

std::uint64_t soa(const std::vector<float>& x, const std::vector<float>& y) {
  std::uint64_t sum = 0;
  for (std::size_t i = 0; i < x.size(); ++i)
    sum += static_cast<std::uint64_t>(x[i] + y[i]);
  return sum;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  constexpr std::size_t count = 1 << 20;
  std::vector<Particle> particles(count);
  std::vector<float> x(count), y(count);
  for (std::size_t i = 0; i < count; ++i) {
    particles[i] = {float(i % 97), float(i % 89), 0.0f, static_cast<std::uint32_t>(i), 0};
    x[i] = particles[i].x;
    y[i] = particles[i].y;
  }
  const auto baseline = aos(particles), optimized = soa(x, y);
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=data_layout\n";
  if (mode != "optimized")
    print_stats("baseline", sample_us([&] {
                  volatile auto z = aos(particles);
                  (void)z;
                }),
                baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us([&] {
                  volatile auto z = soa(x, y);
                  (void)z;
                }),
                optimized);
}
