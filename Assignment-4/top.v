`timescale 1ns / 1ps

// Q - 3

module top( in_num1, in_num2, out_num, clk);
    input clk;
    input [31:0] in_num1;
    input [31:0] in_num2;
    output reg [63:0] out_num ;
    reg [15:0] in_num1_1, in_num1_2, in_num2_1, in_num2_2 ;
    reg [31:0] u1, u2, u3; 
    reg [31:0] mt;
    reg [63:0] shifted_u1, shifted_mt;

    always@(posedge clk) begin
    in_num1_1 <= in_num1[31:16];  // num_1l
    in_num1_2 <=  in_num1[15:0];  // num_1r
    in_num2_1 <=  in_num2[31:16]; // num_2l
    in_num2_2 <=  in_num2[15:0];  // num_2r
    end
    
    always@(posedge clk) begin

    u1 <= (in_num1_1 * in_num2_1);
    u2 <= (in_num1_2 * in_num2_2);
    u3 <= (in_num1_1 + in_num1_2) * (in_num2_1 + in_num2_2); 
    end

    always@(posedge clk) begin
    mt <= u3 - u1 - u2 ;
    end

    always@(posedge clk) begin
    shifted_u1 <= {u1, 32'b0};
    shifted_mt <= {mt, 16'b0};
    out_num <= shifted_u1 + shifted_mt + u2;
    end
    
endmodule

//    assign out_num = 2^32 * in_num1_1 * in_num2_1 + 2^16 * (in_num1_2 * in_num2_1 + in_num1_1 * in_num2_2) + in_num1_2*in_num2_2;    

///////////////////////////////////////////////////

//    assign u1 = (in_num1_1 * in_num2_1);
//    assign u2 = (in_num1_2 * in_num2_2);
//    assign u3 = (in_num1_2 * in_num2_1) + (in_num1_1 * in_num2_2);
        
//    out_num <= ((2^32) * u1) + ((2^16) * u3) + (u2);
//    assign out_num = ((in_num1_1 * 2^16) + (in_num1_2)) * ((in_num2_1 * 2^16) + (in_num2_2));

//    assign out_num = ((in_num1_1?) * (2^(32/2)) + (in_num1_2?)) ? ((in_num2_1?) * (2^(32/2)) + (in_num2_2)?);
    


