#include "test_axi4_lite.hpp"

void test_axi4_lite::thread(void)   {
    ARESETn = 0;

    wait(5 * ACLK.period());
    ARESETn = 1;

    wait(5 * ACLK.period());
    USR_ENA = 1;
    wait(ACLK.period());
    USR_ENA = 0;

    wait(10 * ACLK.period());
    sc_stop();
}

void test_axi4_lite::arready_method(void) {
    next_trigger(aclk_posedge_event);
    if (ARREADY == 1 && ARVALID == 1) {
        ARREADY = 0;
    } else if (ARVALID == 1) {
        ARREADY = 1;
    } else {
        ARREADY = 0;
    }
}

void test_axi4_lite::rvalid_method(void) {
    next_trigger(aclk_posedge_event);
    if (RVALID == 1 && RREADY == 1) {
        RVALID = 0;
    } else if (RREADY == 1) {
        RVALID = 1;
    } else {
        RVALID = 0;
    }
}
