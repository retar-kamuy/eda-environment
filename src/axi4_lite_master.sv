module axi4_lite_master (
    // AXI4 Lite Interface
    input         ARESETn,
    input         ACLK,

    // Write Address Channel
    output  [31:0]  AWADDR,
    output  [3:0]   AWCACHE,
    output  [2:0]   AWPROT,
    output          AWVALID,
    input           AWREADY,

    // Write Data Channel
    output  [31:0]  WDATA,
    output  [3:0]   WSTRB,
    output          WVALID,
    input           WREADY,

    // Write Response Channel
    input           BVALID,
    output          BREADY,
    input   [1:0]   BRESP,

    // Read Address Channel
    output  [31:0]  ARADDR,
    output  [3:0]   ARCACHE,
    output  [2:0]   ARPROT,
    output          ARVALID,
    input           ARREADY,

    // Read Data Channel
    input   [31:0]  RDATA,
    input   [1:0]   RRESP,
    input           RVALID,
    output          RREADY,

    // Local Inerface
    output          BUS_WAIT,
    input           BUS_ENA,
    input   [3:0]   BUS_WSTB,
    input   [31:0]  BUS_ADDR,
    input   [31:0]  BUS_WDATA,
    output  [31:0]  BUS_RDATA
);

    localparam S_IDLE       =   4'd0;
    localparam S_WA_WAIT    =   4'd1;
    localparam S_WA_START   =   4'd2;
    localparam S_WD_WAIT    =   4'd3;
    localparam S_WD_PROC    =   4'd4;
    localparam S_WR_WAIT    =   4'd5;
    localparam S_RA_WAIT    =   4'd6;
    localparam S_RA_START   =   4'd7;
    localparam S_RD_WAIT    =   4'd8;
    localparam S_RD_PROC    =   4'd9;
    localparam S_FIN        =   4'd10;

   reg [3:0]     state;
   reg [31:0]    reg_adrs;
   reg           reg_awvalid, reg_wvalid;
   reg [3:0]     reg_wstb;
   reg           reg_arvalid;
   reg [31:0]    reg_rdata;

   // Write State
   always @(posedge CLK) begin
      if(!RST_N) begin
         state           <= S_IDLE;
         reg_adrs[31:0]  <= 32'd0;
         reg_awvalid     <= 1'b0;
         reg_wvalid      <= 1'b0;
         reg_arvalid     <= 1'b0;
         reg_wstb[3:0]   <= 4'd0;
         reg_rdata[31:0] <= 32'd0;
      end else begin
         case(state)
           S_IDLE: begin
              if(BUS_ENA) begin
                 if(|BUS_WSTB) begin
                    state          <= S_WA_START;
                 end else begin
                    state          <= S_RA_START;
                 end
                 reg_adrs[31:0] <= BUS_ADDR[31:0];
                 reg_wstb[3:0]  <= BUS_WSTB;
              end
              reg_awvalid   <= 1'b0;
              reg_arvalid   <= 1'b0;
              reg_wvalid    <= 1'b0;
           end
           S_WA_START: begin
              state         <= S_WD_WAIT;
              reg_awvalid   <= 1'b1;
           end
           S_WD_WAIT: begin
              if(M_AXI_AWREADY) begin
                 state        <= S_WD_PROC;
                 reg_awvalid  <= 1'b0;
                 reg_wvalid   <= 1'b1;
              end
           end
           S_WD_PROC: begin
              if(M_AXI_WREADY) begin
                 state        <= S_WR_WAIT;
                 reg_wvalid   <= 1'b0;
              end
           end
           S_WR_WAIT: begin
              if(M_AXI_BVALID) begin
                    state          <= S_FIN;
              end
           end
           S_RA_START: begin
              state          <= S_RD_WAIT;
              reg_arvalid    <= 1'b1;
           end
           S_RD_WAIT: begin
              if(M_AXI_ARREADY) begin
                 state        <= S_RD_PROC;
                 reg_arvalid  <= 1'b0;
              end
           end
           S_RD_PROC: begin
              if(M_AXI_RVALID) begin
                 state        <= S_FIN;
                 reg_rdata    <= M_AXI_RDATA;
              end
           end
           S_FIN: begin
              state <= S_IDLE;
           end
           default: begin
              state <= S_IDLE;
           end
         endcase
      end
   end

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (~ARESETn) begin
            AXI_ARVALID <= 1'b0;
        end else begin
            if (read_state == ) begin
            end
        end
    end

    axi4_lite_master_state u_axi4_lite_master_state (
        .ARESETn,
        .ACLK,
        .AXI_BVALID,
        .AXI_BREADY,
        .AXI_RVALID,
        .AXI_RREADY,
        .BUS_ENA,
        .BUS_WSTB,
        .WRITE_STATE    ( write_state   ),
        .READ_STATE     ( read_state    )
    );

    logic [1:0] write_state_reg, read_state_reg;
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (~ARESETn) begin
            write_state_reg <= 2'd0;
        end else begin
            if (read_state == ) begin
            end
        end
    end

   assign M_AXI_AWADDR[31:0] = reg_adrs[31:0];
   assign M_AXI_AWCACHE[3:0] = 4'b0011;
   assign M_AXI_AWPROT[2:0]  = 3'b000;
   assign M_AXI_AWVALID      = reg_awvalid;

   assign M_AXI_WDATA[31:0]  = BUS_WDATA;
   assign M_AXI_WSTRB[3:0]   = reg_wstb;
   assign M_AXI_WVALID       = reg_wvalid;

   assign M_AXI_BREADY       = (state == S_WR_WAIT)?1'b1:1'b0;

   // Master Read Address
   assign M_AXI_ARADDR[31:0] = reg_adrs[31:0];
   assign M_AXI_ARCACHE[3:0] = 4'b0011;
   assign M_AXI_ARPROT[2:0]  = 3'b000;
   assign M_AXI_ARVALID      = reg_arvalid;

   assign M_AXI_RREADY       = 1'b1;

   assign BUS_WAIT = ~(state == S_FIN);
   assign BUS_RDATA = reg_rdata[31:0];

endmodule // fmrv32im_axils
