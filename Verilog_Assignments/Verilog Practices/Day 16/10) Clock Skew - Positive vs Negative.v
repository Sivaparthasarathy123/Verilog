// Clock Skew - Positive vs Negative
module skew_example (
  input clk,
  input rst,
  input d,
  output reg q1,
  output reg q2
);

  always @(posedge clk) begin
    if(rst)
      q1 <= 0;
    else
      q1 <= d;
  end

  always @(posedge clk) begin
    if(rst)
      q2 <= 0;
    else
      q2 <= q1;
  end

endmodule

// Testbench
module skew_example_tb;

  reg clk;
  reg rst;
  reg d;

  wire q1;
  wire q2;

  skew_example dut(
    .clk(clk),
    .rst(rst),
    .d(d),
    .q1(q1),
    .q2(q2)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    d   = 0;

    #20;
    rst = 0;

    @(posedge clk);
    d = 1;

    @(posedge clk);
    d = 0;

    repeat(5)
      @(posedge clk);

    $finish;
  end

  initial begin
    $monitor("T = %0t d = %b q1 = %b q2 = %b", $time,d,q1,q2);
  end

endmodule
