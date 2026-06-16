.. _clara-agx-overview:

Vue d'ensemble
==============

Matériel
--------

La Clara AGX Developer Kit combine :

- **Jetson AGX Xavier** — module ARM embarqué (iGPU 512-core Volta, 8-core ARM v8.2)
- **NVIDIA RTX 6000** — GPU dédié (dGPU) pour le calcul intensif
- **Mellanox ConnectX-6** — SmartNIC 100 GbE pour les flux de données médicaux
- **Ubuntu 18.04 / 20.04** — système hôte (selon la version de Holopack)

Logiciels
---------

La Clara AGX utilise la pile logicielle **Holopack** (et non le JetPack standard Jetson) :

.. list-table::
   :header-rows: 1
   :widths: 25 25 25 25

   * - Holopack
     - L4T (R32/R35)
     - JetPack équivalent
     - Ubuntu
   * - 0.1
     - R32.4.x
     - 4.4
     - 18.04
   * - 0.2
     - R32.5.x
     - 4.5
     - 18.04
   * - 0.3 / 0.4
     - R32.6.x – R32.7.x
     - 4.6.x
     - 20.04
   * - 1.0 (Holoscan)
     - R35.x
     - 5.x
     - 20.04

Version actuelle (CREATIS)
--------------------------

Suite à la vérification effectuée en juin 2025 :

.. code-block:: text

   L4T   : R32, Revision 7.6
   Package : nvidia-l4t-core 32.7.6-20241104234601
   Kernel  : 4.9.337-tegra
   OS      : Ubuntu 20.04.6 LTS (focal)

Cela correspond à **JetPack 4.6.4 / Holopack 0.4** — la dernière version de la branche 4.x,
qui est aussi la **dernière version compatible** avec le matériel Xavier de la Clara AGX.

.. note::

   JetPack 6.x nécessite la génération **Orin** et n'est pas compatible avec la Clara AGX.
   La migration vers JetPack 5.x (L4T R35 / Holopack 1.0) est possible mais nécessite un reflash complet.
