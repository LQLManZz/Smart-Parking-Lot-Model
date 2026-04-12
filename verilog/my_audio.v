module my_audio #(
    parameter FILENAME = ""  // Ten file .mem chua du lieu hex
) (
    input clk,
    input [14:0] address,  // Dia chi truy xuat (32768 mau)
    output reg [15:0] data_out  // Du lieu am thanh 16-bit dau ra
);

  // Khai bao mang bo nho 32768 o, moi o 16 bit
  reg [15:0] memory_array[0:32767];

  // Nap du lieu am thanh tu file .mem vao bo nho khi khoi tao
  initial begin
    if (FILENAME != "") begin
      $readmemh(FILENAME, memory_array);
    end
  end

  // Cap nhat du lieu dau ra dong bo theo xung nhip
  always @(posedge clk) begin
    data_out <= memory_array[address];
  end

endmodule
