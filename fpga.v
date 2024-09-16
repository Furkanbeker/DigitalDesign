`timescale 1ns / 1ps

module switch(mode, rst, clk_1, counter);
    input wire clk_1 ;    
    input wire rst;
    output reg mode = 1'b0;
    output reg [3:0] counter ;

    always@(posedge clk_1 or posedge rst) begin
        
    if (rst == 1) begin
        counter <= 0;
        mode <= 1'b0;
        end   
            
    else if (mode == 1'b0)begin
        if (counter == 4'b1111) begin
                mode <= 1'b1;
                end
            else begin 
                counter <= counter +1;
                end
                end
            
    else if (mode == 1'b1) begin
        if (counter == 4'b0000) begin
            mode <= 1'b0;
            end
        else begin 
            counter <= counter -1;
            end
        end     
    end
endmodule


