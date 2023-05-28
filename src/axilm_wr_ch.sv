`ifndef MODELSIM
module axilm_wr_ch (
`else
module Vaxilm_wr_ch (
`endif
    input                   ARESETn,
    input                   ACLK,
    // Write Address Channel
    output  logic   [31:0]  AWADDR,
    output  logic   [2:0]   AWPROT,
    output  logic           AWVALID,
    input                   AWREADY,
    // Write Data Channel
    output  logic   [31:0]  WDATA,
    output  logic   [3:0]   WSTRB,
    output  logic           WVALID,
    input                   WREADY,

    // Write Response Channel
    input                   BVALID,
    output  logic           BREADY,
    input           [1:0]   BRESP,
    // Local Inerface
    input                   BUS_ENA,
    input           [3:0]   BUS_WSTB,
    input           [31:0]  BUS_ADDR,
    input           [31:0]  BUS_WDATA,
    output          [1:0]   BUS_BRESP
);
    enum logic [2:0] {
        IDLE                = 0,
        AWREADY_WREADY_WAIT = 1,
        AWREADY_WAIT        = 2,
        WREADY_WAIT         = 3,
        BREADY_ASSERT       = 4,
        BVALID_WAIT         = 5
    } state;

    assign AWPROT = 3'b000;

    logic usr_write_req;
    assign usr_write_req = BUS_ENA & (|BUS_WSTB);

    logic slv_addr_resp;
    assign slv_addr_resp = AWVALID & AWREADY;
    logic slv_data_resp;
    assign slv_data_resp = WVALID & WREADY;
    logic slv_resp_resp;
    assign slv_resp_resp = BVALID & BREADY;

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn) begin
            AWADDR <= 32'd0;
            AWVALID <= 1'b0;
            WVALID <= 1'b0;
            BREADY <= 1'b0;
            BUS_BRESP <= 2'b00;
        end else
            case (state)
                IDLE: begin
                    if (usr_write_req) begin
                        AWADDR <= BUS_ADDR;
                        AWVALID <= 1'b1;
                        WDATA <= BUS_WDATA;
                        WSTRB <= BUS_WSTB;
                        WVALID <= 1'b1;
                    end else begin
                        AWVALID <= 1'b0;
                        WVALID <= 1'b0;
                    end
                    BREADY <= 1'b0;
                end
                AWREADY_WREADY_WAIT:
                    if (slv_addr_resp & slv_data_resp) begin
                        AWVALID <= 1'b0;
                        WVALID <= 1'b0;
                        BREADY <= 1'b1;
                    end else if (slv_addr_resp)
                        AWVALID <= 1'b0;
                    else if (slv_data_resp)
                        WVALID <= 1'b0;
                AWREADY_WAIT:
                    if (slv_addr_resp) begin
                        AWVALID <= 1'b0;
                        BREADY <= 1'b1;
                    end
                WREADY_WAIT:
                    if (slv_data_resp) begin
                        WVALID <= 1'b0;
                        BREADY <= 1'b1;
                    end
                BREADY_ASSERT:
                    if (slv_resp_resp) begin
                        BUS_BRESP <= BRESP;
                        BREADY <= 1'b0;
                    end
                BVALID_WAIT:
                    if (slv_resp_resp) begin
                        BUS_BRESP <= BRESP;
                        BREADY <= 1'b0;
                    end
                default: begin
                    AWADDR <= 32'd0;
                    AWVALID <= 1'b0;
                    WVALID <= 1'b0;
                    BREADY <= 1'b0;
                    BUS_BRESP <= 2'b00;
                end
            endcase

    always_ff @(posedge ACLK or negedge ARESETn)
        if (~ARESETn)
            state <= IDLE;
        else
            case (state)
                IDLE:
                    if (usr_write_req)
                        if (AWREADY & WREADY)
                            state <= BREADY_ASSERT;
                        else if (AWREADY)
                            state <= WREADY_WAIT;
                        else if (WREADY)
                            state <= AWREADY_WAIT;
                        else
                            state <= AWREADY_WREADY_WAIT;
                AWREADY_WREADY_WAIT:
                    if (slv_addr_resp & slv_data_resp)
                        state <= BREADY_ASSERT;
                    else if (slv_addr_resp)
                        state <= WREADY_WAIT;
                    else if (slv_data_resp)
                        state <= AWREADY_WAIT;
                AWREADY_WAIT:
                    if (slv_addr_resp)
                        state <= BREADY_ASSERT;
                WREADY_WAIT:
                    if (slv_data_resp)
                        state <= BREADY_ASSERT;
                BREADY_ASSERT:
                    if (BVALID)
                        state <= IDLE;
                    else
                        state <= BVALID_WAIT;
                BVALID_WAIT:
                    if (slv_resp_resp)
                        state <= IDLE;
                default:
                    state <= IDLE;
            endcase

endmodule
