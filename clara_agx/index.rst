.. _clara-agx:

NVIDIA Clara AGX
================

Documentation relative à la plateforme **NVIDIA Clara AGX Developer Kit** utilisée au laboratoire CREATIS.

La Clara AGX est basée sur le module **Jetson AGX Xavier** (iGPU) couplé à une GPU dédiée **RTX 6000**
et une carte réseau **ConnectX-6 100 GbE**. Elle est dédiée au prototypage de dispositifs médicaux
avec traitement d'image et IA temps réel.

.. warning::

   La Clara AGX n'est **pas** un dispositif médical homologué. Elle est réservée au développement.
   Le flashing via SDK Manager est **obligatoire** — les mises à jour APT standard Jetson ne sont pas compatibles.

.. toctree::
   :maxdepth: 2
   :caption: Contenu

   overview
   prerequisites
   virtualbox_setup
   flash_procedure
   troubleshooting

Références
----------

* `NVIDIA CLARA AGX upgrade — Recherche Google <https://www.google.com/search?client=firefox-b-e&channel=entpr&q=NVIDIA+CLARA+AGX+upgrade>`_
* `Clara AGX User Guide — Flashing and Updating (GitHub Holoscan) <https://github.com/nvidia-holoscan/holoscan-docs/blob/main/devkits/clara-agx/clara_agx_user_guide.md#flashing-and-updating-clara-agx-developer-kit-using-the-sdk-manager>`_
* `Clara AGX User Guide — Checklist for Setting Up the Developer Kit (GitHub Holoscan) <https://github.com/nvidia-holoscan/holoscan-docs/blob/main/devkits/clara-agx/clara_agx_user_guide.md#checklist-for-setting-up-the-developer-kit>`_
* `Clara AGX Upgrade — Recherche Google <https://www.google.com/search?client=firefox-b-e&channel=entpr&q=Clara+AGX+Upgrade>`_
* `Install Clara Holoscan Software — NVIDIA SDK Manager Documentation <https://docs.nvidia.com/sdk-manager/install-with-sdkm-clara/index.html>`_
* `Install Jetson Software with SDK Manager on a Host Machine (Direct Flash) — SDK Manager <https://docs.nvidia.com/sdk-manager/install-with-sdkm-jetson-direct-flash/index.html>`_
* `Real-Time AI End-to-End Surgical Video Workflow — NVIDIA Holoscan Ecosystem <https://nvidia-holoscan.github.io/holohub/workflows/ai_surgical_video/>`_
* `Clara AGX Ecosystem — NVIDIA Developer <https://developer.nvidia.com/clara-devkit-distributors>`_