`ifdef VERILATOR
module half_adder (
`else
module Vhalf_adder (
`endif
    input clk,
    input a, b,
    output logic sum, carry
);
    always @(posedge clk) begin
        sum <= a ^ b;
        carry <= a & b;
        $info("sum = %d, carry = %d", sum, carry);
    end
    //assign sum = a ^ b;
    //assign carry = a & b;

endmodule