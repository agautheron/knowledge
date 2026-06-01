.. _verilog_xadc:

Acquisition analogique — XADC
==============================

.. contents:: Sommaire
   :local:
   :depth: 2

Le bloc XADC
------------

L'Artix-7 intègre un bloc **XADC** (*Xilinx Analog-to-Digital Converter*)
capable de convertir des signaux analogiques en valeurs numériques 12 bits.
Il est accessible via un primitif instanciable directement en Verilog.

.. list-table:: Caractéristiques du XADC Artix-7
   :header-rows: 1
   :widths: 40 60

   * - Paramètre
     - Valeur
   * - Résolution
     - 12 bits (valeur dans les 12 MSB d'un mot 16 bits)
   * - Fréquence d'échantillonnage maximale
     - 1 Msps (un million d'échantillons par seconde)
   * - Plage d'entrée (mode différentiel VP/VN)
     - 0 à 1 V différentiel
   * - Canaux disponibles sur JXADC (Nexys 4)
     - VP/VN, VAUXP/N[0], VAUXP/N[1], VAUXP/N[9]

.. danger::

   **Tension maximale absolue : 1 V différentiel.**
   Toute tension supérieure sur les broches VP/VN détruira le FPGA de façon
   permanente. Si le signal source dépasse 1 V (typiquement 3,3 V logique
   ou signal issu d'un générateur de fonctions), interposer un **diviseur
   résistif** ou un buffer opamp (ex. LM358 en suiveur avec résistances).

   Exemple de diviseur pour un signal 0–3,3 V → 0–1 V :
   $R_1 = 2{,}3\,\text{k}\Omega$, $R_2 = 1\,\text{k}\Omega$.

Connecteur JXADC — correspondance des broches
----------------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 25 55

   * - Broche JXADC
     - Signal XADC
     - Broche FPGA (Package PIN)
   * - 1
     - VP (différentiel +)
     - A13
   * - 7
     - VN (différentiel −)
     - A14
   * - 2
     - VAUXP[1]
     - B13
   * - 8
     - VAUXN[1]
     - A13 *(partagé selon config)*
   * - 3
     - VAUXP[9]
     - B14
   * - 9
     - VAUXN[9]
     - B15

Instanciation du primitif XADC
--------------------------------

Le XADC est configuré via des registres ``INIT_xx`` renseignés à la
synthèse comme paramètres du primitif :

.. code-block:: verilog
   :caption: xadc_wrapper.v — acquisition continue sur VP/VN

   module xadc_wrapper (
       input  wire        clk,        // 100 MHz système
       input  wire        rst,        // reset synchrone actif haut
       input  wire        vp_in,      // VP — JXADC broche 1
       input  wire        vn_in,      // VN — JXADC broche 7
       output reg  [11:0] adc_val,    // valeur convertie (0x000–0xFFF)
       output reg         adc_valid   // pulse 1 cycle : nouvelle donnée
   );

       wire [15:0] do_out;
       wire        drdy;

       XADC #(
           // Mode continu, canal VP/VN, moyenne x16
           .INIT_40(16'h9000),
           // Désactiver toutes les alarmes
           .INIT_41(16'h2ef0),
           // ADCCLK = DCLK / 4 → 100 MHz / 4 = 25 MHz
           .INIT_42(16'h0400),
           // Séquenceur : activer uniquement le canal 0 (VP/VN)
           .INIT_48(16'h0100),
           .INIT_49(16'h0000),
           .INIT_4A(16'h0100),
           .INIT_4B(16'h0000)
       ) u_xadc (
           .CONVST   (1'b0),
           .CONVSTCLK(1'b0),
           .DADDR    (7'h00),      // registre 0x00 = mesure VP/VN
           .DCLK     (clk),
           .DEN      (1'b1),
           .DI       (16'h0000),
           .DWE      (1'b0),
           .RESET    (rst),
           .VAUXN    (15'b0),
           .VAUXP    (15'b0),
           .VN       (vn_in),
           .VP       (vp_in),
           .DO       (do_out),     // résultat 16 bits
           .DRDY     (drdy),       // pulse 1 cycle par conversion
           .EOC      (),
           .EOS      ()
       );

       // Capture des 12 MSB sur front DRDY
       always @(posedge clk) begin
           adc_valid <= 1'b0;
           if (drdy) begin
               adc_val   <= do_out[15:4];  // bits 15:4 = valeur (LSB = 0)
               adc_valid <= 1'b1;
           end
       end

   endmodule

Interprétation de la valeur ADC
---------------------------------

La valeur numérique renvoyée par le XADC est :

.. math::

   V_{\text{analog}} = \frac{\text{adc\_val}}{4095} \times 1\,\text{V}

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - ``adc_val`` (hex)
     - Tension analogique
     - Interprétation
   * - ``12'h000``
     - 0 V
     - Signal au niveau bas
   * - ``12'h800`` (2048)
     - ≈ 0,5 V
     - Seuil de comparaison recommandé
   * - ``12'hFFF`` (4095)
     - ≈ 1 V
     - Signal au niveau haut (pleine échelle)

Limitation fréquentielle et conséquences
-----------------------------------------

Le XADC échantillonne à **1 Msps maximum**. Par le théorème de Shannon, il
ne peut reconstituer fidèlement que des signaux de fréquence inférieure à
500 kHz. Pour un signal d'entrée à 20 MHz, il est **impossible** de
reconstruire la forme d'onde — le XADC ne verra qu'environ 1 front sur 20.

La fréquence apparente des fronts détectés sera donc :

.. math::

   f_{\text{fronts détectés}} \approx
   \frac{f_{\text{XADC}}}{f_{\text{signal}}} \times f_{\text{signal fronts}}
   = \frac{1\,\text{Msps}}{20\,\text{MHz}} \times 20\,\text{MHz fronts/s}
   \approx 1\,\text{MHz}

et la fréquence de sortie effective sera :

.. math::

   f_{\text{out}} \approx \frac{1\,\text{MHz}}{16} \approx 62{,}5\,\text{kHz}

.. important::

   **Pour traiter un signal à 20 MHz**, la solution recommandée est
   d'utiliser un **comparateur analogique externe** (ex. LM393, TLV3201)
   pour convertir le signal en niveau logique LVCMOS33, puis de câbler la
   sortie sur un PMOD et d'appliquer la détection de front directement sur
   ce signal numérique propre. Le XADC reste pertinent pour mesurer
   l'amplitude ou détecter des signaux de fréquence ≤ 500 kHz.

.. seealso::

   :doc:`06_comparateur` pour l'étape de seuillage suivante.
