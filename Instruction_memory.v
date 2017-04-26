module Instruction_memory(clk,read_address, instruction);
output  [31:0] instruction;
reg   [31:0] instruction;
input [31:0] read_address;
input clk;


reg [7:0] registers [255:0];

initial registers[0] = 8'b00000001;
initial registers[1] = 8'b01001011;
initial registers[2] = 8'b01001000;
initial registers[3] = 8'b00100100;

// initial registers[7:4] = 8'd0;
// initial registers[11:8] = 8'd0;
// initial registers[15:12] = 8'd6;

always @(posedge clk)
begin
instruction[31:24] <= registers[read_address][7:0];
instruction[23:16] <= registers[read_address+1][7:0];
instruction[15:8] <= registers[read_address+2][7:0];
instruction[7:0] <= registers[read_address+3][7:0];

end
endmodule

module tb7();

	reg [31:0] read_address;
	reg clk;
	wire[31:0] instruction;

	Instruction_memory test(clk,read_address, instruction);

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
