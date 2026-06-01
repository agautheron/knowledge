// =============================================================================
// Testbench : tb_top
// Simule la chaîne edge_detector + freq_divider avec un signal carré à 20 MHz.
// Le XADC et le comparateur sont court-circuités : sig_bin est généré
// directement par l'always de génération d'horloge.
//
// Résultats attendus :
//   rising_pulse : 20 MHz (durée 10 ns)
//   clk_out      : 1,25 MHz (période 800 ns)
// =============================================================================

`timescale 1ns/1ps

module tb_top;

    // ── Paramètres ────────────────────────────────────────────────────────
    localparam CLK_PERIOD = 10;    // 100 MHz → 10 ns
    localparam SIG_PERIOD = 50;    // Signal simulé 20 MHz → 50 ns
    localparam N_DIV      = 16;    // Rapport de division
    localparam EXPECTED_T = SIG_PERIOD * N_DIV;  // 800 ns attendus

    // ── Signaux ───────────────────────────────────────────────────────────
    reg  clk_100mhz;
    reg  rst_n;
    reg  sig_bin_sim;
    wire rising_pulse;
    wire clk_out;

    // ── Génération d'horloge 100 MHz ──────────────────────────────────────
    initial clk_100mhz = 1'b0;
    always  #(CLK_PERIOD/2) clk_100mhz = ~clk_100mhz;

    // ── Signal analogique simulé 20 MHz (remplace XADC + comparateur) ─────
    initial sig_bin_sim = 1'b0;
    always  #(SIG_PERIOD/2) sig_bin_sim = ~sig_bin_sim;

    // ── Instanciation du détecteur de front ───────────────────────────────
    edge_detector u_edge (
        .clk         (clk_100mhz),
        .rst_n       (rst_n),
        .sig_in      (sig_bin_sim),
        .rising_edge (rising_pulse),
        .falling_edge()
    );

    // ── Instanciation du diviseur ─────────────────────────────────────────
    freq_divider #(.N(N_DIV)) u_div (
        .clk          (clk_100mhz),
        .rst_n        (rst_n),
        .rising_pulse (rising_pulse),
        .clk_out      (clk_out)
    );

    // ── Séquence de contrôle ──────────────────────────────────────────────
    initial begin
        rst_n = 1'b0;   #50;
        rst_n = 1'b1;   #20000;
        $display("[INFO] Simulation terminée à %0t ns", $time);
        $finish;
    end

    // ── Mesure automatique de période ─────────────────────────────────────
    real t1, t2, measured_T;

    initial begin
        @(posedge rst_n);
        @(posedge clk_out);           // 1er front (non mesuré)
        @(posedge clk_out); t1 = $realtime;
        @(posedge clk_out); t2 = $realtime;
        measured_T = t2 - t1;

        $display("─────────────────────────────────────────────");
        $display("Période mesurée  : %0.1f ns", measured_T);
        $display("Période attendue : %0d   ns", EXPECTED_T);
        if (measured_T == EXPECTED_T)
            $display("[PASS] Diviseur ÷%0d correct : %0.3f MHz",
                     N_DIV, 1000.0 / measured_T);
        else
            $display("[FAIL] Période incorrecte !");
        $display("─────────────────────────────────────────────");
    end

    // ── Dump VCD (GTKWave) ────────────────────────────────────────────────
    initial begin
        $dumpfile("sim_div_freq.vcd");
        $dumpvars(0, tb_top);
    end

endmodule
