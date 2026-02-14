// 8x1 Mux
module mux8x1(
  input  [7:0] I, 
  input  S0, S1, S2,
  output reg Y
);

  always @(*) begin
    case({S2, S1, S0})
      3'b000: Y = I[0];
      3'b001: Y = I[1];
      3'b010: Y = I[2];
      3'b011: Y = I[3];
      3'b100: Y = I[4];
      3'b101: Y = I[5];
      3'b110: Y = I[6];
      3'b111: Y = I[7];
      default: Y = 1'bx;
    endcase
  end

endmodule

module mux8x1_tb;

  reg [7:0] I;
  reg S0, S1, S2;
  wire Y;

  mux8x1 dut (I, S0, S1, S2, Y);

  integer i;
  initial begin
    $display("--------- 8x1 MUX ----------");
    $monitor("I=%b | S2=%b S1=%b S0=%b | Y=%b", I, S2, S1, S0, Y);

    for(i = 0; i < 10; i = i + 1) begin
      {I, S2, S1, S0} = $urandom;
      #10;
    end

    $finish;
  end

endmodule
