module RegisterFile(
	RegWriteSig,
	readReg1,readReg2,writeReg,
	writeData,
	RegData1,RegData2
);
	
	input RegWriteSig;
	input[4:0] readReg1,readReg2,writeReg;
	input[31:0] writeData;
	output[31:0] RegData1,RegData2;
	reg[31:0]RegData1,RegData2;
	reg[31:0]registersArray[31:0];
	initial registersArray[0] = 32'd0;
	always @(readReg1 or readReg2)
	begin 
		RegData1 <= (readReg1==0)?32'b0:registersArray[readReg1];
		RegData2 <= (readReg2==0)?32'b0:registersArray[readReg2];
	end
	
	always @(RegWriteSig or writeReg or writeData)
	begin
		if(RegWriteSig)
		     begin
			if(writeReg>0)			
			registersArray[writeReg] <= writeData;	
		         
		     end
	end	

endmodule

module tb();
	reg clk;
	reg RegWriteSig;
	reg[4:0] readReg1,readReg2,writeReg;
	reg[31:0] writeData;
	wire[31:0] RegData1,RegData2;
	
	RegisterFile test(
	RegWriteSig,
	readReg1,readReg2,writeReg,
	writeData,
	RegData1,RegData2);
	
	initial begin
		clk=0;
		forever
		#5 clk = ~clk;
	end
	
	initial begin
		#5 readReg1 <= 5'd0;
		#10 writeReg <= 5'd20;RegWriteSig<=1; writeData<= 32'd 50;
		#10 RegWriteSig <=0;
		#10 readReg2 <= 5'd20;
		#5 $finish;
	end
	
	initial
		$monitor("time: %t ReadData1: %d ReadData2: %d  clk: %d signal: %d",$time,RegData1,RegData2,clk,RegWriteSig);
	
	
endmodule
