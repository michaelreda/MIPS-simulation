module forwarding_unit(outA, outB, RegWrite_ex_mem, RegWrite_mem_wb, Rd_ex_mem, Rd_mem_wb, Rs_id_ex, Rt_id_ex);
output [1:0] outA, outB;
reg [1:0] outA, outB;
input RegWrite_ex_mem, RegWrite_mem_wb;
input [4:0] Rd_ex_mem, Rd_mem_wb, Rs_id_ex, Rt_id_ex;

always @(RegWrite_ex_mem or RegWrite_mem_wb or Rd_ex_mem or Rd_mem_wb or Rs_id_ex or Rt_id_ex)
begin

if(RegWrite_ex_mem==1 && Rd_ex_mem != 0 && Rd_ex_mem == Rs_id_ex )
outA <= 10;

if(RegWrite_ex_mem==1 && Rd_ex_mem != 0 && Rd_ex_mem == Rt_id_ex )
outB <= 10;

if(RegWrite_mem_wb==1 && Rd_mem_wb != 0 && Rd_ex_mem != Rs_id_ex && Rd_mem_wb == Rs_id_ex)
outA <= 01;

if(RegWrite_mem_wb==1 && Rd_mem_wb != 0 && Rd_ex_mem != Rt_id_ex && Rd_mem_wb == Rt_id_ex)
outB <= 01;

end
endmodule



module testbench();
wire [1:0] outA, outB;
reg clk;
reg RegWrite_ex_mem, RegWrite_mem_wb;
reg [4:0] Rd_ex_mem, Rd_mem_wb, Rs_id_ex, Rt_id_ex;

forwarding_unit test(outA, outB, RegWrite_ex_mem, RegWrite_mem_wb, Rd_ex_mem, Rd_mem_wb, Rs_id_ex, Rt_id_ex);

initial begin
		clk=0;
		forever
		#5 clk = ~clk;
	end


	initial begin
		
		#0 Rd_ex_mem <= 5'b00001;
		#0 Rs_id_ex  <= 5'b00001;  
		#0 RegWrite_ex_mem <= 1'b1; 
		#0 RegWrite_mem_wb <= 1'b0;
		
		#5 Rd_ex_mem <= 5'b00001;
		#5 Rs_id_ex  <= 5'b00111;  
		#5 RegWrite_ex_mem <= 1'b1; 
		#5 RegWrite_mem_wb <= 1'b0;

		#10 Rd_ex_mem <= 5'b00001;
		#10 Rs_id_ex  <= 5'b00001;  
		#10 RegWrite_ex_mem <= 1'b1; 
		#10 RegWrite_mem_wb <= 1'b0;		

		#15 Rd_ex_mem <= 5'b00001;
		#15 Rt_id_ex  <= 5'b00001;  
		#15 RegWrite_ex_mem <= 1'b1; 
		#15 RegWrite_mem_wb <= 1'b0;

		#20 Rd_mem_wb <= 5'b00001;
		#20 Rd_ex_mem <= 5'b01000;
		#20 Rs_id_ex  <= 5'b00110;
		#20 Rd_mem_wb <= 5'b00110;				
		#20 RegWrite_ex_mem <= 1'b0; 
		#20 RegWrite_mem_wb <= 1'b1;
		 	
		#25 Rd_mem_wb <= 5'b00001;
		#25 Rd_ex_mem <= 5'b01000;
		#25 Rt_id_ex  <= 5'b00110;
		#25 Rd_mem_wb <= 5'b00110;				
		#25 RegWrite_ex_mem <= 1'b0; 
		#25 RegWrite_mem_wb <= 1'b1;

		#30 $finish;
	end
	
	initial
		$monitor("time: %t outA: %b outB: %b ",$time,outA,outB);

endmodule
