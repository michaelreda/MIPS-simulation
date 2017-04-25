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

module execute(clk,in_WB,in_M,in_EX,in_incremented_PC,in_regData1,in_regData2,in_sign_extended_offset,in_rt,in_rd,
  out_WB,out_M,out_branch_address,out_zero_flag,out_ALU_result,out_reg_write_data,out_rd);
input [1:0] in_WB;
input [2:0] in_M;
input [3:0] in_EX;
input [31:0] in_incremented_PC,in_regData1,in_regData2,in_sign_extended_offset;
input [4:0] in_rt,in_rd;
output reg [2:0] out_M;
output reg [1:0] out_WB;
output reg [31:0] out_branch_address,out_ALU_result,out_reg_write_data;
output reg out_zero_flag;
output reg [4:0] out_rd;


assign out_WB = in_WB;
assign out_M = in_M;
assign out_reg_write_data=in_regData2;

reg [32:0] shifted_sign_extended_offset;
ShiftLeft2Bits shifter(shifted_sign_extended_offset,in_sign_extended_offset)
Adder32Bit adder(out_branch_address,in_incremented_PC,shifted_sign_extended_offset);

reg[2:0] ALU_CTRL_output;
ALU_CTRL(in_sign_extended_offset[5:0],in_EX[3:2],ALU_CTRL_output);


reg[31:0] ALU_input2;
MUX_2to1 mux(ALU_input2,in_regData2,in_sign_extended_offset,in_EX[0]);

ALU(in_regData1,ALU_input2,out_ALU_result,ALU_CTRL_output,out_zero_flag );

MUX_2to1 mux(out_rd,in_rt,in_rd,in_EX[1]);

// $monitor("execState: instruction: %d read_address: %d ",instruction,read_address);

endmodule

////mem  stage//////////////

module mem();
endmodule

///// write back stage//////

module writeBack();
endmodule

///test bench///////////////

module testbench();
endmodule


////////////////////////////
