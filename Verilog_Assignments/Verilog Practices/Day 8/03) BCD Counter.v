// BCD Counter
module bcd_counter(
  input clk,
  input rst,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (rst)
      count <= 4'd0;

    else if (count == 4'd9)
      count <= 4'd0;

    else
      count <= count + 4'd1;
  end

endmodule

// Testbench
module bcd_counter_tb;

  reg clk, rst;
  wire [3:0] count;

  bcd_counter dut (clk, rst, count);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t clk = %0b rst = %0b count = %0d", $time, clk, rst, count);

    rst = 1;
    #20 rst = 0;

    #200 $finish;
  end

endmodule
