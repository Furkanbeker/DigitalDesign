`timescale 1ns / 1ps

module top_modul_tb();
    reg clk = 0;
    reg reset = 1;
    reg rx_d_in = 1;
    reg r_button = 0;
    wire tx_d_out;
    wire [7:0] leds;
    wire tx_busy;
    wire empty;
    wire full;
    
    top_modul u(.clk(clk), .reset(reset), .rx_d_in(rx_d_in), .r_button(r_button), .tx_d_out(tx_d_out), .leds(leds), .tx_busy(tx_busy), .empty(empty), .full(full));
    
    always begin
        clk = #10 ~clk; 
    end
    
    initial begin
        #100;
        
        reset = 0;
        
        send_uart_byte(8'b00110000); // "0"
        send_uart_byte(8'b00110001); 
        send_uart_byte(8'b00110010); 
        send_uart_byte(8'b00110011);
        send_uart_byte(8'b00110100);
        send_uart_byte(8'b00110101);  
        send_uart_byte(8'b00110110);
        send_uart_byte(8'b00110111);
        send_uart_byte(8'b00111000);
        send_uart_byte(8'b00111001);
        
        repeat (10) begin
            r_button = 1;
            #20;
            r_button = 0;
            #20;
            #500000;    
        end
    end
    
    task send_uart_byte (input[7:0] data);
        integer i;
        begin
            rx_d_in = 0;
            #104160;
            
            for(i=0; i<8; i= i+1) begin
                rx_d_in = data[i];
                #104160;
                ;
            end
                
            rx_d_in=1;
            #104160;
        end
    endtask

endmodule