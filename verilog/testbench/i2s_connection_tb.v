`timescale 1ns / 1ps

module tb_i2s_connection;

  // ---------------------------------------------------------
  // Testbench Signals
  // ---------------------------------------------------------
  reg  clk;
  reg  rst_n;

  wire i2s_bclk;
  wire i2s_lrck;
  wire i2s_din;

  // ---------------------------------------------------------
  // Instantiate the Unit Under Test (UUT)
  // ---------------------------------------------------------
  i2s_connection uut (
      .clk(clk),
      .rst_n(rst_n),
      .i2s_bclk(i2s_bclk),
      .i2s_lrck(i2s_lrck),
      .i2s_din(i2s_din)
  );

  // ---------------------------------------------------------
  // Clock Generation
  // ---------------------------------------------------------
  // 50 MHz Clock -> T = 1/50MHz = 20 ns. 
  // Toggles every 10 ns.
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // ---------------------------------------------------------
  // Test Sequence
  // ---------------------------------------------------------
  initial begin
    // 1. Initialize Inputs
    rst_n = 0;

    // 2. Wait 100 ns for global reset to propagate
    #100;

    // 3. Release Reset
    rst_n = 1;
    $display("Reset released. Starting I2S transmission...");

    // 4. Run Simulation
    // One BCLK period = 64 system clk cycles = 1,280 ns.
    // One Frame (LRCK period) = 32 BCLK periods = 40,960 ns.
    // The tone amplitude toggles every 100 frames = 4,096,000 ns.
    // Simulating for 4.5 milliseconds to capture the amplitude toggle.
    #4500000;

    // 5. End Simulation
    $display("Simulation complete.");
    $finish;
  end

  // ---------------------------------------------------------
  // Waveform Generation
  // ---------------------------------------------------------
  // This generates a .vcd file to view the timing diagrams.
  initial begin
    $dumpfile("tb_i2s_connection.vcd");
    $dumpvars(0, tb_i2s_connection);
  end

endmodule
