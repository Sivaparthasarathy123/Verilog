// Recovery and Removal Time
module async_reset_dff_timing (
  input clk,
  input rst_n,
  input d,
  output reg q
);

  reg notifier;

  always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
        q <= 1'b0;
      else
        q <= d;
    end

  specify
    $recovery(posedge rst_n, posedge clk, 3, notifier);
    $removal (posedge rst_n, posedge clk, 2, notifier);
  endspecify

  always @(notifier)begin
      $display("Time = %0t Recovery & Removal violation", $time);
  end

endmodule

// Testbench
module async_reset_dff_timing_tb;

  reg clk;
  reg rst_n;
  reg d;

  wire q;

  async_reset_dff_timing dut (
    .clk(clk),
    .rst_n(rst_n),
    .d(d),
    .q(q)
  );

  always #5 clk = ~clk;

  initial
    begin
      $dumpfile("recovery_removal.vcd");
      $dumpvars;

      clk   = 0;
      rst_n = 0;
      d     = 0;

      // Normal recovery
      #2;
      d = 1;

      // Release reset
      #5;
      rst_n = 1;

      #20;

      // Recovery violation
      rst_n = 0;

      #8;
      rst_n = 1;

      #20;

      // Removal violation
      rst_n = 0;

      #11;
      rst_n = 1;

      #30;

      $finish;
    end

  initial begin
    $monitor("Time = %0t | clk = %b | rst_n = %b | d = %b | q = %b",$time, clk, rst_n, d, q);
  end

endmodule
