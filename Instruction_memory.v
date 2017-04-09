module Instruction_memory(read_address, instruction);
output  [31:0] instruction;
reg   [31:0] instruction;
input [31:0] read_address;


reg [7:0] registers [255:0];

//initial registers[20] = 8'd0;
//initial registers[21] = 8'd0;
//initial registers[22] = 8'd0;
//initial registers[23] = 8'd6;

always @(read_address)
begin
instruction[31:24] <= registers[read_address][7:0];
instruction[23:16] <= registers[read_address+1][7:0];
instruction[15:8] <= registers[read_address+2][7:0];
instruction[7:0] <= registers[read_address+3][7:0];

end
endmodule

module tb();

	reg [31:0] read_address;
	reg clk;
	wire[31:0] instruction;
	
	Instruction_memory test(read_address, instruction);
	
	initial begin
		clk=0;
		forever
		#5 clk = ~clk;
	end
	
	initial begin
		
		#10 read_address <= 5'd20; 
		#10 $finish;
	end
	
	initial
		$monitor("time: %t instruction: %d read_address: %d ",$time,instruction,read_address);
	
	
endmodule
