`timescale 1ns / 1ps

    //9600 baud 50MHz clock - limit 5208

module uart_rx(system_clock, next_bit, reset_timer, rx_d_in, rx_d_out, data_ready);
    input wire rx_d_in, system_clock, reset_timer;
    output reg [7:0] rx_d_out = 8'b0 ;
    output reg data_ready = 0;
    
    output reg next_bit;
    reg start = 0;
    reg stop = 0;
    reg [7:0] data;
    reg [3:0] bit_count = 0;
    reg error = 0;
    reg [12:0] sample_counter = 0;
    reg[50:0]counter = 0;
    
    always@(posedge system_clock) begin
    counter <= counter +1;
    if (reset_timer) begin
        next_bit <= 0;
        counter <= 0;
        end
   
    else begin
        if (counter == 5208) begin  //speed 9600 50MHz
            next_bit <= 1;
            counter <= 0;
            end
        else begin
            next_bit <= 0;
            end
        end
    end

    
    always@(posedge system_clock) begin
        if (!start) begin
            if (rx_d_in == 0) begin
                start <= 1;
                bit_count <= 0;
                data_ready <= 0;
                sample_counter <= 2604;
                end
            end
        else if (sample_counter > 0) begin
            sample_counter <= sample_counter-1;
        end
        else begin 
            if (next_bit) begin
                if(bit_count < 8) begin
                    data[bit_count] <= rx_d_in;
                    bit_count <= bit_count +1;
                    end
                else if (bit_count == 8) begin
                    if(rx_d_in == 1) begin
                        stop <= 1;
                        rx_d_out <= data;
                        data_ready <= 1;
                        end
                    else begin
                        error <= 1;
                        end
                    start <= 0;
                    bit_count <= 0;
                    stop <= 0;
                    error <=0;
                    end
            end
            end    
        end    
endmodule




