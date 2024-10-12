`timescale 1ns / 1ps

module counter(clk,x,rst,count );
    input wire x = 0;
    input wire clk,rst;
    output reg [2:0]count = 0;
    
    always@(posedge clk) begin
    if (!rst) begin
        count <= 0;
    end
    else   if (x == 1)begin
        count <= count+1;
     end
     
     else begin
        count <= count-1;
     end
     end
 endmodule
       
       
 
        
     
    