//khi co tin hieu dem thi moi dem=> thay xung clock bang tin hieu
module dem_xe (
    input  clk_in,
    rst,
    vao,
    ra,
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
    g2
);
  wire [3:0] q;
  bo_dem bo_dem1 (
      .clk_in(clk_in),
      .clr(rst),
      .vao(vao),
      .ra(ra),
      .q(q)
  );
  led7seg led7seg1 (
      .q (q),
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
      .g2(g2)
  );
endmodule

/*
module bo_dem( //neu xe thu 16 vao thi barier khong duoc mo 
    input clk_in, clr, vao, ra
    output reg [3:0] q
);
    reg s;
    always @(posedge clk_in, negedge rst) begin
        if(!rst) s<=0;
        else if(vao==1'b1) s<=0;
        else if(ra==1'b1) s<=1;
        else s<=s;
    end
    always @(posedge clk_in, negedge clr) begin
        s_hienTai<=s;
        s_truoc<=s_hienTai;
    end
    wire [3:0] d;
    assign d[0] =    ~q[0];
    assign d[1] =   (~s & ~q[1] & q[0]) |
                    (~s &  q[1] & ~q[0]) |
                    ( s & ~q[1] & ~q[0]) |
                    ( s &  q[1] &  q[0]);
    assign d[2] = (~s & ~q[2] & q[1] & q[0]) |
           (~s &  q[2] & ~q[1]) |
           (~s &  q[2] & ~q[0]) |
           ( s & ~q[2] & ~q[1] & ~q[0]) |
           ( s &  q[2] &  q[1]) |
           ( s &  q[2] &  q[0]);
    assign d[3] = (~s & ~q[3] & q[2] & q[1] & q[0]) |
           (~s &  q[3] & ~q[2]) |
           (~s &  q[3] & ~q[1]) |
           (~s &  q[3] & ~q[0]) |
           ( s & ~q[3] & ~q[2] & ~q[1] & ~q[0]) |
           ( s &  q[3] &  q[2]) |
           ( s &  q[3] &  q[1]) |
           ( s &  q[3] &  q[0]); 
    always @(posedge clk_in or negedge clr) begin
        if (!clr) begin
            q <= 4'b0000;     
        end
        else if (s_truoc==1&&s_hienTai==0) begin
            q <= d;          
        end
    end
endmodule*/

module led7seg (  // loai anode chung 
    input [3:0] q,
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
    g2
);
  reg [6:0] led_donvi, led_chuc;
  assign {a1, b1, c1, d1, e1, f1, g1} = led_donvi;
  assign {a2, b2, c2, d2, e2, f2, g2} = led_chuc;
  always @(*) begin
    led_chuc = 7'b0000000;
    case (q)
      4'd0: led_donvi = 7'b0000001;
      4'd1: led_donvi = 7'b1001111;
      4'd2: led_donvi = 7'b0010010;
      4'd3: led_donvi = 7'b0000110;
      4'd4: led_donvi = 7'b1001100;
      4'd5: led_donvi = 7'b0100100;
      4'd6: led_donvi = 7'b0100000;
      4'd7: led_donvi = 7'b0001111;
      4'd8: led_donvi = 7'b0000000;
      4'd9: led_donvi = 7'b0000100;
      4'd10: begin
        led_donvi = 7'b0000001;
        led_chuc  = 7'b1001111;
      end
      4'd11: begin
        led_donvi = 7'b1001111;
        led_chuc  = 7'b1001111;
      end
      4'd12: begin
        led_donvi = 7'b0010010;
        led_chuc  = 7'b1001111;
      end
      4'd13: begin
        led_donvi = 7'b0000110;
        led_chuc  = 7'b1001111;
      end
      4'd14: begin
        led_donvi = 7'b1001100;
        led_chuc  = 7'b1001111;
      end
      4'd15: begin
        led_donvi = 7'b0100100;
        led_chuc  = 7'b1001111;
      end
      default: begin
        led_donvi = 7'b0000000;
        led_chuc  = 7'b0000000;
      end
    endcase
  end
endmodule

module bo_dem (
    input            clk_in,
    clr,
    input            vao,
    ra,  //tin hieu da qua debounce 
    output reg [3:0] q
    //output full
);
  reg vao_current, vao_pre;
  reg ra_current, ra_pre;
  //tao ra suon tin hieu 
  always @(posedge clk_in, negedge clr) begin
    if (!clr) begin
      vao_current <= 0;
      vao_pre <= 0;
      ra_current <= 0;
      ra_pre <= 0;
    end else begin
      vao_current <= vao;
      vao_pre <= vao_current;
      ra_current <= ra;
      ra_pre <= ra_current;
    end
  end

  always @(posedge clk_in, negedge clr) begin
    if (!clr) q <= 0;
    else if (vao_pre == 0 && vao_current == 1) q <= q + 1'b1;
    else if (ra_pre == 0 && ra_current == 1) q <= q - 1'b1;
    else q <= q;
  end

  //assign full=(q==4'd15);
endmodule
