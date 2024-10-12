`timescale 1ns / 1ps

module debouncer (
    input wire clk,           
    input wire pb_in,         
    output reg pb_out         
);

    reg [1:0] shift_reg = 2'b00;
    reg button_sync_0, button_sync_1;

    always @(posedge clk) begin
        button_sync_0 <= pb_in;
        button_sync_1 <= button_sync_0;
    end

    always @(posedge clk) begin
        shift_reg <= {shift_reg[1:0], button_sync_1};
        if (shift_reg == 2'b01) begin
            pb_out <= 1'b1; 
        end else if (shift_reg == 2'b00) begin
            pb_out <= 1'b0;  
        end
    end
endmodule


module button_up_down_counter(
    input wire clk,
    input wire reset,
    input wire clk_speed_mode,
    input wire switch_dir_button,
    output reg [3:0] count = 0,
    output reg clk_1,
    output reg clk_2,
    output wire clk_main
);

    reg [6:0] clk_div_count = 0;
    reg [6:0] slow_clk_div_count = 0;
    wire switch_dir_button_clean;
    reg mode = 1'b0;  
    reg prev_button_state = 1'b0;  

    debouncer DUT(
        .clk(clk),
        .pb_in(switch_dir_button),
        .pb_out(switch_dir_button_clean)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_div_count <= 0;
            clk_1 <= 0;
        end else if (clk_div_count == 3) begin  
            clk_1 <= ~clk_1;
            clk_div_count <= 0;
        end else begin
            clk_div_count <= clk_div_count + 1;
        end
    end

    always @(posedge clk_1 or posedge reset) begin
        if (reset) begin
            slow_clk_div_count <= 0;
            clk_2 <= 0;
        end else if (slow_clk_div_count == 4) begin  
            clk_2 <= ~clk_2;
            slow_clk_div_count <= 0;
        end else begin
            slow_clk_div_count <= slow_clk_div_count + 1;
        end
    end

    assign clk_main = clk_speed_mode ? clk_1 : clk_2;

    always @(posedge clk_main or posedge reset) begin
        if (reset) begin
            count <= 0;
            mode <= 1'b0; 
        end else begin
            if (switch_dir_button_clean && !prev_button_state) begin
                mode <= ~mode;  
            end
            prev_button_state <= switch_dir_button_clean;  
            
            if (mode == 1'b0) begin
                count <= count + 1;  
            end else begin
                count <= count - 1;  
            end
        end
    end

endmodule
