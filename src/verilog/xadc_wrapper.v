// =============================================================================
// Module  : xadc_wrapper
// Projet  : Diviseur de fréquence analogique → numérique (Nexys 4 DDR)
// Auteur  : cours RT_Models / agautheron
// Cible   : Xilinx Artix-7 XC7A100T (Nexys 4 DDR)
//
// Description :
//   Enveloppe du primitif XADC Xilinx.
//   Convertit le signal différentiel VP/VN en valeur numérique 12 bits.
//   Émet un pulse adc_valid d'un cycle à chaque nouvelle conversion.
//
// Fréquence d'échantillonnage : ADCCLK / 26 ≈ 25 MHz / 26 ≈ 960 ksps
// =============================================================================

`timescale 1ns/1ps

module xadc_wrapper (
    input  wire        clk,        // 100 MHz système
    input  wire        rst,        // reset synchrone actif haut
    input  wire        vp_in,      // VP — JXADC broche 1
    input  wire        vn_in,      // VN — JXADC broche 7
    output reg  [11:0] adc_val,    // valeur 12 bits (0x000–0xFFF)
    output reg         adc_valid   // pulse 1 cycle : nouvelle donnée disponible
);

    wire [15:0] do_out;
    wire        drdy;

    // ── Primitif XADC (Xilinx Artix-7 / 7-series) ─────────────────────────
    XADC #(
        .INIT_40(16'h9000),  // Mode continu, canal 0 (VP/VN), avg x16
        .INIT_41(16'h2ef0),  // Désactiver toutes les alarmes
        .INIT_42(16'h0400),  // ADCCLK = DCLK / 4 → 100 MHz / 4 = 25 MHz
        .INIT_48(16'h0100),  // Séquenceur : canal 0 uniquement
        .INIT_49(16'h0000),
        .INIT_4A(16'h0100),
        .INIT_4B(16'h0000)
    ) u_xadc_prim (
        .CONVST   (1'b0),
        .CONVSTCLK(1'b0),
        .DADDR    (7'h00),    // registre 0x00 = mesure VP/VN
        .DCLK     (clk),
        .DEN      (1'b1),
        .DI       (16'h0000),
        .DWE      (1'b0),
        .RESET    (rst),
        .VAUXN    (15'b0),
        .VAUXP    (15'b0),
        .VN       (vn_in),
        .VP       (vp_in),
        .DO       (do_out),   // résultat 16 bits (12 MSB = valeur)
        .DRDY     (drdy),     // pulse 1 cycle par conversion terminée
        .EOC      (),
        .EOS      ()
    );

    // ── Capture sur front DRDY ─────────────────────────────────────────────
    always @(posedge clk) begin
        adc_valid <= 1'b0;          // défaut : invalide
        if (drdy) begin
            adc_val   <= do_out[15:4];  // 12 MSB justifiés à gauche
            adc_valid <= 1'b1;
        end
    end

endmodule
