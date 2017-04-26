module RegisterFile(clk,
	WB,
	readReg1,readReg2,writeReg,
	writeData,
	RegData1,RegData2
);

	input WB,clk;
	input[4:0] readReg1,readReg2,writeReg;
	input[31:0] writeData;
	output[31:0] RegData1,RegData2;
	reg[31:0]RegData1,RegData2;
	reg[31:0]registersArray[31:0];
	initial registersArray[0] = 32'd0;
	always @(posedge clk)
	begin
		RegData1 <= (readReg1==0)?32'b0:registersArray[readReg1];
		RegData2 <= (readReg2==0)?32'b0:registersArray[readReg2];
	end

	always @(posedge clk)
	begin
		if(WB)
		     begin
			if(writeReg>0)
			registersArray[writeReg] <= writeData;

		     end
	end

endmodule

// module tb10();
// 	reg clk;
// 	reg WB;
// 	reg[4:0] readReg1,readReg2,writeReg;
// 	reg[31:0] writeData;
// 	wire[31:0] RegData1,RegData2;
//
// 	RegisterFile test(clk,
// 	WB,
// 	readReg1,readReg2,writeReg,
// 	writeData,
// 	RegData1,RegData2);
//
// 	initial begin
// 		clk=0;
// 		forever
// 		#5 clk = ~clk;
// 	end
//
// 	initial begin
// 		#5 readReg1 <= 5'd0;
// 		#10 writeReg <= 5'd20;WB<=1; writeData<= 32'd 50;
// 		#10 WB <=0;
// 		#10 readReg2 <= 5'd20;
// 		#5 $finish;
// 	end
//
// 	initial
// 		$monitor("time: %t ReadData1: %d ReadData2: %d  clk: %d signal: %d",$time,RegData1,RegData2,clk,WB);
//
//
// endmodule
