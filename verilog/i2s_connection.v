module i2s_connection (
    input  wire clk,
    input  wire rst_n,
    output reg  i2s_bclk,  // Bit Clock
    output reg  i2s_lrck,  // Left Right Clock
    output reg  i2s_din    // Serial Data In
);

  // Bo chia tan so
  reg [4:0] bclk_div;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) bclk_div <= 5'd0;
    else bclk_div <= bclk_div + 1'b1;
  end

  // Tao xung de dao trang thai BCLK
  wire bclk_toggle = (bclk_div == 5'd31);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2s_bclk <= 1'b0;
    else if (bclk_toggle) i2s_bclk <= ~i2s_bclk;
  end

  // Bo dem bit tu 0 den 31
  // Du lieu thay doi tai suon xuong cua BCLK
  wire bclk_falling = (bclk_toggle && i2s_bclk == 1'b1);
  reg [4:0] bit_cnt;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) bit_cnt <= 5'd0;
    else if (bclk_falling) bit_cnt <= bit_cnt + 1'b1;
  end

  // Tao tin hieu LRCK de phan biet kenh trai va phai
  // 0 la kenh trai, 1 la kenh phai
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2s_lrck <= 1'b0;
    else if (bclk_falling) begin
      if (bit_cnt == 5'd15) i2s_lrck <= 1'b1;
      else if (bit_cnt == 5'd31) i2s_lrck <= 1'b0;
    end
  end

  // Bo tao am thanh don gian hinh song vuong
  reg [ 6:0] tone_cnt;
  reg [15:0] audio_sample;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tone_cnt <= 7'd0;
      audio_sample <= 16'h0000;
    end else if (bclk_falling && bit_cnt == 5'd31) begin
      // Cap nhat mau am thanh sau moi chu ky frame
      tone_cnt <= tone_cnt + 1'b1;
      if (tone_cnt == 7'd100) begin
        tone_cnt <= 7'd0;
        // Dao bien do am thanh de tao tieng bip
        if (audio_sample == 16'h1FFF) audio_sample <= 16'hE000;
        else audio_sample <= 16'h1FFF;
      end
    end
  end

  // Day du lieu ra ngoai, bit cao nhat ra truoc
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2s_din <= 1'b0;
    else if (bclk_falling) begin
      // Lay bit tuong ung tu mau am thanh
      i2s_din <= audio_sample[~bit_cnt[3:0]];
    end
  end

endmodule
