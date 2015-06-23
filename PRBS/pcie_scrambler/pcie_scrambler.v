//-----------------------------------------------------------------------------
// Copyright (C) 2009 OutputLogic.com 
// This source file may be used and distributed without restriction 
// provided that this copyright statement is not removed from the file 
// and that any derivative work contains the original copyright notice 
// and the associated disclaimer. 
// 
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS 
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED 
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
//-----------------------------------------------------------------------------
// scrambler module for data[7:0],   lfsr[15:0]=1+x^3+x^4+x^5+x^16;
//-----------------------------------------------------------------------------
module pcie_scrambler(
  input [7:0] data_in,
  input scram_en,
  input scram_rst,
  output reg [7:0] data_out,
  input rst,
  input clk);

  reg [15:0] lfsr_q,lfsr_c;
  reg [7:0] data_c;

  always @( * ) begin
    lfsr_c[0] = lfsr_q[8];
    lfsr_c[1] = lfsr_q[9];
    lfsr_c[2] = lfsr_q[10];
    lfsr_c[3] = lfsr_q[8] ^ lfsr_q[11];
    lfsr_c[4] = lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[12];
    lfsr_c[5] = lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[13];
    lfsr_c[6] = lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14];
    lfsr_c[7] = lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15];
    lfsr_c[8] = lfsr_q[0] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13];
    lfsr_c[9] = lfsr_q[1] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14];
    lfsr_c[10] = lfsr_q[2] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15];
    lfsr_c[11] = lfsr_q[3] ^ lfsr_q[14] ^ lfsr_q[15];
    lfsr_c[12] = lfsr_q[4] ^ lfsr_q[15];
    lfsr_c[13] = lfsr_q[5];
    lfsr_c[14] = lfsr_q[6];
    lfsr_c[15] = lfsr_q[7];

    data_c[0] = data_in[0] ^ lfsr_q[15];
    data_c[1] = data_in[1] ^ lfsr_q[14];
    data_c[2] = data_in[2] ^ lfsr_q[13];
    data_c[3] = data_in[3] ^ lfsr_q[12];
    data_c[4] = data_in[4] ^ lfsr_q[11];
    data_c[5] = data_in[5] ^ lfsr_q[10];
    data_c[6] = data_in[6] ^ lfsr_q[9];
    data_c[7] = data_in[7] ^ lfsr_q[8];
  end // always

  always @(posedge clk, posedge rst) begin
    if(rst) begin
      lfsr_q <= {16{1'b1}};
      data_out <= {8{1'b0}};
    end
    else begin
      lfsr_q <= scram_rst ? {16{1'b1}} : scram_en ? lfsr_c : lfsr_q;
      data_out <= scram_en ? data_c : data_out;
    end
  end // always
endmodule // scrambler
 
