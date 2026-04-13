`timescale 1ns / 1ps

module tb_ParkingSystem_top;

  // ---------------------------------------------------------
  // 1. Declare Testbench Signals
  // ---------------------------------------------------------
  reg clk;
  reg rst;
  reg sensor0;
  reg sensor1;

  wire a1, b1, c1, d1, e1, f1, g1;
  wire a2, b2, c2, d2, e2, f2, g2;
  wire barier1;
  wire i2s_bclk, i2s_lrck, i2s_din;
  wire [7:0] led;

  // ---------------------------------------------------------
  // 2. Instantiate the Unit Under Test (UUT)
  // ---------------------------------------------------------
  topModule uut (
      .clk(clk),
      .rst(rst),
      .sensor0(sensor0),
      .sensor1(sensor1),
      .a1(a1),
      .b1(b1),
      .c1(c1),
      .d1(d1),
      .e1(e1),
      .f1(f1),
      .g1(g1),
      .a2(a2),
      .b2(b2),
      .c2(c2),
      .d2(d2),
      .e2(e2),
      .f2(f2),
      .g2(g2),
      .barier1(barier1),
      .i2s_bclk(i2s_bclk),
      .i2s_lrck(i2s_lrck),
      .i2s_din(i2s_din),
      .led(led)
  );

  // ---------------------------------------------------------
  // 3. Clock Generation (50 MHz)
  // ---------------------------------------------------------
  initial begin
    clk = 0;
    forever #10 clk = ~clk;  // 20ns period = 50MHz
  end

  // ---------------------------------------------------------
  // 4. Tasks for Car Movement Sequences
  // ---------------------------------------------------------
  // A delay of 2,000,000 ns (2 ms) is used between states to 
  // ensure the FSM's debounce module allows the signal through.

  task car_enters;
    begin
      $display("[%0t] Car entering...", $time);
      sensor0 = 1;
      sensor1 = 0;  // State 1: Front of car blocks sensor0
      #2000000;

      sensor0 = 1;
      sensor1 = 1;  // State 2: Car blocks both sensors
      #2000000;

      sensor0 = 0;
      sensor1 = 1;  // State 3: Rear of car blocks sensor1
      #2000000;

      sensor0 = 0;
      sensor1 = 0;  // State 4: Car fully inside
      #2000000;
      $display("[%0t] Car fully entered.", $time);
    end
  endtask

  task car_leaves;
    begin
      $display("[%0t] Car leaving...", $time);
      sensor0 = 0;
      sensor1 = 1;  // State 1: Front of car blocks sensor1
      #2000000;

      sensor0 = 1;
      sensor1 = 1;  // State 2: Car blocks both sensors
      #2000000;

      sensor0 = 1;
      sensor1 = 0;  // State 3: Rear of car blocks sensor0
      #2000000;

      sensor0 = 0;
      sensor1 = 0;  // State 4: Car fully outside
      #2000000;
      $display("[%0t] Car fully left.", $time);
    end
  endtask

  // ---------------------------------------------------------
  // 5. Main Test Sequence
  // ---------------------------------------------------------
  initial begin
    // Initialize inputs
    rst = 0;  // Assume Active-Low Reset based on FSM logic
    sensor0 = 0;
    sensor1 = 0;

    // Wait 100ns and release reset
    #100;
    rst = 1;
    $display("[%0t] System Reset.", $time);

    // Wait for system to stabilize
    #1000000;

    // Simulate Car 1 Entering
    car_enters();

    // Let the audio play for a while (4.5 ms)
    #4500000;

    // Simulate Car 1 Leaving
    car_leaves();

    // Let the audio play for a while (4.5 ms)
    #4500000;

    $display("[%0t] Simulation Complete.", $time);
    $finish;
  end

  // ---------------------------------------------------------
  // 6. Waveform Output
  // ---------------------------------------------------------
  initial begin
    $dumpfile("tb_ParkingSystem_top.vcd");
    $dumpvars(0, tb_ParkingSystem_top);
  end

endmodule
