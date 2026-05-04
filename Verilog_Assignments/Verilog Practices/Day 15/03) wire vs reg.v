// wire vs reg
module comb_wire (
  input a,
  input b,
  output y
);

  assign y = a & b;

endmodule

module comb_reg (
  input a,
  input b,
  output reg y
);

  always @(*) begin
    y = a & b;
  end

endmodule

// Testbench
module wire_vs_reg_tb;

  reg a, b;

  wire y_wire;
  wire y_reg;

  comb_wire u1 (
    .a(a),
    .b(b),
    .y(y_wire)
  );

  comb_reg u2 (
    .a(a),
    .b(b),
    .y(y_reg)
  );

  initial begin
    $dumpfile("wire_vs_reg.vcd");
    $dumpvars;

    $display("Time | a b | wire_y | reg_y");

    a = 0; b = 0; #10;
    a = 0; b = 1; #10;
    a = 1; b = 0; #10;
    a = 1; b = 1; #10;

    #20;
    $finish;
  end

  initial begin
    $monitor("%0t | %b %b | %b | %b",$time, a, b, y_wire, y_reg);
  end

endmodule
