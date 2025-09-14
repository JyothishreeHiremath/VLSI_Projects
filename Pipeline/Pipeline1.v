`timescale 1ns / 1ps
module Pipeline_1(
input clk,rst,
input [7:0]a,b,c,d,
output [7:0]out
    );
    // Registor to store the results in 1st stage 
    reg [7:0]L12_x1, L12_x2, L12_d1;
    // Registor to store the results in 2nd stage  
    reg [15:0]L23_x3;
    reg  [7:0]L23_d2;
    // Registor to store the results in 3rd stage 
    reg [15:0]L3_result;
    //Logic with pipelining 
    //Stage 1 
    always@(posedge clk)begin
      if(rst)begin 
        L12_x1 <= 0;
        L12_x2 <= 0;
        L12_d1 <= 0;
      end else begin
        L12_x1 <= a + b;
        L12_x2 <= c-d;
        L12_d1 <= d;  
      end    
    end
    //Stage 2
    always@(posedge clk)begin
      if(rst)begin
        L23_x3 <= 0;
      end else begin
        L23_x3 <= L12_x1 * L12_x2;
        L23_d2 <= L12_d1;
      end
    end 
    //Stage 3
    always@(posedge clk)begin
      if(rst)begin
        L3_result <= 0;
      end else begin
      if(L23_d2 != 0)
        L3_result <= L23_x3 / L23_d2;
      else 
        L3_result <= 0;
      end   
    end
    //Final output 
    assign out = L3_result;
endmodule
