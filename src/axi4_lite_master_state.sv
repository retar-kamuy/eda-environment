module axi4_lite_master_state (
    input           ARESETn,
    input           ACLK,
    // Write Response Channel
    input           AXI_BVALID,
    input           AXI_BREADY,
    // Read Data Channel
    input           AXI_RVALID,
    input           AXI_RREADY,
    // Local Inerface
    input           USR_ENA,
    input   [3:0]   USR_WSTB,

    output  [1:0]   WRITE_STATE,
    output  [1:0]   READ_STATE,

    // Read Address Channel
    output          ARVALID,
    input           ARREADY,

    // Read Data Channel
    input           RVALID,
    output          RREADY,
);
    enum logic [1:0] {
        IDLE        = 0;
        WRITE_STATE = 1;
        ACK_STATE   = 2;
    } write_state;

    enum logic [1:0] {
        IDLE        = 0;
        READ_STATE  = 1;
        ACK_STATE   = 2;
    } read_state;

    logic usr_read_req = USR_ENA & ~(|USR_WSTB);
    logic usr_write_req = USR_ENA & (|USR_WSTB);

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn)
            AXI_AWVALID <= 1'b0;
        else
            if (usr_write_req)
                AXI_AWVALID <= 1'b1;
            else if (AXI_AWREADY)
                AXI_AWVALID <= 1'b0;

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn)
            AXI_WVALID <= 1'b0;
        else
            if (usr_write_req)
                AXI_WVALID <= 1'b1;
            else if (AXI_WREADY)
                AXI_WVALID <= 1'b0;

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn)
            AXI_BVALID <= 1'b0;
        else
            if (usr_write_req)
                AXI_BVALID <= 1'b1;
            else if (AXI_WREADY)
                AXI_BVALID <= 1'b0;

    logic axi_ar_ack = AXI_ARVALID & AXI_ARREADY;

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn)
            AXI_ARVALID <= 1'b0;
        else
            if (usr_read_req)
                AXI_ARVALID <= 1'b1;
            else if (axi_ar_ack)
                AXI_ARVALID <= 1'b0;

    logic axi_r_ack = AXI_RVALID & AXI_RREADY;

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn)
            AXI_RVALID <= 1'b0;
        else
            if (read_state === READ_STATE & AXI_ARREADY)
                AXI_RVALID <= 1'b1;
            else if (axi_r_ack)
                AXI_RVALID <= 1'b0;

    // Write State
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (~ARESETn) begin
            write_state <= IDLE;
        end else begin
            case (state)
                IDLE:
                    if (usr_write_req)
                        write_state <= WRITE_STATE;
                WRITE_STATE:
                    if (AXI_BVALID & AXI_BREADY)
                        write_state <= ACK_STATE;
                    else if (~AXI_BREADY)
                        write_state <= WRITE_STATE;
                    else
                        write_state <= IDLE;
                ACK_STATE:
                    write_state <= IDLE;
            endcase
        end
    end

    // Read State
    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn)
            read_state <= IDLE;
        else
            case (read_state)
                IDLE:
                    if (usr_read_req)
                        read_state <= READ_STATE;
                READ_STATE:
                    if (axi_r_ack)
                        read_state <= ACK_STATE;
                    else if (~AXI_RREADY)
                        read_state <= READ_STATE;
                    else
                        read_state <= IDLE;
                ACK_STATE:
                    read_state <= IDLE;
            endcase

endmodule
