// 8 bit Counter with hold
module counter_hold (
  input clk,
  input rst,
  input hold,
  output reg [7:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      count <= 8'd0;
    else if (!hold)
      count <= count + 1;
  end

endmodule

// Testbench
module counter_hold_tb;

  reg clk, rst, hold;
  wire [7:0] count;

  counter_hold dut(clk, rst, hold, count);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t rst = %b hold = %b count = %d",$time,rst,hold,count);
    rst=1; hold=0;

    #10 rst=0;

    #50 hold=1;   
    #30 hold=0;   

    #100 $finish;
  end

endmodule
