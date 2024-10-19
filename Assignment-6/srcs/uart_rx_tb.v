`timescale 1ns / 1ps

module uart_rx_tb();
    reg rx_d_in = 1'b1;
    reg system_clock = 1'b0;
    reg reset_timer = 1'b0;
    wire [7:0] rx_d_out;
    wire data_ready;

    uart_rx u1(.system_clock(system_clock), .reset_timer(reset_timer), .rx_d_in(rx_d_in), .rx_d_out(rx_d_out), .data_ready(data_ready));

    
    always begin
        system_clock = #10 ~system_clock;
    end

    initial begin

        reset_timer <= 1;
        #20
        reset_timer <= 0;

        rx_d_in = 0;        //startbit
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 1;        //stopbit
        #104160;

        if (data_ready && rx_d_out == 8'b00001100) 
            $display("Test Basarili");
        else 
            $display("Test Basarisiz");


        
        rx_d_in = 0;        //startbit
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;        //stopbit
        #104160;    
        #104160;

        if (data_ready && rx_d_out == 8'b11001111) 
            $display("Test Basarili");
        else 
            $display("Test Basarisiz");


        rx_d_in = 0;        //startbit
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;        //stopbit
        #104160;    
        #104160;

        if (data_ready && rx_d_out == 8'b11000000) 
            $display("Test Basarili");
        else 
            $display("Test Basarisiz");


        rx_d_in = 0;        //startbit
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 0;
        #104160;
        rx_d_in = 1;        //stopbit
        #104160;

        if (data_ready && rx_d_out == 8'b00000000) 
            $display("Test Basarili");
        else 
            $display("Test Basarisiz");


        rx_d_in = 0;        //startbit
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;
        #104160;
        rx_d_in = 1;        //stopbit
        #104160;

        if (data_ready && rx_d_out == 8'b11111111) 
            $display("Test Basarili");
        else 
            $display("Test Basarisiz");


        end
endmodule





