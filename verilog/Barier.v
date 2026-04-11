//nguy�n l� c?a motor servo: t�n hi?u di?u khi?n ph?i c� chu k� c? d?nh
//l� 20ms, trong 1 chu k� g�c quay ph? thu?c v�o th?i t�n hi?u m?c 1
//phai nho trong thiet ke co 2 cai barier
module Barier (
    input clk,
    rst,
    control,
    output reg clock_20
);
  reg [15:0] count;
  always @(posedge clk, negedge rst) begin
    if (!rst) begin
      clock_20 <= 0;
      count <= 0;
    end else begin
      //nguon clock la 2Mhz=> 20 ms la 40000 chu ki
      //tao xung clock voi thoi gian muc 1 khac nhau
      //code tuong tu nhu bo chia tan
      if (count < 39999) begin
        count <= count + 1;
        //barier mo 90 do => 1.5ms=> 3000 chu ki
        if (control) begin
          if (count <= 3999) clock_20 <= 1'b1;
          else clock_20 <= 1'b0;
        end  //khi khong co tin hieu mo
             //barier mo goc 0 do=> 1ms=> 2000 chu ki
        else begin
          if (count <= 1999) clock_20 <= 1'b1;
          else clock_20 <= 1'b0;
        end
      end else begin
        count <= 0;
        clock_20 <= 1'b0;
      end
    end
  end
endmodule
