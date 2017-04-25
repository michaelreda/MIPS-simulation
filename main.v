//////include components/////

`include "Adder32Bit.v"
`include "ALU.v"
`include "ALU_CTRL.v"
`include "Control.v"
`include "DataMemory.v"
`include "forwarding.v"
`include "Instruction_memory.v"
`include "MUX_2to1.v"
`include "MUX_3x1.v"
`include "RegisterFile.v"
`include "ShiftLeft2Bits.v"
`include "SignExtender_16to32.v"
`include "TTbitReg.v"

//////main pipelined circuit////

module main;
  initial 
    begin
      $display("Hello, World");
      $finish ;
    end
endmodule

//////fetch stage//////////////

module fetch(clk, branchIN , branchSel, IF_ID);
input ckl, branchSel;
input [31:0] branchIN, noBranchIN;
output [63:0] IF_ID;
reg [63:0] IF_ID;
wire [31:0] mux_out, summation, instruction,pc_out; 
32bitReg PC (0, pc_in, pc_out);
//initial PC = 32'd40;

MUX_2to1 pc_update(mux_out, summation , branchIN, branchSel);
Instruction_memory IM(read_address, instruction); 
Adder32Bit pc_increment(summation, overflowBit,adder_in1, 32'd4);

  

always @(branchIN or branchSel )
begin
pc_in <= mux_out;
end 
always @(posedge clk)
 begin
  read_address <= pc_out;
  adder_in1    <= pc_out;
  IF_ID[31:0]  <= instruction;
  IF_ID[63:32] <= summation;
 end
endmodule

/////decode stage////////////

module decode(clk, instruction, data, regWrite, writeToReg, ID_EX);
input clk, regWrite;
input [63:0] instruction;


endmodule

/////execute stage//////////

module execute();
endmodule

////mem  stage//////////////

module memory(clk,in_WB,in_M,in_branch_address,in_zero_flag,in_ALU_result,in_reg_write_data,in_rd,out_ALU_result,
out_memory_word_read,out_rd,out_WB);

input [1:0] in_WB;
input [2:0] in_M;
input [31:0] in_branch_address,in_ALU_result,in_reg_write_data;
input in_zero_flag;
input [4:0] in_rd;

output reg [31:0] out_ALU_result,out_memory_word_read;
output reg [4:0] out_rd;
output reg [1:0] out_WB;

assign out_WB = in_WB;
assign out_rd = in_rd;

endmodule

///// write back stage//////

module writeBack();
endmodule

///test bench///////////////

module testbench();
endmodule


////////////////////////////

