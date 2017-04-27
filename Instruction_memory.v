module Instruction_memory(clk,read_address, instruction);
output  [31:0] instruction;
reg   [31:0] instruction;
input [31:0] read_address;
input clk;


reg [7:0] registers [255:0];

//addi $t1,$t2,100
//0010 0001 0100 1001 0000 0000 0110 0100
// initial registers[0] = 8'b0010_0001;
// initial registers[1] = 8'b0100_1001;
// initial registers[2] = 8'b0000_0000;
// initial registers[3] = 8'b0110_0100;



//sub $t1,$t2,$t3
//0000 0001 0100 1011 0100 1000 0010 0010
//  initial registers[0] = 8'b0000_0001;
//  initial registers[1] = 8'b0100_1011;
//  initial registers[2] = 8'b0100_1000;
//  initial registers[3] = 8'b0010_0010;

//add $t5,$t2,$t3
//0000 0001 0100 1011 0110 1000 0010 0000
// initial registers[4] = 8'b0000_0001;
// initial registers[5] = 8'b0100_1011;
// initial registers[6] = 8'b0110_1000;
// initial registers[7] = 8'b0010_0000;


//lw $t5,1($0)
//1000 1100 0000 1101 0000 0000 0000 0001
// initial registers[0] = 8'b1000_1100;
// initial registers[1] = 8'b0000_1101;
// initial registers[2] = 8'b0000_0000;
// initial registers[3] = 8'b0000_0001;

//sw $t2,10($0)
//1010 1100 0000 1010 0000 0000 0000 1010
// initial registers[4] = 8'b1010_1100;
// initial registers[5] = 8'b0000_1010;
// initial registers[6] = 8'b0000_0000;
// initial registers[7] = 8'b0000_0100;


//beq $0,$0,30
//0001 0000 0000 0000 0000 0000 0000 0110
// initial registers[0] = 8'b0001_0000;
// initial registers[1] = 8'b0000_0000;
// initial registers[2] = 8'b0000_0000;
// initial registers[3] = 8'b0000_0110;

////beq $0,$10,30
//100a0006
// initial registers[0] = 8'h10;
// initial registers[1] = 8'h0a;
// initial registers[2] = 8'h00;
// initial registers[3] = 8'h06;

// initial registers[0] = 8'b00000001;
// initial registers[1] = 8'b01001011;
// initial registers[2] = 8'b01001000;
// initial registers[3] = 8'b00100000;

// initial registers[4] = 8'b00000001;
// initial registers[5] = 8'b01101001;
// initial registers[6] = 8'b01001000;
// initial registers[7] = 8'b00100000;

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

// module tb7();
//
// 	reg [31:0] read_address;
// 	reg clk;
// 	wire[31:0] instruction;
//
// 	Instruction_memory test(clk,read_address, instruction);
//
// 	initial begin
// 		clk=0;
// 		forever
// 		#5 clk = ~clk;
// 	end
//
// 	initial begin
//
// 		#10 read_address <= 5'd20;
// 		#10 $finish;
// 	end
//
// 	initial
// 		$monitor("time: %t instruction: %d read_address: %d ",$time,instruction,read_address);
//
//
// endmodule
