cmake_minimum_required(VERSION 3.14)

project(axil)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

set(CMAKE_CC_COMPILER "clang")
set(CMAKE_CXX_COMPILER "clang++")

set(target Vaxilm)

add_executable(${target} sc_main.cpp test_axil.cpp)
verilate(${target}
    SYSTEMC
    SOURCES src/axilm.sv src/axilm_rd_ch.sv src/axilm_wr_ch.sv
    TRACE
    VERILATOR_ARGS --Wno-lint --Wall
)

verilator_link_systemc(${target})
