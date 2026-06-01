.. _depot_restructuration:

Restructuration du dépôt Git
=============================

.. contents:: Sommaire
   :local:
   :depth: 2

État actuel du dépôt
---------------------

Le dépôt ``agautheron/RT_Models`` contient actuellement des fichiers RST
à la racine, des dossiers thématiques physique (``bloch/``, ``diffusion/``,
etc.) et les fichiers de configuration Sphinx (``conf.py``, ``_ext/``,
``_static/``).

.. code-block:: text

   RT_Models/                    ← état actuel
   ├── conf.py
   ├── index.rst
   ├── transfert_radiatif.rst
   ├── solutions.rst
   ├── bloch/
   ├── diffusion/
   ├── quantification/
   ├── spatial_encoding/
   ├── spectroscopy/
   ├── _ext/
   ├── _static/
   └── .github/workflows/

Problèmes identifiés :

- Les fichiers RST de contenu sont mélangés aux fichiers de configuration
  Sphinx à la racine.
- Il n'y a pas de séparation claire entre la documentation et les sources
  Python/MATLAB.
- Le nouveau chapitre Verilog/FPGA n'a pas de place naturelle.

Structure recommandée
----------------------

.. code-block:: text

   RT_Models/                          ← racine du dépôt
   │
   ├── conf.py                         ← config Sphinx (reste à la racine)
   ├── index.rst                       ← toctree principal
   ├── requirements.txt
   ├── Makefile
   │
   ├── _ext/                           ← extensions Sphinx personnalisées
   ├── _static/                        ← CSS, images globales
   │
   ├── transfert_radiatif/             ← chapitre 1 (physique RT)
   │   ├── index.rst                   ← toctree du chapitre
   │   ├── introduction.rst
   │   ├── equation_transfert.rst
   │   ├── moments.rst
   │   └── figures/
   │
   ├── modeles_numeriques/             ← chapitre 2 (bloch, diffusion…)
   │   ├── index.rst
   │   ├── bloch.rst
   │   ├── diffusion.rst
   │   └── ...
   │
   ├── verilog_fpga/                   ← chapitre 3 (ce cours) ← NOUVEAU
   │   ├── index.rst
   │   ├── 01_introduction.rst
   │   ├── 02_syntaxe.rst
   │   ├── 03_logique_combinatoire.rst
   │   ├── 04_logique_sequentielle.rst
   │   ├── 05_xadc_analogique.rst
   │   ├── 06_comparateur.rst
   │   ├── 07_edge_detector.rst
   │   ├── 08_diviseur.rst
   │   ├── 09_top_module.rst
   │   ├── 10_contraintes_xdc.rst
   │   ├── 11_testbench.rst
   │   └── figures/
   │
   ├── src/                            ← sources exécutables (séparés des docs)
   │   ├── python/
   │   │   ├── simulator.py
   │   │   └── style.py
   │   ├── matlab/
   │   │   └── Simulator.m
   │   └── verilog/                    ← fichiers .v du chapitre FPGA
   │       ├── xadc_wrapper.v
   │       ├── comparator.v
   │       ├── edge_detector.v
   │       ├── freq_divider.v
   │       ├── top_nexys4.v
   │       ├── constraints/
   │       │   └── nexys4_ddr.xdc
   │       └── sim/
   │           └── tb_top.v
   │
   └── .github/
       └── workflows/
           └── sphinx.yml              ← CI/CD pour ReadTheDocs / GitHub Pages

Migration pas à pas
--------------------

Voici la séquence de commandes Git pour migrer sans perdre l'historique :

.. code-block:: bash

   # 1. Créer les nouveaux dossiers
   mkdir -p verilog_fpga/figures
   mkdir -p src/verilog/constraints src/verilog/sim

   # 2. Déplacer les fichiers RST existants dans leur dossier
   git mv transfert_radiatif.rst transfert_radiatif/
   git mv solutions.rst           transfert_radiatif/

   # 3. Ajouter les nouveaux fichiers RST du chapitre Verilog
   git add verilog_fpga/

   # 4. Ajouter les sources Verilog dans src/
   git add src/verilog/

   # 5. Mettre à jour index.rst (utiliser la version fournie)
   git add index.rst

   # 6. Commit atomique
   git commit -m "docs: restructure repo + add verilog_fpga chapter"

.. important::

   Faire la migration dans **un seul commit** pour conserver la cohérence
   de l'historique et faciliter un éventuel ``git bisect``.

Workflow GitHub Actions recommandé
------------------------------------

Ce workflow reconstruit la documentation Sphinx et la déploie sur
GitHub Pages à chaque push sur ``main`` :

.. code-block:: yaml
   :caption: .github/workflows/sphinx.yml

   name: Build & Deploy Sphinx docs

   on:
     push:
       branches: [main]
     pull_request:
       branches: [main]

   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4

         - name: Set up Python
           uses: actions/setup-python@v5
           with:
             python-version: "3.11"

         - name: Install dependencies
           run: pip install -r requirements.txt

         - name: Build HTML docs
           run: make html

         - name: Deploy to GitHub Pages
           if: github.ref == 'refs/heads/main'
           uses: peaceiris/actions-gh-pages@v3
           with:
             github_token: ${{ secrets.GITHUB_TOKEN }}
             publish_dir: ./_build/html

Fichier ``requirements.txt`` minimal
--------------------------------------

.. code-block:: text

   sphinx>=7.0
   furo
   sphinxcontrib-katex
   sphinx-inline-tabs
   sphinx-math-dollar
   sphinx-togglebutton

Conventions de nommage des fichiers RST
-----------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Contexte
     - Convention adoptée
     - Exemple
   * - Section principale d'un chapitre
     - ``NN_nom_court.rst`` (préfixe numérique)
     - ``07_edge_detector.rst``
   * - Index de chapitre
     - ``index.rst`` dans le sous-dossier
     - ``verilog_fpga/index.rst``
   * - Figures
     - ``nom_module_description.svg`` ou ``.png``
     - ``edge_detector_chronogram.svg``
   * - Sources exécutables
     - Dossier ``src/`` séparé, même nom que le module
     - ``src/verilog/edge_detector.v``

Cette séparation entre ``rst`` (documentation) et ``src/verilog``
(code exécutable) permet de faire tourner Vivado directement sur ``src/``
sans mélanger les fichiers de documentation.
