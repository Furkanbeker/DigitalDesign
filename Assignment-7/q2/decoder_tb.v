module tb_decoder( );
    reg clk = 0;
    reg reset = 0;
    reg Start = 0; 
    reg [63:0] Ciphertext = 0;
    wire done; 
    wire [63:0] Plaintext;

    Decoder dut(.clk(clk), .reset(reset), .Start(Start), .Ciphertext(Ciphertext), .done(done), .Plaintext(Plaintext));

    always begin
         clk = #5 ~clk;
    end
    
    initial begin
        reset= 1;
        #10
        reset =0;
        Start=1;
        Ciphertext = 64'h3cf72a8b7518e6f7;
    
    
    end
        
endmodule