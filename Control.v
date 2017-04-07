module Control(RegDst,Branch,MemRead,MemtoReg,ALUop,MemWrite,ALUsrc,RegWrite,opcode,clk);

output RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUsrc,RegWrite;
reg RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUsrc,RegWrite;
output[2:0] ALUop;
reg[2:0] ALUop;
input[5:0] opcode;
input clk;

always @(posedge clk)
begin
        //defaults
		ALUop[2:0]	<= 3'b000;
		ALUsrc		<= 1'b0;
		Branch	    <= 1'b0;
		RegDst		<= 1'b1;
		MemRead	    <= 1'b0;
		MemWrite	<= 1'b0;
		ALUsrc		<= 1'b0;
		RegWrite	<= 1'b1;
		MemtoReg    <= 1'b0;
		
		case (opcode)
		6'b100011: begin	//lw
				MemRead  <= 1'b1;
				RegDst   <= 1'b0;
				MemtoReg <= 1'b1;
				ALUop    <= 3'b0;
				ALUsrc   <= 1'b1;
		    	end
		    	
		6'b101011: begin	//sw
				MemWrite <= 1'b1;
				ALUop <= 1'b0;
				ALUsrc   <= 3'b001;
				RegWrite <= 1'b0;
			end
			
		6'b001000: begin	 //addi
				RegDst   <= 1'b0;
				ALUop    <= 3'b0;
				ALUsrc   <= 1'b1;
			end	
			
		6'b000000: begin	//add - sub - or - and - srl - sll -slt
			end	
		
		6'b000100: begin	//beq
                ALUop    <= 3'b0;
				Branch   <= 1'b1;
				RegWrite <= 1'b0;
		end	
		
		6'b000101: begin	//bne
                ALUop    <= 3'b0;
				Branch   <= 1'b1;
				RegWrite <= 1'b0;
		end
			
		endcase
end

endmodule

