.. _verilog_testbench:

Simulation et testbench
========================

.. contents:: Sommaire
   :local:
   :depth: 2

Principe du testbench
-----------------------

Un **testbench** est un module Verilog sans ports physiques, destiné
uniquement à la simulation. Il instancie le circuit à vérifier
(*Device Under Test*, DUT) et génère des stimuli.

.. code-block:: text

   ┌──────────────────────────────────────┐
   │  Testbench (tb_top.v)                │
   │                                      │
   │  clk_gen   ──────────────────────┐   │
   │  rst_seq   ──────────────────┐   │   │
   │  sig_sim   ─────────────┐    │   │   │
   │                         ▼    ▼   ▼   │
   │              ┌──────────────────────┐│
   │              │   DUT (top_nexys4)   ││
   │              └──────────────────────┘│
   │                         │            │
   │  monitor   ◄────────────┘            │
   └──────────────────────────────────────┘

Testbench complet
-----------------

.. code-block:: verilog
   :caption: tb_top.v

   `timescale 1ns/1ps

   module tb_top;

       // ── Paramètres de simulation ──────────────────────────────
       localparam CLK_PERIOD  = 10;   // 100 MHz → 10 ns
       localparam SIG_PERIOD  = 50;   // signal analogique simulé 20 MHz → 50 ns
       localparam N_DIV       = 16;   // rapport de division
       localparam EXPECTED_T  = SIG_PERIOD * N_DIV; // 800 ns attendus

       // ── Déclarations ──────────────────────────────────────────
       reg  clk_100mhz;
       reg  rst_btn;
       reg  sig_bin_sim;      // simule la sortie du comparateur
       wire rising_pulse;
       wire clk_out;

       // ── Horloge système 100 MHz ───────────────────────────────
       initial clk_100mhz = 1'b0;
       always  #(CLK_PERIOD/2) clk_100mhz = ~clk_100mhz;

       // ── Signal analogique simulé à 20 MHz ─────────────────────
       // (on court-circuite le XADC qui n'est pas simulable directement)
       initial sig_bin_sim = 1'b0;
       always  #(SIG_PERIOD/2) sig_bin_sim = ~sig_bin_sim;

       // ── Instanciation du détecteur de front (DUT partiel) ─────
       edge_detector u_edge (
           .clk         (clk_100mhz),
           .rst_n       (~rst_btn),
           .sig_in      (sig_bin_sim),
           .rising_edge (rising_pulse),
           .falling_edge()
       );

       // ── Instanciation du diviseur (DUT) ───────────────────────
       freq_divider #(.N(N_DIV)) u_div (
           .clk          (clk_100mhz),
           .rst_n        (~rst_btn),
           .rising_pulse (rising_pulse),
           .clk_out      (clk_out)
       );

       // ── Séquence de contrôle ──────────────────────────────────
       initial begin
           rst_btn = 1'b1;          // reset actif
           #50;
           rst_btn = 1'b0;          // relâcher le reset
           #20000;                  // simuler 20 µs
           $display("[INFO] Fin de simulation à %0t ns", $time);
           $finish;
       end

       // ── Vérification automatique de la période ─────────────────
       real t_rise1, t_rise2, measured_T;

       initial begin
           @(posedge (~rst_btn));       // attendre fin de reset
           @(posedge clk_out);          // ignorer le 1er front (init)
           @(posedge clk_out); t_rise1 = $realtime;
           @(posedge clk_out); t_rise2 = $realtime;
           measured_T = t_rise2 - t_rise1;

           $display("──────────────────────────────────────────");
           $display("Période mesurée : %0.1f ns", measured_T);
           $display("Période attendue: %0d ns", EXPECTED_T);
           if (measured_T == EXPECTED_T)
               $display("[PASS] Diviseur ÷%0d correct.", N_DIV);
           else
               $display("[FAIL] Période incorrecte !");
           $display("──────────────────────────────────────────");
       end

       // ── Dump VCD pour visualisation GTKWave ───────────────────
       initial begin
           $dumpfile("sim_div_freq.vcd");
           $dumpvars(0, tb_top);
       end

   endmodule

Lancer la simulation dans Vivado
----------------------------------

#. Ajouter ``tb_top.v`` via *Add Sources → Add simulation sources*.
#. Dans le *Flow Navigator* : **Run Simulation → Run Behavioral Simulation**.
#. Dans la fenêtre *Tcl Console*, vérifier les messages ``[PASS]``.
#. Dans la fenêtre *Waveform*, ajouter les signaux ``sig_bin_sim``,
   ``rising_pulse`` et ``clk_out`` pour visualiser le chronogramme.

Résultats attendus en simulation
----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Signal
     - Fréquence attendue
     - Période attendue
   * - ``sig_bin_sim`` (signal simulé)
     - 20 MHz
     - 50 ns
   * - ``rising_pulse``
     - 20 MHz (1 pulse/période)
     - 50 ns (durée : 10 ns)
   * - ``clk_out`` (sortie divisée)
     - 1,25 MHz
     - 800 ns

.. note::

   En simulation, le signal analogique est remplacé par un carré parfait.
   Sur carte réelle avec XADC, la fréquence effective sera plus basse
   (voir :doc:`05_xadc_analogique`).

.. seealso::

   :doc:`12_restructuration_depot` pour les recommandations d'organisation
   du dépôt Git contenant ces fichiers Verilog.
