// Time Borrowing (Latch-Based Design)
module latch_pipeline (
  input en,
  input d,
  output reg q1,
  output reg q2
);

  // Positive latch
  always @(en or d) begin
    if(en)
      q1 = d;
  end

  // Negative latch
  always @(en or q1) begin
    if(!en)
      q2 = q1;
  end

endmodule

// Testbench
module time_borrowing_tb;

  reg clk;
  reg d;

  wire q1;
  wire q2;

  latch_pipeline dut (
    .clk(clk),
    .d(d),
    .q1(q1),
    .q2(q2)
  );

  always #5 clk = ~clk;

  initial
    begin
      $dumpfile("time_borrowing.vcd");
      $dumpvars;

      clk = 0;
      d   = 0;

      // During positive latch transparent phase
      #2;
      d = 1;

      #4;
      d = 0;

      // During negative latch phase
      #6;
      d = 1;

      #8;
      d = 0;

      #20;
      $finish;
    end

  initial begin
    $monitor("Time = %0t | clk = %b | d = %b | q1 = %b | q2 = %b",
               $time, clk, d, q1, q2);
  end

endmodule
