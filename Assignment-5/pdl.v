`timescale 1ns / 1ps


module pdl(clk, data_in, reset, w_enable, r_enable, data_out);
    input wire reset,clk;
    input wire [width-1:0] data_in;  
    input wire w_enable;
    input wire r_enable ;
    output reg [width-1:0] data_out = 0;
    reg [width-1:0] memory ;
    
    parameter width = 16; 
    parameter depth = 32;
    
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 0;
            data_out <= 0;
            end
            
        else begin
            if (w_enable ) begin
                memory <= data_in;
                end
                
            if (r_enable ) begin
                data_out <= memory;
                end
            end       
    end
endmodule    





