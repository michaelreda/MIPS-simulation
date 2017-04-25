module SignExtender_16to32(clk,outData,inData);
  input clk;
  input[15:0] inData;
  output[31:0] outData;
  reg [31:0] outData;
  
  always@(clk)
    begin
      
      outData[15:0]  = inData[15:0];
      outData[31:16] = {16{inData[15]}};
      
    end
endmodule


module test();

reg[15:0] inData;
wire[31:0] outData;


initial begin
inData=16'd5323;
#10 $display("the inData is:%b outData is:%b",inData,outData);

inData=0 - 16'd323;
#10 $display("the inData is:%b outData is:%b",inData,outData);
end

SignExtender_16to32 testing(outData,inData);

endmodule
