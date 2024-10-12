`timescale 1ns / 1ps

module counter_tb();
    reg clk_f = 1'b0;
    wire clk_s;
    wire [7:0] count_f;
    wire [7:0] count_s;
    wire [7:0] counterr;
    reg [1:0] rst = 0;
    reg mode= 1'b0;
    
    counter a1(.clk_f(clk_f), .clk_s(clk_s), .count_f(count_f), .count_s(count_s), .rst(rst), .counterr(counterr), .mode(mode));
    
    always begin
    clk_f = #10 ~clk_f;
    end
    
    initial begin
    
    rst=1;
    #10 rst=0; mode=1'b1;
    #250 mode = 1'b0;
    #250 mode = 1'b1;
    #250 rst =1; mode = 1'b0;
    #15 rst=0;
    
    end
endmodule


