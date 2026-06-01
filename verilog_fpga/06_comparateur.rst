.. _verilog_comparateur:

Comparateur numérique
=====================

.. contents:: Sommaire
   :local:
   :depth: 2

Rôle dans la chaîne
--------------------

Le comparateur reçoit la valeur ADC 12 bits et produit un signal **binaire
1 bit** ``sig_bin``. Il constitue le pont entre le monde analogique
(grandeur continue) et le monde logique (0 ou 1).

Principe du seuillage avec hystérésis
---------------------------------------

Sans hystérésis, un signal bruité autour du seuil provoquerait des
oscillations rapides de ``sig_bin`` (*chattering*), qui génèreraient de
faux fronts montants dans l'étage suivant.

L'**hystérésis** introduit une zone morte de largeur $\pm H$ :

.. math::

   \text{sig\_bin} = \begin{cases}
     1 & \text{si } \text{adc\_val} \geq T + H \text{ (montée)} \\
     0 & \text{si } \text{adc\_val} < T - H \text{ (descente)} \\
     \text{inchangé} & \text{sinon (zone morte)}
   \end{cases}

où $T$ est le seuil (*threshold*) et $H$ l'hystérésis.

.. code-block:: verilog
   :caption: comparator.v — version complète

   module comparator #(
       parameter [11:0] THRESHOLD = 12'h800,  // 50 % pleine échelle ≈ 0,5 V
       parameter [11:0] HYST      = 12'd50    // ±50 LSB ≈ ±12 mV
   ) (
       input  wire        clk,
       input  wire [11:0] adc_val,
       input  wire        adc_valid,
       output reg         sig_bin
   );
       always @(posedge clk) begin
           if (adc_valid) begin
               if      (adc_val >= THRESHOLD + HYST) sig_bin <= 1'b1;
               else if (adc_val <  THRESHOLD - HYST) sig_bin <= 1'b0;
               // zone morte : sig_bin conserve sa valeur précédente
           end
       end
   endmodule

Chronogramme
-------------

.. code-block:: text

   adc_val  ────╮ bruit ╭───────────────╮ bruit ╭───────
                ╰───────╯               ╰───────╯
                        T+H ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
                        T   ──────────────────────  ← seuil
                        T-H ─ ─ ─ ─ ─ ─ ─ ─ ─ ─

   sig_bin  ────────────────┌─────────────────┐───────
            0               1   (pas de chattering)   0

Choix du seuil et de l'hystérésis
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Paramètre
     - Valeur recommandée
     - Justification
   * - ``THRESHOLD``
     - ``12'h800`` (2048 = 0,5 V)
     - Centre de la plage 0–1 V du XADC
   * - ``HYST``
     - ``12'd50`` (≈ 12 mV)
     - Quelques LSB au-dessus du bruit thermique du XADC (~1–2 LSB RMS)

.. seealso::

   :doc:`07_edge_detector` — étape suivante : détection du front montant
   sur le signal ``sig_bin`` produit par ce comparateur.
