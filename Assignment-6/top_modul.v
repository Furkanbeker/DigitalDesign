`timescale 1ns / 1ps

module uart_top(clk,reset ,rx_d_in, r_button, tx_d_out, leds, tx_busy, empty, full);
    input wire clk, reset, rx_d_in, r_button;
    output wire tx_d_out;
    output wire [7:0] leds;
    output wire tx_busy; 
    output wire empty;
    output wire full;

    wire [7:0] rx_d_out;
    wire [7:0] fifo_data_out;
    wire data_ready;
    wire r_trigger;
    wire w_trigger;

    reg [7:0] tx_data;
    reg tx_trigger;
    reg prev_empty;
    reg prev_full;

    edge_detector u1(.clk(clk), .signal_in(r_button), .signal_edge(r_trigger));
    
    fifo u3(.clk(clk), .reset(reset), .data_in(rx_d_out), .w_button(data_ready), .r_button(r_trigger), .data_out(fifo_data_out), .empty(empty), .full(full));
    
    uart_rx u4(.system_clock(clk), .rx_d_in(rx_d_in), .rx_d_out(rx_d_out), .reset_timer(reset), .write(data_ready));
    
    uart_tx u5(.system_clock(clk), .tx_d_in(tx_data), .tx_d_out(tx_d_out), .start_tx(tx_trigger), .tx_busy(tx_busy));

    always@(posedge clk or posedge reset) begin
        if (reset) begin
            tx_data <= 8'b0;
            tx_trigger <= 0;
            prev_empty <= 1;
            prev_full <= 0;
        end
        else begin
            if(empty && !prev_empty ) begin
                if(empty) begin
                    tx_data <= 8'b01000101; // E
                    tx_trigger <= 1;
                end
                else begin
                    tx_trigger <= 0;
                end
            end
                else if(full && !prev_full ) begin
                    tx_data <= 8'b01000110;  //F
                    tx_trigger <= 1;
                end
                else begin
                    tx_trigger <= 0;
                end
                prev_empty <= empty;
                prev_full <= full;
        end
    end
    assign leds = fifo_data_out;
endmodule

/////////////////////////////////////////////////////////////////////////////////////////

module uart_tx(system_clock, start_tx, tx_d_in, tx_d_out, tx_busy);
    input wire system_clock;
    input wire start_tx;
    input wire [7:0] tx_d_in;
    output reg tx_d_out = 1;
    output reg tx_busy = 0;
    
    reg [12:0] baud_counter = 0;
    reg [3:0] bit_count = 0;
    reg [7:0] tx_buffer = 8'b0;
    reg sending = 0;    
    reg [12:0] bit_timer = 0;
    
    parameter HZ = 50000000;
    parameter br = 9600;
    localparam integer max = HZ / br;
    
    always@(posedge system_clock) begin 
        if (!tx_busy && start_tx && !sending) begin
            tx_busy <= 1;
            tx_buffer <= tx_d_in;
            bit_count <= 0;
            sending <= 1;
            tx_d_out <= 0;
            bit_timer <= 0;
        end
        else if (sending) begin
            if (bit_timer == max) begin
                bit_timer <= 0;
                if(bit_count <8 ) begin
                    tx_d_out <= tx_buffer[bit_count];
                    bit_count <= bit_count + 1;
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

/////////////////////////////////////////////////////////////////////////////////////////

module uart_rx(system_clock, reset_timer, rx_d_in, rx_d_out, write);
    input wire rx_d_in, system_clock, reset_timer;
    output reg [7:0] rx_d_out = 8'b0 ;
    output wire write;
    reg data_ready = 0;  
    
    reg [7:0] data;
    reg [3:0] bit_count = 0;
    reg [20:0] sample_counter = 0;
    
    parameter HZ = 50000000;
    parameter br = 9600;
    localparam integer max = HZ / br;
    
    reg [20:0] baud_counter = 0;
    
    
    assign write = data_ready;
    
    parameter START = 2'b00 ;
    parameter DATA = 2'b01 ;
    parameter IDLE = 2'b10 ;
    
    reg [1:0] state ;
    
    always@(posedge system_clock) begin
        if (reset_timer) begin
            baud_counter <= 0;
            state <= IDLE;
        end
            
        else begin 
            case (state)
            IDLE: begin
                data_ready <= 0;
                if (rx_d_in == 0) begin
                    bit_count <= 0;
                    sample_counter <= 0;
                    state <= START;
                end
            end
            
            START: begin
                    if(baud_counter == max/2) begin
                        baud_counter <= 0;
                        state <= DATA;                    
                    end 
                    else begin
                        baud_counter <= baud_counter +1;
                    end
                
            end
            
            DATA: begin
                if (sample_counter == max) begin
                    sample_counter <= 0;
                    if(bit_count < 8) begin
                        data[bit_count] <= rx_d_in;
                        bit_count <= bit_count +1;
                        end
                    if (bit_count == 8) begin
                            rx_d_out <= data;
                            data_ready <= 1;
                            state <= IDLE;
                            end
                    end
                 else begin
                    sample_counter <= sample_counter +1;
                end
            end
            
            
            default: state <= IDLE;
            endcase
        end 
    end 
    endmodule
                        


/////////////////////////////////////////////////////////////////////////////////////////

module fifo(clk, data_in, reset, w_button, r_button, data_out, empty, full);
    input wire reset,clk;
    input wire [width-1:0] data_in;  
    input wire w_button;   //w_enable
    input wire r_button ;  //r_enable
    output reg [width-1:0] data_out = 0;
    output reg empty ;
    output reg full ;
    
    parameter width = 8; 
    parameter depth = 8;
    
    reg [width-1:0] memory [0:depth-1] ;
    reg [3:0] w_pointer;
    reg [3:0] r_pointer;
    reg [3:0] count;
    
    reg prev_w_enable = 0;
    reg prev_r_enable = 0;
    
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            w_pointer <= 0;
            r_pointer <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
            data_out <= 0;
           
            end
            
        else begin
            if (w_button && !full ) begin
            
                memory[w_pointer] <= data_in;
                w_pointer <= (w_pointer +1)%depth;
                count <= count +1;
                end
            if (r_button && !empty) begin
                r_pointer <= (r_pointer +1)%depth; 
                data_out <= memory[r_pointer];
                count <= count -1;
                end
                
            empty <= (count == 0);
            full <= (count == depth);

            end       
    end
endmodule    

/////////////////////////////////////////////////////////////////////////////////////////

module debouncer (clk,pb_in,pb_out);
    input wire clk;
    input wire pb_in;
    output reg pb_out;    
    
    reg [2:0] shift_reg = 3'b000;
    
    always@(posedge clk) begin
        shift_reg <= {shift_reg[1:0], pb_in} ;
        if (shift_reg == 3'b111) begin
            pb_out <= 1'b1;
            end
        else if (shift_reg == 3'b000) begin
            pb_out <= 1'b0;
            end
        end
endmodule       
    
/////////////////////////////////////////////////////////////////////////////////////////

module edge_detector(clk, signal_in, signal_edge);
    input wire clk;
    input wire signal_in;
    output reg signal_edge;

    reg prev_signal = 0;

    always@(posedge clk) begin
        signal_edge <= (signal_in && !prev_signal);
        prev_signal <= signal_in;
    end
endmodule