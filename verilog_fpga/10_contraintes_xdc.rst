.. _verilog_xdc:

Fichier de contraintes XDC
===========================

.. contents:: Sommaire
   :local:
   :depth: 2

Rôle du fichier XDC
--------------------

Le fichier **XDC** (*Xilinx Design Constraints*) remplit deux fonctions :

1. **Placement physique** : associe chaque port du top-module à une broche
   physique précise du boîtier FPGA.
2. **Contraintes de timing** : déclare les horloges, les faux chemins et les
   exigences de setup/hold.

.. warning::

   Les broches analogiques du XADC (VP, VN) ne doivent **pas** porter de
   directive ``set_property IOSTANDARD``. Laisser ces lignes absentes ou
   commenter — ajouter un ``IOSTANDARD`` provoque une erreur de DRC
   (Design Rule Check) dans Vivado.

Fichier complet
----------------

.. code-block:: tcl
   :caption: nexys4_ddr.xdc

   ## ── Horloge système 100 MHz ──────────────────────────────────
   set_property PACKAGE_PIN E3       [get_ports clk_100mhz]
   set_property IOSTANDARD  LVCMOS33 [get_ports clk_100mhz]
   create_clock -add -name sys_clk_pin \
                -period 10.00 -waveform {0 5} \
                [get_ports clk_100mhz]

   ## ── Reset (BTNC) ─────────────────────────────────────────────
   set_property PACKAGE_PIN N17      [get_ports rst_btn]
   set_property IOSTANDARD  LVCMOS33 [get_ports rst_btn]

   ## ── Entrées analogiques XADC (JXADC) ────────────────────────
   ## IMPORTANT : PAS de IOSTANDARD pour les broches analogiques
   set_property PACKAGE_PIN A13      [get_ports vp_in]
   set_property PACKAGE_PIN A14      [get_ports vn_in]

   ## ── Sortie divisée → PMOD JA broche 1 (JA[0]) ───────────────
   set_property PACKAGE_PIN C17      [get_ports clk_out_1m25]
   set_property IOSTANDARD  LVCMOS33 [get_ports clk_out_1m25]

   ## ── LED debug : pulse de front montant ───────────────────────
   set_property PACKAGE_PIN H17      [get_ports led_pulse]
   set_property IOSTANDARD  LVCMOS33 [get_ports led_pulse]

   ## ── LEDs 12 bits ADC ─────────────────────────────────────────
   set_property PACKAGE_PIN H17      [get_ports {led[0]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[0]}]
   set_property PACKAGE_PIN K15      [get_ports {led[1]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[1]}]
   set_property PACKAGE_PIN J13      [get_ports {led[2]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[2]}]
   set_property PACKAGE_PIN N14      [get_ports {led[3]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[3]}]
   set_property PACKAGE_PIN R18      [get_ports {led[4]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[4]}]
   set_property PACKAGE_PIN V17      [get_ports {led[5]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[5]}]
   set_property PACKAGE_PIN U17      [get_ports {led[6]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[6]}]
   set_property PACKAGE_PIN U16      [get_ports {led[7]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[7]}]
   set_property PACKAGE_PIN V16      [get_ports {led[8]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[8]}]
   set_property PACKAGE_PIN T15      [get_ports {led[9]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[9]}]
   set_property PACKAGE_PIN U14      [get_ports {led[10]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[10]}]
   set_property PACKAGE_PIN T16      [get_ports {led[11]}]
   set_property IOSTANDARD  LVCMOS33 [get_ports {led[11]}]

   ## ── Contrainte de timing : clk_out n'est pas une vraie horloge ─
   ## La sortie est un signal ordinaire, pas une horloge propagée
   set_false_path -to [get_ports clk_out_1m25]

Explication des directives
---------------------------

``create_clock``
   Déclare l'horloge principale à 100 MHz avec une période de 10 ns et un
   rapport cyclique 50 % (montée à 0 ns, descente à 5 ns). Vivado utilise
   cette information pour vérifier que tous les chemins de données sont
   parcourus en moins de 10 ns.

``set_false_path -to [get_ports clk_out_1m25]``
   Indique à Vivado que la sortie ``clk_out_1m25`` n'est **pas** soumise
   à une contrainte de timing stricte. Sans cela, Vivado tenterait de
   vérifier que le signal arrive sur la broche de sortie en moins d'une
   période d'horloge, ce qui n'a pas de sens pour un signal de données
   synchrones sortant vers l'extérieur sans récepteur déclaré.

.. seealso::

   :doc:`11_testbench` pour la simulation avant de programmer la carte.
