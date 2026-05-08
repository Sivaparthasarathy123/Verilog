// Synchronous vs Asynchronous Reset
module sync_reset_ff (
  input clk,
  input rst,
  input d,
  output reg q
);

  always @(posedge clk) begin
    if (rst)
      q <= 1'b0;
    else
      q <= d;
  end

endmodule

module async_reset_ff (
  input clk,
  input rst,
  input d,
  output reg  q
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 1'b0;
    else
      q <= d;
  end

endmodule

// Testbench
module reset_compare_tb;

  reg clk;
  reg rst;
  reg d;

  wire q_sync;
  wire q_async;

  sync_reset_ff u_sync (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q_sync)
  );

  async_reset_ff u_async (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q_async)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("reset_compare.vcd");
    $dumpvars;

    $monitor("Time = %0t | clk = %b | rst = %b | d = %b | q_sync = %b |    q_async = %b", $time, clk, rst, d, q_sync, q_async);
  end

  initial begin
    clk = 0;
    rst = 0;
    d   = 0;

    #7;
    d = 1;

    // Apply reset between clock edges
    // Async reset responds immediately
    // Sync reset waits until next posedge clk
    #6;
    rst = 1;

    #4;
    rst = 0;

    // Continue data changes
    #3;
    d = 0;

    #10;
    d = 1;

    // Apply reset exactly long enough to catch clock edge
    #7;
    rst = 1;

    #10;
    rst = 0;

    #10;
    d = 0;

    #20;
    $finish;
  end

endmodule
