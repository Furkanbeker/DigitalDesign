`timescale 1ns / 1ps

module up_down_counter (
    input wire clk,            // Yava�lat�lm�� clock sinyali (clk_slow)
    input wire rst,            // Reset sinyali
    input wire button,         // Debounced buton sinyali
    output reg [3:0] counter = 4'b0000,  // 4-bit saya� ba�lang�� de�eri
    output reg mode = 1'b0              // Yukar�/A�a�� sayma modu ba�lang�� de�eri
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 4'b0000; // Reset durumunda saya� s�f�rlan�r
            mode <= 1'b0;       // Yukar� sayma modu ba�lang�c�
        end else if (button) begin
            if (mode == 1'b0) begin
                if (counter == 4'b1111) begin
                    mode <= 1'b1;  // En �st de�ere ula��ld���nda a�a�� saymaya ba�la
                end else begin
                    counter <= counter + 1;  // Yukar� say
                end
            end else if (mode == 1'b1) begin
                if (counter == 4'b0000) begin
                    mode <= 1'b0;  // S�f�ra ula��ld���nda yukar� saymaya ba�la
                end else begin
                    counter <= counter - 1;  // A�a�� say
                end
            end
        end
    end
endmodule

