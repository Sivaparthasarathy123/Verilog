// Programmable Counter
module programmable_counter(
  input clk,
  input rst,
  input [7:0] max_value,
  output reg [7:0] count
);

  always @(posedge clk or posedge rst) begin
    if(rst)
      count <= 0;
    else if(count == max_value)
      count <= 0;
    else
      count <= count + 1;
  end

endmodule

// Testbench
module programmable_counter_tb;
  reg clk, rst;
  reg [7:0] max_value;
  wire [7:0] count;

  programmable_counter dut (clk, rst, max_value, count);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t clk = %b rst = %b max_value = %d count = %d",$time, clk, rst, max_value, count);

    rst = 1;
    max_value = 5;  

    #20 rst = 0;

    #200 max_value = 10;

    #200 max_value = 3;

    #500 $finish;

  end

endmodule
