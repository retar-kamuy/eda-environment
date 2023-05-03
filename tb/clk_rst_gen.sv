`timescale 1ns / 1ns

module clk_rst_gen #(
    parameter CLK_PERIOD = 10
) (
    output logic RST_N,
    output logic CLK
);

    initial begin
        RST_N = 0;

        wait(CLK);

        #(CLK_PERIOD * 5)
        RST_N = 1;
    end

    initial begin
        CLK = 0;
        forever begin
            #(CLK_PERIOD / 2) CLK = ~CLK;
        end
    end

endmodule
