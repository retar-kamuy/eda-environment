#ifndef TEST_AXIL_HPP_
#define TEST_AXIL_HPP_

#include <systemc.h>
#include "Vaxilm.h"

class test_axil:
    public sc_core::sc_module {
 public:
    sc_clock ACLK;
    sc_signal<bool> ARESETn;
#ifndef MTI_SYSTEMC
    sc_signal<uint32_t> AWADDR;
    sc_signal<uint32_t> AWPROT;
    sc_signal<bool> AWVALID;
    sc_signal<bool> AWREADY;
    // Write Data Channel
    sc_signal<uint32_t> WDATA;
    sc_signal<uint32_t> WSTRB;
    sc_signal<bool> WVALID;
    sc_signal<bool> WREADY;
    // Write Response Channel
    sc_signal<bool> BVALID;
    sc_signal<bool> BREADY;
    sc_signal<uint32_t> BRESP;
    // Read Address Channel
    sc_signal<uint32_t> ARADDR;
    sc_signal<uint32_t> ARPROT;
    sc_signal<bool> ARVALID;
    sc_signal<bool> ARREADY;
    // Read Data Channel
    sc_signal<uint32_t> RDATA;
    sc_signal<uint32_t> RRESP;
    sc_signal<bool> RVALID;
    sc_signal<bool> RREADY;
    // Local Inerface
    sc_signal<bool> BUS_ENA;
    sc_signal<uint32_t> BUS_WSTB;
    sc_signal<uint32_t> BUS_ADDR;
    sc_signal<uint32_t> BUS_WDATA;
    sc_signal<uint32_t> BUS_RDATA;
    sc_signal<uint32_t> BUS_BRESP;
    sc_signal<uint32_t> BUS_RRESP;
#else
    sc_signal<sc_uint<32> > AWADDR;
    sc_signal<sc_uint<3> > AWPROT;
    sc_signal<bool> AWVALID;
    sc_signal<bool> AWREADY;
    // Write Data Channel
    sc_signal<sc_uint<32> > WDATA;
    sc_signal<sc_uint<4> > WSTRB;
    sc_signal<bool> WVALID;
    sc_signal<bool> WREADY;
    // Write Response Channel
    sc_signal<bool> BVALID;
    sc_signal<bool> BREADY;
    sc_signal<sc_uint<2> > BRESP;
    // Read Address Channel
    sc_signal<sc_uint<32> > ARADDR;
    sc_signal<sc_uint<3> > ARPROT;
    sc_signal<bool> ARVALID;
    sc_signal<bool> ARREADY;
    // Read Data Channel
    sc_signal<sc_uint<32> > RDATA;
    sc_signal<sc_uint<2> > RRESP;
    sc_signal<bool> RVALID;
    sc_signal<bool> RREADY;
    // Local Inerface
    sc_signal<bool> BUS_ENA;
    sc_signal<sc_uint<4> > BUS_WSTB;
    sc_signal<sc_uint<32> > BUS_ADDR;
    sc_signal<sc_uint<32> > BUS_WDATA;
    sc_signal<sc_uint<32> > BUS_RDATA;
    sc_signal<sc_uint<2> > BUS_BRESP;
    sc_signal<sc_uint<2> > BUS_RRESP;
#endif  // MTI_SYSTEMC

    Vaxilm *dut;

    sc_event aclk_posedge_event;

    SC_HAS_PROCESS(test_axil);
    explicit test_axil(sc_core::sc_module_name name):
        ACLK("ACLK", 10, SC_NS) {
#ifndef MTI_SYSTEMC
        dut = new Vaxilm("Vaxilm");
#else
        dut = new Vaxilm{"top", "Vaxilm"};
#endif  // MTI_SYSTEMC

        dut->ACLK(ACLK);
        dut->ARESETn(ARESETn);
        dut->AWADDR(AWADDR);
        dut->AWPROT(AWPROT);
        dut->AWVALID(AWVALID);
        dut->AWREADY(AWREADY);
        dut->WDATA(WDATA);
        dut->WSTRB(WSTRB);
        dut->WVALID(WVALID);
        dut->WREADY(WREADY);
        dut->BVALID(BVALID);
        dut->BREADY(BREADY);
        dut->BRESP(BRESP);
        dut->ARADDR(ARADDR);
        dut->ARPROT(ARPROT);
        dut->ARVALID(ARVALID);
        dut->ARREADY(ARREADY);
        dut->RDATA(RDATA);
        dut->RRESP(RRESP);
        dut->RVALID(RVALID);
        dut->RREADY(RREADY);
        dut->BUS_ENA(BUS_ENA);
        dut->BUS_WSTB(BUS_WSTB);
        dut->BUS_ADDR(BUS_ADDR);
        dut->BUS_WDATA(BUS_WDATA);
        dut->BUS_RDATA(BUS_RDATA);
        dut->BUS_BRESP(BUS_BRESP);
        dut->BUS_RRESP(BUS_RRESP);

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
#endif  // MTI_SYSTEMC
        delete dut;
    }
};

#endif  // TEST_AXIL_HPP_
