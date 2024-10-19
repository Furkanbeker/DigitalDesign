
module tb_top();

    reg Start, clk, reset;
    reg [63:0] state_in; 
    reg [79:0] KEY0;
    wire [63:0] state_out;
    wire done;
    
    top dut(Start, clk, reset,state_in, KEY0,state_out, done);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        reset= 1;
        state_in = 64'h0;
        KEY0 = 80'd1365;
        #10
        reset=0;
        Start=0;
        #10
        Start=1;
        
       
        #1000
        state_in = 64'd256;
        KEY0 = 80'd1;
        Start=0;
        #10
        Start=1;
        
        #1000
        state_in = 64'hABAB_FEBA_FEDA_ADAD;
        KEY0 = 80'd0;
        Start=0;
        #10
        Start=1;
        
        
        
        
    end
     

endmodule
