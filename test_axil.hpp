#ifndef TEST_AXIL_HPP_
#define TEST_AXIL_HPP_

#include <systemc.h>
#include "Vaxilm_rd_ch.h"

class test_axil:
    public sc_core::sc_module {
 public:
    sc_clock ACLK;

    sc_signal<bool> ARESETn;
    sc_signal<bool> ARVALID;
    sc_signal<bool> ARREADY;
    sc_signal<bool> RVALID;
    sc_signal<bool> RREADY;
    sc_signal<bool> USR_ENA;
#ifndef MTI_SYSTEMC
    sc_signal<uint32_t> USR_WSTB;
#else
    sc_signal<sc_uint<4>> USR_WSTB;
#endif  // VERILATOR

    Vaxilm_rd_ch *dut;

    sc_event aclk_posedge_event;

    SC_HAS_PROCESS(test_axil);
    explicit test_axil(sc_core::sc_module_name name):
        ACLK("ACLK", 10, SC_NS) {
#ifndef MTI_SYSTEMC
        dut = new Vaxilm_rd_ch("Vaxilm_rd_ch");
#else
        dut = new Vaxilm_rd_ch{"top", "Vaxilm_rd_ch"};
#endif  // VERILATOR

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
    }
    void arready_method();
    void rvalid_method();

    ~test_axil() {
#ifndef MTI_SYSTEMC
        dut->final();
#endif  // VERILATOR
        delete dut;
    }
};

#endif  // TEST_AXIL_HPP_
