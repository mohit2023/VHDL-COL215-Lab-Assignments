//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
//Date        : Tue May 24 14:17:56 2022
//Host        : teesta running 64-bit Ubuntu 16.04.7 LTS
//Command     : generate_target bram_wrapper.bd
//Design      : bram_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bram_wrapper
   (BRAM_PORTA_addr,
    BRAM_PORTA_clk,
    BRAM_PORTA_din,
    BRAM_PORTA_dout,
    BRAM_PORTA_en,
    BRAM_PORTA_rst,
    BRAM_PORTA_we);
  input [31:0]BRAM_PORTA_addr;
  input BRAM_PORTA_clk;
  input [31:0]BRAM_PORTA_din;
  output [31:0]BRAM_PORTA_dout;
  input BRAM_PORTA_en;
  input BRAM_PORTA_rst;
  input [3:0]BRAM_PORTA_we;

  wire [31:0]BRAM_PORTA_addr;
  wire BRAM_PORTA_clk;
  wire [31:0]BRAM_PORTA_din;
  wire [31:0]BRAM_PORTA_dout;
  wire BRAM_PORTA_en;
  wire BRAM_PORTA_rst;
  wire [3:0]BRAM_PORTA_we;

  bram bram_i
       (.BRAM_PORTA_addr(BRAM_PORTA_addr),
        .BRAM_PORTA_clk(BRAM_PORTA_clk),
        .BRAM_PORTA_din(BRAM_PORTA_din),
        .BRAM_PORTA_dout(BRAM_PORTA_dout),
        .BRAM_PORTA_en(BRAM_PORTA_en),
        .BRAM_PORTA_rst(BRAM_PORTA_rst),
        .BRAM_PORTA_we(BRAM_PORTA_we));
endmodule
