.. _verilog_top:

Module top — intégration
========================

.. contents:: Sommaire
   :local:
   :depth: 2

Le module ``top_nexys4`` assemble les quatre sous-modules en une hiérarchie
complète et présente les ports physiques de la carte.

Hiérarchie des instances
-------------------------

.. code-block:: text

   top_nexys4
   ├── u_xadc  : xadc_wrapper     (VP/VN → adc_val[11:0], adc_valid)
   ├── u_cmp   : comparator       (adc_val → sig_bin)
   ├── u_edge  : edge_detector    (sig_bin → rising_pulse)
   └── u_div   : freq_divider     (rising_pulse → clk_out_1m25)

Module complet
--------------

.. code-block:: verilog
   :caption: top_nexys4.v

   `timescale 1ns/1ps

   module top_nexys4 (
       input  wire        clk_100mhz,   // horloge 100 MHz (E3)
       input  wire        rst_btn,      // BTNC — reset (actif haut sur carte)
       input  wire        vp_in,        // JXADC pin 1 — VP
       input  wire        vn_in,        // JXADC pin 7 — VN
       output wire        clk_out_1m25, // sortie 1,25 MHz (JA[0])
       output wire [11:0] led,          // valeur ADC → 12 LEDs
       output wire        led_pulse     // LED debug : clignote sur chaque front
   );

       // ── Signaux internes ─────────────────────────────────────
       wire        rst_n;
       wire [11:0] adc_val;
       wire        adc_valid;
       wire        sig_bin;
       wire        rising_pulse;
       wire        clk_div;

       // Le bouton BTNC est actif haut sur la Nexys 4 DDR
       assign rst_n = ~rst_btn;

       // ── 1. Acquisition analogique ────────────────────────────
       xadc_wrapper u_xadc (
           .clk      (clk_100mhz),
           .rst      (rst_btn),
           .vp_in    (vp_in),
           .vn_in    (vn_in),
           .adc_val  (adc_val),
           .adc_valid(adc_valid)
       );

       // ── 2. Comparateur — 12 bits → 1 bit ─────────────────────
       comparator #(
           .THRESHOLD(12'h800),
           .HYST     (12'd50)
       ) u_cmp (
           .clk      (clk_100mhz),
           .adc_val  (adc_val),
           .adc_valid(adc_valid),
           .sig_bin  (sig_bin)
       );

       // ── 3. Détection de front montant ─────────────────────────
       edge_detector u_edge (
           .clk         (clk_100mhz),
           .rst_n       (rst_n),
           .sig_in      (sig_bin),
           .rising_edge (rising_pulse),
           .falling_edge()              // non utilisé
       );

       // ── 4. Diviseur ÷ 16 ─────────────────────────────────────
       freq_divider #(.N(16)) u_div (
           .clk          (clk_100mhz),
           .rst_n        (rst_n),
           .rising_pulse (rising_pulse),
           .clk_out      (clk_div)
       );

       // ── Sorties ──────────────────────────────────────────────
       assign clk_out_1m25 = clk_div;
       assign led          = adc_val;       // affichage brut ADC sur LEDs
       assign led_pulse    = rising_pulse;  // debug : clignote à ~1 MHz

   endmodule

Tableau de synthèse des signaux
---------------------------------

.. list-table::
   :header-rows: 1
   :widths: 25 15 20 40

   * - Signal
     - Freq. / type
     - Direction
     - Description
   * - ``clk_100mhz``
     - 100 MHz
     - Entrée
     - Horloge système, oscillateur Nexys 4
   * - ``rst_btn``
     - Statique
     - Entrée
     - Bouton BTNC, actif haut
   * - ``vp_in`` / ``vn_in``
     - Analogique
     - Entrée
     - Signal différentiel XADC (JXADC)
   * - ``adc_val``
     - ~1 Msps
     - Interne
     - Valeur 12 bits issue du XADC
   * - ``sig_bin``
     - ~1 MHz eff.
     - Interne
     - Résultat du comparateur (1 bit)
   * - ``rising_pulse``
     - ~1 MHz eff.
     - Interne
     - Enable : 1 cycle par front montant
   * - ``clk_out_1m25``
     - ~62,5 kHz*
     - Sortie
     - Signal divisé (PMOD JA[0])
   * - ``led[11:0]``
     - ~1 Msps
     - Sortie
     - Affichage valeur ADC (12 LEDs)

\* Fréquence effective limitée par le XADC (voir :doc:`05_xadc_analogique`).
Pour 20 MHz avec comparateur externe, la sortie serait 1,25 MHz.
