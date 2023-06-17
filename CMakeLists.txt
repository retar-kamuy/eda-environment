cmake_minimum_required(VERSION 3.14)

project(axil)

set(CMAKE_CC_COMPILER "/usr/bin/clang")
set(CMAKE_CXX_COMPILER "/usr/bin/clang++")

set(target Vaxilm)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_executable(${target} sc_main.cpp test_axil.cpp)

include_directories(/opt/googletest-1.13.0/include)

set(VERILATOR_ARGS CACHE STRING "")

verilate(${target}
    SYSTEMC
    SOURCES src/axilm.sv src/axilm_rd_ch.sv src/axilm_wr_ch.sv
    VERILATOR_ARGS --Wno-lint --Wall ${VERILATOR_ARGS} -LDFLAGS "-L/opt/googletest-1.13.0/lib -lgtest -lpthread"
)

verilator_link_systemc(${target})

# CTest
include(GoogleTest)
gtest_discover_tests(${target})
