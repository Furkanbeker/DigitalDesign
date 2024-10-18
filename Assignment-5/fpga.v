`timescale 1ns / 1ps

module fpga(clk, data_in, reset, w_button, r_button, data_out, empty, full);
    input wire reset,clk;
    input wire [width-1:0] data_in;  
    input wire w_button;
    input wire r_button ;
    output reg [width-1:0] data_out = 0;
    output reg empty ;
    output reg full ;
        
    parameter width = 8; 
    parameter depth = 8;
    
    reg [width-1:0] memory [0:depth-1] ;
    reg [3:0] w_pointer = 0;
    reg [3:0] r_pointer = 0;
    reg [3:0] count = 0;
    reg fr = 1;
    
    wire w_enable_clean;
    wire r_enable_clean;
    
    reg prev_w_enable = 0;
    reg prev_r_enable = 0;

    debouncer w(.clk(clk), .pb_in(w_button), .pb_out(w_enable_clean));
    debouncer r(.clk(clk), .pb_in(r_button), .pb_out(r_enable_clean));
       
    always@(posedge clk) begin             
        if (reset) begin
            w_pointer <= 0;
            r_pointer <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
            data_out <= 0;
            prev_w_enable = 0;
            prev_r_enable = 0;
            memory[w_pointer] <= 0;
            fr <= 1;
            end
        else begin
            if (w_enable_clean && !prev_w_enable && !full && !fr) begin
                memory[w_pointer] <= data_in;
                w_pointer <= (w_pointer +1)%depth;
                //r_pointer <= (r_pointer==8) ? 0 : r_pointer+1;
                count <= count +1;
                end
            else if (r_enable_clean && !prev_r_enable &&  !empty) begin
                r_pointer <= (r_pointer +1)%depth; 
                //r_pointer <= (r_pointer==8) ? 0 : r_pointer+1;
                data_out <= memory[r_pointer];
                count <= count -1;
                end
                
            if (count ==0) begin
                empty <= 1;
                full <= 0;
                end             
                  
            else if (count == depth) begin
                empty <= 0;
                full <= 1;
                end               
                
            else begin
                empty <= 0;
                full <= 0;               
                end    
                       
                prev_w_enable <= w_enable_clean;
                prev_r_enable <= r_enable_clean; 
                fr <= 0;
                end               
    end               
            
endmodule    

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
    

//module debouncer (clk,pb_in,pb_out);
//    input wire clk;
//    input wire pb_in;
//    output reg pb_out;
    
//    reg [18:0] counter = 0;
//    reg pb_sync = 0;
    
    
//    always@(posedge clk) begin
//    pb_sync <= pb_in;
//    end
    
//    always@(posedge clk) begin
//        if(pb_sync == pb_out) begin
//        counter <= 0;
//        end
//    else begin
//        counter <= counter +1;
//        if (counter == 500000) begin
//            pb_out <= pb_sync;
//            counter <=0;
//            end
//        end
//    end
//endmodule      

