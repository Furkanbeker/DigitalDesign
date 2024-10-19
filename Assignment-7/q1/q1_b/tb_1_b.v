
module tb_keygen();

    reg [79:0] KEY; 
    reg [4:0] RC;
    wire [79:0] Key_Register;
    
    Key_Generator t1(.KEY(KEY),.RC(RC),.Key_Register(Key_Register)) ;
    
    initial begin
        KEY = 80'h00000000000000000000;
        RC = 5'd0;
        #100
        KEY = 80'h0000000000000000000e;
        RC = 5'd1;
        #100
        KEY = 80'h0000080000000001c00e;
        RC = 5'd2;
        #100
        KEY = 80'h0100100000003801c00e;
        RC = 5'd3;
        #100
        KEY = 80'h0200180007003801c02e;
        RC = 5'd4;
        #100
        KEY = 80'h030020e007003805c04e;
        RC = 5'd5;
        #100
        KEY = 80'h041c28e00700b809c06e;
        RC = 5'd6;
        #100
        KEY = 80'h851c30e01701380dc081;
        RC = 5'd7;
        #100
        KEY = 80'h861c3ae02701b81030a1;
        RC = 5'd8;
        #100
        KEY = 80'h875c44e03702061430c1;
        RC = 5'd9;
        #100
        KEY = 80'h889c4ee040c2861830ef;
        RC = 5'd10;
        #100
        KEY = 80'h89dc581850c3061df111;
        RC = 5'd11;
        #100
        KEY = 80'h8b03521860c3be22313f;
        RC = 5'd12;
        #100
        KEY = 80'h6a436c1877c44627f16e;
        RC = 5'd13;
        #100
        KEY = 80'h6d8366f888c4fe2dcd4d;
        RC = 5'd14;
        
    end
    
endmodule
