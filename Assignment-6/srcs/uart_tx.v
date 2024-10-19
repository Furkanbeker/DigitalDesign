`timescale 1ns / 1ps


module uart_tx(system_clock, tx_start, tx_data, tx_d_out, tx_busy );
    input wire system_clock;
    input wire tx_start;
    input wire [7:0] tx_data;
    output reg [2:0] tx_d_out = 1;
    output reg tx_busy = 0;
    
    reg [3:0] bit_count = 0;
    reg [12:0] baud_counter = 0;
    reg[7:0] tx_buffer = 8'b0;
    reg sending = 0;
    reg [12:0] bit_timer = 0;
    
    always@(posedge system_clock) begin
        if (!tx_busy && tx_start && !sending) begin
            tx_busy <= 1;
            tx_buffer <= tx_data;
            bit_count <= 0;
            sending <= 1;
            tx_d_out <= 0;
            bit_timer <= 0;
        end
        else if (sending) begin
            if (bit_timer == 5208) begin
                bit_timer <= 0;
                if (bit_count <8) begin
                    tx_d_out <= tx_buffer[bit_count];
                    bit_count <= bit_count +1;
                end
                else if (bit_count == 8) begin
                    tx_d_out <= 1;
                    sending <= 0;
                    tx_busy <= 0;
                end
            end
            else begin
                bit_timer <= bit_timer +1;
            end
        end
    end            
endmodule
