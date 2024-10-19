

module Round_Enc(round_key, state_in, state_out);
    input [79:0] round_key;
    input [63:0] state_in;
    output [63:0] state_out;

    wire [63:0] S1,S2;
    
    Add_round_key     f1(state_in, round_key[63:0], S1);  
    S_Box_Layer       f2(S1,S2);
    Permutation_Layer f3(S2,state_out);
    
endmodule    


//////////////////////////////////////////////////////////////////////////////////////////

module Add_round_key(S_in, R_key, S_out);
    input [63:0] S_in;
    input [63:0] R_key;
    output [63:0] S_out;
    
    //  şimdiki durum ile tur anahtarının en düşük anlamlı 64 biti arasında xor 
    //  her turda anahtar değişir
    
    assign S_out = R_key ^ S_in;
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module S_Box_Layer(a, S_a);
    input [63:0] a;
    output [63:0] S_a;
    
    //  4 bit giriş 4 bit çıkış birbiriyle paralel çalışan 16 s_boxtan oluşur
    
    genvar i;
    
    generate for(i=0; i<16; i=i+1) begin  
        S_Box f(a[(4*i+3) : (4*i)], S_a[(4*i+3) : (4*i)]); 
        end 
    endgenerate
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module S_Box(k, S_k);
    input [3:0] k;
    output reg [3:0] S_k; 
    
    //   k   0 1 2 3 4 5 6 7 8 9 A B C D E F
    //  S(k) E 4 B 1 7 9 C A D 2 0 F 8 5 3 6 
   
    always @* begin
    
        case(k)
            4'h0: S_k= 4'hE; 
            4'h1: S_k= 4'h4;    
            4'h2: S_k= 4'hB; 
            4'h3: S_k= 4'h1;
            4'h4: S_k= 4'h7; 
            4'h5: S_k= 4'h9;
            4'h6: S_k= 4'hC; 
            4'h7: S_k= 4'hA;    
            4'h8: S_k= 4'hD; 
            4'h9: S_k= 4'h2;
            4'hA: S_k= 4'h0; 
            4'hB: S_k= 4'hF;
            4'hC: S_k= 4'h8; 
            4'hD: S_k= 4'h5;
            4'hE: S_k= 4'h3; 
            4'hF: S_k= 4'h6;
        endcase
        
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Permutation_Layer(s_in, s_out);
    input [63:0] s_in;
    output [63:0] s_out;
    
    wire [63:0] S1, S2;
    
    //  3 ara katmana sahiptir
    
    Block_Shuffle     bs(s_in,S1);
    Round_Permutation rp(S1,S2);
    XOR_Operation     xr(S2,s_out);
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Block_Shuffle(j, B_j);
    input [63:0] j;
    output [63:0] B_j;
    
    //  16 bitlik girdiyi 8 bitlik sola çevrimsel kaydırma - 16bit çıktı 

    genvar i;
    
    generate for(i=0; i<4; i=i+1)  
    Block_S f(j[(16*i+15) : (16*i)], B_j[(16*i+15) : (16*i)]);  
    endgenerate
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Block_S(j, B_j);

    input [15:0] j;
    output reg [15:0] B_j;
    
    //  16 bitlik girdi önce 4 bitlik bloklar ayrılı 
    //  en anlamsız 4 bitlik blok 8 bit sola kaydırılarak 3. en anlamsız bloğun yerine geçer 
    //  aynı şekilde ikinci en anlamsız blok 8 bit kaydırılraak en anlmalı bloğun yerin egeçmiş olur.        
    //   j   0 1 2 3 
    //  B(j) 2 3 0 1    
    
    always @* begin
        B_j[3:0]  = j[11:8];
        B_j[7:4]  = j[15:12];
        B_j[11:8] = j[3:0];
        B_j[15:12]= j[7:4];

    end
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module XOR_Operation(X, W_x);
    input [63:0] X;
    output reg [63:0] W_x;
    
    //  16 bitlik bloklar arasında basit xor 
    //  4 tane 16 bitlik çıktıdan(W'3 W'2 W'1 W'0 ) toplamda 64 bit çıkış
    //  W'3 =  W3 ^ W2^ W0
    //  W'2 =  W2^ W0 
    //  W'1 =  W3 ^ W1
    //  W'0 =  W3 ^ W1^ W0
    
    always @* begin
        W_x[63:48] = (X[63:48]^X[47:32]^X[15:0]);
        W_x[47:32] = (X[47:32]^X[15:0]);
        W_x[31:16] = (X[63:48]^X[31:16]);
        W_x[15:0]  = (X[63:48]^X[31:16]^X[15:0]);
    end
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Round_Permutation(j, r_j);
    input [63:0] j;
    output reg [63:0] r_j ;
    
    //  16 bitlik bloklara sola kaydırma işlemi uygular
    //  64 bitlik giriş önce 16 bitlik 4 bloğa ayrılır ve bu dört bloğa sola çevrimsel kaydırma yapılır. 
    //   j   0 1 2 3
    //  r(j) 1 4 7 9 
    
    always @* begin
        r_j[15:0]  = {j[14:0],j[15]};
        r_j[31:16] = {j[27:16],j[31:28]};
        r_j[47:32] = {j[40:32],j[47:41]};
        r_j[63:48] = {j[54:48],j[63:55]};
        
    end
endmodule