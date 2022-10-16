#ifndef TESTS_INCLUDE_SC_TOP_H_
#define TESTS_INCLUDE_SC_TOP_H_

#include "Vour.h"

class sc_top:
    public sc_core::sc_module   {
 public:
    sc_clock clk;

    Vour *u_top;

    SC_HAS_PROCESS(sc_top);
    explicit sc_top(sc_core::sc_module_name name):
        clk("clk", 10, SC_NS, 0.5, 3, SC_NS, true)  {
#ifdef MODELSIM
        u_top = new Vour{"top", "Vour"};
#else
        u_top = new Vour{"top"};
#endif
        u_top->clk(clk);
    }

    ~sc_top() {
        delete u_top;
    }
};

#endif  // TESTS_INCLUDE_SC_TOP_H_
