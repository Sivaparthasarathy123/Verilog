// Combinational vs Sequential
module comb_wrong (
  input a,
  input b,
  output reg x,
  output reg y
);

  always @(*) begin
    x <= a & b;
    y <= x | b;   // uses OLD x → wrong behavior
  end

endmodule

module comb_correct (
  input a,
  input b,
  output reg x,
  output reg y
);

  always @(*) begin
    x = a & b;
    y = x | b;   // uses updated x → correct
  end

endmodule

// Testbench
`timescale 1ns/1ps

module comb_assignment_tb;

  reg a, b;

  wire x_wrong, y_wrong;
  wire x_correct, y_correct;

  // Instantiate WRONG module
  comb_wrong u_wrong (
    .a(a),
    .b(b),
    .x(x_wrong),
    .y(y_wrong)
  );

  // Instantiate CORRECT module
  comb_correct u_correct (
    .a(a),
    .b(b),
    .x(x_correct),
    .y(y_correct)
  );

  initial begin
    $dumpfile("comb_test.vcd");
    $dumpvars;

    $display("Time | a b | WRONG(x,y) | CORRECT(x,y)");

    a = 0; b = 0; #10;
    a = 0; b = 1; #10;
    a = 1; b = 0; #10;
    a = 1; b = 1; #10;

    #20;
    $finish;
  end

  initial begin
    $monitor("%0t | %b %b | %b %b | %b %b",$time, a, b,x_wrong, y_wrong, x_correct, y_correct);
  end

endmodule
