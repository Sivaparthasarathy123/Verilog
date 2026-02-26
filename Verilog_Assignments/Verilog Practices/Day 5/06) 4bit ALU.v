// 4 Bit ALU
module alu_4bit(
  input [3:0] A,B,
  input [1:0] sel,
  output reg [3:0] Y
);

  always @(*) begin
    case(sel)
        2'b00: Y = A + B;
        2'b01: Y = A - B;
        2'b10: Y = A & B;
        2'b11: Y = A | B;
    endcase
  end

endmodule

// Testbench
module alu_4bit_tb;

  reg  [3:0] A,B;
  reg  [1:0] sel;
  wire [3:0] Y;

  alu_4bit dut (A,B,sel,Y);

initial begin
  $monitor("Time = %0t A = %0d | B = %0d | SEL = %0b | Y = %0d", $time, A, B, sel, Y);

    A = 4'd5; B = 4'd3; sel = 2'b00; #10; // ADD
    sel = 2'b01; #10;                 // SUB
    sel = 2'b10; #10;                 // AND
    sel = 2'b11; #10;                 // OR

    A = 4'd15; B = 4'd1; sel = 2'b00; #10;

    $finish;
end

endmodule
