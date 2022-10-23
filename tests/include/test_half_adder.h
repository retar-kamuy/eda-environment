#ifndef TEST_HALF_ADDER_H_
#define TEST_HALF_ADDER_H_

#include "Vhalf_adder.h"

class test_half_adder:
    public sc_core::sc_module   {
 public:
    sc_clock clk;

    sc_signal<bool> a;
    sc_signal<bool> b;
    sc_signal<bool> sum;
    sc_signal<bool> carry;

    Vhalf_adder *u_half_adder;

    SC_HAS_PROCESS(test_half_adder);
    explicit test_half_adder(sc_core::sc_module_name name):
        clk("clk", 10, SC_NS, 0.5, 3, SC_NS, true)  {
        //u_half_adder = new Vhalf_adder{"half_adder", "Vhalf_adder", 0, NULL};
        u_half_adder = new Vhalf_adder{"half_adder", "Vhalf_adder"};
        u_half_adder->clk(clk);
        u_half_adder->a(a);
        u_half_adder->b(b);
        u_half_adder->sum(sum);
        u_half_adder->carry(carry);

        SC_THREAD(thread);
    }

    void thread();

    ~test_half_adder() {
        delete u_half_adder;
    }
};

#endif  // TEST_HALF_ADDER_H_
