`timescale 1ns / 1ps

module tb_enc();
    reg clk = 0;
    reg reset = 0; 
    reg start = 0; 
    reg [block_length-1 : 0] p_text = 0; 
    reg [key_length-1: 0] m_key = 0; 
    wire done; 
    wire [block_length-1 : 0] c_text;
    
    parameter block_length = 64;
    parameter key_length = 80;
    
    Encoder t(.clk(clk), 
              .reset(reset), 
              .start(start), 
              .p_text(p_text), 
              .m_key(m_key), 
              .done(done), 
              .c_text(c_text));
    
    always begin
        clk = #5 ~clk;
    end
    
    initial begin
        reset <= 1;
        #10
        reset <= 0;
        start <= 1;
        p_text <= 5'd0;;
        m_key <= 80'h0;
        #500
        $finish;
    end

endmodule

