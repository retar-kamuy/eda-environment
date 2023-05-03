module axi4_lite_master_read_state (
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
        IDLE            = 0;
        WAIT_ARREADY    = 1;
        ASSERT_RREADY   = 2;
        WAIT_RVALID     = 3;
    } state;

    logic usr_read_req = USR_ENA & (|USR_WSTB);

    logic assert_arready = AXI_ARVALID & AXI_ARREADY;
    logic assert_rvalid = AXI_RVALID & AXI_RREADY;

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn) begin
            AXI_ARVALID <= 1'b0;
            AXI_RVALID <= 1'b0;
        end else
            case(state)
                IDLE: begin
                    if (usr_read_req)
                        AXI_ARVALID <= 1'b1;
                    else
                        AXI_ARVALID <= 1'b0;
                    AXI_RREADY <= 1'b0;
                end
                WAIT_ARREADY:
                    if (assert_arready) begin
                        AXI_ARVALID <= 1'b0;
                        AXI_RREADY <= 1'b1;
                    end
                ASSERT_RREADY:
                    if (assert_rvalid)
                        AXI_RVALID <= 1'b0;
                WAID_RVALID:
                    if (assert_rvalid)
                        AXI_RVALID <= 1'b0;
            endcase

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn)
            state <= IDLE;
        else
            case (state)
                IDLE:
                    if (usr_read_req)
                        if (AXI_ARREADY)
                            state <= ASSERT_RVALID;
                        else
                            state <= WAIT_ARREADY;
                WAIT_ARREADY:
                    if (assert_arready)
                        state <= ASSERT_RVALID;
                ASSERT_READY:
                    if (AXI_RVALID)
                        state <= IDLE;
                    else
                        state <= WAIT_RVALID;
                WAIT_RVALID:
                    if (assert_rvalid)
                        state <= IDLE;
            endcase

endmodule
