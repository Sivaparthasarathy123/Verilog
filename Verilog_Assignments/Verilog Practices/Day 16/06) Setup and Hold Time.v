// Setup and Hold Time
module dff_timing_check (
  input clk,
  input d,
  output reg q
);

  parameter SETUP_TIME = 3;
  parameter HOLD_TIME  = 2;

  reg notifier;

  always @(posedge clk) begin
    q <= d;
  end

  specify
    $setup(d, posedge clk, SETUP_TIME, notifier);
    $hold (posedge clk, d, HOLD_TIME, notifier);
  endspecify

  always @(notifier) begin
    $display("Time = %0t TIMING VIOLATION", $time);
  end

endmodule

// Testbench
module setup_hold_tb;

  reg clk;
  reg d;
  wire q;

  dff_timing_check #(
    .SETUP_TIME(3),
    .HOLD_TIME(2)
  ) dut (
    .clk(clk),
    .d(d),
    .q(q)
  );

  always #10 clk = ~clk;

  initial begin
    $monitor("Time = %0t | clk = %b | d = %b | q = %b", $time, clk, d, q);
    $dumpfile("setup_hold.vcd");
    $dumpvars;

    clk = 0;
    d   = 0;

    // Correct case
    #5;
    d = 1;

    #20;

    // Setup violation
    #3;
    d = 0;

    #20;

    // Hold violation
    #3;
    d = 1;

    #1;
    d = 0;

    #30;
    $finish;
  end

endmodule
