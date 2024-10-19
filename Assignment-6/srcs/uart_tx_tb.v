`timescale 1ns / 1ps

module uart_tx_tb( );
    reg system_clock = 0;
    reg tx_start = 0;
    reg [7:0] tx_data = 8'b0;
    wire [2:0] tx_d_out;
    wire tx_busy;
    
    uart_tx u1(.system_clock(system_clock), .tx_start(tx_start), .tx_data(tx_data), .tx_d_out(tx_d_out), .tx_busy(tx_busy)); 
    
    always begin
    system_clock = #10 ~system_clock;
    end
    
    initial begin
        #1000;
        tx_data <= 8'b10011010;
        tx_start <= 1;
        #20;
        tx_start <= 0;
        
        #1041600;
        tx_data <= 8'b01010101;
        tx_start <= 1;
        #20;
        tx_start <= 0;
        
        while (tx_busy) begin
            #104160;
        end
        
        #104160;
    end
endmodule
