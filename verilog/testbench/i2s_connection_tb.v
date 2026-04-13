`timescale 1ns / 1ps

module tb_i2s_connection;

  // ---------------------------------------------------------
  // 1. Declare Testbench Signals
  // ---------------------------------------------------------
  reg clk;
  reg rst_n;
  reg [3:0] signal;

  wire i2s_bclk;
  wire i2s_lrck;
  wire i2s_din;

  // ---------------------------------------------------------
  // 2. Instantiate the Unit Under Test (UUT)
  // ---------------------------------------------------------
  i2s_connection uut (
      .clk(clk),
      .rst_n(rst_n),
      .signal(signal),
      .i2s_bclk(i2s_bclk),
      .i2s_lrck(i2s_lrck),
      .i2s_din(i2s_din)
  );

  // ---------------------------------------------------------
  // 3. Clock Generation (2 MHz)
  // ---------------------------------------------------------
  // 2 MHz = 500 ns period. 
  // Toggles every 250 ns.
  initial begin
    clk = 0;
    forever #250 clk = ~clk;
  end

  // ---------------------------------------------------------
  // 4. Main Test Sequence
  // ---------------------------------------------------------
  initial begin
    // Setup Waveform Dump
    $dumpfile("tb_i2s_connection.vcd");
    $dumpvars(0, tb_i2s_connection);

    // Initialize inputs
    rst_n  = 0;
    signal = 4'b0000;  // IDLE state

    // Wait 1000ns and release reset
    #1000;
    rst_n = 1;
    $display("[%0t] System Reset Released.", $time);
    #2000;

    // -----------------------------------------------------
    // Test 1: Car Entering ("Welcome")
    // -----------------------------------------------------
    $display("[%0t] Triggering Welcome Audio (State 0001)...", $time);
    signal = 4'b0001;

    // Wait for several audio frames to shift out.
    // 1 audio frame = 32 bclk cycles = 128 system clk cycles = 64,000 ns
    // Waiting 3,200,000 ns = ~50 audio frames
    #3200000;

    // -----------------------------------------------------
    // Test 2: Lot is Full / Back Up ("Luilai")
    // -----------------------------------------------------
    $display("[%0t] Triggering Luilai Audio (State 0010)...", $time);
    signal = 4'b0010;
    #3200000;

    // -----------------------------------------------------
    // Test 3: Car Leaving ("Goodbye")
    // -----------------------------------------------------
    $display("[%0t] Triggering Goodbye Audio (State 0110)...", $time);
    signal = 4'b0110;
    #3200000;

    // -----------------------------------------------------
    // Return to IDLE
    // -----------------------------------------------------
    $display("[%0t] Returning to IDLE (State 0000)...", $time);
    signal = 4'b0000;
    #1000000;

    $display("[%0t] Simulation Complete.", $time);
    $finish;
  end

endmodule
