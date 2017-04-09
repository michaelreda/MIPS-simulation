module MUX_2to1(out, in1 , in2, select );
  input [31:0] in1, in2;
  input select;
  output [31:0]out;
  reg [31:0]out;
  always @(in1 or in2 or select )
    begin 
      case(select)
          1'b0:   out=in1;
          1'b1:  out=in2;
      endcase
    end
 endmodule  

module testbench();
reg clk;
reg [31:0] in1, in2;
reg sel;
wire [31:0] out;

MUX_2to1 test(out, in1 , in2, sel );

initial begin
		clk=0;
		forever
		#5 clk = ~clk;
	end

initial begin
#0 in1 <= 32'd5;
#0 in2 <= 32'd9;
#0 sel <= 1'b0;
#5 sel <= 1'b1;
#10 in2 <= 32'd0;


#15 $finish; 
end


initial
		$monitor("time: %t in1: %d in2: %d  sel: %d out: %d ",$time,in1,in2,sel,out);


endmodule
