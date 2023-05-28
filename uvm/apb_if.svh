`timescale 1ns / 1ns

interface apb_if #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input PCLK,
    input PRESETn
);
    // Requester
    logic [ADDR_WIDTH-1:0] PADDR;
    logic [2:0] PPROT;
    logic PNSE;
    logic PSEL;
    logic PENABLE;
    logic PWRITE;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic [DATA_WIDTH/8-1:0] PSTRB;
    // Completer
    logic PREADY;
    logic PRDATA;
    logic PSLVERR;

    modport requester (
        input PCLK,
        input PRESETn,
        output PADDR,
        output PPROT,
        output PNSE,
        output PSEL,
        output PENABLE,
        output PWRITE,
        output PREADY,
        output PWDATA,
        output PSTRB,
        input PRDATA,
        input PSLVERR
    );

    modport completer (
        input PCLK,
        input PRESETn,
        input PADDR,
        input PPROT,
        input PNSE,
        input PSEL,
        input PENABLE,
        input PWRITE,
        input PWDATA,
        input PSTRB,
        output PREADY,
        output PRDATA,
        output PSLVERR
    );

    clocking cb @(posedge PCLK);
        default input #1step output #3ns;
        output PADDR;
        output PPROT;
        output PNSE;
        output PSEL;
        output PENABLE;
        output PWRITE;
        output PWDATA;
        output PSTRB;
        input PREADY;
        input PRDATA;
        input PSLVERR;
    endclocking
endinterface
