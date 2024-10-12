`timescale 1ns / 1ps

module debouncer (clk,pb_in,pb_out);
    input wire clk;
    input wire pb_in;
    output reg pb_out;
    
    reg button_sync_0 , button_sync_1; 
    
    always@(posedge clk) begin
        button_sync_0 <= pb_in;
        button_sync_1 <= button_sync_0;
        end
        
    always@(posedge clk) begin
    if (button_sync_0 == button_sync_1) begin
        pb_out <= button_sync_1;
        end
    end
endmodule
    
    
module furkan(clk,reset,clk_speed_mode,switch_dir_button,count,clk_1,clk_2,clk_main);
    input wire clk;
    input wire reset;
    input wire clk_speed_mode;
    input wire switch_dir_button;
    output reg [3:0] count = 0;
    output reg clk_1;
    output reg clk_2;
    output wire clk_main;
    wire slow_clock;

    reg [6:0] clk_div_count = 0;
    reg [6:0] slow_clk_div_count = 0;
    wire switch_dir_button_clean;
    reg mode = 1'b0;
    reg prev_button_state = 1'b0;
    
    debouncer a1( .clk(clk), .pb_in(switch_dir_button), .pb_out(switch_dir_button_clean));
    cd a2(.clk_in(clk), .clk_out(slow_clock));
    
    always@(posedge slow_clock or posedge reset) begin

        if (reset) begin
            clk_div_count <= 0;
            clk_1 <= 0;
            end 
        else if (clk_div_count ==1) begin
            clk_1 = ~clk_1;
            clk_div_count <= 0;
            end
        else begin
            clk_div_count <= clk_div_count +1;
            end
        end
            
    always@(posedge clk_1 or posedge reset) begin
        if (reset) begin
            slow_clk_div_count <= 0;
            clk_2 <= 0;
            end 
        else if (slow_clk_div_count ==4) begin
            clk_2 = ~clk_2;
            slow_clk_div_count <= 0;
            end
        else begin
            slow_clk_div_count <= slow_clk_div_count +1;
            end
        end
        
    assign clk_main = clk_speed_mode ? clk_1 : clk_2 ;
    
    always@(posedge clk_main or posedge reset) begin
        if(reset) begin
            count <= 0;
            mode <= 1'b0;
            end
        else begin
            if (switch_dir_button_clean && !prev_button_state) begin
                mode <= ~mode;
                end
            prev_button_state <= switch_dir_button_clean;
            
            if(mode == 1'b0) begin
                count <= count +1;
                end
            else begin
                count <= count -1;
                end
            end
        end
endmodule

module cd(clk_in,clk_out);
    input wire clk_in;
    output reg clk_out = 1'b0;
    reg [50:0]c;
    
    always @(posedge clk_in) begin
    c = c +1;
    if (c == 1000000) begin
        clk_out = ~clk_out;
        c <= 0;
        end
    end
endmodule


