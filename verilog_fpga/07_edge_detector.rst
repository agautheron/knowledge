.. _verilog_edge:

Détecteur de front montant
==========================

.. contents:: Sommaire
   :local:
   :depth: 2

Principe
--------

Un **détecteur de front montant** produit un pulse d'exactement **1 cycle
d'horloge** à chaque transition $0 \to 1$ du signal d'entrée. Ce pulse
servira d'*enable* au compteur diviseur : le compteur n'avancera que lors
d'un front montant détecté sur le signal analogique numérisé.

La technique repose sur deux bascules D en série (*two-flop synchronizer*)
et une porte ET :

.. math::

   \text{rising\_edge} = \text{sig\_d1} \;\wedge\; \overline{\text{sig\_d2}}

.. code-block:: text

   Chronogramme (horloge à 100 MHz, signal à ~1 MHz effectif)

   clk      ┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐
   sig_bin  ─────┐         ┌────
                 └─────────┘
   sig_d1   ──────┐         ┌───   ← retardé de 1 cycle
                  └─────────┘
   sig_d2   ───────┐         ┌──   ← retardé de 2 cycles
                   └─────────┘
   rising   ───────┐┘               ← pulse : d1=1 ET d2=0 (1 cycle)

L'idée : quand ``sig_d1`` vient de passer à 1 mais que ``sig_d2`` est
encore à 0 (il "voit" le cycle précédent), leur combinaison ``d1 & ~d2``
est vraie pendant exactement 1 cycle d'horloge.

Module Verilog
--------------

.. code-block:: verilog
   :caption: edge_detector.v

   module edge_detector (
       input  wire clk,
       input  wire rst_n,
       input  wire sig_in,        // signal binaire issu du comparateur
       output wire rising_edge,   // pulse 1 cycle sur chaque front 0→1
       output wire falling_edge   // pulse 1 cycle sur chaque front 1→0
   );

       reg sig_d1, sig_d2;

       always @(posedge clk or negedge rst_n) begin
           if (!rst_n) begin
               sig_d1 <= 1'b0;
               sig_d2 <= 1'b0;
           end
           else begin
               sig_d1 <= sig_in;    // capture au cycle N
               sig_d2 <= sig_d1;   // retard d'un cycle supplémentaire
           end
       end

       // Front montant : d1 vient de passer à 1, d2 est encore à 0
       assign rising_edge  = sig_d1 & (~sig_d2);
       // Front descendant : d1 vient de passer à 0, d2 est encore à 1
       assign falling_edge = (~sig_d1) & sig_d2;

   endmodule

Variantes de détection
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 35 35 30

   * - Variante
     - Expression
     - Usage
   * - Front montant (*rising*)
     - ``sig_d1 & ~sig_d2``
     - Pilotage du diviseur (ce projet)
   * - Front descendant (*falling*)
     - ``~sig_d1 & sig_d2``
     - Mesure de largeur d'impulsion
   * - Tout front (*any edge*)
     - ``sig_d1 ^ sig_d2``
     - Décodeur de quadrature, encodeur rotatif

Latence et impact sur la fréquence
------------------------------------

Le double registre introduit une latence de **2 cycles d'horloge** (20 ns
à 100 MHz) entre le front physique du signal analogique et le pulse généré.

Pour un signal à 20 MHz ($T = 50\,\text{ns}$), cette latence représente
40 % de la période — non négligeable si l'on cherche une précision temporelle
absolue, mais sans impact sur la **fréquence** de sortie du diviseur, qui
ne dépend que du **nombre** de fronts, pas de leur position temporelle exacte.

.. seealso::

   :doc:`08_diviseur` — utilisation du signal ``rising_edge`` comme
   enable du compteur diviseur ÷16.
