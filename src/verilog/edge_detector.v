// =============================================================================
// Module  : edge_detector
// Description :
//   Détecte les fronts montants et descendants d'un signal binaire.
//   Produit un pulse d'exactement 1 cycle d'horloge sur chaque transition.
//
//   Technique : double registre + porte logique
//     rising  = sig_d1 & ~sig_d2   (transition 0→1)
//     falling = ~sig_d1 & sig_d2   (transition 1→0)
//
//   Latence introduite : 2 cycles d'horloge (20 ns @ 100 MHz).
// =============================================================================

`timescale 1ns/1ps

module edge_detector (
    input  wire clk,
    input  wire rst_n,          // reset asynchrone actif bas
    input  wire sig_in,         // signal binaire à surveiller
    output wire rising_edge,    // pulse 1 cycle sur front montant 0→1
    output wire falling_edge    // pulse 1 cycle sur front descendant 1→0
);

    reg sig_d1, sig_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sig_d1 <= 1'b0;
            sig_d2 <= 1'b0;
        end
        else begin
            sig_d1 <= sig_in;   // capture au cycle N
            sig_d2 <= sig_d1;  // retard d'un cycle supplémentaire
        end
    end

    assign rising_edge  =  sig_d1 & (~sig_d2);  // vient de passer à 1
    assign falling_edge = (~sig_d1) & sig_d2;   // vient de passer à 0

endmodule
