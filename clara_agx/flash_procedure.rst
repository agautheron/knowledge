.. _clara-agx-flash:

Procédure de Flash (SDK Manager)
=================================

Cette procédure décrit le flash complet de la Clara AGX depuis une VM Ubuntu sous VirtualBox sur Windows.

Durée estimée : **45 à 90 minutes** selon la connexion réseau et les composants SDK sélectionnés.

Étape 1 — Lancer SDK Manager
------------------------------

Dans la VM Ubuntu :

.. code-block:: bash

   sdkmanager

Se connecter avec le compte NVIDIA Developer si demandé.

Étape 2 — Sélectionner la cible (Step 01)
-------------------------------------------

Dans SDK Manager, panneau **Step 01 — Development Environment** :

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Champ
     - Valeur à sélectionner
   * - Product Category
     - **Holoscan** (ou Clara Holoscan)
   * - Hardware Configuration — Host Machine
     - ``Linux``
   * - Hardware Configuration — Target Hardware
     - **Clara AGX Developer Kit**
   * - Target Operating System
     - Ubuntu 20.04 + Holopack (choisir la version souhaitée)

.. note::

   Ne pas sélectionner de cible Jetson standard (Jetson AGX Xavier, etc.) —
   la Clara AGX a son propre BSP et son propre Holopack.

Cliquer sur **Continue**.

Étape 3 — Sélectionner les composants (Step 02)
-------------------------------------------------

SDK Manager propose plusieurs groupes de composants :

- **Jetson Linux (L4T)** — Obligatoire (OS + BSP)
- **Jetson SDK Components** — CUDA, cuDNN, TensorRT (recommandé)
- **Clara Holoscan SDK** — Librairies Holoscan, DeepStream, Rivermax (selon besoin)

Cocher au minimum **Jetson Linux** pour un flash OS complet.

Accepter les termes de licence puis cliquer **Continue**.

Étape 4 — Flash de l'OS (Step 03)
------------------------------------

SDK Manager demande la méthode de connexion à la Clara AGX :

- Sélectionner **USB**
- Vérifier que la Clara AGX est bien en mode recovery (voir :ref:`clara-agx-recovery-mode`)
- Cliquer sur **Flash**

Le flash de l'OS dure environ **20–30 minutes**. La progression s'affiche dans SDK Manager.

.. warning::

   Ne pas débrancher le câble USB ni éteindre la VM pendant le flash.
   Une interruption peut nécessiter un recovery hardware (clignoteur JTAG).

Étape 5 — Premier démarrage et installation SDK
-------------------------------------------------

Après le flash de l'OS, la Clara AGX redémarre automatiquement sur Ubuntu.

SDK Manager propose ensuite d'installer les composants SDK (CUDA, TensorRT, etc.) via SSH :

1. La Clara AGX doit être connectée au **réseau local** (câble Ethernet ou via le réseau de la VM)
2. Renseigner l'IP de la Clara AGX, le nom d'utilisateur et mot de passe créés lors du flash
3. Cliquer **Install** — durée estimée : 20–40 minutes supplémentaires

.. tip::

   Pour trouver l'IP de la Clara AGX après le premier boot :

   .. code-block:: bash

      # Sur la Clara AGX (accès local via clavier/écran ou UART)
      ip addr show eth0

Étape 6 — Vérification post-flash
------------------------------------

Sur la Clara AGX, vérifier la version installée :

.. code-block:: bash

   # Version L4T
   cat /etc/nv_tegra_release

   # Version des paquets NVIDIA
   dpkg -s nvidia-l4t-core | grep Version

   # Vérifier que la dGPU (RTX 6000) est détectée
   nvidia-smi

   # Vérifier le mode GPU (iGPU / dGPU)
   sudo nvpmodel -q

Résultat attendu après flash Holopack 0.4 (L4T R32.7.x) :

.. code-block:: text

   # R32 (release), REVISION: 7.6, GCID: XXXXXXXX, BOARD: t186ref, EABI: aarch64

Basculer en mode dGPU (si nécessaire)
---------------------------------------

Par défaut après un flash, la Clara AGX démarre en mode **iGPU** (Jetson Xavier intégré).
Pour activer la RTX 6000 :

.. code-block:: bash

   # Lister les modes disponibles
   sudo nvpmodel -q --verbose

   # Basculer en mode dGPU (mode 8 en général sur Clara AGX)
   sudo nvpmodel -m 8
   sudo reboot

   # Après reboot, vérifier
   nvidia-smi
   # Doit afficher la RTX 6000

.. note::

   Un bug connu peut empêcher la dGPU d'être détectée après le premier reboot post-flash.
   Si ``nvidia-smi`` échoue ou si ``lspci`` ne montre pas la RTX 6000,
   redémarrer plusieurs fois jusqu'à ce que le bridge PCIe remonte.
   Voir :ref:`clara-agx-troubleshooting`.
