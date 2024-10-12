`timescale 1ns / 1ps

module debouncer (
    input wire clk,            // Yava�lat�lm�� clock sinyali (clk_slow)
    input wire button_in,      // S��ramal� buton sinyali
    output reg button_out      // Debounced buton sinyali (temiz sinyal)
);

    reg button_sync_0 = 1'b0, button_sync_1 = 1'b0;   // D flip-flop'larla senkronizasyon
    reg [2:0] shift_reg = 3'b000;                // Shift register ba�lang�� de�eri

    // D flip-flop kullanarak buton sinyalini senkronize etme
    always @(posedge clk) begin
        button_sync_0 <= button_in;
        button_sync_1 <= button_sync_0;
    end

    // Shift register ile debouncing i�lemi
    always @(posedge clk) begin
        shift_reg <= {shift_reg[1:0], button_sync_1};  // 3-bit kayd�rma kayd�
        if (shift_reg == 3'b111) begin
            button_out <= 1'b1;  // Temiz sinyal 1
        end else if (shift_reg == 3'b000) begin
            button_out <= 1'b0;  // Temiz sinyal 0
        end
    end
endmodule
