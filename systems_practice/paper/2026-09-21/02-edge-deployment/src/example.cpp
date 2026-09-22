#include "lesson.hpp"
using namespace lesson;
constexpr size_t block = 256;
struct Storage {
  std::string mode;
  Bytes bytes;
  Vec decoded;
};
Storage serialize(const Vec& w) {
  require(!w.empty(), "empty weights");
  Storage result;
  if (w.size() % block) {
    result.mode = "fp16_fallback";
    for (double x : w) {
      put(result.bytes, half_bits(x), 2);
    }
    size_t pos = 0;
    while (pos < result.bytes.size()) {
      result.decoded.push_back(from_half(uint16_t(get(result.bytes, pos, 2))));
    }
    return result;
  }
  result.mode = "custom_u4";
  for (size_t start = 0; start < w.size(); start += block) {
    double peak = 0;
    for (size_t i = start; i < start + block; ++i) {
      peak = std::max(peak, std::abs(w[i]));
    }
    const float scale = peak ? float(peak / 7) : 1;
    put_float(result.bytes, scale);
    std::vector<int> codes;
    for (size_t i = start; i < start + block; ++i) {
      codes.push_back(int(std::clamp(std::nearbyint(w[i] / scale), -7.0, 7.0)) + 8);
    }
    const auto payload = pack_u4(codes);
    result.bytes.insert(result.bytes.end(), payload.begin(), payload.end());
  }
  // 只从物理字节读回 scale 与 nibble，不借用输入权重作解码。
  size_t pos = 0;
  while (pos < result.bytes.size()) {
    const double scale = get_float<float>(result.bytes, pos);
    Bytes payload(result.bytes.begin() + pos, result.bytes.begin() + pos + block / 2);
    pos += block / 2;
    for (int q : unpack_u4(payload, block)) {
      result.decoded.push_back((q - 8) * scale);
    }
  }
  return result;
}
int main() {
  try {
    Random rng(21);
    Vec w(1024), x(1024);
    for (auto& v : w) {
      v = 2 * rng.uniform() - 1;
    }
    for (auto& v : x) {
      v = 2 * rng.uniform() - 1;
    }
    require(serialize(Vec(block, 0)).decoded == Vec(block, 0), "zero block");
    require(serialize(Vec(block - 1, 0)).mode == "fp16_fallback", "unaligned tail");
    Vec exact(block);
    for (size_t i = 0; i < block; ++i) {
      exact[i] = int(i % 15) - 7;
    }
    require(serialize(exact).decoded == exact, "exact nibble roundtrip");
    bool rejected = false;
    try {
      serialize({});
    } catch (const std::runtime_error&) {
      rejected = true;
    }
    require(rejected, "empty accepted");
    const double reference = dot(w, x);
    std::cout << std::setprecision(17)
              << "{\"kind\":\"independent_cpp_custom_format_not_gguf\",\"cases\":[";
    const std::vector<size_t> widths = {1024, 922, 768};
    const std::vector<std::string> names = {
        "baseline", "prune_target_10pct", "round_down_to_aligned_width"};
    for (size_t i = 0; i < widths.size(); ++i) {
      if (i) {
        std::cout << ',';
      }
      const size_t kept = widths[i];
      const Vec prefix(w.begin(), w.begin() + kept), inputs(x.begin(), x.begin() + kept);
      const auto s = serialize(prefix);
      require(s.bytes.size() == (kept % block ? kept * 2 : kept / block * (4 + block / 2)),
              "storage size");
      std::cout << "{\"case\":\"" << names[i] << "\",\"kept_width\":" << kept
                << ",\"actual_pruned_fraction\":" << 1 - double(kept) / 1024
                << ",\"storage_mode\":\"" << s.mode
                << "\",\"payload_and_scales_bytes\":" << s.bytes.size()
                << ",\"abs_error_vs_original\":" << std::abs(dot(s.decoded, inputs) - reference)
                << ",\"abs_storage_error_vs_pruned_reference\":"
                << std::abs(dot(s.decoded, inputs) - dot(prefix, inputs)) << '}';
    }
    std::cout << "],\"checks\":[\"zero_block\",\"unaligned_tail\",\"exact_nibble_roundtrip\","
                 "\"actual_byte_lengths\",\"empty_rejected\"]}\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
