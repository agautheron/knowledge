.. _clara-agx-virtualbox:

Configuration VirtualBox
========================

Étape 1 — Installer VirtualBox et l'Extension Pack
---------------------------------------------------

1. Télécharger **VirtualBox** sur https://www.virtualbox.org/wiki/Downloads
2. Installer VirtualBox sur Windows
3. Télécharger l'**Extension Pack** (même version que VirtualBox)
4. Dans VirtualBox → *Fichier → Outils → Installer l'Extension Pack*

.. important::

   L'Extension Pack doit avoir exactement la **même version** que VirtualBox.

Étape 2 — Créer la VM Ubuntu 20.04
------------------------------------

1. Cliquer sur **Nouvelle** dans VirtualBox
2. Paramètres recommandés :

   .. list-table::
      :header-rows: 1
      :widths: 35 65

      * - Paramètre
        - Valeur recommandée
      * - Nom
        - ``Ubuntu-Clara-Flash``
      * - Type / Version
        - Linux / Ubuntu (64-bit)
      * - RAM
        - 4 Go minimum (8 Go recommandé)
      * - Disque dur
        - VDI, dynamique, **40 Go minimum**

3. Démarrer la VM avec l'ISO Ubuntu 20.04 et suivre l'installation standard

Étape 3 — Configurer le contrôleur USB 3.0
-------------------------------------------

.. warning::

   Cette étape est critique. Sans USB 3.0, SDK Manager ne détecte pas la Clara AGX.

La VM doit être **éteinte** pour modifier ces paramètres.

1. Sélectionner la VM → *Configuration → USB*
2. Activer le contrôleur **USB 3.0 (xHCI)**
3. Cliquer sur l'icône **+** (filtre USB) et ajouter le périphérique NVIDIA en mode recovery :

   .. code-block:: text

      Nom du fabricant : NVIDIA Corp.
      Nom du produit   : APX

   .. note::

      La Clara AGX doit être en mode recovery **avant** d'ajouter le filtre,
      pour qu'elle apparaisse dans la liste. Voir :ref:`clara-agx-recovery-mode`.

Étape 4 — Installer les Guest Additions
-----------------------------------------

Démarrer la VM, puis dans le menu VirtualBox :

.. code-block:: text

   Périphériques → Insérer l'image CD des Guest Additions

Dans le terminal Ubuntu de la VM :

.. code-block:: bash

   sudo apt update
   sudo apt install -y build-essential dkms linux-headers-$(uname -r)
   sudo mount /dev/cdrom /mnt
   sudo /mnt/VBoxLinuxAdditions.run
   sudo reboot

Étape 5 — Installer SDK Manager dans la VM
-------------------------------------------

Dans la VM Ubuntu :

.. code-block:: bash

   # Ajouter le dépôt NVIDIA
   wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
   sudo dpkg -i cuda-keyring_1.1-1_all.deb
   sudo apt-get update

   # Installer SDK Manager
   sudo apt-get install -y sdkmanager

   # Lancer SDK Manager
   sdkmanager

Se connecter avec son compte NVIDIA Developer quand demandé.

.. _clara-agx-recovery-mode:

Passer la Clara AGX en mode Recovery
--------------------------------------

Le mode recovery permet à SDK Manager de communiquer avec la carte pour la flasher.

1. Clara AGX **alimentée** (câble power branché au port arrière)
2. Brancher le câble USB entre le **port frontal USB-C** de la Clara AGX et le PC Windows
3. S'assurer que VirtualBox est lancé avec la VM Ubuntu démarrée
4. Sur la Clara AGX :

   a. Maintenir le bouton **Recovery** (bouton du milieu, panneau arrière)
   b. Appuyer brièvement sur **Reset** (bouton de droite) tout en maintenant Recovery
   c. Relâcher Recovery après ~2 secondes

5. Vérifier dans la VM que le périphérique est détecté :

   .. code-block:: bash

      lsusb | grep -i nvidia
      # Doit afficher : Bus XXX Device XXX: ID 0955:7020 NVIDIA Corp. APX

6. Si non détecté, aller dans VirtualBox → *Périphériques → USB* et cocher le périphérique NVIDIA APX

.. tip::

   Si ``lsusb`` ne montre rien, vérifier que le câble est branché sur le **port frontal** (pas le port arrière qui sert à l'alimentation).
