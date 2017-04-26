module DataMemory(clk,outputData, inputAddress, inputData, MemRead, MemWrite);
output [31:0] outputData;
reg [31:0] outputData;
input[31:0] inputAddress;
input[31:0] inputData;
input MemRead, MemWrite, clk;

reg [7:0]memory[255:0]; //memory //check about size !


reg[255:0] i;
initial fork
    #98 $display("---------Memory Data---------");
    #99 for( i = 0; i < 256; i++ )
           $display("%d  ::  %b",i,memory[i]);
join

always @(posedge clk )
begin
	if(MemWrite==1)
	begin
		memory[inputAddress] = inputData[31:24];
		memory[inputAddress+1] = inputData[23:16];
		memory[inputAddress+2] = inputData[15:8];
		memory[inputAddress+3] = inputData[7:0];
	end

	if (MemRead==1)
	begin
		outputData[31:24] = memory[inputAddress][7:0];
		outputData[23:16] = memory[inputAddress+1][7:0];
		outputData[15:8] = memory[inputAddress+2][7:0];
		outputData[7:0] = memory[inputAddress+3][7:0];
	end

end



endmodule

// module tb5();
//
// 	reg MemRead, MemWrite;
// 	reg[31:0] inputAddress,inputData;
// 	reg clk;
// 	wire[31:0] outputData;
//
// 	DataMemory test(clk,
// 	outputData,
// 	inputAddress,inputData,
// 	MemRead, MemWrite);
//
// 	initial begin
// 		clk=0;
// 		forever
// 		#5 clk = ~clk;
// 	end
//
// 	initial begin
//
// 		#10 inputAddress <= 5'd20; inputData<= 32'd 50;
// 		#10 MemWrite <= 1'b1;
// 		#10 MemRead <= 1'b1;MemWrite <= 1'b0;
// 		#10 $finish;
// 	end
//
// 	initial
// 		$monitor("time: %t outputData: %d inputAddress: %d ",$time,outputData,inputAddress);
//
//
// endmodule
