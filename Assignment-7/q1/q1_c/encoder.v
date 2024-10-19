`timescale 1ns / 1ps

module Encoder(clk, reset, start, p_text, m_key, done, c_text);
    input clk, reset, start;
    input wire [block_length-1 : 0] p_text;
    input wire [key_length-1: 0] m_key;
    output reg done;
    output reg [block_length-1 : 0]  c_text;
    
    reg[4:0] counter ;
    reg [key_length-1:0] key;
    reg [63:0] s_in; 
    wire [key_length-1:0] key_reg;
    wire [63:0] s_out;
    
    parameter block_length = 64;
    parameter key_length = 80;
    
    Round_Enc u2(key,s_in,s_out);
    
    Key_Generator u1(key,counter,key_reg);
        
    parameter IDLE = 2'b00;
    parameter LOAD = 2'b01;
    parameter ROUND = 2'b10;
    parameter ROUND25 = 2'b11;
    reg [1:0] state;
    
      always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            counter <= 5'd0; 
        end 
        
        else begin
        
            case (state) 
            
              IDLE: begin 
                  done <= 0;
                  if (start == 1) begin
                      counter <= 5'd0;
                      state <= LOAD;
                  end
              end 
                 
              LOAD: begin
              
                  if (counter == 0) begin
                      key <= m_key; 
                      s_in <= p_text;
                      counter <= counter +1;
                  end
                  
                  else begin
                  counter <= counter -1;
                  state <= ROUND;
                  end
              end
                
              ROUND: begin      
                  if (counter < 5'd24) begin
                      counter <= counter +1;
                      key <= key_reg; 
                      s_in <= s_out;
                  end 
                  else if (counter == 5'd24) begin
                      state <= ROUND25;
                  end
               end
                
               ROUND25: begin
                  done <= 1;
                  c_text <= s_out[63:0] ^ key_reg[63:0] ;
                  state <= IDLE;
               end   
                 
            endcase
         end
      end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Key_Generator(Key, RC, Key_Register);
    input [79:0] Key;
    input [4:0] RC; 
    output [79:0] Key_Register;
    wire [79:0] keywire; 
    wire [3:0] key1; 
    wire [4:0] key2;
    
/////   key_schedule
//        26 tane 64 bitlik anahtar kullan�l�r
//        128 bitlik ya da 80 bitlik kullan�c� tan�ml� master_key in �retim fonksiyonuna sokulup - ��k�� en anlams�z 64 bit
//        �retilen anahtarlar s�ras�yla round fonksiyonuna dahil olurlar 
//        ilk turun anahtar� round_key[0] �retilmeyip kullan�c� taraf�ndan tan�mlanm�� ana anahtar�n en anlams�z 64 biti
//        ilk �retilen anahtar ikinci turda dahil olacka 
//        gerekli 26 anahtar�n (k[0] - k[25]) ilkini ana anahtar�n son 64 bitinden, di�erlerini anahtar �retim fonksiyonundan
//        ana anahtar key_register da kaydedilir bu kayd�n en anlams�z 64 biti her turun ara anahtar� (round_key) 

    assign keywire = {Key[66:0],Key[79:67]};
    S_Box lsb(keywire[3:0],key1);        
    assign key2 = (RC ^ keywire[63:59]);
    assign Key_Register = {keywire[79:64],key2,keywire[58:4],key1};
    
endmodule


//////////////////////////////////////////////////////////////////////////////////////////

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
    
//  �imdiki durum ile tur anahtar�n�n en d���k anlaml� 64 biti aras�nda xor 
//  her turda anahtar de�i�ir
    
    output [63:0] S_out;
    
    assign S_out = R_key ^ S_in;
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module S_Box_Layer(a, S_a);
    input [63:0] a;
    output [63:0] S_a;
    
//  4 bit giri� 4 bit ��k�� birbiriyle paralel �al��an 16 s_boxtan olu�ur
    
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
    
//  k    0 1 2 3 4 5 6 7 8 9 A B C D E F
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
    
//  3 ara katmana sahiptir

    wire [63:0] S1, S2;
    
    Block_Shuffle     bs(s_in,S1);
    Round_Permutation rp(S1,S2);
    XOR_Operation     xr(S2,s_out);
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Block_Shuffle(j, B_j);
    input [63:0] j;
    output [63:0] B_j;
    
    //16 bitlik girdiyi 8 bitlik sola �evrimsel kayd�rma - 16bit ��kt�

    
    genvar i;
    
    generate for(i=0; i<4; i=i+1)  
    Block_S f(j[(16*i+15) : (16*i)], B_j[(16*i+15) : (16*i)]);  
    endgenerate
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Block_S(j, B_j);

    input [15:0] j;
    output reg [15:0] B_j;
    
    //16 bitlik girdi �nce 4 bitlik bloklar ayr�l� 
    //en anlams�z 4 bitlik blok 8 bit sola kayd�r�larak 3. en anlams�z blo�un yerine ge�er 
    //ayn� �ekilde ikinci en anlams�z blok 8 bit kayd�r�lraak en anlmal� blo�un yerin ege�mi� olur.        
    //j   0 1 2 3 
    //B(j) 2 3 0 1    
    
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
    
    //    16 bitlik bloklar aras�nda basit xor 
    //    4 tane 16 bitlik ��kt�dan(W'3 W'2 W'1 W'0 ) toplamda 64 bit ��k��
    //    W'3 =  W3 ^ W2^ W0
    //    W'2 =  W2^ W0 
    //    W'1 =  W3 ^ W1
    //    W'0 =  W3 ^ W1^ W0
    
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
    
    //            16 bitlik bloklara sola kayd�rma i�lemi uygular
    //            64 bitlik giri� �nce 16 bitlik 4 blo�a ayr�l�r ve bu d�rt blo�a sola �evrimsel kayd�rma yap�l�r. 
    //             j   0 1 2 3
    //            r(j) 1 4 7 9 
    
    always @* begin
        r_j[15:0]  = {j[14:0],j[15]};
        r_j[31:16] = {j[27:16],j[31:28]};
        r_j[47:32] = {j[40:32],j[47:41]};
        r_j[63:48] = {j[54:48],j[63:55]};
    end
endmodule

