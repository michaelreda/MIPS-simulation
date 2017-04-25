module ALU_CTRL(clk,in, alu_op, select);
input clk;
input [5:0]in;
input [2:0] alu_op;
output [2:0] select;
reg [2:0] select;


always @(posedge clk)
begin
case(in)

6'h20: begin
 	select <= 3'd0;
       end
6'h22: begin
 	select <= 3'd1;
       end
6'h24: begin
 	select <= 3'd2;
       end
6'h25: begin
 	select <= 3'd3;
       end
6'h0: begin
 	select <= 3'd4;
       end
6'h2: begin
 	select <= 3'd5;
       end
6'h2A: begin
 	select <= 3'd6;
       end
endcase

end


endmodule




module test();
reg [5:0] in;
reg [2:0] alu_op;
reg clk;
wire [2:0] sel;


ALU_CTRL test(in, alu_op, sel);

initial begin
		clk=0;
		forever
		#5 clk = ~clk;
	end
initial begin
#0 alu_op <= 3'd0;
#0 in <= 6'h20;
#5 in <= 6'h22;
#10 in <= 6'h24;
#15 in <= 6'h25;
#20 in <= 6'h0;
#25 in <= 6'h2;
#30 in <= 6'h2A;
#35 $finish;
end


initial
		$monitor("time: %t in: %h alu_op: %h  sel: %d",$time,in,alu_op,sel);
endmodule
