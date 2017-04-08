module MUX_2to1(out, in1 , in2, select );
  input [31:0] in1, in2;
  input select;
  output [31:0]out;
  reg [31:0]out;
  always @(in1 or in2 or select )
    begin 
      case(select)
          1'b0:   out=in1;
          1'b1:  out=in2;
      endcase
    end
 endmodule  
