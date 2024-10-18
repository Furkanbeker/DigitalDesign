`timescale 1ns / 1ps

module fifo(clk, data_in, reset, w_enable, r_enable, data_out, empty, full);
    input wire reset,clk;
    input wire [width-1:0] data_in;  
    input wire w_enable;
    input wire r_enable ;
    output reg [width-1:0] data_out = 0;
    output reg empty ;
    output reg full ;
    reg [width-1:0] memory [0:depth-1] ;
    reg [31:0] w_pointer;
    reg [31:0] r_pointer;
    reg [31:0] count;
    
    parameter width = 16; 
    parameter depth = 32;
    
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            w_pointer <= 0;
            r_pointer <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
            data_out <= 0;
            end
            
        else begin
            if (w_enable && !full) begin
                w_pointer <= (w_pointer +1)%depth;
                memory[w_pointer] <= data_in;
                count <= count +1;
                end               
            if (r_enable && !empty) begin
                r_pointer <= (r_pointer +1)%depth; 
                data_out <= memory[r_pointer];
                count <= count -1;
                end                
            if (count ==0) begin
                empty <= 1;
                full <= 0;
                end               
            else if (count == depth) begin
                empty <= 0;
                full <= 1;
                end               
            else begin
                empty <= 0;
                full <= 0;
                end            
            end       
    end
endmodule    


    // width - depth 
    
    // write pointer and read pointer
    // veri yazýlýrsa wp + 
    // veri okunursa rp +
        
    //    fifo doluysa yazma durur, boþsa okuma durur        
            
    //    first in first out    
        
    //    // if signal active
    //        if (!full)
    //            w_enable;              
    //    // if signal active
    //        if (!empty)
    //            r_enable;

//////////////////////////////////////////////////////
            



