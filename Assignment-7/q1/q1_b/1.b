
module Key_Generator(Key, RC, Key_Register);
    input [79:0] Key;
    input [4:0] RC; 
    output [79:0] Key_Register;
    wire [79:0] keywire; 
    wire [3:0] key1; 
    wire [4:0] key2;
    
/////   key_schedule
//        26 tane 64 bitlik anahtar kullanýlýr
//        128 bitlik ya da 80 bitlik kullanýcý tanýmlý master_key in üretim fonksiyonuna sokulup - çýkýþ en anlamsýz 64 bit
//        üretilen anahtarlar sýrasýyla round fonksiyonuna dahil olurlar 
//        ilk turun anahtarý round_key[0] üretilmeyip kullanýcý tarafýndan tanýmlanmýþ ana anahtarýn en anlamsýz 64 biti
//        ilk üretilen anahtar ikinci turda dahil olacka 
//        gerekli 26 anahtarýn (k[0] - k[25]) ilkini ana anahtarýn son 64 bitinden, diðerlerini anahtar üretim fonksiyonundan
//        ana anahtar key_register da kaydedilir bu kaydýn en anlamsýz 64 biti her turun ara anahtarý (round_key) 

    assign keywire = {Key[66:0],Key[79:67]};
    S_Box lsb(keywire[3:0],key1);        
    assign key2 = (RC ^ keywire[63:59]);
    assign Key_Register = {keywire[79:64],key2,keywire[58:4],key1};
    
endmodule

////////////////////////////////////////////////////////////


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
