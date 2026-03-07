// Frequency Divider (by 2)
module freq_div2(
  input clk,
  input rst,
  output reg out
);

  always @(posedge clk or posedge rst) begin
    if(rst)
      out <= 0;
    else
      out <= ~out;
  end

endmodule

// Testbench
`timescale 1ns/1ps

module freq_div2_tb;
  reg clk;
  reg rst;
  wire out;

  freq_div2 dut (clk, rst, out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t clk = %b rst = %b out = %b",$time,clk,rst,out);

    rst = 1;      
    #12 rst = 0;  

    #200 $finish;

  end

endmodule
