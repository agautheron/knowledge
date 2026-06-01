.. _verilog_intro:

Introduction à Verilog
======================

.. contents:: Sommaire
   :local:
   :depth: 2

Qu'est-ce que Verilog ?
-----------------------

Verilog est un **langage de description matérielle** (*Hardware Description
Language*, HDL) standardisé IEEE 1364. Il permet de modéliser et de synthétiser
des circuits numériques pour des cibles telles que les FPGA (*Field-Programmable
Gate Array*) ou les ASIC (*Application-Specific Integrated Circuit*).

.. important::

   Verilog décrit de l'**électronique**, pas un programme séquentiel.
   Tous les blocs ``always`` d'un module s'exécutent **en parallèle**,
   comme des portes logiques câblées simultanément.

   .. tab:: Verilog

      .. code-block:: verilog

         // Ces deux blocs always fonctionnent EN MÊME TEMPS
         always @(posedge clk) a <= b;
         always @(posedge clk) c <= d;

   .. tab:: C (analogie incorrecte)

      .. code-block:: c

         // En C, les instructions sont séquentielles — ce n'est PAS Verilog
         a = b;
         c = d;

Carte cible : Nexys 4 DDR
--------------------------

La **Nexys 4 DDR** est une carte de développement FPGA produite par Digilent,
équipée d'un FPGA Xilinx **Artix-7 XC7A100T**.

.. list-table:: Ressources principales de la Nexys 4 DDR
   :header-rows: 1
   :widths: 35 65

   * - Ressource
     - Valeur
   * - FPGA
     - Xilinx Artix-7 XC7A100T (csg324-1)
   * - Horloge principale
     - 100 MHz (broche E3)
   * - LEDs utilisateur
     - 16 (dont 12 utilisées ici pour afficher la valeur ADC)
   * - Boutons
     - 5 (BTNC = reset dans ce projet)
   * - Connecteurs PMOD
     - JA, JB, JC, JD (sortie 1,25 MHz sur JA[0])
   * - Convertisseur analogique
     - XADC intégré Artix-7, connecteur JXADC

Objectif du chapitre
---------------------

À partir d'un signal **analogique sinusoïdal à 20 MHz** injecté sur le connecteur
JXADC, on produit un signal numérique à **1,25 MHz** en quatre étapes :

.. code-block:: text

   Signal analogique (JXADC)
        │
        ▼  XADC — conversion 12 bits à ~1 Msps
        │
        ▼  Comparateur numérique — seuillage → signal binaire
        │
        ▼  Détecteur de front montant — pulse 1 cycle par front
        │
        ▼  Compteur diviseur ÷ 16 — 20 MHz → 1,25 MHz
        │
   Sortie 1,25 MHz (PMOD JA[0])

Le rapport de division est :

.. math::

   N = \frac{f_{\text{in}}}{f_{\text{out}}} = \frac{20\,\text{MHz}}{1{,}25\,\text{MHz}} = 16

Flux de développement Vivado
-----------------------------

Les étapes pour passer du code Verilog à un circuit physique sur la carte sont :

#. **Écriture des sources** ``.v`` — description du circuit en Verilog.
#. **Simulation** — vérification comportementale avec un testbench.
#. **Synthèse** — transformation du HDL en netlist de portes logiques.
#. **Implémentation** — placement et routage sur le FPGA cible.
#. **Génération du bitstream** — fichier de configuration ``.bit``.
#. **Programmation** — chargement du bitstream sur la carte via JTAG.

.. seealso::

   :doc:`10_contraintes_xdc` pour le fichier XDC associant les signaux
   Verilog aux broches physiques de la Nexys 4 DDR.
