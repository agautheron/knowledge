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

* [Getting Started with Xilinx Vivado and the Nexys 4 – Digilent Blog](https://digilent.com/blog/getting-started-with-xilinx-vivado-and-the-nexys-4/?srsltid=AfmBOoq3yKKUlyDI0bvfFd-vBtD9PM7fEhgRVKKk9eES3Zd2n-2UDrlW "Getting Started with Xilinx Vivado and the Nexys 4 – Digilent Blog")
* [Getting Started With Xilinx Vivado W\/ Digilent Nexys 4 FPGA 1 \- Build Multiple Inputs AND Logic Gate \: 17 Steps \- Instructables](https://www.instructables.com/Simple-Logic-Design-w-Digilent-Nexys-4-Field-Progr/ "Getting Started With Xilinx Vivado W/ Digilent Nexys 4 FPGA 1 - Build Multiple Inputs AND Logic Gate : 17 Steps - Instructables")
* [Vivado Overview](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html "Vivado Overview")
* [Nexys4\.pdf](https://www.cs.unc.edu/~montek/teaching/Comp541-Fall16/Lab/Nexys4.pdf "Nexys4.pdf")
* [7 Series FPGAs and Zynq\-7000 All Programmable SoC XADC Dual 12\-Bit 1 MSPS Analog\-to\-Digital Converter User Guide \(UG480\) \- ug480\_7Series\_XADC\.pdf](https://www.physics.umd.edu/hep/drew/495/ug480_7Series_XADC.pdf "7 Series FPGAs and Zynq-7000 All Programmable SoC XADC Dual 12-Bit 1 MSPS Analog-to-Digital Converter User Guide \(UG480\) - ug480_7Series_XADC.pdf")
* [nexys 4 vivado \- Recherche Google](https://www.google.com/search?q=nexys4+vivado&client=firefox-b-e&hs=fDLV&sca_esv=9a26454b369da4f9&channel=entpr&sxsrf=ANbL-n7lalw3w0OzRH1fi4WkrZusxCLilA%3A1780476147444&ei=8-gfasbkGraD9u8PgqrN4Ac&biw=1054&bih=1065&ved=0ahUKEwiGqrLC1uqUAxW2gf0HHQJVE3wQ4dUDCBA&uact=5&oq=nexys4+vivado&gs_lp=Egxnd3Mtd2l6LXNlcnAiDW5leHlzNCB2aXZhZG8yBhAAGBYYHjIIEAAYCBgeGA0yBRAAGO8FMggQABiABBiiBDIFEAAY7wUyBRAAGO8FMgUQABjvBUiQD1DjBljPDHACeAGQAQGYAbwBoAHEBaoBAzQuMrgBA8gBAPgBAZgCB6ACqATCAgoQABhHGNYEGLADwgIIEAAYFhgeGArCAgoQABgIGB4YDRgKmAMAiAYBkAYCkgcDNi4xoAeRG7IHAzQuMbgHoATCBwUwLjUuMsgHEYAIAQ&sclient=gws-wiz-serp "nexys 4 vivado - Recherche Google")
* [Programmable Logic Tutorials \- Digilent Reference](https://digilent.com/reference/learn/programmable-logic/tutorials/start "Programmable Logic Tutorials - Digilent Reference")
* [Getting Started with Vivado \- Digilent Reference](https://digilent.com/reference/vivado/getting_started/start "Getting Started with Vivado - Digilent Reference")
* [Nexys 4 DDR Programming Guide \- Digilent Reference](https://digilent.com/reference/learn/programmable-logic/tutorials/nexys-4-ddr-programming-guide/start "Nexys 4 DDR Programming Guide - Digilent Reference")
* [Getting Started with Vivado \- Digilent Reference](https://digilent.com/reference/vivado/getting_started/2018.2 "Getting Started with Vivado - Digilent Reference")
* [Counter and Clock Divider \- Digilent Reference](https://digilent.com/reference/learn/programmable-logic/tutorials/counter-and-clock-divider/start "Counter and Clock Divider - Digilent Reference")
* [GitHub \- Digilent\/digilent\-xdc\: A collection of Master XDC files for Digilent FPGA and Zynq boards\. · GitHub](https://github.com/Digilent/digilent-xdc/tree/master "GitHub - Digilent/digilent-xdc: A collection of Master XDC files for Digilent FPGA and Zynq boards. · GitHub")
* [Getting Started with FPGA \- Digilent Reference](https://digilent.com/reference/learn/programmable-logic/tutorials/getting-started-with-fpga/start "Getting Started with FPGA - Digilent Reference")
* [Use Flip\-flops to Build a Clock Divider \- Digilent Reference](https://digilent.com/reference/learn/programmable-logic/tutorials/use-flip-flops-to-build-a-clock-divider/start "Use Flip-flops to Build a Clock Divider - Digilent Reference")
* [Counter and Clock Divider \- Digilent Reference](https://digilent.com/reference/learn/programmable-logic/tutorials/counter-and-clock-divider/start "Counter and Clock Divider - Digilent Reference")
* [ELEC 4200 Digital System Design](https://www.eng.auburn.edu/~nelsovp/courses/elec4200/elec4200.html "ELEC 4200 Digital System Design")

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
