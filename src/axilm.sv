`ifndef QUESTA
module axilm (
`else
module Vaxilm (
`endif
  // AXI4 Lite Interface
  input                 ARESETn,
  input                 ACLK,
  // Write Address Channel
  output  logic [31:0]  AWADDR,
  output  logic [2:0]   AWPROT,
  output  logic         AWVALID,
  input                 AWREADY,
  // Write Data Channel
  output  logic [31:0]  WDATA,
  output  logic [3:0]   WSTRB,
  output  logic         WVALID,
  input                 WREADY,
  // Write Response Channel
  input                 BVALID,
  output  logic         BREADY,
  input         [1:0]   BRESP,
  // Read Address Channel
  output  logic [31:0]  ARADDR,
  output  logic [2:0]   ARPROT,
  output  logic         ARVALID,
  input                 ARREADY,
  // Read Data Channel
  input         [31:0]  RDATA,
  input         [1:0]   RRESP,
  input                 RVALID,
  output  logic         RREADY,
  // Local Inerface
  input                 bus_ena,
  input         [3:0]   bus_wstb,
  input         [31:0]  bus_addr,
  input         [31:0]  bus_wdata,
  output  logic [31:0]  bus_rdata,
  output  logic [1:0]   bus_bresp,
  output  logic [1:0]   bus_rresp
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
    .bus_ena,
    .bus_wstb,
    .bus_addr,
    .bus_wdata,
    .bus_bresp
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
    .bus_ena,
    .bus_wstb,
    .bus_addr,
    .bus_rdata,
    .bus_rresp
  );

endmodule
