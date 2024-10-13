`timescale 1ns / 1ps

module serial_adder(A_i, B_i, clk_i, start_i, rst_ni, sum_o);
    input clk_i;
    input [7:0] A_i;
    input [7:0] B_i;
    input start_i;
    input rst_ni;
    output reg [8:0] sum_o = 9'b0;

    wire [7:0] shift_A_out;
    wire [7:0] shift_B_out;
    wire sum_out;
    wire carry_out;
    wire load;
    wire enable;
    wire ff_out;
    wire rstn;
   
    shift_register u1(.clk_i(clk_i), .rstn(rstn), .data_i(A_i), .load_i(load), .enable_i(enable), .shift_o(shift_A_out));
    shift_register u2(.clk_i(clk_i), .rstn(rstn), .data_i(B_i), .load_i(load), .enable_i(enable), .shift_o(shift_B_out));
    full_adder u3(.A(shift_A_out[0]), .B(shift_B_out[0]), .Cin(ff_out), .Sum(sum_out), .Cout(carry_out) );
    //shift_register u4(.clk_i(clk_i), .rstn(rstn), .data_i(sum_out), .load_i(load), .enable_i(enable), .shift_o(result));
    control_fsm u5(.rstn(rstn), .rst_ni(rst_ni), .start_i(start_i), .clk_i(clk_i), .enable(enable), .load(load));
    flipflop u6( .clk_i(clk_i), .D(carry_out), .Q(ff_out), .rstn(rstn));

    always@(posedge clk_i) begin  
    if(!rstn) begin
        sum_o <= 9'b0;
        end
    else if (start_i) begin
        sum_o <= 9'b0;
        end    
    else if (enable) begin
        sum_o <= {carry_out , sum_out, sum_o[8:1]};
        end
    end

endmodule


module shift_register(clk_i, rstn, data_i, load_i, enable_i, shift_o);
    input clk_i;
    input [7:0] data_i;
    input rstn;
    input load_i;
    input enable_i;
    output reg [7:0] shift_o;

    always@(posedge clk_i) begin
    if (!rstn) begin
        shift_o <= 8'b0;
        end
    else if (load_i == 1'b1) begin
        shift_o <= data_i;
        end
    else if (enable_i == 1'b1) begin
        shift_o <= {1'b0, shift_o[7:1]};
        end
    end
endmodule

module full_adder (A, B,Cin,Sum,Cout);
    input A,B,Cin;
    output Sum, Cout;  
        
    assign Sum = (A^B)^Cin;
    assign Cout = (A&B) | (B&Cin) | (Cin&A);

endmodule


module flipflop(clk_i, D, Q, rstn );
    input clk_i;
    input D;
    input rstn;
    output reg Q;

    always@(posedge clk_i) begin
    if (!rstn) begin
        Q <= 0;
        end
    else begin
        Q <= D;
        end
    end
endmodule


module control_fsm(rst_ni, start_i, clk_i, rstn, enable, load );
    input rst_ni;
    input start_i;
    input clk_i;
    output reg rstn;
    output reg enable = 1'b0;
    output reg load = 1'b0;

    reg [3:0] count;

    always@(posedge clk_i) begin

    if (!rst_ni) begin
        rstn <= 0;
        load <= 1;
        enable <= 0;
        count <= 0;
        end
    else if (start_i) begin
        count <= 0;
        load <= 1;
        enable <= 1;
        rstn <= 1;
        end
    else if (count == 9) begin
        load <= 0;
        enable <= 0;
        end
    else begin
        count <= count +1;
        load <= 0;
        enable <= 1;
    end
    end
endmodule