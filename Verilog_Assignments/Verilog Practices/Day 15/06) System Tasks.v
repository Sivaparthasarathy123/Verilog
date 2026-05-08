// display,monitor,strobe,write - Timing Differences
module dff (
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

// Testbench
module system_tasks;

  reg clk;
  reg rst;
  reg d;
  wire q;

  dff dut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    d   = 0;

    #12;
    rst = 0;

    #3;  d = 1;   // before posedge at 15ns
    #10; d = 0;   // before posedge at 25ns
    #10; d = 1;   // before posedge at 35ns
    #10; d = 0;   // before posedge at 45ns

    #20;
    $finish;
  end

  // Difference between display and strobe
  always @(posedge clk) begin
    $display("DISPLAY time = %0t | d = %b q = %b", $time, d, q);
    $strobe ("STROBE  time = %0t | d = %b q = %b", $time, d, q);
  end

  // Monitor prints whenever d, q, rst, or clk changes
  initial begin
    $monitor("MONITOR time = %0t | clk = %b rst = %b d = %b q = %b",$time, clk, rst, d, q);
  end

  initial begin
    $dumpfile("system_tasks.vcd");
    $dumpvars;
  end

endmodule
