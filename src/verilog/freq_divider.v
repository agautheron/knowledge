// =============================================================================
// Module  : freq_divider
// Description :
//   Diviseur de fréquence paramétrable à signal enable.
//   Cadencé sur clk (100 MHz), n'avance que sur rising_pulse.
//   Produit un signal symétrique (rapport cyclique 50 %).
//
//   Rapport de division : N (doit être un entier pair).
//   Pour N=16 : 20 MHz → 1,25 MHz  (ou ~62,5 kHz avec XADC réel).
// =============================================================================

`timescale 1ns/1ps

module freq_divider #(
    parameter integer N = 16    // rapport de division (entier pair)
) (
    input  wire clk,            // horloge système (100 MHz)
    input  wire rst_n,          // reset asynchrone actif bas
    input  wire rising_pulse,   // enable : avancer sur chaque front analogique
    output reg  clk_out         // signal de sortie divisé
);

    // Nombre de bits : ceil(log2(N)) — calculé automatiquement
    reg [$clog2(N)-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count   <= 0;
            clk_out <= 1'b0;
        end
        else if (rising_pulse) begin
            if (count == (N/2) - 1) begin
                clk_out <= ~clk_out;    // basculer à mi-période
                count   <= 0;
            end
            else begin
                count <= count + 1'b1;
            end
        end
        // sans rising_pulse : état gelé
    end

endmodule
