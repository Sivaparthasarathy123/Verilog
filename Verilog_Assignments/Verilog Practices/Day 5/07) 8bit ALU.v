// 8 bit ALU
module alu_8bit(
    input [7:0] A,B,
    input [2:0] sel,
    output reg [7:0] Y
);

  always @(*) begin
    case(sel)
        3'b000: Y = A + B;
        3'b001: Y = A - B;
        3'b010: Y = A & B;
        3'b011: Y = A | B;
        3'b100: Y = A ^ B;
        3'b101: Y = ~A;
        3'b110: Y = A << 1;
        3'b111: Y = A >> 1;
    endcase
  end

endmodule

// Testbench
module alu_8bit_tb;

  reg  [7:0] A,B;
  reg  [2:0] sel;
  wire [7:0] Y;

  alu_8bit dut (A,B,sel,Y);

  integer i;
  initial begin
    $monitor("Time  = %0t A = %0d B = %0d SEL = %0b Y = %0d", $time, A, B, sel, Y);

    A = 8'd20; B = 8'd5;
    for(i = 0; i<8; i=i+1)begin
      sel = i;
      #10;
    end

    $finish;
  end

endmodule
