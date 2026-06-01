// =============================================================================
// Module  : comparator
// Description :
//   Convertit la valeur ADC 12 bits en signal binaire 1 bit.
//   Implémente une hystérésis numérique pour éviter le chattering.
// =============================================================================

`timescale 1ns/1ps

module comparator #(
    parameter [11:0] THRESHOLD = 12'h800,  // seuil : 50 % pleine échelle (≈0,5 V)
    parameter [11:0] HYST      = 12'd50    // zone morte : ±50 LSB (≈ ±12 mV)
) (
    input  wire        clk,
    input  wire [11:0] adc_val,    // valeur ADC 12 bits
    input  wire        adc_valid,  // pulse 1 cycle : nouvelle mesure disponible
    output reg         sig_bin     // signal binaire résultant
);

    always @(posedge clk) begin
        if (adc_valid) begin
            if      (adc_val >= THRESHOLD + HYST) sig_bin <= 1'b1;
            else if (adc_val <  THRESHOLD - HYST) sig_bin <= 1'b0;
            // dans la zone morte : maintien de l'état précédent
        end
    end

endmodule
