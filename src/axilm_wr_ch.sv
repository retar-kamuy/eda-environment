`ifndef MODELSIM
module axilm_wr_ch (
`else
module Vaxilm_wr_ch (
`endif
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
  // Local Inerface
  input                 bus_ena,
  input         [3:0]   bus_wstb,
  input         [31:0]  bus_addr,
  input         [31:0]  bus_wdata,
  output        [1:0]   bus_bresp
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
  assign usr_write_req = bus_ena & (|bus_wstb);

  logic slv_addr_rsp;
  assign slv_addr_rsp = AWVALID & AWREADY;
  logic slv_data_rsp;
  assign slv_data_rsp = WVALID & WREADY;
  logic slv_response_rsp;
  assign slv_response_rsp = BVALID & BREADY;

  always_ff @(posedge ACLK or negedge ARESETn)
    if (~ARESETn) begin
      AWADDR <= 32'd0;
      AWVALID <= 1'b0;
      WVALID <= 1'b0;
      BREADY <= 1'b0;
      bus_bresp <= 2'b00;
    end else
      case (state)
        IDLE: begin
          if (usr_write_req) begin
            AWADDR <= bus_addr;
            AWVALID <= 1'b1;
            WDATA <= bus_wdata;
            WSTRB <= bus_wstb;
            WVALID <= 1'b1;
          end else begin
            AWVALID <= 1'b0;
            WVALID <= 1'b0;
          end
          BREADY <= 1'b0;
        end
        AWREADY_WREADY_WAIT:
          if (slv_addr_rsp & slv_data_rsp) begin
            AWVALID <= 1'b0;
            WVALID <= 1'b0;
            BREADY <= 1'b1;
          end else if (slv_addr_rsp)
            AWVALID <= 1'b0;
          else if (slv_data_rsp)
            WVALID <= 1'b0;
        AWREADY_WAIT:
          if (slv_addr_rsp) begin
            AWVALID <= 1'b0;
            BREADY <= 1'b1;
          end
        WREADY_WAIT:
          if (slv_data_rsp) begin
            WVALID <= 1'b0;
            BREADY <= 1'b1;
          end
        BREADY_ASSERT:
          if (slv_response_rsp) begin
            bus_bresp <= BRESP;
            BREADY <= 1'b0;
          end
        BVALID_WAIT:
          if (slv_response_rsp) begin
            bus_bresp <= BRESP;
            BREADY <= 1'b0;
          end
        default: begin
          AWADDR <= 32'd0;
          AWVALID <= 1'b0;
          WVALID <= 1'b0;
          BREADY <= 1'b0;
          bus_bresp <= 2'b00;
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
          if (slv_addr_rsp & slv_data_rsp)
            state <= BREADY_ASSERT;
          else if (slv_addr_rsp)
            state <= WREADY_WAIT;
          else if (slv_data_rsp)
            state <= AWREADY_WAIT;
        AWREADY_WAIT:
          if (slv_addr_rsp)
            state <= BREADY_ASSERT;
        WREADY_WAIT:
          if (slv_data_rsp)
            state <= BREADY_ASSERT;
        BREADY_ASSERT:
          if (BVALID)
            state <= IDLE;
          else
            state <= BVALID_WAIT;
        BVALID_WAIT:
          if (slv_response_rsp)
            state <= IDLE;
        default:
          state <= IDLE;
      endcase

endmodule
