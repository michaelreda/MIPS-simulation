module ALU(in1,in2,out,aluop,zeroflag);
input[31:0] in1;
input[31:0] in2;
input aluop;
output reg [31:0] out;
output reg zeroflag;

always @(in1,in2,aluop)
begin
if(in1==in2)
zeroflag=1;
else
zeroflag=0;

case(aluop)
0:out=in1+in2;
1:out=in1-in2;
endcase
end
endmodule

module test();

reg[31:0] x,y;
reg select;
wire[31:0] res;
wire zeroflag;





initial begin
x=10;
y=5;
select=0;
#10 $display("the result is:%d",res);
$display("flag: %d",zeroflag);
select=1;
#20 $display("the result is:%d",res);
$display("flag: %d",zeroflag);
x=5;
select=0;
#30 $display("the result is:%d",res);
$display("flag: %d",zeroflag);
end

ALU testing(x,y,res,select,zeroflag);

endmodule

