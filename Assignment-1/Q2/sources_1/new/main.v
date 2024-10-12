`timescale 1ns / 1ps

module clk_divider(clk_out,clk,x);
    input wire clk;
    input wire [1:0]x;
    output reg clk_out=0;
    reg [4:0]count =0;
    
    always@(posedge clk)begin
    count <= count +1;
    if(x==2'b00) begin
        if (count == 2) begin
            clk_out = ~clk_out;
            count <= 1; 
            end   
        end
     else if(x==2'b01) begin
        if (count == 4) begin
            clk_out = ~clk_out;
            count <= 1;    
            end
        end
     else if(x==2'b10) begin
        if (count == 8) begin
            clk_out = ~clk_out;
            count <= 1;    
            end
        end 
     else if(x==2'b11) begin
        if (count == 16) begin
            clk_out = ~clk_out;
            count <= 1;   
            end 
        end
     end  
    endmodule     
    





