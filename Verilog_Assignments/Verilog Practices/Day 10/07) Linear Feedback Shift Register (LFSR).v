// Linear Feedback Shift Register (LFSR)
module lfsr(
  input clk,rst,
  output reg [3:0] q
);

  wire feedback;
  assign feedback = q[3] ^ q[2];

  always @(posedge clk or posedge rst) begin
    if(rst)
      q<=4'b0001;
    else
      q<={q[2:0],feedback};
  end

endmodule

// Testbench
module lfsr_tb;

  reg clk;
  reg rst;
  wire [3:0] q;

  lfsr dut (clk,rst,q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t | Reset = %b | LFSR Output = %b", $time, rst, q);
    $dumpfile("lfsr.vcd");
    $dumpvars;
    rst = 1;
    #10 rst = 0;

    #200;
    $finish;

  end

endmodule
