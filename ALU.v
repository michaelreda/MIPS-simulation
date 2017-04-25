module ALU(clk,in1,in2,out,aluop,zeroflag);
input clk;
input[31:0] in1;
input[31:0] in2;
input[2:0] aluop;
output reg [31:0] out;
output reg zeroflag;

always @(posedge clk)
begin
if(in1==in2)
zeroflag=1;
else
zeroflag=0;

case(aluop)
0:out=in1+in2; //add
1:out=in1-in2; //sub
2:out=in1&in2; //and
3:out=in1|in2; //or
4:out=in1<<in2; //sll Shift left logical
5:out=in1>>in2; //srl Shift right logical
6:out=(in1<in2)?1:0; //slt set on less than
endcase
end
endmodule

module test();

reg[31:0] x,y;
reg[2:0] select;
wire[31:0] res;
wire zeroflag;


initial begin
x=10;
y=5;
select=3'd0;
#10 $display("the result is:%d",res);
$display("flag: %d",zeroflag);
select=3'd1;
#10 $display("the result is:%d",res);
$display("flag: %d",zeroflag);
x=5;
select=3'd0;
#30 $display("the result is:%d",res);
$display("flag: %d",zeroflag);
select=3'd6;
x=1;
#10 $display("the result is:%d",res);
$display("flag: %d",zeroflag);
select=3'd5;
x=1;
#10 $display("the result is:%d",res);
$display("flag: %d",zeroflag);
end

ALU testing(x,y,res,select,zeroflag);

endmodule
