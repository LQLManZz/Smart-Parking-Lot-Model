module i2s_connection (
    input            clk,
    input            rst_n,
    input      [3:0] signal,
    output reg       i2s_bclk,
    output reg       i2s_lrck,
    output reg       i2s_din
);

  // Bo chia tan so de tao BCLK
  reg [4:0] bclk_div;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) bclk_div <= 5'd0;
    else bclk_div <= bclk_div + 1'b1;
  end

  // Tao xung de dao trang thai BCLK tai cuoi chu ky chia
  wire bclk_toggle = (bclk_div == 5'd31);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2s_bclk <= 1'b0;
    else if (bclk_toggle) i2s_bclk <= ~i2s_bclk;
  end

  // Phat hien suon xuong cua BCLK de cap nhat du lieu SD
  wire bclk_falling = (bclk_toggle && i2s_bclk == 1'b1);
  reg [4:0] bit_cnt;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) bit_cnt <= 5'd0;
    else if (bclk_falling) bit_cnt <= bit_cnt + 1'b1;
  end

  // Tao tin hieu LRCK de phan biet kenh trai (0) va phai (1)
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) i2s_lrck <= 1'b0;
    else if (bclk_falling) begin
      if (bit_cnt == 5'd15) i2s_lrck <= 1'b1;
      else if (bit_cnt == 5'd31) i2s_lrck <= 1'b0;
    end
  end

  // Ket noi voi cac module ROM chua am thanh
  wire [14:0] rom_addr;
  reg playing;
  wire [15:0] audio_welcome, audio_luilai, audio_goodbye;

  my_audio #(
      .FILENAME("welcome.mem")
  ) welcome (
      .clk(clk),
      .address(rom_addr),
      .data_out(audio_welcome)
  );

  my_audio #(
      .FILENAME("luilai.mem")
  ) luilai (
      .clk(clk),
      .address(rom_addr),
      .data_out(audio_luilai)
  );

  my_audio #(
      .FILENAME("goodbye.mem")
  ) goodbye (
      .clk(clk),
      .address(rom_addr),
      .data_out(audio_goodbye)
  );

  // Phat hien su thay doi cua tin hieu dau vao de bat dau phat am thanh
  reg [3:0] last_signal;
  wire signal_changed = (signal != last_signal && signal != 4'b0000);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) last_signal <= 4'd0;
    else last_signal <= signal;
  end

  // Tin hieu yeu cau mau tiep theo tai cuoi moi frame
  wire req_next = (bclk_falling && bit_cnt == 5'd31);
  reg [14:0] rom_addr_reg;
  assign rom_addr = rom_addr_reg;

  // Bo dieu khien playback
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rom_addr_reg <= 15'd0;
      playing <= 1'b0;
    end else if (signal_changed) begin
      // Reset ve dau file am thanh khi co tin hieu moi
      rom_addr_reg <= 15'd0;
      playing <= 1'b1;
    end else if (playing && req_next) begin
      // Dung phat khi het bo nho (32767 samples)
      if (rom_addr_reg == 15'd32767) begin
        playing <= 1'b0;
      end else begin
        rom_addr_reg <= rom_addr_reg + 1'b1;
      end
    end
  end

  // Day du lieu ra chan DIN theo chuan I2S (MSB first)
  // bit_cnt 0-15 cho kenh trai, 16-31 cho kenh phai
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n || !playing) i2s_din <= 1'b0;
    else if (bclk_falling) begin
      case (signal)
        4'b0001: i2s_din <= audio_welcome[4'd15-bit_cnt[3:0]];
        4'b0010: i2s_din <= audio_luilai[4'd15-bit_cnt[3:0]];
        4'b0110: i2s_din <= audio_goodbye[4'd15-bit_cnt[3:0]];
        default: i2s_din <= 1'b0;
      endcase
    end
  end

endmodule
