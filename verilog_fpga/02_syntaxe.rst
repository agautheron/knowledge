.. _verilog_syntaxe:

Syntaxe de base
===============

.. contents:: Sommaire
   :local:
   :depth: 2

Le module
---------

Le **module** est la brique fondamentale de tout design Verilog. Il correspond
à un composant électronique avec des ports d'entrée/sortie.

.. code-block:: verilog
   :caption: Squelette d'un module Verilog

   // Déclaration du module — style Verilog-2001 (recommandé)
   module nom_module #(
       parameter TAILLE = 8          // paramètre de configuration
   ) (
       input  wire        clk,       // entrée horloge
       input  wire        rst_n,     // reset asynchrone actif bas
       input  wire [7:0]  data_in,   // bus 8 bits en entrée
       output reg  [7:0]  data_out   // registre 8 bits en sortie
   );

       // ── Corps du module ──────────────────────────────────────
       // déclarations internes, blocs always, assign…

   endmodule

Types de données
-----------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - Type
     - Description
     - Usage typique
   * - ``wire``
     - Connexion continue — sans mémoire. Doit être piloté en permanence.
     - Logique combinatoire, sorties d'``assign``, entrées de module
   * - ``reg``
     - Registre — mémorise la dernière valeur affectée dans un ``always``.
     - Sorties de blocs ``always``, compteurs, bascules D
   * - ``integer``
     - Entier 32 bits signé — non synthétisable en général.
     - Variables de boucle en simulation, paramètres de test
   * - ``parameter``
     - Constante évaluée à la compilation.
     - Rapports de division, largeurs de bus, seuils configurables

.. warning::

   ``reg`` ne signifie pas nécessairement "registre physique". Si un ``reg``
   est affecté dans un bloc ``always @(*)``, Vivado le synthétise comme
   de la logique combinatoire (sans bascule).

Représentation des constantes
-------------------------------

La notation ``taille'base valeur`` est universelle en Verilog :

.. code-block:: verilog

   4'b1010    // 4 bits, binaire  → valeur décimale 10
   8'hFF      // 8 bits, hexa     → 255
   16'd1000   // 16 bits, décimal → 1000
   1'b0       // 1 bit            → 0 (faux)
   1'b1       // 1 bit            → 1 (vrai)
   12'h800    // 12 bits, hexa    → 2048 (= 50 % pleine échelle ADC)

Affectations : bloquante vs non-bloquante
------------------------------------------

C'est l'une des règles les plus importantes de Verilog synthétisable :

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Opérateur
     - Comportement
     - Utilisation
   * - ``=`` (bloquante)
     - L'affectation prend effet **immédiatement** dans le bloc.
     - Dans ``always @(*)``, logique combinatoire uniquement
   * - ``<=`` (non-bloquante)
     - Toutes les évaluations se font d'abord, puis les affectations s'appliquent simultanément à la fin du pas de simulation.
     - Dans ``always @(posedge clk)``, logique séquentielle

.. danger::

   Ne jamais mélanger ``=`` et ``<=`` dans le même bloc ``always``.
   Ce mélange produit un comportement indéfini et des erreurs de synthèse.

   .. tab:: Correct ✓

      .. code-block:: verilog

         // Bloc séquentiel : tout en non-bloquant
         always @(posedge clk) begin
             a <= b;
             c <= a;  // c reçoit l'ANCIENNE valeur de a (pipeline)
         end

   .. tab:: Incorrect ✗

      .. code-block:: verilog

         // Mélange interdit
         always @(posedge clk) begin
             a <= b;
             c = a;   // comportement indéfini !
         end

Opérateurs courants
--------------------

.. code-block:: verilog

   // Logique bit à bit
   assign s = a & b;     // ET
   assign s = a | b;     // OU
   assign s = a ^ b;     // OU-exclusif
   assign s = ~a;        // NON (bit à bit)

   // Réduction (1 bit résultat)
   assign s = &a;        // ET de tous les bits de a
   assign s = |a;        // OU de tous les bits de a

   // Arithmétique
   assign s = a + b;     // addition (débordement silencieux)
   assign s = a - b;     // soustraction

   // Comparaison (résultat 1 bit)
   assign s = (a == b);  // égalité
   assign s = (a >= b);  // supérieur ou égal

   // Concaténation et répétition
   assign s = {a, b};        // concaténation : {a[3:0], b[3:0]} → 8 bits
   assign s = {4{1'b0}};     // répétition    : 0000

   // Opérateur ternaire (mux)
   assign s = sel ? a : b;   // si sel=1 alors a, sinon b

   // Fonction de taille automatique
   reg [$clog2(16)-1:0] cnt; // $clog2(16)=4 → reg [3:0] cnt

.. seealso::

   :doc:`03_logique_combinatoire` et :doc:`04_logique_sequentielle` pour
   les blocs ``always`` dans leur contexte d'utilisation.
