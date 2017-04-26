//////include components/////

//`include "Adder32Bit.v"
//`include "ALU.v"
//`include "ALU_CTRL.v"
//`include "Control.v"
//`include "DataMemory.v"
//`include "forwarding.v"
//`include "Instruction_memory.v"
//`include "MUX_2to1.v"
//`include "MUX_3x1.v"
//`include "RegisterFile.v"
//`include "ShiftLeft2Bits.v"
//`include "SignExtender_16to32.v"
//`include "TTbitReg.v"

//////main pipelined circuit////

module main(clk);
input clk;
wire [63:0] IF_ID;
wire [147:0] ID_EX;
wire [106:0] EX_MEM;
wire [70:0] MEM_WB;

//outputs from writeback stage
wire[31:0] out_writeData;
wire[4:0] out_rd;
wire out_regWrite;

//outputs from Memory stage
wire PCSrc;
wire [31:0]out_branch_address;

// $monitor("---clk : --- \n IF_ID %b \n",IF_ID,
//           "ID_EX %b \n",ID_EX,
//           "EX_MEM %b \n",EX_MEM,
//           "MEM_WB %b \n",MEM_WB
//           );


fetch f(clk,out_branch_address,PCSrc,IF_ID[31:0], IF_ID[63:32]);


decode d(clk, out_regWrite, IF_ID[63:32], IF_ID[31:0],out_writeData,out_rd,  ID_EX[1:0], ID_EX[4:2],ID_EX[9:5], ID_EX[41:10], ID_EX[73:42]   ,ID_EX[105:74]   , ID_EX[137:106],ID_EX[142:138],ID_EX[147:143]);

//exec  ( clk, WB 2b   , M 3b      ,EXE 4b    , incPC 32b, in_regData1 32b,in_regData2  32b, in_sign_extended_offset 32b, in_rt 5b ,     in_rd 5b    ,out_WB 2b,  out_M 3b   ,out_branch_address 32b,out_zero_flag 1b,out_ALU_result 32b,out_reg_write_data 32,out_rd)
execute e(clk,ID_EX[1:0], ID_EX[4:2],ID_EX[9:5], ID_EX[41:10], ID_EX[73:42]   ,ID_EX[105:74]   ,   ID_EX[137:106]         ,ID_EX[142:138],ID_EX[147:143], EX_MEM[1:0], EX_MEM[4:2],    EX_MEM[36:5]     , EX_MEM[37]   ,     EX_MEM[69:38] ,      EX_MEM[101:70] , EX_MEM[106:102]);

//mem(clk,in_WB 2b     ,  in_M 3b,  in_branch_address 32b,in_zero_flag 1b,in_ALU_result 32b,  in_reg_write_data 32b,   in_rd  5b    ,out_WB 2b ,out_ALU_result 32b,out_memory_word_read 32b,out_rd 5b);
memory m(clk,EX_MEM[1:0], EX_MEM[4:2],    EX_MEM[36:5]     , EX_MEM[37]   ,     EX_MEM[69:38] ,      EX_MEM[101:70] , EX_MEM[106:102],MEM_WB[1:0],    MEM_WB[33:2]  ,        MEM_WB[65:34]  ,MEM_WB[70:66], PCSrc,out_branch_address);

//WB(      clk,in_WB 2b ,in_ALU_result 32b,in_memory_word_read 32b,      in_rd 5b,  out_writeData,out_rd, out_regWrite
writeBack w(clk,MEM_WB[1:0],    MEM_WB[33:2]  ,        MEM_WB[65:34]  ,MEM_WB[70:66], out_writeData,out_rd,out_regWrite);

endmodule

//////fetch stage//////////////

module fetch(clk, in_branch , in_branchSel, out_instruction, out_incremented_pc );
input clk, in_branchSel;
input [31:0] in_branch;
output [31:0] out_instruction, out_incremented_pc ;
//reg [31:0]  out_instruction, out_incremented_pc;

wire [31:0] mux_out, pc_out;


//initial PC = 32'd40;

MUX_2to1 pc_update(clk,mux_out, out_incremented_pc , in_branch, in_branchSel);
reg reset=0;
TTbitReg PC (clk,reset, mux_out, pc_out);
Instruction_memory IM(clk,pc_out, out_instruction);
Adder32Bit pc_increment(clk,out_incremented_pc,pc_out, 32'd4);

always @ (posedge clk)
begin
$monitor("---fetch Stage:--- INPUTS:\n in_branchSel: %b \n",in_branchSel,
          "in_branch %b \n",in_branch,
          "---fetch Stage:--- OUTPUTS:\n out_instruction %b \n",out_instruction,
         "out_instruction %d \n",out_instruction,
          "out_incremented_pc %d \n",out_incremented_pc,
          );
end


endmodule




/////decode stage////////////

module decode( clk, in_regWrite, in_incremented_pc, in_instruction, in_data, in_writeToReg,
              out_WB, out_M,out_EX,out_incremented_pc, out_data1, out_data2, out_extended, out_rt, out_rd );
input clk,in_regWrite;
input [31:0] in_instruction, in_data,in_incremented_pc;
input [4:0] in_writeToReg;//edited to 5 bits by tweety
output [1:0] out_WB;
output [2:0] out_M;
output [4:0] out_EX;
output [31:0] out_incremented_pc, out_data1, out_data2, out_extended;
output	 [4:0] out_rd, out_rt;

reg [1:0] out_WB;
reg [2:0] out_M;
reg [4:0] out_EX;
//reg [31:0] out_incremented_pc, out_data1, out_data2, out_extended;
reg [31:0] out_incremented_pc;
reg [4:0] out_rd, out_rt;




wire [5:0] op_code = in_instruction[5:0];
wire [15:0] into_extender = in_instruction[15:0];
wire [4:0] read1 = in_instruction[10:6];
wire [4:0] read2 =in_instruction[15:11];

always @(posedge clk)
begin
 out_incremented_pc = in_incremented_pc  ;
 out_rd = in_instruction[20:16];
 out_rt = in_instruction[15:11];
end

wire [2:0] ALUop;
Control main_crtl(clk,RegDst,Branch,MemRead,MemtoReg,ALUop,MemWrite,ALUsrc,RegWrite,op_code);
always @(posedge clk)
begin
 out_WB = {RegWrite, MemtoReg};
 out_M  = {Branch, MemRead, MemWrite};
 out_EX = {RegDst ,ALUop, ALUsrc};
end

RegisterFile regfile(clk,in_regWrite, read1, read2, in_writeToReg, in_data, out_data1, out_data2 );
SignExtender_16to32 se(clk,out_extended, into_extender);



always @ (posedge clk)
begin
$monitor("---decode Stage:--- INPUTS:\n in_regWrite: %b \n",in_regWrite,
		  "in_incremented_pc %d \n",in_incremented_pc,
          "in_instruction %b \n",in_instruction,
          "in_data %b \n",in_data,
          "in_writeToReg %d \n",in_writeToReg,
          "---decode Stage:--- OUTPUTS:\n out_WB %b \n",out_WB,
          "out_M %b \n",out_M,
          "out_EX %b \n",out_EX,
         "out_incremented_pc %d \n",out_incremented_pc,
          "out_data1 %d \n",out_data1,
          "out_data2 %d \n",out_data2,
          "out_rd %d \n",out_rd,
          "out_rt %d \n",out_rt,
          "out_extended %d \n",out_extended
          );
end



endmodule

/////execute stage//////////

module execute(clk,in_WB,in_M,in_EX,in_incremented_PC,in_regData1,in_regData2,in_sign_extended_offset,in_rt,in_rd,
  out_WB,out_M,out_branch_address,out_zero_flag,out_ALU_result,out_reg_write_data,out_rd);
input clk;
input [1:0] in_WB;
input [2:0] in_M;
input [4:0] in_EX;
input [31:0] in_incremented_PC,in_regData1,in_regData2,in_sign_extended_offset;
input [4:0] in_rt,in_rd;
output  [2:0] out_M;
output  [1:0] out_WB;
output  [31:0] out_branch_address,out_ALU_result,out_reg_write_data;
output  out_zero_flag;
output  [4:0] out_rd;

  reg [2:0] out_M;
  reg [1:0] out_WB;
  //reg [31:0] out_branch_address,out_ALU_result,out_reg_write_data;
  reg [31:0] out_reg_write_data;
  //reg out_zero_flag;
//  reg [4:0] out_rd;

always @(posedge clk)
begin
 out_WB = in_WB;
 out_M = in_M;
 out_reg_write_data=in_regData2;
end

wire [31:0] shifted_sign_extended_offset;
ShiftLeft2Bits shifter(clk,shifted_sign_extended_offset,in_sign_extended_offset);
Adder32Bit adder(clk,out_branch_address,in_incremented_PC,shifted_sign_extended_offset);

wire[2:0] ALU_CTRL_output;
ALU_CTRL ctrl(clk,in_sign_extended_offset[5:0],in_EX[4:2],ALU_CTRL_output);


wire[31:0] ALU_input2;
MUX_2to1 mux1(clk,ALU_input2,in_regData2,in_sign_extended_offset,in_EX[0]);

ALU alu(clk,in_regData1,ALU_input2,out_ALU_result,ALU_CTRL_output,out_zero_flag );

MUX_2to1_5b mux2(clk,out_rd,in_rt,in_rd,in_EX[1]);

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

output  [31:0] out_ALU_result,out_memory_word_read;
output  [4:0] out_rd;
output  [1:0] out_WB;
output  PCSrc;
output  [31:0] out_branch_address;

// reg [31:0] out_ALU_result,out_memory_word_read;
reg [31:0] out_ALU_result;
 reg [4:0] out_rd;
 reg [1:0] out_WB;
 reg PCSrc;
 reg [31:0] out_branch_address;

 always @ (posedge clk)
begin
 out_WB = in_WB;
 out_rd = in_rd;
 out_branch_address= in_branch_address;
end

DataMemory d(clk,out_memory_word_read,in_ALU_result,in_reg_write_data,in_M[0],in_M[1]);

 always @ (posedge clk)
begin
PCSrc = in_zero_flag & in_M[2];
end

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

module writeBack(clk,in_WB,in_ALU_result,in_memory_word_read,in_rd,out_writeData,out_rd,out_regWrite);
  input clk;
	input [1:0] in_WB;
	input [31:0] in_ALU_result,in_memory_word_read;
  input [4:0] in_rd;
	output  out_regWrite;
	output  [31:0] out_writeData;
	output [4:0] out_rd;

	reg  out_regWrite;
//	reg  [31:0] out_writeData, out_rd;
	reg  [4:0]  out_rd;

always @ (posedge clk)
begin
	 out_rd = in_rd;
     out_regWrite= in_WB[0];
end
	MUX_2to1 m(clk,out_writeData, in_ALU_result,in_memory_word_read, in_WB[1]);


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

module testbenchmain();
reg clk;

initial begin
  clk=0;
  forever
  #5 clk = ~clk;
end

main m(clk);


endmodule


////////////////////////////
