`timescale 1ns / 1ps

module clk_divider_tb();
    reg clk = 1'b0;
    reg[1:0] x = 0 ;
    wire clk_out;
    clk_divider a1(.clk(clk),.clk_out(clk_out),.x(x));
    
    always
    begin
    clk = #10 ~clk;
    end  
    
    initial begin
     x <= 2'b00;
    #200; x <= 2'b01;
    #200; x <= 2'b10;
    #300; x <= 2'b11;

    end
    

endmodule


