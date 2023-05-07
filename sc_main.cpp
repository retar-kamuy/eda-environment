#include <systemc.h>
#include "Vaxilm.h"
#include "verilated_vcd_sc.h"
#include "test_axil.hpp"

#include <gtest/gtest.h>

TEST(systemc_test, test1) {
    printf("Built with %s %s.\n", Verilated::productName(), Verilated::productVersion());
    printf("Recommended: Verilator 4.0 or later.\n");

    //Verilated::commandArgs(argc, argv);
    test_axil* top = new test_axil("top");

    sc_start(0, SC_NS);

    // Tracing (vcd)
    VerilatedVcdSc* tfp = NULL;
    // If verilator was invoked with --trace argument,
    // and if at run time passed the +trace argument, turn on tracing
    //const char* flag_vcd = Verilated::commandArgsPlusMatch("trace");
    //if (flag_vcd && 0 == strcmp(flag_vcd, "+trace")) {
    //    std::cout << "VCD dump on" << std::endl;
    //    Verilated::traceEverOn(true);
    //    tfp = new VerilatedVcdSc;
    //    top->dut->trace(tfp, 99);
    //    tfp->open("simx.vcd");
    //}

    sc_start(-1, SC_NS);

    //if (tfp) {
    //    tfp->flush();
    //    tfp->close();
    //    tfp = NULL;
    //}
    delete top;
    EXPECT_EQ(7 * 6, 42);
}

int sc_main(int argc, char** argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
    return 0;
}
