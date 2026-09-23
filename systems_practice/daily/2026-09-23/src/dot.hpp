#pragma once
#include <cstddef>
#include <cstdint>

// 一个块最多32个INT8乘积；块间先乘各自scale，再累加FP32。
using BlockDot = std::int32_t (*)(const std::int8_t*, const std::int8_t*, std::size_t);
std::int32_t scalar_dot(const std::int8_t*, const std::int8_t*, std::size_t);
std::int32_t neon_dot(const std::int8_t*, const std::int8_t*, std::size_t);
std::int32_t optional_dot(const std::int8_t*, const std::int8_t*, std::size_t);
bool has_compiled_dot();
float scaled_dot(
    const std::int8_t*, const std::int8_t*, const float*, const float*, std::size_t, BlockDot);
