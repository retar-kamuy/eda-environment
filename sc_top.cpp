#include "sc_top.h"

SC_MODULE_EXPORT(sc_top);

int sc_main(int argc, char* argv[]) {
    sc_top* u_sc_top = new sc_top("sc_top");

    sc_start(1, SC_NS);

    cout << "done, time = " << sc_time_stamp() << endl;
    delete u_sc_top;
    return 0;
}