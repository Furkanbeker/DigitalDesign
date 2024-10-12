`timescale 1ns / 1ps

module up_down_counter_tb();
    reg clk = 1'b0 ;
    reg rst = 0;
    reg switch = 1'b0 ;
    wire [3:0] count ;
    wire mode;
    wire clk_2;
    wire clk_main;
    reg x=0;
 
    up_down_counter a1(.x(x), .clk_main(clk_main), .rst(rst), .clk_2(clk_2), .clk(clk), .switch(switch), .count(count), .mode(mode) );
    
    always begin
    clk = #10 ~clk;
    end
    
    initial begin
    
    switch = 0; rst = 1; x=0;
    #20 rst = 0; switch = 1;
    #200 switch = 0; x=1;
    #200 switch =1;
    #400 x=0;
    
    end
    
endmodule




