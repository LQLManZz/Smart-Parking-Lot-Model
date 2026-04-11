module Debounce (  //dam bao tin hieu phai giu nguyen 100ms moi cap nhat
    input clk,
    rst,
    nhieu,
    output reg sach
);
  reg signal_1, signal_2;
  always @(posedge clk) begin  // chi nhan tin hieu khi co xung=>dong bo
    signal_1 <= nhieu;
    signal_2 <= signal_1;
  end
  //dem thoi gian xac nhan du lieu
  //ta muon cu moi 100ms tin hieu giu nguyen thi moi duoc cap nhat
  //xung clock=2Mhz => chu ki la 500ns =>can 200k chu ki de duoc 100ms 
  reg [17:0] count;
  always @(posedge clk, negedge rst) begin
    if (!rst) count <= 0;
    else if (signal_2 != sach) begin  // neu tin hieu thay doi
      if (count < 199999) count <= count + 1;
      else begin
        count <= 0;
        sach  <= signal_2;
      end
    end else count <= 0;  // quan trong  
  end
endmodule
