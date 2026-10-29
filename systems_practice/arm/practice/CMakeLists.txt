cmake_minimum_required(VERSION 3.16)
project(rk3588_optimization_practice LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

foreach(lesson IN ITEMS 01 02 03 04 05 06 07 08 09 10)
  add_executable(example_${lesson} examples/${lesson}/main.cpp)
  target_include_directories(example_${lesson} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
  target_compile_options(example_${lesson} PRIVATE -O3 -Wall -Wextra -Wpedantic)
endforeach()

find_package(Threads REQUIRED)
target_link_libraries(example_08 PRIVATE Threads::Threads)
