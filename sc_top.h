#include "Vour.h"

class sc_top:
    public sc_core::sc_module
{
public:
    sc_clock clk;

    Vour *u_top;

    SC_HAS_PROCESS(sc_top);
    sc_top(sc_core::sc_module_name name):
        clk("clk", 10, SC_NS, 0.5, 3, SC_NS, true)
    {
        u_top = new Vour{"top", "Vour"};
        u_top->clk(clk);
    }

    ~sc_top() {
        delete u_top;
    }
};