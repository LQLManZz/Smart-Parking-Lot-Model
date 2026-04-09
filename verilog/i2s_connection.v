module i2s_connection (
    input  wire clk,   // 50 MHz system clock from X3
    input  wire rst_n,     // Active low reset (e.g., SW1)
    output reg  i2s_bclk,  // Bit Clock
    output reg  i2s_lrck,  // Left/Right Clock (Word Select)
    output reg  i2s_din    // Serial Data In
);

  // ---------------------------------------------------------
  // 1. Clock Divider: 50 MHz -> ~1.56 MHz BCLK
  // Dividing 50 MHz by 32 gives 1.5625 MHz.
  // This results in a sample rate of ~48.8 kHz (close to 48 kHz standard).
  // ---------------------------------------------------------
  reg [4:0] bclk_div;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) bclk_div <= 5'd0;
    else bclk_div <= bclk_div + 1'b1;
  end

  wire bclk_toggle = (bclk_div == 5'd31);  // Pulse to toggle BCLK

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2s_bclk <= 1'b0;
    else if (bclk_toggle) i2s_bclk <= ~i2s_bclk;
  end

  // ---------------------------------------------------------
  // 2. Bit Counter (0 to 31 for 16-bit stereo)
  // I2S mandates that data changes on the FALLING edge of BCLK.
  // ---------------------------------------------------------
  wire bclk_falling = (bclk_toggle && i2s_bclk == 1'b1);
  reg [4:0] bit_cnt;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) bit_cnt <= 5'd0;
    else if (bclk_falling) bit_cnt <= bit_cnt + 1'b1;
  end

  // ---------------------------------------------------------
  // 3. LRCK Generation (Transitions one bit BEFORE data MSB)
  // 0 = Left Channel, 1 = Right Channel
  // ---------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2s_lrck <= 1'b0;
    else if (bclk_falling) begin
      if (bit_cnt == 5'd15) i2s_lrck <= 1'b1;
      else if (bit_cnt == 5'd31) i2s_lrck <= 1'b0;
    end
  end

  // ---------------------------------------------------------
  // 4. Square Wave Tone Generator (~480 Hz)
  // ---------------------------------------------------------
  reg [ 6:0] tone_cnt;
  reg [15:0] audio_sample;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tone_cnt <= 7'd0;
      audio_sample <= 16'h0000;
    end else if (bclk_falling && bit_cnt == 5'd31) begin
      // Update sample once per full audio frame
      tone_cnt <= tone_cnt + 1'b1;
      if (tone_cnt == 7'd100) begin
        tone_cnt <= 7'd0;
        // Toggle amplitude (Using 0x1FFF instead of 0x7FFF so it isn't deafeningly loud)
        if (audio_sample == 16'h1FFF) audio_sample <= 16'hE000;
        else audio_sample <= 16'h1FFF;
      end
    end
  end

  // ---------------------------------------------------------
  // 5. Data Out (Shift out MSB first)
  // ---------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2s_din <= 1'b0;
    else if (bclk_falling) begin
      // ~bit_cnt[3:0] is a bitwise trick to cleanly map counts 0->15 to indices 15->0
      i2s_din <= audio_sample[~bit_cnt[3:0]];
    end
  end

endmodule
