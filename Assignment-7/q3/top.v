module top(
    input Start, clk, reset,
    input [63:0] state_in, 
    input [79:0] KEY0,
    output [63:0] state_out, 
    output done );
    
    wire [63:0] state_out_enc; 
    
    wire done_enc;
    
    Encoder enc(clk, reset, Start, state_in, KEY0, done_enc, state_out_enc);
    Decoder dec(clk, reset, done_enc, state_out_enc, KEY0, done, state_out);
    
    assign state_in_enc = state_in;
    
endmodule



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
//        26 tane 64 bitlik anahtar kullanılır
//        128 bitlik ya da 80 bitlik kullanıcı tanımlı master_key in üretim fonksiyonuna sokulup - çıkış en anlamsız 64 bit
//        üretilen anahtarlar sırasıyla round fonksiyonuna dahil olurlar 
//        ilk turun anahtarı round_key[0] üretilmeyip kullanıcı tarafından tanımlanmış ana anahtarın en anlamsız 64 biti
//        ilk üretilen anahtar ikinci turda dahil olacka 
//        gerekli 26 anahtarın (k[0] - k[25]) ilkini ana anahtarın son 64 bitinden, diğerlerini anahtar üretim fonksiyonundan
//        ana anahtar key_register da kaydedilir bu kaydın en anlamsız 64 biti her turun ara anahtarı (round_key) 

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
    
//  şimdiki durum ile tur anahtarının en düşük anlamlı 64 biti arasında xor 
//  her turda anahtar değişir
    
    output [63:0] S_out;
    
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
    
    //16 bitlik girdiyi 8 bitlik sola çevrimsel kaydırma - 16bit çıktı

    
    genvar i;
    
    generate for(i=0; i<4; i=i+1)  
    Block_S f(j[(16*i+15) : (16*i)], B_j[(16*i+15) : (16*i)]);  
    endgenerate
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Block_S(j, B_j);

    input [15:0] j;
    output reg [15:0] B_j;
    
    //16 bitlik girdi önce 4 bitlik bloklar ayrılı 
    //en anlamsız 4 bitlik blok 8 bit sola kaydırılarak 3. en anlamsız bloğun yerine geçer 
    //aynı şekilde ikinci en anlamsız blok 8 bit kaydırılraak en anlmalı bloğun yerin egeçmiş olur.        
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
    
    //    16 bitlik bloklar arasında basit xor 
    //    4 tane 16 bitlik çıktıdan(W'3 W'2 W'1 W'0 ) toplamda 64 bit çıkış
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
    
    //            16 bitlik bloklara sola kaydırma işlemi uygular
    //            64 bitlik giriş önce 16 bitlik 4 bloğa ayrılır ve bu dört bloğa sola çevrimsel kaydırma yapılır. 
    //             j   0 1 2 3
    //            r(j) 1 4 7 9 
    
    always @* begin
        r_j[15:0]  = {j[14:0],j[15]};
        r_j[31:16] = {j[27:16],j[31:28]};
        r_j[47:32] = {j[40:32],j[47:41]};
        r_j[63:48] = {j[54:48],j[63:55]};
    end
endmodule


`timescale 1ns / 1ps


// Bir round : 
//        her turun giriş verisinin tur anahtarı ile xorlanması
//        s_box ile doğrusal olmayan dönüşüm
//        blok karıştırma
//        round permütasyon
//        xor
    
//    //add_round_key
//    şimdiki durum ile tur anahtarının en düşük anlamlı 64 biti arasında xor 
//    her turda anahtar değişir
    
//    //s_box_layer
//    4 bit giriş 4 bit çıkış birbiriyle paralel çalışan 16 s_boxtan oluşur
//    x    0 1 2 3 4 5 6 7 8 9 A B C D E F
//    S(x) E 4 B 1 7 9 C A D 2 0 F 8 5 3 6

//      ////permutaion_layer
//      3 ara katmana sahiptir
    //            //block_shuffle
    //            16 bitlik girdiyi 8 bitlik sola çevrimsel kaydırma - 16bit çıktı
    //            16 bitlik girdi önce 4 bitlik bloklar ayrılı 
    //            en anlamsız 4 bitlik blok 8 bit sola kaydırılarak 3. en anlamsız bloğun yerine geçer 
    //            aynı şekilde ikinci en anlamsız blok 8 bit kaydırılraak en anlmalı bloğun yerin egeçmiş olur.        
    //            j   0 1 2 3 
    //           B(j) 2 3 0 1 
                    
    //            //round_permütation 
    //            16 bitlik bloklara sola kaydırma işlemi uygular
    //            64 bitlik giriş önce 16 bitlik 4 bloğa ayrılır ve bu dört bloğa sola çevrimsel kaydırma yapılır. 
    //            j   0 1 2 3
    //            r(j) 1 4 7 9 
                 
    //             //xor operation
    //             16 bitlik bloklar arasında basit xor 
    //             4 tane 16 bitlik çıktıdan(W'3 W'2 W'1 W'0 ) toplamda 64 bit çıkış
    //             W'3 =  W3 ^ W2^ W0
    //             W'2 =  W2^ W0
    //             W'1 =  W3 ^ W1
    //             W'0 =  W3 ^ W1^ W0
    
/////   key_schedule
//        26 tane 64 bitlik anahtar kullanılır
//        128 bitlik ya da 80 bitlik kullanıcı tanımlı master_key in üretim fonksiyonuna sokulup - çıkış en anlamsız 64 bit
//        üretilen anahtarlar sırasıyla round fonksiyonuna dahil olurlar 
//        ilk turun anahtarı round_key[0] üretilmeyip kullanıcı tarafından tanımlanmış ana anahtarın en anlamsız 64 biti
//        ilk üretilen anahtar ikinci turda dahil olacka 
//        gerekli 26 anahtarın (k[0] - k[25]) ilkini ana anahtarın son 64 bitinden, diğerlerini anahtar üretim fonksiyonundan
//        ana anahtar key_register da kaydedilir bu kaydın en anlamsız 64 biti her turun ara anahtarı (round_key) 
    //        anahtar güncelerken 
    //                önce key_register 13 bit sola çevrimsel kaydırılır kaydırılır 
    //                bu anahtarın en anlamsız 4 biti S_box' a sokularak güncellenir. 
    //                bu anahtar kaydının 59. ve 63. bitleri arasındaki 4 bit kaçıncı turda ise o sayının 4 bitlik ikilik tabandaki o sayıyla xorlanır
    //                key_register    = K79K78...K2K1K0 
    //                round_key = K63K62...K2K1K0 
    //                1.key_register <<< 13
    //                2. [K3K2K1K0]<- S[K3K2K1K0]
    //                3. [K63K62K61K60K59] <- [K63K62K61K60K59] ^RCi
    //                <<<n n bitlik çevrimsel sola kaydırma ve RCi tur sayacı
                
                
   
module Decoder(clk, reset, Start, Ciphertext, KEY0, done, Plaintext);
      input clk, reset, Start;
      input [63:0] Ciphertext;
      input [79:0] KEY0;
      output reg done;
      output reg [63:0] Plaintext = 0;
      
      wire [79:0] key_reg_dec;
      wire [79:0] key_reg;
      wire [63:0] state_in;
      reg [79:0] key; 
      reg [79:0] key_25;
      reg [4:0] counter; 
      reg [4:0] counter_25;
      reg key25_finish;
      reg [79:0] key_dec; 
      reg [79:0] round_key; 
      reg [63:0] state_out; 
  
      Key_Generator keyreg(key,counter_25,key_reg);
     
      Round_dec round_dec(round_key,state_out,state_in);

      Key_Gen_dec keygen_dec(key_dec,counter,key_reg_dec);
              
      reg [1:0]state;
      parameter IDLE=2'b00;
      parameter LOAD=2'b01;
      parameter KEY25=2'b10;
      parameter ROUND=2'b11; 
      
      always @(posedge clk) begin
        if(reset ) begin
            state <= IDLE;
            done <= 0;
        end 
        else begin       
            case(state) 
            
            IDLE: begin 
                  done <= 0;
                  if (Start == 1) begin
                      counter_25 <= 5'd0;
                      state <= LOAD;
                  end
              end 
                 
            LOAD: begin
                if (counter_25 == 5'd0) begin
                    key <= KEY0;
                end
                
                else begin
                    counter <= counter -1;
                    state <= KEY25;
                end
            end
            
            KEY25: begin
                if (counter_25 == 5'd0) begin
                    key <= KEY0;
                    counter_25 <= counter_25 + 1;
                    end
                    
                else if (counter_25 < 5'd24) begin
                    counter_25 <= counter_25 + 1;
                    key <= key_reg;
                    key25_finish <= 0;
                end 
                else if (counter_25 == 5'd24) begin
                    key_25 <= key_reg;
                    state <= ROUND; 
                    counter <= 5'd24;
                    key_dec <= key_reg;
                end
            end
            
            ROUND: begin
                if (counter == 5'd24) begin
                    key_dec <= key_reg_dec;
                    round_key <= key_reg_dec;
                    state_out <= Ciphertext ^ key_25[63:0];
                    counter <= counter -1; 
                end 
                else if(counter > 5'd0) begin
                    key_dec <= key_reg_dec;
                    state_out <= state_in;
                    round_key <= key_reg_dec;
                    counter <= counter -1;
                end 
                else if (counter == 5'd0) begin
                    state_out <= state_in;
                    round_key <= key_reg_dec;
                    state <= IDLE;
                    done <= 1;
                    Plaintext <= state_in;
                end
              end 
          endcase 
        end
      end
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////
  
    
module Round_dec(round_key, state_out,state_in);
    input [79:0] round_key;
    input [63:0] state_out;
    output [63:0] state_in;
    
    wire [63:0] S2,S1;
    
    Permutation_Layer_dec f3(state_out,S2); 
    S_Box_Layer_dec       f2(S2,S1);
    Add_round_key         f1(S1,round_key[63:0],state_in);
    
endmodule


//////////////////////////////////////////////////////////////////////////////////////////

module Round_Permutation_dec(r_j, j);
    input [63:0] r_j;
    output reg [63:0] j;
        
    always @* begin
        j[63:48] = {r_j[56:48],r_j[63:57]};
        j[47:32] = {r_j[38:32],r_j[47:39]};
        j[31:16] = {r_j[19:16],r_j[31:20]};
        j[15:0]  = {r_j[0], r_j[15:1]};
    end 
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module S_Box_Layer_dec(S_x, X);
    input [63:0] S_x;
    output [63:0] X;
    
    genvar i;
    generate 
        for(i=0; i<16; i=i+1)  begin 
            S_Box_dec f(S_x[(4*i+3) : (4*i)], X[(4*i+3) : (4*i)]);  
            end 
    endgenerate
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module S_Box_dec(S_a, A);
    input [3:0] S_a;
    output reg [3:0] A; 
    
    always @* begin
        case(S_a)
            4'h0: A= 4'ha;
            4'h1: A= 4'h3;    
            4'h2: A= 4'h9;
            4'h3: A= 4'he;
            4'h4: A= 4'h1;    
            4'h5: A= 4'hd;
            4'h6: A= 4'hf;
            4'h7: A= 4'h4;    
            4'h8: A= 4'hc;
            4'h9: A= 4'h5;
            4'ha: A= 4'h7;    
            4'hb: A= 4'h2;
            4'hc: A= 4'h6;    
            4'hd: A= 4'h8;
            4'he: A= 4'h0;    
            4'hf: A= 4'hb;
        endcase
        
    end
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module XOR_Operation_dec(W_x, X);
    input [63:0] W_x;
    output [63:0] X ;
    
    assign X[63:48] = (W_x[63:48]^W_x[47:32]);
    assign X[47:32] = (W_x[47:32]^((W_x[63:48]^W_x[47:32])^(W_x[63:48]^W_x[47:32]^W_x[31:16])^W_x[15:0])); 
    assign X[31:16] = (W_x[63:48]^W_x[47:32]^W_x[31:16]);
    assign X[15:0]  = ((W_x[63:48]^W_x[47:32])^(W_x[63:48]^W_x[47:32]^W_x[31:16])^W_x[15:0]); 

endmodule

//////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////

module Key_Gen_dec(KEY, RC, key_register);
    input [79:0] KEY;
    input [4:0] RC;
    output [79:0] key_register;
    
    wire [79:0] keywr; 
    wire [3:0] key1; 
    wire [4:0] key2;
    
    S_Box_dec lsb(KEY[3:0],key1);
    assign key2 = KEY[63:59] ^ RC;
    assign keywr = {KEY[79:64],key2,KEY[58:4],key1};
    assign key_register = {keywr[12:0],keywr[79:13]};
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Permutation_Layer_dec(state_out, state_in);
    input [63:0] state_out;
    output [63:0] state_in;
    
    wire [63:0] S1,S2;
    
    XOR_Operation_dec      f3(state_out,S2);
    Round_Permutation_dec  f2(S2,S1);
    Block_Shuffle          f1(S1,state_in);
    
endmodule





 
               
        
            










    
  
