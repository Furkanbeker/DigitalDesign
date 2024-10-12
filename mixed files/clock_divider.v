`timescale 1ns / 1ps

module clock_divider(
    input wire clk_in,         // Ana clock sinyali (100 MHz)
    output reg clk_out = 1'b0  // Yava�lat�lm�� clock sinyali
);

    reg [16:0] count = 0;      // Saya�

    always @(posedge clk_in) begin
        count <= count + 1;
        if (count == 50) begin  // Clock'u yava�lat (50000 d�ng�de bir sinyal de�i�ir)
            clk_out <= ~clk_out;
            count <= 0;
        end
    end
endmodule
