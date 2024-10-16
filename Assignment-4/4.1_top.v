`timescale 1ns / 1ps

module top_tb();
    reg [31:0] in_num1 = 0;
    reg [31:0] in_num2 = 0;
    wire [63:0 ]out_num;
    reg clk = 1'b0;

    top u1(.clk(clk), .in_num1(in_num1), .in_num2(in_num2), .out_num(out_num));
    
always begin
clk = #5 ~clk;
end

initial begin
#50 in_num1 <= 32'd2; in_num2 <= 32'd2;
#50 in_num1 <= 20; in_num2 <= 10;
#50 in_num1 <= 2132; in_num2 <= 3212;
#50 in_num1 <= 5322; in_num2 <= 5652;
#50 in_num1 <= 76842; in_num2 <= 28654;
#50 in_num1 <= 76843552; in_num2 <= 28625354;
#50; $finish;
end

endmodule



