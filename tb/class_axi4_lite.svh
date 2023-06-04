`include "axi4_lite_if.svh"

`timescale 1ns / 1ns

class class_axi4_lite;
  localparam CLK_PERIOD = 10ns;

  virtual axi4_lite_if intf;

  function void assign_vi (virtual interface axi4_lite_if vif);
    intf = vif;
  endfunction

endclass
