`timescale 1ns / 1ps
module pipeline_1_tb();
  reg clk;
  reg [7:0]a,b,c,d;
  wire [7:0]out;
  
  initial begin
  clk = 0;
  end 
  Pipeline_1 dut(.a(a),.b(b),.c(c),.d(d),.clk(clk),.out(out));
  always #5 clk = ~clk; 
  initial begin
        a=0; b=0; c=0; d=0;
    #10; a=4; b=5; c=3; d=2;
    #10; a=10; b=3; c=15; d=5;
    #10; a=20; b=4; c=4; d=2;
    #10; a=15; b=2; c=10; d=4;
    #50; $finish;
  end 
  initial begin
    $monitor("time=%0t,a=%d,b=%d,c=%d,d=%d,out=%d",$time,a,b,c,d,out);
  end
endmodule
