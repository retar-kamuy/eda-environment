#include <systemc.h>
#include "Vaxi4_lite_master_read_state.h"
#include "verilated_vcd_sc.h"
#include "test_axi4_lite.hpp"

int sc_main(int argc, char** argv) {
    printf("Built with %s %s.\n", Verilated::productName(), Verilated::productVersion());
    printf("Recommended: Verilator 4.0 or later.\n");

    Verilated::commandArgs(argc, argv);
    test_axi4_lite* top = new test_axi4_lite("top");

    sc_start(0, SC_NS);

    // Tracing (vcd)
    VerilatedVcdSc* tfp = NULL;
    // If verilator was invoked with --trace argument,
    // and if at run time passed the +trace argument, turn on tracing
    const char* flag_vcd = Verilated::commandArgsPlusMatch("trace");
    if (flag_vcd && 0==strcmp(flag_vcd, "+trace")) {
        std::cout << "VCD dump on" << std::endl;
        Verilated::traceEverOn(true);
        tfp = new VerilatedVcdSc;
        top->dut->trace(tfp, 99);
        tfp->open("testbench.vcd");
    }

    sc_start(-1, SC_NS);

    if (tfp) {
        tfp->flush();
        tfp->close();
        tfp = NULL;
    }
    top->dut->final();
    delete top;
    return 0;
}