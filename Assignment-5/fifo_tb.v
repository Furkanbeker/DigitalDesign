`timescale 1ns / 1ps

module fifo_tb();
    reg clk = 0; 
    reg [width-1:0] data_in = 0; 
    reg reset = 0; 
    reg w_enable = 0; 
    reg r_enable = 0; 
    wire [width-1:0] data_out; 
    wire empty; 
    wire full;
    integer i;

    parameter width = 16;
    parameter depth = 32;
    
    fifo u1(.clk(clk), .data_in(data_in), .reset(reset), .w_enable(w_enable), .r_enable(r_enable), .data_out(data_out), .empty(empty), .full(full));
    
    always begin 
    clk = #5 ~clk;
    end

    initial begin

    reset <= 1 ;
    #20;
    reset <= 0;    
    w_enable <= 1;
    
    for(i = 0; i < 7; i = i+1) begin 
        data_in <= i; 
        #10;
    end 
    r_enable <= 1;
    w_enable <= 0;
    #50;    
    while(!empty) begin
    #10;
    end
    r_enable <= 0;    
    #50;  
    w_enable <= 1;  
    for(i = 0; i < 5; i = i+1) begin 
        data_in <= i; 
        #10;
    end   
    w_enable <= 0;
    #50;
    r_enable <= 1;
    while(!empty) begin
    #10;
    end
    r_enable <= 0;
    
        
    w_enable <= 1;
    data_in <= 1; 
        #15;
    r_enable <= 1;
        
    data_in <= 4; 
        #10;
    
    data_in <= 6; 
        #10;
        
    data_in <= 3; 
        #100;

    w_enable <= 0;
    #50;
    r_enable <= 0;
    
    
        $finish;

    
    
    
    end

endmodule
