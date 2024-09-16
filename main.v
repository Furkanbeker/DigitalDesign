`timescale 1ns / 1ps

module counter(clk,x,rst,count);
    input wire clk,x,rst;
    output reg [2:0] count;
        
    always@(posedge clk) begin
    if (!rst) begin
        count <= 0;
    end
    
    else if (x ==1) begin
        count <= count +1;
    end
    
    else begin
        count <= count -1;
    end
    end   
    
endmodule