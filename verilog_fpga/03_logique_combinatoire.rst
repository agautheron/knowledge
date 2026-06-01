.. _verilog_combinatoire:

Logique combinatoire
====================

.. contents:: Sommaire
   :local:
   :depth: 2

La logique combinatoire produit une sortie qui ne dépend que des **entrées
actuelles** — aucune horloge, aucune mémoire d'état.

Assignation continue : ``assign``
----------------------------------

Le mot-clé ``assign`` relie en permanence une expression à un ``wire``.
C'est l'équivalent d'un câblage direct.

.. code-block:: verilog
   :caption: Exemples d'assignations continues

   wire a, b, sel;
   wire s_and, s_or, s_xor, s_not, s_mux;

   assign s_and = a & b;          // porte ET
   assign s_or  = a | b;          // porte OU
   assign s_xor = a ^ b;          // porte XOR
   assign s_not = ~a;             // inverseur
   assign s_mux = sel ? a : b;    // multiplexeur 2→1

Bloc ``always @(*)`` — combinatoire conditionnel
------------------------------------------------

Lorsque la logique est trop complexe pour une seule expression, on utilise
``always @(*)``. La liste de sensibilité ``(*)`` signifie : *recalculer dès
que n'importe quelle entrée change*.

.. important::

   Dans un ``always @(*)``, utiliser **exclusivement** l'affectation
   bloquante ``=``, jamais ``<=``.

.. code-block:: verilog
   :caption: Décodeur 2 vers 4 avec always combinatoire

   module dec2to4 (
       input  wire [1:0] sel,
       output reg  [3:0] out
   );
       always @(*) begin
           out = 4'b0000;          // valeur par défaut (évite les latches)
           case (sel)
               2'b00 : out = 4'b0001;
               2'b01 : out = 4'b0010;
               2'b10 : out = 4'b0100;
               2'b11 : out = 4'b1000;
           endcase
       end
   endmodule

.. warning::

   Toujours prévoir une valeur par défaut **avant** un ``case`` ou un
   ``if``. Sans cela, Vivado infère des **latches transparents** (mémoire
   non intentionnelle), source de bugs difficiles à diagnostiquer.

Exemple du projet : le comparateur numérique
---------------------------------------------

Dans notre chaîne de traitement, le comparateur convertit la valeur ADC
12 bits en un signal binaire 1 bit, en comparant à un seuil paramétrable.
La zone d'hystérésis évite les oscillations dues au bruit.

.. code-block:: verilog
   :caption: comparator.v — seuillage avec hystérésis

   module comparator #(
       parameter [11:0] THRESHOLD = 12'h800,  // seuil à 50 % (0,5 V)
       parameter [11:0] HYST      = 12'd50    // zone morte ± 50 LSB
   ) (
       input  wire        clk,
       input  wire [11:0] adc_val,    // valeur ADC 12 bits
       input  wire        adc_valid,  // '1' pendant 1 cycle : nouvelle mesure
       output reg         sig_bin     // signal binaire résultant
   );
       always @(posedge clk) begin
           if (adc_valid) begin
               if      (adc_val >= THRESHOLD + HYST) sig_bin <= 1'b1;
               else if (adc_val <  THRESHOLD - HYST) sig_bin <= 1'b0;
               // sinon : maintien (hystérésis → pas de changement d'état)
           end
       end
   endmodule

.. note::

   Bien que la comparaison soit combinatoire, la bascule sur ``posedge clk``
   re-synchronise la sortie sur l'horloge système, ce qui élimine les
   glitches et garantit un signal propre pour l'étage suivant.

.. seealso::

   :doc:`06_comparateur` pour la version complète avec simulation.
