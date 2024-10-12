`timescale 1ns / 1ps

module button_up_down_counter_tb();
    reg clk = 1'b0;
    reg reset = 1'b1;
    reg clk_speed_mode = 1'b0;
    reg switch_dir_button = 1'b0;
    wire [3:0] count;
    wire clk_1;
    wire clk_2;
    wire clk_main;
    
    button_up_down_counter uut(.clk(clk), .reset(reset), .clk_speed_mode(clk_speed_mode), 
        .switch_dir_button(switch_dir_button), .count(count), .clk_1(clk_1), .clk_2(clk_2), .clk_main(clk_main));
        
    always begin
        clk = #1 ~clk;
        end
     
     
     initial begin
        #20 reset = 1'b0;
        #50 clk_speed_mode = 1'b1;
        #200 switch_dir_button = 1'b1;
        #7 switch_dir_button = 1'b0;
        #200 switch_dir_button = 1'b1;
        #7 switch_dir_button = 1'b0;
        #100 switch_dir_button = 1'b1;
        #7 switch_dir_button = 1'b0;
        #50 clk_speed_mode = 1'b0;

    end
    
    
endmodule
