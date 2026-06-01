// =============================================================================
// Module  : top_nexys4
// Projet  : Diviseur de fréquence analogique → numérique
// Cible   : Nexys 4 DDR (Xilinx Artix-7 XC7A100T)
//
// Chaîne de traitement :
//   vp_in/vn_in  →  XADC  →  Comparateur  →  Edge Detector  →  Diviseur ÷16
//                                                                     │
//                                                             clk_out_1m25
//
// Ports physiques :
//   clk_100mhz  : E3     (oscillateur 100 MHz)
//   rst_btn     : N17    (BTNC, actif haut)
//   vp_in       : A13    (JXADC broche 1)
//   vn_in       : A14    (JXADC broche 7)
//   clk_out_1m25: C17    (PMOD JA broche 1)
//   led[11:0]   : T16..H17 (12 LEDs — valeur ADC)
//   led_pulse   : R18    (debug : clignote sur chaque front détecté)
// =============================================================================

`timescale 1ns/1ps

module top_nexys4 (
    input  wire        clk_100mhz,   // horloge 100 MHz
    input  wire        rst_btn,      // BTNC — reset (actif haut)
    input  wire        vp_in,        // JXADC VP
    input  wire        vn_in,        // JXADC VN
    output wire        clk_out_1m25, // sortie divisée (PMOD JA[0])
    output wire [11:0] led,          // valeur ADC → 12 LEDs
    output wire        led_pulse     // debug : pulse à ~1 MHz
);

    // ── Signaux internes ───────────────────────────────────────────────────
    wire        rst_n;
    wire [11:0] adc_val;
    wire        adc_valid;
    wire        sig_bin;
    wire        rising_pulse;
    wire        clk_div;

    // BTNC est actif haut sur la Nexys 4 DDR → inverser pour rst_n
    assign rst_n = ~rst_btn;

    // ── 1. Acquisition analogique ──────────────────────────────────────────
    xadc_wrapper u_xadc (
        .clk      (clk_100mhz),
        .rst      (rst_btn),
        .vp_in    (vp_in),
        .vn_in    (vn_in),
        .adc_val  (adc_val),
        .adc_valid(adc_valid)
    );

    // ── 2. Comparateur numérique ───────────────────────────────────────────
    comparator #(
        .THRESHOLD(12'h800),  // 50 % = 0,5 V
        .HYST     (12'd50)    // ±50 LSB ≈ ±12 mV
    ) u_cmp (
        .clk      (clk_100mhz),
        .adc_val  (adc_val),
        .adc_valid(adc_valid),
        .sig_bin  (sig_bin)
    );

    // ── 3. Détection de front montant ──────────────────────────────────────
    edge_detector u_edge (
        .clk         (clk_100mhz),
        .rst_n       (rst_n),
        .sig_in      (sig_bin),
        .rising_edge (rising_pulse),
        .falling_edge()             // non utilisé
    );

    // ── 4. Diviseur de fréquence ÷ 16 ─────────────────────────────────────
    freq_divider #(.N(16)) u_div (
        .clk          (clk_100mhz),
        .rst_n        (rst_n),
        .rising_pulse (rising_pulse),
        .clk_out      (clk_div)
    );

    // ── Sorties ────────────────────────────────────────────────────────────
    assign clk_out_1m25 = clk_div;
    assign led          = adc_val;
    assign led_pulse    = rising_pulse;

endmodule
