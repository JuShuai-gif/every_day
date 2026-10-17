#include "config.hpp"
const Config* other_config() {
  return &config;
}
const Config* other_local() {
  return &local_config;
}
const std::nullopt_t* other_nullopt() {
  return &std::nullopt;
}
void other_increment() {
  accepted.fetch_add(1, std::memory_order_relaxed);
}
