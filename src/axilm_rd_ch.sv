`ifdef VERILATOR
module axilm_rd_ch (
`else
module Vaxilm_rd_ch (
`endif
    input                   ARESETn,
    input                   ACLK,
    // Read Address Channel
    output  logic           ARVALID,
    input                   ARREADY,
    // Read Data Channel
    input                   RVALID,
    output  logic           RREADY,
    // Local Inerface
    input                   USR_ENA,
    input           [3:0]   USR_WSTB
);
    enum logic [1:0] {
        IDLE            = 0,
        ARREADY_WAIT    = 1,
        RREADY_ASSERT   = 2,
        RVALID_WAIT     = 3
    } state;

    logic usr_read_req;
    assign usr_read_req = USR_ENA & ~(|USR_WSTB);

    logic assert_arready;
    assign assert_arready = ARVALID & ARREADY;
    logic assert_rvalid;
    assign assert_rvalid = RVALID & RREADY;

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn) begin
            ARVALID <= 1'b0;
            RREADY <= 1'b0;
        end else
            case(state)
                IDLE: begin
                    if (usr_read_req)
                        ARVALID <= 1'b1;
                    else
                        ARVALID <= 1'b0;
                    RREADY <= 1'b0;
                end
                ARREADY_WAIT:
                    if (assert_arready) begin
                        ARVALID <= 1'b0;
                        RREADY <= 1'b1;
                    end
                RREADY_ASSERT:
                    if (assert_rvalid)
                        RREADY <= 1'b0;
                RVALID_WAIT:
                    if (assert_rvalid)
                        RREADY <= 1'b0;
            endcase

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn)
            state <= IDLE;
        else
            case (state)
                IDLE:
                    if (usr_read_req)
                        if (ARREADY)
                            state <= RREADY_ASSERT;
                        else
                            state <= ARREADY_WAIT;
                ARREADY_WAIT:
                    if (assert_arready)
                        state <= RREADY_ASSERT;
                RREADY_ASSERT:
                    if (RVALID)
                        state <= IDLE;
                    else
                        state <= RVALID_WAIT;
                RVALID_WAIT:
                    if (assert_rvalid)
                        state <= IDLE;
            endcase

endmodule
