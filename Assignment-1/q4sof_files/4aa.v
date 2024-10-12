`timescale 1ns / 1ps
module furkan( mode ,rst, clk_1, counter, switch);
    input wire clk_1;
    input wire rst;
    input wire switch;
    output reg mode ;
    output reg [3:0] counter;
    reg [5:0] c;
    reg [50:0] count;  
    
    always@(posedge clk_1) begin  
    count = count +1;
    if (count == 100000000) begin
        count <= 1;
     
        if (switch == 0) begin
                
            if (rst ==1) begin
                counter <= 0;  
                end      
             else begin
                if (mode == 1'b1) begin
                    if (counter == 4'b1111) begin
                        mode <= 1'b0;
                        end
                    else begin
                        counter <= counter +1;
                        end
                    end
                    
                else if (mode == 1'b0) begin
                    if (counter == 4'b0000) begin
                        mode <= 1'b1;
                        end
                    else begin
                        counter <= counter -1;
                        end
                    end
                end
            end
        
       
         else if (switch == 1) begin
             c = c+1;
             
            if (c == 5) begin
                c <= 1;
        
            if (rst ==1) begin
                counter <= 0;  
                end 
                     
             else begin
                if (mode == 1'b1) begin
                    if (counter == 4'b1111) begin
                        mode <= 1'b0;
                        end
                    else begin
                        counter <= counter +1;
                        end
                    end
                    
                else if (mode == 1'b0) begin
                    if (counter == 4'b0000) begin
                        mode <= 1'b1;
                        end
                    else begin
                        counter <= counter -1;
                        end
                    end               
               end
               end
           end
       end
       end
endmodule



    
    
    
    
    
    










