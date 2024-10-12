`timescale 1ns / 1ps

module counter_tb();
    reg clk =1'b0;
    reg x = 0;
    reg rst =1;
    wire [2:0]count;
    
    counter a1(.clk(clk),.rst(rst),.count(count),.x(x));
    
    always begin
    clk= #10 ~clk;
    end
    
    initial begin
    #50 rst=0;
    #50 x=1; rst=1;
    #100 rst=0;
    #50 rst=1;
    #100 x=0;
    #200 x=1;
    end
    
endmodule
    
    
    