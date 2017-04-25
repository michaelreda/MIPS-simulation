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

module fetch(clk, in_branch , in_branchSel, out_instruction, out_incremented_pc );
input clk, in_branchSel;
input [31:0] in_branch;
output [31:0] out_instruction, out_incremented_pc ;
reg [31:0]  out_instruction, out_incremented_pc;

wire [31:0] mux_out, pc_out;


//initial PC = 32'd40;

MUX_2to1 pc_update(clk,mux_out, out_incremented_pc , in_branch, in_branchSel);
TTbitReg PC (clk,0, mux_out, pc_out);
Instruction_memory IM(clk,pc_out, out_instruction);
Adder32Bit pc_increment(clk,out_incremented_pc, overflowBit,pc_out, 32'd4);


endmodule




/////decode stage////////////

module decode( clk, regWrite, in_incremented_pc, in_instruction, in_data, in_writeToReg, 
              out_WB, out_M,out_EX,out_incremented_pc, out_data1, out_data2, out_extended, out_rt, out_rd );
input clk,in_regWrite;
input [31:0] in_instruction, in_data,;
input [3:0] in_writeToReg;
output [1:0] out_WB;
output [2:0] out_M;
output [3:0] out_EX;
output [31:0] out_incremented_pc, out_data1, out_data2, out_extended;
output [4:0] out_rd, out_rt;

wire op_code = instruction[5:0];
wire into_extender = instruction[15:0];
wire read1 = [10:6];
wire read2 =[15:11];


assign out_incremented_pc = in_incremented_pc  ;
assign out_rd = instruction[20:16];
assign out_rt = instruction[15:11];
 
assign 

Control main_crtl(clk,RegDst,Branch,MemRead,MemtoReg,ALUop,MemWrite,ALUsrc,RegWrite,op_code);
assign out_WB = {RegWrite, MemtoReg};
assign out_M  = {Branch, MemRead, MemWrite};
assign out_EX = {RegDst ,ALUop, ALUsrc};

RegisterFile regfile(clk,in_regWrite, read1, read2, in_writeToReg, in_data, out_data1, out_data2 );
SignExtender_16to32 se(out_extended, into_extender);
endmodule 

/////execute stage//////////

module execute(clk,in_WB,in_M,in_EX,in_incremented_PC,in_regData1,in_regData2,in_sign_extended_offset,in_rt,in_rd,
  out_WB,out_M,out_branch_address,out_zero_flag,out_ALU_result,out_reg_write_data,out_rd);
input clk;
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

reg [31:0] shifted_sign_extended_offset;
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
module memory(clk,in_WB,in_M,in_branch_address,in_zero_flag,in_ALU_result,in_reg_write_data,in_rd,
  out_ALU_result,out_memory_word_read,out_rd,out_WB);
input clk;
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

DataMemory(out_memory_word_read,in_ALU_result,in_reg_write_data,in_M[0],in_M[1]);

reg PCSrc;
assign PCSrc = in_zero_flag & in_M[2];

endmodule

///// write back stage//////

module writeBack(in_WB,in_regData1,in_regData2,in_regData3,out_wb,out_muxRes,out_regData);
	input in_WB;
	input [31:0] in_regData1,in_regData2,in_regData3;
	output reg out_wb;
	output reg [31:0] out_muxRes, out_regData;

	assign out_WB = in_WB;
	assign out_regData = in_regData3;

	MUX_2to1(out_muxRes, in_regData1, in_regData2, in_WB);
endmodule

///test bench///////////////

module testbench();
endmodule


////////////////////////////
