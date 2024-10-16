`timescale 1ns / 1ps

// Q - 1

module top( clk, in_num1, in_num2, out_num);
    input clk;
    input [31:0] in_num1;
    input [31:0] in_num2;
    output reg [63:0] out_num;
    
    
    reg [31:0]in_num1_inp;
    reg [31:0]in_num2_inp;

    always@(posedge clk) begin
    in_num1_inp <= in_num1;
    in_num2_inp <= in_num2; 
    out_num <= in_num1_inp * in_num2_inp;
    
    end

endmodule


