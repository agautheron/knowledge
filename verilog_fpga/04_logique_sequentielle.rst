.. _verilog_sequentiel:

Logique séquentielle
====================

.. contents:: Sommaire
   :local:
   :depth: 2

La logique séquentielle introduit une **mémoire d'état** : la sortie dépend
non seulement des entrées actuelles, mais aussi de l'historique. L'élément
de base est la **bascule D** (*flip-flop D*).

La bascule D
------------

Une bascule D capture la valeur de son entrée ``d`` sur le **front montant**
de l'horloge et la présente sur sa sortie ``q`` jusqu'au prochain front.

.. code-block:: verilog
   :caption: bascule_d.v — bascule D avec reset asynchrone actif bas

   module bascule_d (
       input  wire clk,    // horloge
       input  wire rst_n,  // reset asynchrone actif bas
       input  wire d,      // donnée
       output reg  q       // sortie mémorisée
   );
       always @(posedge clk or negedge rst_n) begin
           if (!rst_n)  q <= 1'b0;   // reset : remise à zéro immédiate
           else         q <= d;       // capture sur front montant
       end
   endmodule

.. list-table:: Reset synchrone vs asynchrone
   :header-rows: 1
   :widths: 25 37 38

   * - Type de reset
     - Déclenchement
     - Syntaxe Verilog
   * - **Asynchrone** (recommandé Xilinx)
     - Dès que ``rst_n`` passe bas, indépendamment de l'horloge
     - ``always @(posedge clk or negedge rst_n)``
   * - **Synchrone**
     - Seulement sur le prochain front montant de l'horloge
     - ``always @(posedge clk)`` + ``if (!rst_n)``

Compteur n bits
---------------

Un compteur est un registre auto-incrémenté. Avec $n$ bits, il compte de
$0$ à $2^n - 1$ puis déborde naturellement vers $0$.

.. code-block:: verilog
   :caption: compteur 4 bits (0 à 15, débordement automatique)

   module counter4 (
       input  wire       clk, rst_n,
       output reg  [3:0] count
   );
       always @(posedge clk or negedge rst_n) begin
           if (!rst_n) count <= 4'd0;
           else        count <= count + 1'b1;
       end
   endmodule

Le bit ``count[3]`` (MSB) vaut ``1`` pour les valeurs 8 à 15 et ``0``
pour les valeurs 0 à 7 — il bascule donc toutes les **8 périodes d'horloge**,
réalisant naturellement une division par 16 avec un rapport cyclique de 50 %.

Compteur avec remise à zéro conditionnelle
-------------------------------------------

Pour un rapport de division quelconque $N$, on remet le compteur à zéro
dès qu'il atteint $N/2 - 1$ (pour un signal symétrique) :

.. code-block:: verilog
   :caption: Principe du compteur à remise à zéro (extrait de freq_divider.v)

   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           count   <= 0;
           clk_out <= 1'b0;
       end
       else if (enable) begin           // n'avance que si enable actif
           if (count == (N/2) - 1) begin
               clk_out <= ~clk_out;     // inversion à mi-période
               count   <= 0;
           end
           else
               count <= count + 1'b1;
       end
   end

Double registre de synchronisation
------------------------------------

Lorsqu'un signal provient d'un domaine d'horloge différent (ou d'une logique
asynchrone comme notre comparateur ADC), il faut le **resynchroniser** pour
éviter la **métastabilité** — un état indéfini où la bascule ne sait pas si
elle doit basculer à 0 ou à 1.

La solution standard est le **double registre** (*two-FF synchronizer*) :

.. code-block:: verilog
   :caption: Synchroniseur à deux bascules

   reg sig_d1, sig_d2;

   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           sig_d1 <= 1'b0;
           sig_d2 <= 1'b0;
       end
       else begin
           sig_d1 <= sig_in;   // 1re bascule : peut être métastable
           sig_d2 <= sig_d1;   // 2e bascule : probabilité de métastabilité ≈ 0
       end
   end

Ce double registre est aussi le cœur du **détecteur de front montant**
décrit à la section suivante.

.. seealso::

   :doc:`07_edge_detector` pour l'utilisation concrète du double registre
   dans la détection de front montant du signal analogique numérisé.
