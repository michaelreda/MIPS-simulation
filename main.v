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

module main(clk);
input clk;
reg [63:0] IF_ID;
reg [146:0] ID_EX;
reg [106:0] EX_MEM;
reg [70:0] MEM_WB;

//outputs from writeback stage
wire[31:0] out_writeData;
wire[4:0] out_rd;

//outputs from Memory stage
wire PCSrc;
wire out_branch_address;

//exec  ( clk, WB 2b   , M 3b      ,EXE 4b    , incPC 32b, in_regData1 32b,in_regData2  32b, in_sign_extended_offset 32b, in_rt 5b ,     in_rd 5b    ,out_WB 2b,  out_M 3b   ,out_branch_address 32b,out_zero_flag 1b,out_ALU_result 32b,out_reg_write_data 32,out_rd)
execute (clk,ID_EX[1:0], ID_EX[4:2],ID_EX[8:5], ID_EX[40:9], ID_EX[72:41]   ,ID_EX[104:73]   ,   ID_EX[136:105]         ,ID_EX[141:137],ID_EX[146:142], EX_MEM[1:0], EX_MEM[4:2],    EX_MEM[36:5]     , EX_MEM[37]   ,     EX_MEM[69:38] ,      EX_MEM[101:70] , EX_MEM[106:102]);

//mem(clk,in_WB 2b     ,  in_M 3b,  in_branch_address 32b,in_zero_flag 1b,in_ALU_result 32b,  in_reg_write_data 32b,   in_rd  5b    ,out_WB 2b ,out_ALU_result 32b,out_memory_word_read 32b,out_rd 5b);
memory (clk,EX_MEM[1:0], EX_MEM[4:2],    EX_MEM[36:5]     , EX_MEM[37]   ,     EX_MEM[69:38] ,      EX_MEM[101:70] , EX_MEM[106:102],MEM_WB[1:0],    MEM_WB[33:2]  ,        MEM_WB[65:34]  ,MEM_WB[70:66], PCSrc,out_branch_address);

//WB(      clk,in_WB 2b ,in_ALU_result 32b,in_memory_word_read 32b,      in_rd 5b,  out_writeData,out_rd
writeBack(clk,MEM_WB[1:0],    MEM_WB[33:2]  ,        MEM_WB[65:34]  ,MEM_WB[70:66], out_writeData,out_rd);

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

always @ (posedge clk)
begin
$monitor("---execute Stage:--- INPUTS:\n in_wb: %b \n",in_WB,
          "in_M %b \n",in_M,
          "in_EX %b \n",in_EX,
          "in_incremented_PC %d \n",in_incremented_PC,
          "in_regData1 %d \n",in_regData1,
          "in_regData2 %d \n",in_regData2,
          "in_sign_extended_offset %d \n",in_sign_extended_offset,
          "in_rt %d \n",in_rt,
          "in_rd %d \n",in_rd,
          "---execute Stage:--- OUTPUTS:\n out_WB %b \n",out_WB,
          "out_WB %b \n",out_WB,
          "out_branch_address %d \n",out_branch_address,
          "out_zero_flag %d \n",out_zero_flag,
          "out_ALU_result %d \n",out_ALU_result,
          "out_rd %d \n",out_rd
          );
end

endmodule

////mem  stage//////////////
module memory(clk,in_WB,in_M,in_branch_address,in_zero_flag,in_ALU_result,in_reg_write_data,in_rd,
  out_WB,out_ALU_result,out_memory_word_read,out_rd,PCSrc,out_branch_address);
input clk;
input [1:0] in_WB;
input [2:0] in_M;
input [31:0] in_branch_address,in_ALU_result,in_reg_write_data;
input in_zero_flag;
input [4:0] in_rd;

output reg [31:0] out_ALU_result,out_memory_word_read;
output reg [4:0] out_rd;
output reg [1:0] out_WB;
output reg PCSrc;
output reg [31:0] out_branch_address;

assign out_WB = in_WB;
assign out_rd = in_rd;
assign out_branch_address= in_branch_address;

DataMemory(out_memory_word_read,in_ALU_result,in_reg_write_data,in_M[0],in_M[1]);


assign PCSrc = in_zero_flag & in_M[2];


always @ (posedge clk)
begin
$monitor("---Memory Stage:--- INPUTS:\n in_wb: %b \n",in_WB,
          "in_M: %b \n",in_M,
          "in_branch_address: %d \n",in_branch_address,
          "in_zero_flag: %d \n",in_zero_flag,
          "in_ALU_result: %d \n",in_ALU_result,
          "in_reg_write_data: %d \n",in_reg_write_data,
          "in_rd: %d \n",in_rd,
          "---Memory Stage:--- OUTPUTS:\n out_WB: %b \n",out_WB,
          "out_ALU_result: %d \n",out_ALU_result,
          "out_memory_word_read: %d \n",out_memory_word_read,
          "out_rd: %d \n",out_rd,
          "PCSrc: %d \n",out_branch_address
          );
end

endmodule

///// write back stage//////

module writeBack(clk,in_WB,in_ALU_result,in_memory_word_read,in_rd,out_writeData,out_rd);
  input clk;
	input [1:0] in_WB;
	input [31:0] in_ALU_result,in_memory_word_read;
  input [4:0] in_rd;
	output reg out_regWrite;
	output reg [31:0] out_writeData, out_rd;

	assign out_rd = in_rd;

	MUX_2to1(out_writeData, in_ALU_result,in_memory_word_read, in_WB[1]);

in_WB,in_ALU_result,in_memory_word_read,in_rd,out_writeData,out_rd
  always @ (posedge clk)
  begin
  $monitor("---writeBack Stage:--- INPUTS:\n in_wb: %b \n",in_WB,
            "in_ALU_result: %d \n",in_ALU_result,
            "in_memory_word_read: %d \n",in_memory_word_read,
            "in_rd: %d \n",in_rd,
            "---writeBack Stage:--- OUTPUTS:\n out_writeData: %b \n",out_writeData,
            "out_rd: %d \n",out_rd
            );
  end
endmodule

///test bench///////////////

module testbench();
reg clk;

initial begin
  clk=0;
  forever
  #5 clk = ~clk;
end

main(clk);


endmodule


////////////////////////////
