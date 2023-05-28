module apb #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input PCLK,
    input PRESETn,
    // Requester
    output logic [ADDR_WIDTH-1:0] PADDR,
    output logic [2:0] PPROT,
    output logic PNSE,
    output logic PSEL,
    output logic PENABLE,
    output logic PWRITE,
    output logic [DATA_WIDTH-1:0] PWDATA,
    output logic [DATA_WIDTH/8-1:0] PSTRB,
    // Completer
    input PREADY,
    input PRDATA,
    input PSLVERR,
    // Local Inerface
    input BUS_ENA,
    input [DATA_WIDTH/8-1:0] BUS_WSTB,
    input [DATA_WIDTH-1:0] BUS_ADDR,
    input [DATA_WIDTH-1:0] BUS_WDATA,
    output logic BUS_READY,
    output logic [DATA_WIDTH-1:0] BUS_RDATA,
    output logic BUS_SLVERR
);
    enum logic [1:0] {
        IDLE = 0,
        SETUP = 1,
        ACCESS = 2
    } state;

    assign PPROT = 3'b000;
    assign PNSE = 1'b0;

    logic usr_read_req;
    assign usr_read_req = BUS_ENA & ~(|BUS_WSTB);
    logic usr_write_req;
    assign usr_write_req = BUS_ENA & (|BUS_WSTB);
    logic transfer;
    assign transfer = usr_read_req | usr_write_req;

    logic exit_access;
    assign exit_access = PENABLE & PREADY;

    always_ff @(posedge PCLK or negedge PRESETn)
        if (~PRESETn) begin
            PADDR <= ADDR_WIDTH'(1'd0);
            PWRITE <= 1'b0;
            PSEL <= 1'b0;
            PENABLE <= 1'b0;
            PWDATA <= DATA_WIDTH'(1'd0);
        end else
            case (state)
                IDLE: begin
                    PADDR <= ADDR_WIDTH'(1'd0);
                    PWRITE <= 1'b0;
                    PSEL <= 1'b0;
                    PENABLE <= 1'b0;
                end
                SETUP: begin
                    PADDR <= BUS_ADDR;
                    if (usr_write_req)
                        PWRITE <= 1'b1;
                    PSEL <= 1'b1;
                    PWDATA <= BUS_WDATA;
                end
                ACCESS: begin
                    PENABLE <= 1'b1;
                end
            endcase

    always_ff @(posedge PCLK or negedge PRESETn)
        if (~PRESETn)
            BUS_RDATA <= DATA_WIDTH'(1'd0);
        else
            if (exit_access)
                if (usr_read_req)
                    BUS_RDATA <= PRDATA;

    always_ff @(posedge PCLK or negedge PRESETn)
        if (~PRESETn) begin
            BUS_READY <= 1'b0;
            BUS_SLVERR <= 1'b0;
        end else
            case (state)
                IDLE: begin
                    BUS_READY <= 1'b0;
                    BUS_SLVERR <= 1'b0;
                end
                ACCESS:
                    if (exit_access) begin
                        BUS_READY <= 1'b1;
                        BUS_SLVERR <= PSLVERR;
                    end
            endcase

    always_ff @(posedge PCLK or negedge PRESETn)
        if (~PRESETn)
            state <= IDLE;
        else
            case (state)
                IDLE:
                    if (transfer)
                        state <= SETUP;
                SETUP:
                    state <= ACCESS;
                ACCESS:
                    if (exit_access & transfer)
                        state <= SETUP;
                    else if (exit_access)
                        state <= IDLE;
            endcase

endmodule
