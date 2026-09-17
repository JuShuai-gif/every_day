cmake_minimum_required(VERSION 3.16)
project(vla_frame_arena LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(frame_arena src/main.cpp)
target_compile_options(frame_arena PRIVATE -Wall -Wextra -Wpedantic)
