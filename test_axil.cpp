#include <gtest/gtest.h>

#include "test_axil.hpp"

#ifdef MTI_SYSTEMC
SC_MODULE_EXPORT(test_axil);
#endif  // MTI_SYSTEMC

void test_axil::thread(void)   {
    ARESETn = 0;

    wait(5 * ACLK.period());
    ARESETn = 1;

    wait(5 * ACLK.period());

    wait(aclk_posedge_event);
    BUS_ENA = 1;
    wait(aclk_posedge_event);
    BUS_ENA = 0;

    wait(10 * ACLK.period());
    sc_stop();
}

void test_axil::arready_method(void) {
    next_trigger(aclk_posedge_event);
    if (ARREADY == 1 && ARVALID == 1) {
        ARREADY = 0;
    } else if (ARVALID == 1) {
        ARREADY = 1;
    } else {
        ARREADY = 0;
    }
}

void test_axil::rvalid_method(void) {
    next_trigger(aclk_posedge_event);
    if (RVALID == 1 && RREADY == 1) {
        RVALID = 0;
    } else if (RREADY == 1) {
        RVALID = 1;
    } else {
        RVALID = 0;
    }
}
