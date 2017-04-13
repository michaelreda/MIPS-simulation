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


module main;
  initial 
    begin
      $display("Hello, World");
      $finish ;
    end
endmodule



module fetch(clk, branchIN, noBranchIN, branchSel, IF_ID);
input ckl, branchSel;
input [31:0] branchIN, noBranchIN;
output [63:0] IF_ID;
reg [63:0] IF_ID;

endmodule

module decode();
endmodule

module execute();
endmodule

module mem();
endmodule

module writeBack();
endmodule

