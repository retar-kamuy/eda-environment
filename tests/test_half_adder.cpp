#include "test_half_adder.h"

SC_MODULE_EXPORT(test_half_adder);

int sc_main(int argc, char* argv[]) {
    test_half_adder* u_test_half_adder = new test_half_adder("test_half_adder");

    // sc_start(1, SC_NS);
    sc_start(-1);

    cout << "done, time = " << sc_time_stamp() << endl;
    delete u_test_half_adder;
    return 0;
}

void test_half_adder::thread(void)   {
    a.write(0);
    b.write(0);
    wait(10, SC_NS);
    cout << "time = " << sc_time_stamp()
         << "sum = " << sum.read() << ", carry = " << carry.read() << endl;

    a.write(0);
    b.write(1);
    wait(10, SC_NS);
    cout << "time = " << sc_time_stamp()
         << "sum = " << sum.read() << ", carry = " << carry.read() << endl;

    a.write(1);
    b.write(0);
    wait(10, SC_NS);
    cout << "time = " << sc_time_stamp()
         << "sum = " << sum.read() << ", carry = " << carry.read() << endl;

    a.write(1);
    b.write(1);
    wait(10, SC_NS);
    cout << "time = " << sc_time_stamp()
         << "sum = " << sum.read() << ", carry = " << carry.read() << endl;
    wait(10, SC_NS);
    sc_stop();
}
