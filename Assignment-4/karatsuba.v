`timescale 1ns / 1ps
// Q - 2

module karatsuba( clk, in_num1, in_num2, out_num);
    input clk;
    input [31:0] in_num1;
    input [31:0] in_num2;
    output reg [63:0] out_num = 0;
    reg [15:0] in_num1_1, in_num1_2, in_num2_1, in_num2_2 ;

    always@(posedge clk) begin
    in_num1_1 <= in_num1[31:16];  // num_1l
    in_num1_2 <=  in_num1[15:0];  // num_1r

    in_num2_1 <=  in_num2[31:16]; // num_2l
    in_num2_2 <=  in_num2[15:0];  // num_2r
    
    out_num <= 2^32 * in_num1_1 * in_num2_1 + 2^16 * (in_num1_2 * in_num2_1 + in_num1_1 * in_num2_2) + in_num1_2*in_num2_2;

    end
endmodule








//    assign u1 = (in_num1_1 * in_num2_1);
//    assign u2 = (in_num1_2 * in_num2_2);
//    assign u3 = (in_num1_2 * in_num2_1) + (in_num1_1 * in_num2_2);
        
//    out_num <= ((2^32) * u1) + ((2^16) * u3) + (u2);
//    assign out_num = ((in_num1_1 * 2^16) + (in_num1_2)) * ((in_num2_1 * 2^16) + (in_num2_2));

//    assign out_num = ((in_num1_1?) * (2^(32/2)) + (in_num1_2?)) ? ((in_num2_1?) * (2^(32/2)) + (in_num2_2)?);
    


