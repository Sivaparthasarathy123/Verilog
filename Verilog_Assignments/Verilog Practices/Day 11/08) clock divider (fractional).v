// Clock Divider (fractional)
module clk_div_fractional #(
  parameter NUM = 5,   // numerator
  parameter DEN = 2    // denominator
)(
  input clk,
  input rst,
  output reg  clk_out
);

  reg [$clog2(NUM)-1:0] acc;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      acc     <= 0;
      clk_out <= 0;
    end 
    else begin
      acc <= acc + DEN;

      if (acc >= NUM) begin
        acc     <= acc - NUM;
        clk_out <= ~clk_out;
      end
    end
  end

endmodule

// Testbench
module clk_div_fractional_tb;

  reg clk;
  reg rst;
  wire clk_out;

  clk_div_fractional #(.NUM(5), .DEN(2)) DUT (clk, rst, clk_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst = 1;
    #20 rst = 0;

    #1000;
    $finish;
  end

  initial begin
    $monitor("clk = %0b | rst = %0b | clk_out = %0b",clk, rst, clk_out);
    $dumpfile("cd_fr.vcd");
    $dumpvars;
  end

endmodule
