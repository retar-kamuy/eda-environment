`ifdef VERILATOR
module our (
`else
module Vour (
`endif
    input clk  // Clock is required to get initial activation
);
    always @(posedge clk) begin
        $display("Hello World");
        $finish;
    end
endmodule