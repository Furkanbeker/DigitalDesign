`timescale 1ns / 1ps

module counter(clk_f,clk_s,count_f,count_s,rst, counterr, mode);
    input wire clk_f;
    output reg clk_s = 0;    
    input wire rst;
    output reg [7:0] count_f = 0;
    output reg [7:0] count_s = 0;
    output reg [7:0] counterr = 0;
    input wire mode;
    reg [4:0] count = 0;
    
    always@(posedge clk_f ) begin
    count <= count +1;
    if (count == 2) begin
        clk_s = ~clk_s;
        count <= 1;
        end
        
    if (rst) begin
        count_f <= 0;
        count_s <= 0;
        counterr <= 0;
        end
    
    else begin
        count_f = count_f +1;
        if (mode == 1'b1) begin
            counterr <= counterr +1;
        end
        end
    end
        
    always@(posedge clk_s) begin
    if(rst) begin
        count_f <= 0;
        count_s <= 0;
        counterr <= 0;
        end
        
    else begin
        count_s = count_s +1;
            
        if (mode == 1'b0) begin
            counterr <= counterr +1;
            end
        end
     end
        
endmodule

