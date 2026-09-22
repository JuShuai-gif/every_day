cmake_minimum_required(VERSION 3.16)
project(arm_target_inspector LANGUAGES CXX)

# 本节面向 macOS / Linux；uname 是 POSIX 接口，不伪装成标准 C++ API。
if(NOT UNIX)
  message(FATAL_ERROR "This lesson requires a POSIX macOS/Linux environment")
endif()

add_executable(inspect_target src/inspect_target.cpp)
set_target_properties(inspect_target PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED YES
  CXX_EXTENSIONS NO
)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
  target_compile_options(inspect_target PRIVATE -Wall -Wextra -Wpedantic -Werror)
endif()
