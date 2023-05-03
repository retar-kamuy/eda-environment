`include "axi4_lite_if.svh"
`include "class_axi4_lite.svh"

module tb_top;
    logic ACLK;
    logic ARESETn;

    logic ARVALID;
    logic ARREADY = 0;
    logic RVALID = 0;
    logic RREADY;

    logic USR_ENA = 0;
    logic [3:0] USR_WSTB = 4'b0000;

    axi4_lite_if _if(ACLK, ARESETn);

    class_axi4_lite axils;

    initial begin
        forever begin
            wait(ARVALID);
            @(posedge ACLK);
            #1 ARREADY = 1;
            @(posedge ACLK);
            #1 ARREADY = 0;
        end
    end

    initial begin
        forever begin
            wait(RREADY);
            @(posedge ACLK);
            #1 RVALID = 1;
            @(posedge ACLK);
            #1 RVALID = 0;
        end
    end

    initial begin
        axils = new();
        axils.assign_vi(_if);

        wait(ARESETn);

        repeat(5) @(posedge ACLK);
        #1 USR_ENA = 1;
        @(posedge ACLK);
        #1 USR_ENA = 0;
        repeat(10) @(posedge ACLK);
        $finish;
    end

    clk_rst_gen #(
        .CLK_PERIOD ( 10        )
    ) u_clk_rst_gen (
        .RST_N      ( ARESETn   ),
        .CLK        ( ACLK      )
    );

    axi4_lite_master_read_state u_axi4_lite_master_read_state (
        .ARESETn,
        .ACLK,
        .ARVALID,
        .ARREADY,
        .RVALID,
        .RREADY,
        .USR_ENA,
        .USR_WSTB
    );

endmodule
