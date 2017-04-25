module TTbitReg (clk,reset, in, out);
    input        reset, clk;
    input	[31:0]	in;
    output 	[31:0] 	out;
    reg 	[31:0]	out;

    always @(posedge clk)
    begin
        if (reset) out <= 32'd0;
        else out <= in;
    end

endmodule


module test();
reg clk,reset;
reg [31:0] in;

wire [31:0] out;

TTbitReg test(reset,in, out);

initial begin
		clk=0;
		forever
		#5 clk = ~clk;
	end



initial begin
#0 in <= 32'd2;
#0 reset <= 0;
#5 reset <= 1;
#5 reset <= 0;
#5 in <= 32'd5;


#15 $finish;
end

initial
		$monitor("time: %t in: %d  out: %d ",$time,in,out);


endmodule
