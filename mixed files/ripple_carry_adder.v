`timescale 1ns / 1ps

//module fulladder(X, Y, Ci, S, Co);
//  input X, Y, Ci;
//  output S, Co;
//  wire w1,w2,w3;

//  xor G1(w1, X, Y);
//  xor G2(S, w1, Ci);
//  and G3(w2, w1, Ci);
//  and G4(w3, X, Y);
//  or G5(Co, w2, w3);
//endmodule

//module ripple_carry_adder_32bit(
//    input [31:0] A,       
//    input [31:0] B,       
//    input Cin,            
//    output [31:0] Sum,    
//    output Cout           
//);

//    wire [31:0] carry;    

//    fulladder fa0 (.X(A[0]), .Y(B[0]), .Ci(Cin), .S(Sum[0]), .Co(carry[0]));

//    genvar i;
//    generate
//        for (i = 1; i < 32; i = i + 1) begin : ripple
//            fulladder fa (.X(A[i]), .Y(B[i]), .Ci(carry[i-1]), .S(Sum[i]), .Co(carry[i]));
//        end
//    endgenerate

//    assign Cout = carry[31];

//endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////   

//module ripple_adder(X, Y, S, Co);
// input [3:0] X, Y;
// output [3:0] S;
// output Co;
// wire w1, w2, w3;
 
// fulladder u1(X[0], Y[0], 1'b0, S[0], w1);
// fulladder u2(X[1], Y[1], w1, S[1], w2);
// fulladder u3(X[2], Y[2], w2, S[2], w3);
// fulladder u4(X[3], Y[3], w3, S[3], Co);
//endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////   

//module full_adder_s(a,b,cin,sum,carry);
//    input wire a,b,cin;
//    output sum,carry;
//    wire w1,w2,w3,w4;
    
//    xor(w1,a,b);
//    xor(sum,w1,cin);
    
//    and(w2,a,b);
//    and(w3,b,cin);
//    and(w4,cin,a);
    
//    or(carry,w2,w3,w4);
    
//endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////   
 
//module full_adder_d(a,b,cin,sum,carry);
//    input a,b,cin;
//    output sum,carry;

//assign sum = a ^ b ^ cin;
//assign carry = (a & b)|(b & cin)|(cin & a);
                
//endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////   

//module full_adder_case(a, b, cin, sum, carry);
//    input a, b, cin;
//    output reg sum, carry;
    
//    always @(a, b, cin) begin
    
//    case (cin)  
//    0: begin    // if( cin == 0 )
//        sum = a^b; carry=a&b;  
//        end    
//    1: begin    //if ( cin ==1 )
//        sum = a~^b; carry= a|b;    
//        end       
//    endcase
    
//    end
//endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////   

module fa(a, b, cin, s, cout);
    
    input a, b, cin;
    output s, cout;
    
    assign s= (a^b)^cin;
    assign cout = (a&b)|(b&cin)|(cin&a);
    
endmodule

module my_design #(parameter N=5)
    (a, b, cin, s, cout);
    
    input [N-1 : 0] a, b;
    input cin;
    
    output [N-1:0] cout, s;
    
    genvar i;
    
    generate
        for (i=0; i<N; i= i+1) begin: furkan
        
        fa unit( a[i], b[i], (i==0)? 0:cout[i-1], s[i], cout[i] ) ;
    
        end
    endgenerate
endmodule
    
    




































    
    
    
    