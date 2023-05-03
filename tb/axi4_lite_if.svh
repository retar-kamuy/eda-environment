interface axi4_lite_if (
    input ARESETn,
    input ACLK
);

    // Write Address Channel
    logic   [31:0]  AWADDR;
    logic   [3:0]   AWCACHE;
    logic   [2:0]   AWPROT;
    logic           AWVALID;
    logic           AWREADY;

    // Write Data Channel
    logic   [31:0]  WDATA;
    logic   [3:0]   WSTRB;
    logic           WVALID;
    logic           WREADY;

    // Write Response Channel
    logic           BVALID;
    logic           BREADY;
    logic   [1:0]   BRESP;

    // Read Address Channel
    logic   [31:0]  ARADDR;
    logic   [3:0]   ARCACHE;
    logic   [2:0]   ARPROT;
    logic           ARVALID;
    logic           ARREADY;

    // Read Data Channel
    logic   [31:0]  RDATA;
    logic   [1:0]   RRESP;
    logic           RVALID;
    logic           RREADY;

    modport master (
        input   ARESETn,
        input   ACLK,

        output  AWADDR,
        output  AWCACHE,
        output  AWPROT,
        output  AWVALID,
        input   AWREADY,

        output  WDATA,
        output  WSTRB,
        output  WVALID,
        input   WREADY,

        input   BVALID,
        output  BREADY,
        input   BRESP,

        output  ARADDR,
        output  ARCACHE,
        output  ARPROT,
        output  ARVALID,
        input   ARREADY,

        input   RDATA,
        input   RRESP,
        input   RVALID,
        output  RREADY
    );

    modport slave (
        input   ARESETn,
        input   ACLK,

        input   AWADDR,
        input   AWCACHE,
        input   AWPROT,
        input   AWVALID,
        output  AWREADY,

        input   WDATA,
        input   WSTRB,
        input   WVALID,
        output  WREADY,

        output  BVALID,
        input   BREADY,
        output  BRESP,

        input   ARADDR,
        input   ARCACHE,
        input   ARPROT,
        input   ARVALID,
        output  ARREADY,

        output  RDATA,
        output  RRESP,
        output  RVALID,
        input   RREADY
    );

endinterface
