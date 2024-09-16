`timescale 1ns / 1ps

module mainn(x, mode, rst, clk_1, clk_2, clk, counter, button);
    input wire clk_1 ;    
    output reg clk_2 = 0;
    input wire  x;
    input wire rst;
    output reg mode;
    output reg [3:0] counter ;
    output reg clk = 0;
    input wire button;
    reg [5:0] count = 0;

    initial begin
        mode = 1'b0;
        end
        
    always@(posedge clk_1 or posedge rst) begin
    count <= count + 1;
 
    if ( count == 50) begin
        clk_2 = ~clk_2;
        count <= 1;
        end
        
    if (rst == 1) begin
        counter <= 0;
        count <= 0;
        mode <= 1'b0;
        end   
            
    else if (x == 1) begin       
        if (mode == 1'b0)begin
            if (counter == 4'b1111) begin
                mode <= 1'b1;
                end
            else if (button == 1'b0) begin 
                counter <= counter +1;
                end
            else if (button == 1'b1) begin 
                counter <= counter -1;
                end
            end
            
        if (mode == 1'b1) begin
            if (counter == 4'b0000) begin
                mode <= 1'b0;
                end
            else if (button == 1'b0) begin 
                counter <= counter +1;
                end
            else if (button == 1'b1) begin 
                counter <= counter -1;
                end
            end
        end
    end
    
    always@(posedge clk_2 or posedge rst) begin
    if (rst == 1) begin
        counter <= 0;
    end  
    else if (x==0) begin
        if (mode == 1'b1) begin    
            if (counter == 4'b0000) begin
                mode <= 1'b0;
                end
             else if (button == 1'b0) begin 
                counter <= counter +1;
             end
             else if (button == 1'b1) begin 
                counter <= counter -1;
             end
            end
            
        else if (mode == 1'b0) begin
            if (counter == 4'b1111) begin
                mode <= 1'b1;
                end
            else if (button == 1'b0) begin 
                    counter <= counter +1;
                 end
            else if (button == 1'b1) begin 
                    counter <= counter -1;
                 end
            end      
    end
    end
    always @(*) begin
        if (x == 1'b0) begin
            clk = clk_2;  
        end else begin
            clk = clk_1; 
        end
    end
endmodule
