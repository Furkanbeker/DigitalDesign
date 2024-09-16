`timescale 1ns / 1ps

module up_down_counter (
    input wire clk,            // Yavaþlatýlmýþ clock sinyali (clk_slow)
    input wire rst,            // Reset sinyali
    input wire button,         // Debounced buton sinyali
    output reg [3:0] counter = 4'b0000,  // 4-bit sayaç baþlangýç deðeri
    output reg mode = 1'b0              // Yukarý/Aþaðý sayma modu baþlangýç deðeri
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 4'b0000; // Reset durumunda sayaç sýfýrlanýr
            mode <= 1'b0;       // Yukarý sayma modu baþlangýcý
        end else if (button) begin
            if (mode == 1'b0) begin
                if (counter == 4'b1111) begin
                    mode <= 1'b1;  // En üst deðere ulaþýldýðýnda aþaðý saymaya baþla
                end else begin
                    counter <= counter + 1;  // Yukarý say
                end
            end else if (mode == 1'b1) begin
                if (counter == 4'b0000) begin
                    mode <= 1'b0;  // Sýfýra ulaþýldýðýnda yukarý saymaya baþla
                end else begin
                    counter <= counter - 1;  // Aþaðý say
                end
            end
        end
    end
endmodule

