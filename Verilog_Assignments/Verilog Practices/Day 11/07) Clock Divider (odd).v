// Clock Divider (odd)
module clk_div_odd #(
  parameter DIVIDE = 3
)(
  input clk,
  input rst,
  output reg  clk_out
);

  reg [$clog2(DIVIDE)-1:0] count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count   <= 0;
      clk_out <= 0;
    end 
    else begin
      if (count == DIVIDE-1)
        count <= 0;
      else
        count <= count + 1;

      if (count < DIVIDE/2)
        clk_out <= 1;
      else
        clk_out <= 0;
    end
  end

endmodule

// Testbench
module clk_div_odd_tb;

  reg clk;
  reg rst;
  wire clk_out;

  parameter DIVIDE = 3;

  clk_div_odd #(.DIVIDE(DIVIDE)) DUT (clk, rst, clk_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst = 1;
    #20 rst = 0;

    #500;
    $finish;
  end

  initial begin
    $monitor("clk = %0b | rst = %0b | clk_out = %0b",clk, rst, clk_out);
    $dumpfile("cd_odd.vcd");
    $dumpvars;
  end

endmodule
