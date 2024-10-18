`timescale 1ns / 1ps

module pdl_tb();
    reg clk = 0; 
    reg [width-1:0] data_in = 0; 
    reg reset = 0; 
    reg w_enable = 0; 
    reg r_enable = 0; 
    wire [width-1:0] data_out; 
    integer i;

    parameter width = 16;
    parameter depth = 32;
    
    pdl u1(.clk(clk), .data_in(data_in), .reset(reset), .w_enable(w_enable), .r_enable(r_enable), .data_out(data_out));
    
    always begin 
    clk = #5 ~clk;
    end

    initial begin

    reset <= 1 ;
    #20;
    reset <= 0;    
    
    w_enable <= 1;
    data_in <= 8'h1; 
    #10;
    data_in <= 8'h2; 
    #10;
    data_in <= 8'h3; 
    #10;
    data_in <= 8'h4; 
    #10;
    data_in <= 8'h5; 
        r_enable <= 1;

    #10;
    data_in <= 8'h6; 
    #10;
    data_in <= 8'h7; 
    #10;
    data_in <= 8'h8; 
    #10;
    data_in <= 8'h9; 
    #10;
    data_in <= 8'h10; 
    #10;
    
    
    w_enable <= 0;
    r_enable <= 1;
    #10;
    r_enable <= 0;
    
    #20
    w_enable <= 1;
    data_in <= 8'ha6; 
    #10;
    w_enable <= 0;
    r_enable <= 1;
    #10;
    r_enable <= 0;
    r_enable <= 0;
    
    w_enable <= 1;
    data_in <= 8'h01; 
    #10;
    w_enable <= 0;
    r_enable <= 1;
    #10;
    r_enable <= 0;
    
    #20
    w_enable <= 1;
    data_in <= 8'h00; 
    #10;
    w_enable <= 0;
    r_enable <= 1;
    #10;
    r_enable <= 0;
    r_enable <= 0;
    
    #10;
    
    w_enable <= 1;
    r_enable <= 1;
    data_in <= 8'h15; 
    #10;
    w_enable <= 0;
    #10;
    r_enable <= 0;
    
    #20
    w_enable <= 1;
    data_in <= 8'h28; 
    #10;
    w_enable <= 0;
    r_enable <= 1;
    #10;
    r_enable <= 0;
    r_enable <= 0;
    
    
    
        $finish;

    
    
    
    end

endmodule
