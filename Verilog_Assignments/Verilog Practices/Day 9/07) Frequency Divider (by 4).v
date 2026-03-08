// Frequency Divider (by 4)
module freq_div4(
  input clk,
  input rst,
  output reg out
);

  reg [1:0] count;

  always @(posedge clk or posedge rst) begin
    if(rst) begin
      count <= 0;
      out <= 0;
    end
    else begin
      count <= count + 1;
      if(count == 2'b11)
        out <= ~out;
    end
  end

endmodule

// Testbench
module freq_div4_tb;
  reg clk;
  reg rst;
  wire out;

  freq_div4 dut (clk,rst,out);

  initial clk = 0;
  always #5 clk = ~clk; 

  initial begin
    $monitor("Time = %0t clk = %b rst = %b out = %b", $time, clk, rst, out);

    rst = 1;
    #12 rst = 0;

    #200 $finish;
  end

endmodule
