// Self checking testbench architecture
module counter_4bit (
  input clk,
  input rst,
  output reg [3:0]count
);

  always @(posedge clk) begin
    if(rst)
      count <= 4'd0;
    else
      count <= count + 1'b1;
  end

endmodule

// Testbench
`timescale 1ns/1ps
module counter_4bit_tb;

  reg clk;
  reg rst;

  wire [3:0]count;

  counter_4bit dut (clk,rst,count);

  always #5 clk = ~clk;

  reg [3:0] expected_count;

  // Pass & Fail Counters
  integer pass_count;
  integer fail_count;

  // Golden Model
  initial begin

    clk = 0;
    rst = 1;

    expected_count = 0;

    pass_count = 0;
    fail_count = 0;

    #20;
    rst = 0;

    repeat(20)
      @(posedge clk);

    $display("PASS COUNT = %0d", pass_count);
    $display("FAIL COUNT = %0d", fail_count);

    if(fail_count == 0)
      $display("TEST PASSED");
    else
      $display("TEST FAILED");

    $finish;

  end

  // Reference Model
  always @(posedge clk) begin

    if(rst)
      expected_count <= 0;
    else
      expected_count <= expected_count + 1'b1;

  end

  always @(posedge clk) begin

    #1; // waiting for dut update

    if(count === expected_count)begin
      pass_count = pass_count + 1;

      $display("PASS Time = %0t Expected = %0d Actual = %0d",$time, expected_count, count);
    end
    else begin
      fail_count = fail_count + 1;

      $display("FAIL Time = %0t Expected = %0d Actual = %0d", $time, expected_count, count);
    end
  end

endmodule
