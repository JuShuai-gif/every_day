#include "common.hpp"
namespace practice {
void reference(const float* input, float* output, int batch) {
  const auto count = elements(batch);
  if (!input || !output)
    throw std::invalid_argument("null tensor");
  for (std::size_t i = 0; i < count; ++i)
    output[i] = std::max(0.0F, input[i] * 0.5F + 0.25F);
}
}  // namespace practice
