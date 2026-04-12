module topModule (
    input clk,
    rst,
    sensor0,
    sensor1,
    output a1,
    b1,
    c1,
    d1,
    e1,
    f1,
    g1,
    a2,
    b2,
    c2,
    d2,
    e2,
    f2,
    g2,
    barier1,
    i2s_bclk,
    i2s_lrck,
    i2s_din,
    output [7:0] led  // kiem tra trang thai 
);
  wire vao, ra;
  wire       control;
  wire [1:0] s;
  wire [3:0] current_signal;
  assign s = {sensor1, sensor0};
  TN_HDL_FSM fsm (
      .clk(clk),
      .rst(rst),
      .s(s),
      .vao(vao),
      .ra(ra),
      .barier1(control),
      .led(led),
      .output_signal(current_signal)
  );
  Barier Barier1 (
      .clk(clk),
      .rst(rst),
      .control(control),
      .clock_20(barier1)
  );  //loi
  dem_xe dem_xe1 (
      .clk_in(clk),
      .rst(rst),
      .vao(vao),
      .ra(ra),
      .a1(a1),
      .a2(a2),
      .b1(b1),
      .b2(b2),
      .c1(c1),
      .c2(c2),
      .d1(d1),
      .d2(d2),
      .e1(e1),
      .e2(e2),
      .f1(f1),
      .f2(f2),
      .g1(g1),
      .g2(g2)
  );
  i2s_connection speaker (
      .clk(clk),
      .rst_n(rst),
      .signal(current_signal),
      .i2s_bclk(i2s_bclk),
      .i2s_lrck(i2s_lrck),
      .i2s_din(i2s_din)
  );
endmodule
