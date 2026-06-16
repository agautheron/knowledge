.. _clara-agx-prerequisites:

Prérequis
=========

Hôte Windows
------------

La procédure décrite ici utilise **Windows + VirtualBox + Ubuntu** pour contourner l'absence
de machine Ubuntu native.

Logiciels à installer sur Windows :

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Logiciel
     - Lien
   * - VirtualBox ≥ 7.0
     - https://www.virtualbox.org/wiki/Downloads
   * - VirtualBox Extension Pack
     - Même page (requis pour USB 3.0)
   * - Ubuntu 20.04 ISO
     - https://releases.ubuntu.com/20.04/

.. warning::

   L'**Extension Pack** est indispensable pour le passthrough USB 3.0.
   Sans lui, la Clara AGX en mode recovery ne sera pas détectée par la VM.

Compte NVIDIA Developer
-----------------------

Un compte NVIDIA Developer est requis pour télécharger et utiliser SDK Manager.

Créer un compte sur https://developer.nvidia.com (gratuit).

Matériel nécessaire
-------------------

- Câble **USB-C → USB-A** (ou USB-C → USB-C selon votre hôte) pour le port **frontal** de la Clara AGX
- La Clara AGX doit être **alimentée** (câble power au port arrière)
- Accès physique aux boutons **Recovery** et **Reset** (panneau arrière)

.. figure:: _images/clara_agx_buttons.png
   :alt: Boutons Recovery et Reset de la Clara AGX
   :align: center

   *Panneau arrière de la Clara AGX — bouton Recovery (milieu) et Reset (droite)*

   *(Image optionnelle — à ajouter si disponible)*

Espace disque
-------------

SDK Manager télécharge l'image complète de Holopack :

- Image L4T : ~3–5 Go
- SDK complets (CUDA, TensorRT, etc.) : ~10–15 Go supplémentaires

Prévoir **au minimum 30 Go libres** dans la VM Ubuntu.
