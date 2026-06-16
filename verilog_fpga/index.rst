.. _verilog_fpga:

Implémentation FPGA en Verilog
==============================

Ce chapitre présente une initiation au langage Verilog dans le contexte de
la carte **Nexys 4 DDR** (Xilinx Artix-7). L'objectif fil conducteur est la
réalisation d'un **diviseur de fréquence** piloté par un signal d'entrée
**analogique** : le signal est numérisé par le bloc XADC, chaque front montant
est détecté, et le compteur diviseur divise la fréquence résultante par 16 pour
passer de 20 MHz à 1,25 MHz.

Les ressources suivantes ont été utilisées pour la rédaction de cette partie :

* `Getting Started with Xilinx Vivado and the Nexys 4 – Digilent Blog <https://digilent.com/blog/getting-started-with-xilinx-vivado-and-the-nexys-4/>`_
* `Getting Started With Xilinx Vivado W/ Digilent Nexys 4 FPGA – Instructables <https://www.instructables.com/Simple-Logic-Design-w-Digilent-Nexys-4-Field-Progr/>`_
* `Vivado Overview – AMD <https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html>`_
* `Nexys4 Reference Manual (PDF) <https://www.cs.unc.edu/~montek/teaching/Comp541-Fall16/Lab/Nexys4.pdf>`_
* `XADC User Guide UG480 – 7 Series FPGAs (PDF) <https://www.physics.umd.edu/hep/drew/495/ug480_7Series_XADC.pdf>`_
* `Programmable Logic Tutorials – Digilent Reference <https://digilent.com/reference/learn/programmable-logic/tutorials/start>`_
* `Getting Started with Vivado – Digilent Reference <https://digilent.com/reference/vivado/getting_started/start>`_
* `Nexys 4 DDR Programming Guide – Digilent Reference <https://digilent.com/reference/learn/programmable-logic/tutorials/nexys-4-ddr-programming-guide/start>`_
* `Counter and Clock Divider – Digilent Reference <https://digilent.com/reference/learn/programmable-logic/tutorials/counter-and-clock-divider/start>`_
* `Use Flip-flops to Build a Clock Divider – Digilent Reference <https://digilent.com/reference/learn/programmable-logic/tutorials/use-flip-flops-to-build-a-clock-divider/start>`_
* `GitHub – Digilent/digilent-xdc (Master XDC files) <https://github.com/Digilent/digilent-xdc/tree/master>`_
* `Getting Started with FPGA – Digilent Reference <https://digilent.com/reference/learn/programmable-logic/tutorials/getting-started-with-fpga/start>`_
* `ELEC 4200 Digital System Design – Auburn University <https://www.eng.auburn.edu/~nelsovp/courses/elec4200/elec4200.html>`_

.. toctree::
   :maxdepth: 2
   :caption: Contents:
   :hidden:

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
