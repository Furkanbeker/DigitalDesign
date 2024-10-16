`timescale 1ns / 1ps
    
module debouncer (clk,pb_in,pb_out);
    input wire clk;
    input wire pb_in;
    output reg pb_out;
    
    reg [2:0] shift_reg = 3'b000;
    always@(posedge clk) begin
        shift_reg <= {shift_reg[1:0], pb_in} ;
        if (shift_reg == 3'b001) begin
            pb_out <= 1'b1;
            end
        else if (shift_reg == 3'b000) begin
            pb_out <= 1'b0;
            end
        end
endmodule       
    
    
module button_up_down_counter(clk,reset,clk_speed_mode,switch_dir_button,count,clk_1,clk_2,clk_main,stop_start_button);
    input wire clk;
    input wire reset;
    input wire clk_speed_mode;
    input wire switch_dir_button;
    input wire stop_start_button;
    output reg [3:0] count = 0;
    output reg clk_1;
    output reg clk_2;
    output wire clk_main;

    reg [6:0] clk_div_count = 0;
    reg [6:0] slow_clk_div_count = 0;
    wire switch_dir_button_clean;
    wire stop_start_button_clean;
    reg stop_flag = 0;
    reg switch_dir_flag = 0;
    
    debouncer dir(.clk(clk), .pb_in(switch_dir_button), .pb_out(switch_dir_button_clean));
    debouncer stop_start(.clk(clk), .pb_in(stop_start_button), .pb_out(stop_start_button_clean));
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
        else if (slow_clk_div_count ==50) begin
            clk_2 = ~clk_2;
            slow_clk_div_count <= 0;
            end
        else begin
            slow_clk_div_count <= slow_clk_div_count +1;
            end
        end
        
    assign clk_main = clk_speed_mode ? clk_1 : clk_2 ;
    
    always@(posedge stop_start_button_clean or posedge reset) begin
        if(reset) begin
            stop_flag <= 0;
            end
        else begin
            stop_flag <= ~stop_flag;
            end
        end
    
        
    always@(posedge switch_dir_button_clean or posedge reset) begin
        if(reset) begin
            switch_dir_flag <= 0;
            end
        else begin
            switch_dir_flag <= ~switch_dir_flag;
            end
        end
    
    always@(posedge clk_main or posedge reset) begin
        if(reset) begin
            count <= 0;
            end
        else if (!stop_flag) begin
            if (switch_dir_flag== 0) begin
                count <= count +1;
                end
            else if(switch_dir_button_clean == 1) begin
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




