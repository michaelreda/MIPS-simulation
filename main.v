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

module decode();


endmodule

/////execute stage//////////

module execute();
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

