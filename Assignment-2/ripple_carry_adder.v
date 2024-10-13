`timescale 1ns / 1ps
module full_adder (A, B,Cin,Sum,Cout);
    input A,B,Cin;
    output Sum, Cout;  
        
    assign 
//    #20 
    Sum = (A^B)^Cin;
    assign 
//    #15 
    Cout = (A&B) | (B&Cin) | (Cin&A);
    
//    wire w1, w2, w3, w4;
        
//    and #15(w1,A,Cin); 
//    and #15 (w2,A,B);
//    and #15(w3,B,Cin);
            
//    xor #20(w4,A,B);
//    xor #20(Sum, Cin, w4);
//    or #15(Cout,w1,w2,w3);

endmodule

module ripple_carry_adder #(parameter WIDTH = 32) (A_i, B_i, C_i, Sel_i, Sum_o, C_o, Overflow_o); 
    input [WIDTH-1:0] A_i;      // source input1
    input [WIDTH-1:0] B_i;      // source input2
    input C_i;                  // carry input
    input Sel_i;                // select sum or sub

    output [WIDTH-1:0] Sum_o;   // result output
    output C_o;                 // carry out signal
    output Overflow_o;          // overflow signal

    wire [WIDTH-1:0] B_o;       
    wire [WIDTH:0] C;           

    assign C[0] = C_i;          
    assign B_o = Sel_i ? (~B_i + 1) : B_i; 
    //assign B_o = B_i ^ {32{Sel_i}}; 

    assign Overflow_o = C[WIDTH-1] ^ C[WIDTH]; 
    assign C_o = C[WIDTH]; 

    genvar i;
    
    generate
    
        for (i = 0; i < WIDTH; i = i + 1) begin : fa
            full_adder x(.A(A_i[i]), .B(B_o[i]), .Cin(C[i]), .Sum(Sum_o[i]), .Cout(C[i+1]));
        end
     
    endgenerate

endmodule





