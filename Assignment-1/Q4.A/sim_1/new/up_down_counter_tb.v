`timescale 1ns / 1ps

module fpga_tb();
    reg clk_1 = 1'b0;
    wire clk_2;
    reg x;
    wire [3:0] counter;
    reg rst = 0;
    wire mode ;
    wire clk;
    
    fpga a1(.clk_1(clk_1), .clk_2(clk_2), .x(x), .counter(counter), .rst(rst), .mode(mode), .clk(clk));
    
    always begin
    clk_1 = #5 ~clk_1;
    end
    
    initial begin 
    x=0; rst =1 ;
    #5; rst = 0;
    #500 ; x= 1;
    #250 ; x=0 ;
    end
    
endmodule



