// Nbit Comparator
module comparator_Nbit #(parameter N = 32)(
  input  [N-1:0] val1,
  input  [N-1:0] val2,
  output reg lt,
  output reg gt,
  output reg eq
);

  always @(*) begin
    lt = (val1 < val2);
    gt = (val1 > val2);
    eq = (val1 == val2);
  end

endmodule

// Testbench
module comparator_Nbit_tb;

  parameter N = 32;
 
  reg  [N-1:0] val1;
  reg  [N-1:0] val2;
  wire lt, gt, eq;

  comparator_Nbit #(N) dut (
    .val1(val1),
    .val2(val2),
    .lt(lt),
    .gt(gt),
    .eq(eq)
);

  initial begin
    $monitor("Time=%0t | val1=%0d | val2=%0d | LT=%b | GT=%b | EQ=%b",
              $time, val1, val2, lt, gt, eq);
  end

  initial begin
    val1 = 45; val2 = 35; #10;
    val1 = 60; val2 = 70; #10;
    val1 = 100; val2 = 100; #10;
    val1 = 0; val2 = 1; #10;
    $finish;
  end

endmodule
