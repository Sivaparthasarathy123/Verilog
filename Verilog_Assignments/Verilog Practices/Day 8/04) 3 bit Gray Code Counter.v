// 3-bit Gray Code Counter
module gray_counter_3bit (
  input clk,
  input rst,
  output reg [2:0] gray
);

  reg [2:0] binary;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      binary <= 3'b000;
      gray   <= 3'b000;
    end
    else begin
      binary <= binary + 1;
      gray   <= (binary + 1) ^ ((binary + 1) >> 1);
    end
  end

endmodule

// Testbench
module gray_counter_tb;
  reg clk;
  reg rst;
  wire [2:0] gray;

  gray_counter_3bit dut (clk, rst, gray);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t clk = %b rst = %b gray = %b",$time,clk,rst,gray);

    rst = 1;
    #12 rst = 0;

    #100 $finish;
  end

endmodule
