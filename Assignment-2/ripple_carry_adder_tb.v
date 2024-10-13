`timescale 1ns / 1ps

module ripple_carry_adder_tb();
    reg [31:0]A_i;
    reg [31:0]B_i;
    reg C_i;
    reg Sel_i;
    wire [31:0]Sum_o;
    wire C_o; 
    wire Overflow_o;
    
    ripple_carry_adder u1(.A_i(A_i), .B_i(B_i), .C_i(C_i), .Sum_o(Sum_o), .C_o(C_o), .Overflow_o(Overflow_o), .Sel_i(Sel_i));
    
    initial begin
    A_i= 32'h00000001; B_i= 32'h00000001; C_i =1'b0; Sel_i = 1'b1;
    #100 A_i= 32'hFFFFFFFF; B_i= 32'h00000001; C_i =1'b0;
    #100 A_i= 32'hFFFFFFFF; B_i= 32'h00000020; C_i =1'b0;
    #100 A_i= 32'h12345678; B_i= 32'h87654321; C_i =1'b0;
    #100 A_i= 32'hABCABABA; B_i= 32'hff355235; C_i =1'b0; Sel_i = 1'b0;
    #100 A_i= 32'h12315151; B_i= 32'h11431342; C_i =1'b0;
    #100 A_i= 32'h15215353; B_i= 32'h13643215; C_i =1'b0;
    #100 A_i= 32'h32521551; B_i= 32'h03214327; C_i =1'b0;
    #100 A_i= 32'hFABC3332; B_i= 32'hD0123432; C_i =1'b0;Sel_i = 1'b1;
    #100 A_i= 32'h12332478; B_i= 32'h87654321; C_i =1'b0;
    #100 A_i= 32'hABC2314B; B_i= 32'hF43CDA86; C_i =1'b0; Sel_i = 1'b0;
    #100 A_i= 32'h12313241; B_i= 32'h11431342; C_i =1'b0;
    #100 A_i= 32'h15215353; B_i= 32'h43258761; C_i =1'b0;
    #100 A_i= 32'hFFFFFFFF; B_i= 32'h00000001; C_i =1'b0;

    end
    
endmodule

