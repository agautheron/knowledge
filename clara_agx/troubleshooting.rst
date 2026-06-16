.. _clara-agx-troubleshooting:

Dépannage
=========

La Clara AGX n'est pas détectée par SDK Manager
-------------------------------------------------

**Symptôme** : SDK Manager affiche "No target hardware detected" ou la liste des cibles est vide.

**Causes possibles et solutions** :

1. **La Clara AGX n'est pas en mode recovery**

   Recommencer la procédure de mise en mode recovery :
   maintenir Recovery → appuyer Reset → relâcher Recovery.
   Vérifier avec ``lsusb | grep -i nvidia``.

2. **Le périphérique USB n'est pas attaché à la VM**

   Dans VirtualBox → *Périphériques → USB* → cocher **NVIDIA Corp. APX**.

3. **Contrôleur USB 2.0 au lieu de USB 3.0**

   Aller dans *Configuration VM → USB* et s'assurer que **USB 3.0 (xHCI)** est activé
   (nécessite l'Extension Pack VirtualBox).

4. **Câble USB branché sur le mauvais port**

   Le port de flash est le **port USB-C frontal**.
   Le port arrière sert uniquement à l'alimentation.

La dGPU (RTX 6000) n'est pas détectée après le flash
------------------------------------------------------

**Symptôme** : ``nvidia-smi`` échoue, ``lspci`` ne montre pas de VGA device ou bridge Mellanox.

.. code-block:: bash

   # Vérifier si le bridge PCIe est visible
   lspci | grep -i "mellanox\|vga\|nvidia"

**Solution** : Il s'agit d'un bug connu intermittent sur la Clara AGX après un flash.

.. code-block:: bash

   # Redémarrer jusqu'à 3–5 fois si nécessaire
   sudo reboot

   # Après chaque reboot, vérifier
   lspci | grep -i nvidia
   nvidia-smi

Si le problème persiste, mettre à jour le firmware de la RTX 6000 :

.. code-block:: bash

   # Télécharger et appliquer le firmware update
   # (se référer au Clara AGX User Guide officiel, section "Update Firmware")
   sudo /opt/nvidia/firmware/update_firmware.sh

Le flash échoue en cours de route
-----------------------------------

**Symptôme** : SDK Manager affiche une erreur pendant le flash, exemple :
``Error: Cannot communicate with device`` ou ``Flash failed``.

**Solutions** :

- Vérifier que le câble USB est bien connecté et stable
- Relancer SDK Manager → Step 01 → *Repair/Uninstall* pour nettoyer une install partielle
- Remettre la Clara AGX en mode recovery et relancer le flash depuis le début
- Utiliser un câble USB différent (les câbles trop longs ou de mauvaise qualité causent des erreurs)

Erreur lors de l'installation des SDK via SSH
----------------------------------------------

**Symptôme** : L'installation des composants SDK (CUDA, TensorRT) échoue avec une erreur SSH.

**Solutions** :

- S'assurer que la Clara AGX et la VM sont sur le **même réseau** (configurer la VM en mode Pont/Bridge dans VirtualBox → *Réseau*)
- Vérifier que SSH est actif sur la Clara AGX :

  .. code-block:: bash

     # Sur la Clara AGX
     sudo systemctl status ssh

- Vérifier l'IP renseignée dans SDK Manager correspond bien à celle de la Clara AGX

Erreur CUDA après installation
--------------------------------

**Symptôme** : ``nvcc --version`` ou une application CUDA échoue.

.. code-block:: bash

   # Vérifier que CUDA est dans le PATH
   echo $PATH | grep cuda

   # Ajouter CUDA au PATH si absent
   echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
   echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
   source ~/.bashrc

   nvcc --version

Ressources utiles
-----------------

- `NVIDIA Clara AGX User Guide (GitHub Holoscan) <https://github.com/nvidia-holoscan/holoscan-docs/blob/main/devkits/clara-agx/clara_agx_user_guide.md>`_
- `NVIDIA SDK Manager Documentation <https://docs.nvidia.com/sdk-manager/>`_
- `Forum NVIDIA Holoscan SDK <https://forums.developer.nvidia.com/c/healthcare/holoscan-sdk/320>`_
- `JetPack Archive <https://developer.nvidia.com/embedded/jetpack-archive>`_
