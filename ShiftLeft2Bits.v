module ShiftLeft2Bits(clk,outData,inData);
  input [31:0]inData;
  output [31:0]outData;
  reg [31:0]outData;
  input clk;

  always@(posedge clk)
    begin
      outData = inData<<2;
    end
endmodule


module test();
reg clk;
reg [31:0] inData;
wire [31:0] outData;

ShiftLeft2Bits test(outData,inData);


initial begin
		clk=0;
		forever
		#5 clk = ~clk;
	end

initial begin
#0 inData <= 32'd70;
#5 inData <= 32'd110;
#10 inData <= 32'd12;


#15 $finish;
end


initial
		$monitor("time: %t inData: %b outData: %b",$time,inData,outData);



endmodule
