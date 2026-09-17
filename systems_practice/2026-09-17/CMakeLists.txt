cmake_minimum_required(VERSION 3.16)
project(rknn_stride_binding LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Mac 只构建可移植参考；板端传入 -DRKNN_API_ROOT=/path/to/rknpu2/runtime/Linux/librknn_api。
add_executable(cpu_stride_check src/preprocess_cpu.cpp)
target_compile_options(cpu_stride_check PRIVATE -Wall -Wextra -Wpedantic)

# 有 clang-format 时提供显式格式目标；缺工具不影响 Mac CPU 参考构建。
find_program(CLANG_FORMAT_EXECUTABLE clang-format)
if(CLANG_FORMAT_EXECUTABLE)
  add_custom_target(format
    COMMAND "${CLANG_FORMAT_EXECUTABLE}" -i -style=file
            "${CMAKE_CURRENT_SOURCE_DIR}/src/preprocess_cpu.cpp"
            "${CMAKE_CURRENT_SOURCE_DIR}/src/rknn_stride_binding.cpp"
    COMMENT "按仓库 .clang-format 格式化 C++ 源码")
endif()

if(RKNN_API_ROOT)
  find_path(RKNN_INCLUDE_DIR rknn_api.h PATHS "${RKNN_API_ROOT}/include" REQUIRED)
  find_library(RKNN_RUNTIME rknnrt PATHS "${RKNN_API_ROOT}/aarch64" "${RKNN_API_ROOT}/lib" REQUIRED)
  add_executable(rknn_stride_binding src/rknn_stride_binding.cpp)
  target_include_directories(rknn_stride_binding PRIVATE "${RKNN_INCLUDE_DIR}")
  target_link_libraries(rknn_stride_binding PRIVATE "${RKNN_RUNTIME}")
endif()
