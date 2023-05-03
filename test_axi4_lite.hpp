#ifndef TEST_AXI4_LITE_HPP_
#define TEST_AXI4_LITE_HPP_

#include "Vaxi4_lite_master_read_state.h"

class test_axi4_lite:
    public sc_core::sc_module   {
 public:
    sc_clock ACLK;

    sc_signal<bool> ARESETn;
    sc_signal<bool> ARVALID;
    sc_signal<bool> ARREADY;
    sc_signal<bool> RVALID;
    sc_signal<bool> RREADY;
    sc_signal<bool> USR_ENA;
    sc_signal<uint32_t> USR_WSTB;

    Vaxi4_lite_master_read_state *dut;

    sc_event aclk_posedge_event;

    SC_HAS_PROCESS(test_axi4_lite);
    explicit test_axi4_lite(sc_core::sc_module_name name):
        ACLK("ACLK", 10, SC_NS) {
            //u_half_adder = new Vhalf_adder{"half_adder", "Vhalf_adder", 0, NULL};
            dut = new Vaxi4_lite_master_read_state("Vaxi4_lite_master_read_state");

            dut->ACLK(ACLK);
            dut->ARESETn(ARESETn);
            dut->ARVALID(ARVALID);
            dut->ARREADY(ARREADY);
            dut->RVALID(RVALID);
            dut->RREADY(RREADY);
            dut->USR_ENA(USR_ENA);
            dut->USR_WSTB(USR_WSTB);

            SC_THREAD(thread);
            SC_METHOD(clock_method);
                sensitive << ACLK.posedge_event();
            SC_METHOD(arready_method);
                sensitive << ARVALID.posedge_event();
            SC_METHOD(rvalid_method);
                sensitive << RREADY.posedge_event();
        }

    void thread();
    void clock_method() {
        aclk_posedge_event.notify();
    };
    void arready_method();
    void rvalid_method();

    ~test_axi4_lite() {
        delete dut;
    }
};

#endif  // TEST_AXI4_LITE_HPP_
