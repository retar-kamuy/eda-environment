`timescale 1ns / 10ps

module half_adder_tb;
    logic a, b;
    logic sum, carry;

    localparam period = 20;

    half_adder UUT (
        .a,
        .b,
        .sum,
        .carry
    );
    
    initial begin
        a = 0;
        b = 0;
        #period;

        a = 0;
        b = 1;
        #period;

        a = 1;
        b = 0;
        #period;

        a = 1;
        b = 1;
        #period;
    end
endmodule