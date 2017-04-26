module MUX_3x1(clk,out, in1 , in2, in3, select);
input [31:0] in1, in2, in3;
  input [1:0] select;
  output [31:0]out;
  reg [31:0]out;
  input clk;
  always @(posedge clk )
    begin
      case(select)
          2'b00: out <= in1;
          2'b01: out <= in2;
	      2'b10: out <= in3;
	      2'b11: out <= 32'bz;
      endcase
    end
 endmodule


module testbench9();
reg clk;
reg [31:0] in1, in2, in3;
reg [1:0] sel;
wire [31:0] out;

MUX_3x1 test(clk,out, in1 , in2,in3,sel );

initial begin
		clk=0;
		forever
		#5 clk = ~clk;
	end

initial begin
#0 in1 <= 32'd5;
#0 in2 <= 32'd9;
#0 in3 <= 32'd12;
#0 sel <= 2'b00;
#5 sel <= 2'b01;
#10 sel <= 2'b10;
#15 sel <= 2'b11;
#20 sel <= 2'b01;
#0 in2 <= 32'd0;


#25 $finish;
end


initial
		$monitor("time: %t in1: %d in2: %d in3: %d  sel: %d out: %d ",$time,in1,in2,in3,sel,out);



endmodule
