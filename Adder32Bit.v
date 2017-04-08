module Adder32Bit(out, overflowBit,in1, in2);
  input [31:0] in1, in2;
  output [31:0] out;
  reg [31:0]out;
  output overflowBit;
  reg overflowBit;
      always@(in1 or in2)
        begin
          {overflowBit , out } = in1 + in2;
        end
endmodule
