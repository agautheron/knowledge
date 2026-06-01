.. _verilog_diviseur:

Diviseur de fréquence ÷ 16
===========================

.. contents:: Sommaire
   :local:
   :depth: 2

Calcul du rapport
-----------------

Le signal analogique d'entrée est à $f_{\text{in}} = 20\,\text{MHz}$.
La fréquence de sortie souhaitée est $f_{\text{out}} = 1{,}25\,\text{MHz}$.
Le rapport de division est :

.. math::

   N = \frac{f_{\text{in}}}{f_{\text{out}}}
     = \frac{20\,\text{MHz}}{1{,}25\,\text{MHz}} = 16

Pour un signal de sortie **symétrique** (rapport cyclique 50 %), le compteur
doit basculer tous les $N/2 = 8$ fronts montants entrants.

Architecture : diviseur à enable
----------------------------------

Le diviseur est cadencé sur l'**horloge système 100 MHz** mais n'avance
que lorsque le signal ``rising_pulse`` (front détecté sur le signal
analogique) est actif. Cette architecture est dite *clock-enable* :

- la sortie est un registre synchrone → **aucun glitch**
- l'horloge système n'est jamais dérivée → **pas de problème de clock domain**
- Vivado ne génère pas d'avertissement sur les horloges dérivées

.. code-block:: verilog
   :caption: freq_divider.v — diviseur paramétrable à enable

   module freq_divider #(
       parameter integer N = 16    // rapport de division (entier pair)
   ) (
       input  wire clk,            // horloge système (100 MHz)
       input  wire rst_n,          // reset asynchrone actif bas
       input  wire rising_pulse,   // enable : 1 cycle par front détecté
       output reg  clk_out         // sortie divisée
   );

       // Nombre de bits nécessaires : $clog2(N) = $clog2(16) = 4 → [3:0]
       reg [$clog2(N)-1:0] count;

       always @(posedge clk or negedge rst_n) begin
           if (!rst_n) begin
               count   <= 0;
               clk_out <= 1'b0;
           end
           else if (rising_pulse) begin    // avancer seulement sur front entrant
               if (count == (N/2) - 1) begin
                   clk_out <= ~clk_out;    // basculer à mi-période
                   count   <= 0;
               end
               else begin
                   count <= count + 1'b1;
               end
           end
           // sans rising_pulse : état maintenu — pas d'évolution
       end

   endmodule

Chronogramme de fonctionnement
--------------------------------

.. code-block:: text

   fronts détectés  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑
   count            0  1  2  3  4  5  6  7  0  1  2  3  4  5  6  7  0 ...
                                            ↑ basculement            ↑
   clk_out          ────────────────┐       └────────────────┐       └──
                    0               1                        0

À chaque 8\ :sup:`e` front montant du signal analogique, ``clk_out`` bascule
→ période de ``clk_out`` = 16 fronts montants d'entrée.

Utilisation du paramètre N
---------------------------

La généricité via ``parameter`` permet de réutiliser ce module pour d'autres
rapports de division sans modifier le code :

.. code-block:: verilog

   // Division par 8 (20 MHz → 2,5 MHz)
   freq_divider #(.N(8))  u_div8  (.clk(clk), .rst_n(rst_n),
                                    .rising_pulse(rp), .clk_out(out8));

   // Division par 32 (20 MHz → 625 kHz)
   freq_divider #(.N(32)) u_div32 (.clk(clk), .rst_n(rst_n),
                                    .rising_pulse(rp), .clk_out(out32));

.. note::

   ``$clog2(N)`` est une fonction système Verilog-2005 qui calcule
   $\lceil \log_2 N \rceil$ à la compilation. Vivado la supporte nativement.
   Pour $N = 16$, $\lceil \log_2 16 \rceil = 4$, donc le compteur sera un
   registre 4 bits ``[3:0]``.

.. seealso::

   :doc:`09_top_module` pour l'assemblage de tous les modules dans le
   top-level de la Nexys 4 DDR.
