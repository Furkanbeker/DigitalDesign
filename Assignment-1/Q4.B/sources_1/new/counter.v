`timescale 1ns / 1ps

module up_down_counter(clk,clk_2, x, clk_main,rst,switch,count,mode);
    input wire clk; 
    output reg clk_2 = 0;
    input wire rst;
    input wire switch;
    output reg [3:0] count =0 ;
    output reg mode = 1'b1;
    output reg clk_main = 0;
    input wire x;
    reg [5:0] counter = 0;
    
   
    always@(posedge clk or posedge rst) begin
    counter <= counter +1;
    
    if (counter == 50) begin
        clk_2 = ~clk_2;
        count <= 1;
        end    
        
    if (rst) begin
        count <= 0;
        counter <= 0;
        end
    
    else if (x==1) begin
        if (mode == 1'b0) begin
                if (count == 4'b1111) begin
                    mode <= 1'b1 ;
                    end
                 else if (switch == 1'b0) begin  
                    count <= count +1;
                    end
                  else if (switch == 1'b1) begin  
                    count <= count -1;
                    end
                end
        else if(mode == 1'b1) begin
                if (count == 4'b0000) begin
                    mode <= 1'b0;
                    end
                 else if (switch == 1'b0) begin  
                    count <= count +1;
                    end
                 else if (switch == 1'b1) begin
                    count <= count -1;
                    end
                end
            end
        end
    always@(posedge clk_2 or posedge rst) begin
    
    if (rst) begin
        count <= 0;
        counter <= 0;
        end
        
    else if (x==0) begin
        if (mode == 1'b1) begin
                if (count == 4'b0000) begin
                    mode <= 1'b0 ;
                    end
                 else if (switch == 1'b0) begin  
                    count <= count +1;
                    end
                  else if (switch == 1'b1) begin  
                    count <= count -1;
                    end
                end
           else if(mode == 1'b0) begin
                if (count == 4'b1111) begin
                    mode <= 1'b1;
                    end
                 else if (switch == 1'b0) begin  
                    count <= count +1;
                    end
                 else if (switch == 1'b1) begin
                    count <= count -1;
                    end
                end
            end   
        end
        
    always@(*) begin
        if(x == 1'b0) begin
            clk_main = clk_2;
            end
        else begin;
            clk_main = clk;
        end
    end

endmodule


