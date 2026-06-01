.. _verilog_fpga:

Implémentation FPGA en Verilog
==============================

Ce chapitre présente une initiation au langage Verilog dans le contexte de
la carte **Nexys 4 DDR** (Xilinx Artix-7). L'objectif fil conducteur est la
réalisation d'un **diviseur de fréquence** piloté par un signal d'entrée
**analogique** : le signal est numérisé par le bloc XADC, chaque front montant
est détecté, et le compteur diviseur divise la fréquence résultante par 16 pour
passer de 20 MHz à 1,25 MHz.

.. toctree::
   :maxdepth: 2
   :numbered:

   01_introduction
   02_syntaxe
   03_logique_combinatoire
   04_logique_sequentielle
   05_xadc_analogique
   06_comparateur
   07_edge_detector
   08_diviseur
   09_top_module
   10_contraintes_xdc
   11_testbench
   12_restructuration_depot
