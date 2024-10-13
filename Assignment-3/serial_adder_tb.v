`timescale 1ns / 1ps

module serial_adder_tb();
    reg clk_i = 0;
    reg [7:0] A_i = 8'b0;
    reg [7:0] B_i = 8'b0;
    reg start_i = 0;
    reg rst_ni = 0; 
    wire [8:0] sum_o;
       
    serial_adder tb1(.A_i(A_i), .B_i(B_i) , .clk_i(clk_i), .start_i(start_i), .rst_ni(rst_ni), .sum_o(sum_o)); 
    
    always begin
    clk_i = #5 ~clk_i;
    end
 
    initial begin   
    rst_ni = 0;
    #20;
    rst_ni = 1; 
    #5;

    
    A_i = 8'd64; 
    B_i = 8'd37;
    start_i = 1;
    #10;
    start_i = 0;
    #100;
    
    A_i = 8'b01010111; 
    B_i = 8'b11101010;
    start_i = 1;
    #10;
    start_i = 0;
    #100;
    
    A_i = 8'd100; 
    B_i = 8'd50;
    start_i = 1;
    #10;
    start_i = 0;
    #100;
    
    A_i = 8'd111; 
    B_i = 8'd111;
    start_i = 1;
    #10;
    start_i = 0;
    #100;
    
    A_i = 8'd0; 
    B_i = 8'd0;
    start_i = 1;
    #10;
    start_i = 0;
    #100;
    
    A_i = 8'd200; 
    B_i = 8'd200;
    start_i = 1;
    #10;
    start_i = 0;
    #100;
    
    A_i = 8'b11111111; 
    B_i = 8'b11111110;
    start_i = 1;
    #10;
    start_i = 0;
    #100;
    
    A_i = 8'b11111101; 
    B_i = 8'b11111111;
    start_i = 1;
    #10;
    start_i = 0;
    #100;
  
    
    
    
    
    #50;
    $finish;
    
    
          
    end
endmodule
        