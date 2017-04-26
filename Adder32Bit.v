// module Adder32Bit(out, overflowBit,in1, in2);
module Adder32Bit(clk,out,in1, in2);
  input [31:0] in1, in2;
  output [31:0] out;
  reg [31:0]out;
  output overflowBit;
  input clk;
// reg overflowBit;
      always@(posedge clk)
        begin
          out  = in1 + in2;
          // {overflowBit , out } = in1 + in2;
        end
endmodule

// module test1();
// reg clk;
// reg [31:0] in1, in2;
// // wire overF;
// wire [31:0] out;
//
// // Adder32Bit test(out, overF, in1, in2);
// Adder32Bit test(clk,out, in1, in2);
//
// initial begin
// 		clk=0;
// 		forever
// 		#5 clk = ~clk;
// 	end
//
//
//
// initial begin
// #0 in1 <= 32'd2;
// #0 in2 <= 32'd20;
// #5 in1 <= 32'd25;
// #5 in2 = 32'd5;
//
// #10 $finish;
// end
//
// initial
// 		$monitor("time: %t in1: %d in2: %d out: %d",$time,in1,in2,out);
//
//
// endmodule
