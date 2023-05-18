cmake_minimum_required(VERSION 3.8)

project(CrossBuildTest LANGUAGES CXX)

# Find fmt
# Test whether the toolchain works correctly and we are able to find the
# libraries in sysroot
find_package(fmt REQUIRED)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(${PROJECT_NAME} CrossBuildTest.cpp)
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 17)
target_link_libraries(${PROJECT_NAME} PUBLIC fmt::fmt)

add_executable(ExamplePThread ExamplePThread.cpp)
set_target_properties(ExamplePThread PROPERTIES CXX_STANDARD 17)
target_link_libraries(ExamplePThread PUBLIC pthread rt)
