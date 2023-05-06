module axilm (
    // AXI4 Lite Interface
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
    // Read Address Channel
    output  logic   [31:0]  ARADDR,
    output  logic   [2:0]   ARPROT,
    output  logic           ARVALID,
    input                   ARREADY,
    // Read Data Channel
    input           [31:0]  RDATA,
    input           [1:0]   RRESP,
    input                   RVALID,
    output  logic           RREADY,
    // Local Inerface
    input                   USR_ENA,
    input           [3:0]   USR_WSTB,
    input           [31:0]  USR_ADDR,
    input           [31:0]  USR_WDATA,
    output  logic   [31:0]  USR_RDATA,
    output  logic   [1:0]   USR_BRESP,
    output  logic   [1:0]   USR_RRESP
);

    axilm_wr_ch u_axilm_wr_ch (
        .ARESETn,
        .ACLK,
        .AWADDR,
        .AWPROT,
        .AWVALID,
        .AWREADY,
        .WDATA,
        .WSTRB,
        .WVALID,
        .WREADY,
        .BVALID,
        .BREADY,
        .BRESP,
        .USR_ENA,
        .USR_WSTB,
        .USR_ADDR,
        .USR_WDATA,
        .USR_BRESP
    );

    axilm_rd_ch u_axilm_rd_ch (
        .ARESETn,
        .ACLK,
        .ARADDR,
        .ARPROT,
        .ARVALID,
        .ARREADY,
        .RDATA,
        .RRESP,
        .RVALID,
        .RREADY,
        .USR_ENA,
        .USR_WSTB,
        .USR_ADDR,
        .USR_RDATA,
        .USR_RRESP
    );

endmodule
