module TN_HDL_FSM (
    input clk,
    rst,
    input [1:0] s,
    output reg vao,
    ra,
    output reg barier1,
    output reg [7:0] led,  // led nay de kiem tra trang thai
    output [3:0] output_signal
);
  localparam [3:0] IDLE = 4'b0000,
                     A0=4'b0001,
                     A1=4'b0010,
                     A2=4'b0011,
                     A3=4'b0100,
                     A4=4'b0101,
                     A5=4'b0110,
                     A6=4'b0111,
                     A7=4'b1000,
                     A8=4'b1001;
  reg [3:0] current, next;
  //DFF
  always @(posedge clk, negedge rst) begin
    if (!rst) current <= IDLE;
    else current <= next;
  end
  //Tin hieu phai qua bo loc nhieu 
  wire [1:0] s_clean;
  Debounce loc_0 (
      .clk  (clk),
      .rst  (rst),
      .nhieu(s[0]),
      .sach (s_clean[0])
  );
  Debounce loc_1 (
      .clk  (clk),
      .rst  (rst),
      .nhieu(s[1]),
      .sach (s_clean[1])
  );
  //ngo ra=> de chong nhieu boi ngo vao, ta co the dong bo bang xung clock 
  always @(posedge clk, negedge rst) begin
    if (!rst) begin
      vao <= 0;
      ra  <= 0;
    end else begin
      if ((current == A2 && s_clean == 2'b11) || (current == A5 && s_clean == 2'b11)) begin
        vao <= 1'b1;
        ra  <= 1'b0;
      end
    else if ((current == A7 && s_clean == 2'b11) || 
             (current == A8 && s_clean == 2'b10) || 
             (current == A3 && s_clean == 2'b11)) begin
        ra  <= 1'b1;
        vao <= 1'b0;
      end else begin
        vao <= 0;
        ra  <= 0;
      end
    end
  end
  //trang thai tiep theo
  always @(*) begin
    case (current)
      IDLE: begin
        barier1 = 0;
        if (s_clean == 2'b10) next = A0;
        else if (s_clean == 2'b01) next = A1;
        else next = IDLE;
      end
      A0: begin
        barier1 = 1;
        if (s_clean == 2'b11) next = A4;
        else if (s_clean == 2'b01) next = A2;
        else if (s_clean == 2'b00) next = A5;
        else next = A0;
      end
      A5: begin
        barier1 = 1;
        if (s_clean == 2'b01) next = A2;
        else if (s_clean == 2'b11) next = IDLE;
        else if (s_clean == 2'b10) next = A0;
        else next = A5;
      end
      A4: begin  //sai
        barier1 = 1;
        if (s_clean == 2'b00) next = A5;
        else if (s_clean == 2'b01) next = A2;
        else if (s_clean == 2'b10) next = A0;
        else next = A4;
      end
      A2: begin
        barier1 = 1;
        if (s_clean == 2'b11) next = IDLE;
        else if (s_clean == 2'b00) next = A5;  //da sua
        //else if(s==2'b10) next=A0;
        else
          next = A2;
      end
      A1: begin
        barier1 = 1;
        if (s_clean == 2'b00) next = A7;
        else if (s_clean == 2'b10) next = A3;
        else if (s_clean == 2'b11) next = A6;
        else next = A1;  //co the bo sung truong hop 2 xe ra noi tiep nhau
      end
      A6: begin
        barier1 = 1;
        if (s_clean == 2'b00) next = A7;
        else if (s_clean == 2'b10) next = A3;
        else if (s_clean == 2'b01) next = A1;
        else next = A6;  //co the bo sung truong hop 2 xe ra noi tiep nhau
      end
      A3: begin
        barier1 = 1;
        if (s_clean == 2'b11) next = IDLE;
        else if (s_clean == 2'b01) next = A1;
        else next = A3;  // co the bo sung truong hop 2 xe ra noi tiep nhau
      end
      A7: begin
        barier1 = 1;
        if (s_clean == 2'b01) next = A1;
        else if (s_clean == 2'b11) next = A8;
        else if (s_clean == 2'b10) next = A3;
        else next = A7;
      end
      A8: begin
        barier1 = 1;
        if (s_clean == 2'b10) next = A3;
        else next = A8;
      end
      default begin
        next = IDLE;
        barier1 = 0;
      end
    endcase
  end
  always @(*) begin
    led = 8'b00000000;
    case (current)
      IDLE: led[0] = 1;
      A1: led[1] = 1;
      A7: led[2] = 1;
      A6: led[3] = 1;
      A8: led[4] = 1;
      A3: led[5] = 1;
      A0: led[6] = 1;
      A2: led[7] = 1;
      default: led = 8'b00000000;
    endcase
  end

  // Lay tin hieu hien tai ra de su dung cho audio
  assign output_signal = current;
endmodule

