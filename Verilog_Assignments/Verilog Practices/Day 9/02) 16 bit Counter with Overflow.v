// 16 bit Counter with Overflow
module counter_overflow(
  input clk,
  input rst,
  output reg overflow,
  output reg [7:0] count
);

  always @(posedge clk or posedge rst) begin
    if(rst) begin
      count <= 0;
      overflow <= 0;
    end
    else begin
      if(count == 16'hFFFF) begin
        count <= 0;
        overflow <= 1;
      end
      else begin
        count <= count + 1;
        overflow <= 0;
      end
    end
  end

endmodule

// Testbench
module counter_overflow_tb;

  reg clk, rst;
  wire overflow;
  wire [15:0] count;

  counter_overflow dut(clk, rst, overflow, count);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t rst = %b overflow = %b count = %d",
              $time,rst,overflow,count);

    rst = 1;
    #10 rst = 0;

    #700000 $finish;  

  end

endmodule
