`timescale 1ns / 1ps


// Bir round : 
//        her turun giriþ verisinin tur anahtarý ile xorlanmasý
//        s_box ile doðrusal olmayan dönüþüm
//        blok karýþtýrma
//        round permütasyon
//        xor
    
//    //add_round_key
//    þimdiki durum ile tur anahtarýnýn en düþük anlamlý 64 biti arasýnda xor 
//    her turda anahtar deðiþir
    
//    //s_box_layer
//    4 bit giriþ 4 bit çýkýþ birbiriyle paralel çalýþan 16 s_boxtan oluþur
//    x    0 1 2 3 4 5 6 7 8 9 A B C D E F
//    S(x) E 4 B 1 7 9 C A D 2 0 F 8 5 3 6

//      ////permutaion_layer
//      3 ara katmana sahiptir
    //            //block_shuffle
    //            16 bitlik girdiyi 8 bitlik sola çevrimsel kaydýrma - 16bit çýktý
    //            16 bitlik girdi önce 4 bitlik bloklar ayrýlý 
    //            en anlamsýz 4 bitlik blok 8 bit sola kaydýrýlarak 3. en anlamsýz bloðun yerine geçer 
    //            ayný þekilde ikinci en anlamsýz blok 8 bit kaydýrýlraak en anlmalý bloðun yerin egeçmiþ olur.        
    //            j   0 1 2 3 
    //           B(j) 2 3 0 1 
                    
    //            //round_permütation 
    //            16 bitlik bloklara sola kaydýrma iþlemi uygular
    //            64 bitlik giriþ önce 16 bitlik 4 bloða ayrýlýr ve bu dört bloða sola çevrimsel kaydýrma yapýlýr. 
    //            j   0 1 2 3
    //            r(j) 1 4 7 9 
                 
    //             //xor operation
    //             16 bitlik bloklar arasýnda basit xor 
    //             4 tane 16 bitlik çýktýdan(W'3 W'2 W'1 W'0 ) toplamda 64 bit çýkýþ
    //             W'3 =  W3 ^ W2^ W0
    //             W'2 =  W2^ W0
    //             W'1 =  W3 ^ W1
    //             W'0 =  W3 ^ W1^ W0
    
/////   key_schedule
//        26 tane 64 bitlik anahtar kullanýlýr
//        128 bitlik ya da 80 bitlik kullanýcý tanýmlý master_key in üretim fonksiyonuna sokulup - çýkýþ en anlamsýz 64 bit
//        üretilen anahtarlar sýrasýyla round fonksiyonuna dahil olurlar 
//        ilk turun anahtarý round_key[0] üretilmeyip kullanýcý tarafýndan tanýmlanmýþ ana anahtarýn en anlamsýz 64 biti
//        ilk üretilen anahtar ikinci turda dahil olacka 
//        gerekli 26 anahtarýn (k[0] - k[25]) ilkini ana anahtarýn son 64 bitinden, diðerlerini anahtar üretim fonksiyonundan
//        ana anahtar key_register da kaydedilir bu kaydýn en anlamsýz 64 biti her turun ara anahtarý (round_key) 
    //        anahtar güncelerken 
    //                önce key_register 13 bit sola çevrimsel kaydýrýlýr kaydýrýlýr 
    //                bu anahtarýn en anlamsýz 4 biti S_box' a sokularak güncellenir. 
    //                bu anahtar kaydýnýn 59. ve 63. bitleri arasýndaki 4 bit kaçýncý turda ise o sayýnýn 4 bitlik ikilik tabandaki o sayýyla xorlanýr
    //                key_register    = K79K78...K2K1K0 
    //                round_key = K63K62...K2K1K0 
    //                1.key_register <<< 13
    //                2. [K3K2K1K0]<- S[K3K2K1K0]
    //                3. [K63K62K61K60K59] <- [K63K62K61K60K59] ^RCi
    //                <<<n n bitlik çevrimsel sola kaydýrma ve RCi tur sayacý
                
                
   
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
   
module Key_Generator(KEY, RC, Key_Register);
    input [79:0] KEY;
    input [4:0] RC; 
    output [79:0] Key_Register;
    
    wire [79:0] keywr; 
    wire [3:0] key1; 
    wire [4:0] key2;

    S_Box lsb(keywr[3:0],key1);
    assign keywr = {KEY[66:0],KEY[79:67]};
    assign key2 = (RC ^ keywr[63:59]);
    assign Key_Register = {keywr[79:64],key2,keywr[58:4],key1};
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module S_Box(a, S_a);
    input [3:0] a;
    output reg [3:0] S_a; 
    
    always @* begin
    
        case(a)
            4'h0: S_a= 4'he;
            4'h1: S_a= 4'h4;    
            4'h2: S_a= 4'hb;
            4'h3: S_a= 4'h1;
            4'h4: S_a= 4'h7;    
            4'h5: S_a= 4'h9;
            4'h6: S_a= 4'hc;
            4'h7: S_a= 4'ha;    
            4'h8: S_a= 4'hd;
            4'h9: S_a= 4'h2;
            4'ha: S_a= 4'h0;    
            4'hb: S_a= 4'hf;
            4'hc: S_a= 4'h8;    
            4'hd: S_a= 4'h5;
            4'he: S_a= 4'h3;    
            4'hf: S_a= 4'h6;
        endcase
        
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

module Add_round_key(State_in, Round_key, State_out);
    input [63:0] State_in;
    input [63:0] Round_key;
    output [63:0] State_out ;
    
    assign State_out = Round_key ^ State_in;
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Block_Shuffle(j, B_j);
    input [63:0] j;
    output [63:0] B_j ;
    
    genvar i;
    generate 
        for(i=0; i<4; i=i+1) begin 
            Block_S f(j[(16*i+15) : (16*i)], B_j[(16*i+15) : (16*i)]);  
            end
    endgenerate
    
endmodule

//////////////////////////////////////////////////////////////////////////////////////////

module Block_S(a, B_a);
    input [15:0] a;
    output reg [15:0] B_a;
    
    always @* begin
        B_a[3:0]  = a[11:8];
        B_a[7:4]  = a[15:12];
        B_a[11:8] = a[3:0];
        B_a[15:12]= a[7:4];
    end
    
endmodule

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





 
               
        
            










    
  