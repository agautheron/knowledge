## =============================================================================
## Fichier de contraintes XDC — Nexys 4 DDR (Artix-7 XC7A100T csg324-1)
## Projet : Diviseur de fréquence analogique → numérique
## =============================================================================

## ── Horloge système 100 MHz ──────────────────────────────────────────────────
set_property PACKAGE_PIN E3       [get_ports clk_100mhz]
set_property IOSTANDARD  LVCMOS33 [get_ports clk_100mhz]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_100mhz]

## ── Bouton Reset (BTNC) ──────────────────────────────────────────────────────
set_property PACKAGE_PIN N17      [get_ports rst_btn]
set_property IOSTANDARD  LVCMOS33 [get_ports rst_btn]

## ── Entrées analogiques XADC (JXADC) ────────────────────────────────────────
## IMPORTANT : ne PAS ajouter de IOSTANDARD pour les broches analogiques
set_property PACKAGE_PIN A13      [get_ports vp_in]
set_property PACKAGE_PIN A14      [get_ports vn_in]

## ── Sortie divisée → PMOD JA broche 1 (JA[0]) ───────────────────────────────
set_property PACKAGE_PIN C17      [get_ports clk_out_1m25]
set_property IOSTANDARD  LVCMOS33 [get_ports clk_out_1m25]

## ── LED debug (front montant) ────────────────────────────────────────────────
set_property PACKAGE_PIN H17      [get_ports led_pulse]
set_property IOSTANDARD  LVCMOS33 [get_ports led_pulse]

## ── LEDs 12 bits ADC ─────────────────────────────────────────────────────────
set_property PACKAGE_PIN H17      [get_ports {led[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN K15      [get_ports {led[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN J13      [get_ports {led[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN N14      [get_ports {led[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN R18      [get_ports {led[4]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN V17      [get_ports {led[5]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN U17      [get_ports {led[6]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN U16      [get_ports {led[7]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN V16      [get_ports {led[8]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[8]}]
set_property PACKAGE_PIN T15      [get_ports {led[9]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[9]}]
set_property PACKAGE_PIN U14      [get_ports {led[10]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[10]}]
set_property PACKAGE_PIN T16      [get_ports {led[11]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {led[11]}]

## ── Contrainte timing : clk_out n'est pas une horloge propagée ───────────────
set_false_path -to [get_ports clk_out_1m25]
