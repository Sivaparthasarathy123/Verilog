// Frequency Divider (by N)
module freq_divN #(parameter N = 10)(
  input clk,
  input rst,
  output reg out
);

  reg [31:0] count;

  always @(posedge clk or posedge rst) begin
    if(rst) begin
      count <= 0;
      out <= 0;
    end
    else begin
      if(count == N-1) begin
        count <= 0;
        out <= ~out;
      end
      else
        count <= count + 1;
    end
  end

endmodule

// Testbench
module freq_divN_tb;
  reg clk;
  reg rst;
  wire out;

  freq_divN dut (clk,rst,out);

  initial clk = 0;
  always #5 clk = ~clk; 

  initial begin
    $monitor("Time = %0t clk = %b rst = %b out = %b", $time, clk, rst, out);

    rst = 1;
    #12 rst = 0;

    #200 $finish;
  end

endmodule
