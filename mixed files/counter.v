`timescale 1ns / 1ps

module counter(x,rst,clk_f,clk_s,count_s,count_f);
    input wire clk_f;
    input wire [1:0] x;
    input wire rst;
    output reg clk_s = 0;
    output reg [2:0]count_s ;
    output reg [2:0]count_f ;
    reg [4:0]count = 0;
    
    always@(posedge clk_f) begin
    count <= count +1;
    if (count == 4)begin
        clk_s =  ~clk_s ;
        count <= 1;
    end    
    //////////////////////////////////////////////////////////////////////////////////////
    if (rst) begin
        count_s <= 0;
        count_f <= 0;
        end
        
    else if (x == 1) begin
        count_f = count_f +1;
    end
    end
    
    always@ (posedge clk_s) begin
    
    if (rst) begin
        count_s <= 0;
        count_f <= 0;
        end
        
    if (x == 0)  begin
        count_s = count_s + 1;
    end
    end
endmodule