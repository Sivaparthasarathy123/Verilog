// Mod 12 Counter
module mod12_counter(
  input clk,
  input rst,
  output reg [3:0] count
);

  always @(posedge clk)begin
    if(rst)
      count <= 0;
    else if(count == 11)
      count <= 0;
    else
      count <= count + 1;
  end

endmodule

// Testbench
module mod12_tb;

  reg clk;
  reg rst;
  wire [3:0] count;

  mod12_counter dut(clk, rst, count);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = .%0t rst = %b count = %d", $time, rst, count);

    rst = 1;
    #10 rst = 0;   
    #1000 $finish;
  end

endmodule
