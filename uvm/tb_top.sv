`include "uvm_macros.svh"
`include "defines.svh"
`include "prj_pkg.svh"

module tb_top;
    import uvm_pkg::*;
    import prj_pkg::*;

    logic PCLK;
    logic PRESETn;

    apb_if _if (PCLK, PRESETn);

    clk_rst_gen #(
        .CLK_PERIOD ( 10        )
    ) u_clk_rst_gen (
        .RST_N      ( PRESETn   ),
        .CLK        ( PCLK      )
    );

    apb #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(32)
    ) u_apb (
        .PCLK,
        .PRESETn,
        // Requester
        .PADDR(_if.PADDR),
        .PPROT(_if.PPROT),
        .PNSE(_if.PNSE),
        .PSEL(_if.PSEL),
        .PENABLE(_if.PENABLE),
        .PWRITE(_if.PWRITE),
        .PWDATA(_if.PWDATA),
        .PSTRB(_if.PSTRB),
        // Completer
        .PREADY(_if.PREADY),
        .PRDATA(_if.PRDATA),
        .PSLVERR(_if.PSLVERR),
        // Local Inerface
        .BUS_ENA(1'b0),
        .BUS_WSTB(4'd0),
        .BUS_ADDR(32'd0),
        .BUS_WDATA(32'd0),
        .BUS_READY(),
        .BUS_RDATA(),
        .BUS_SLVERR()
    );

    initial begin
        uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top", "apb_vif", _if);
        run_test("test_1011");
    end
endmodule
