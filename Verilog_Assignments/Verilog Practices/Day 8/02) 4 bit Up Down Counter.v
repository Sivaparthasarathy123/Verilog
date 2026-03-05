// 4 bit Up/Down counter
module up_down_counter(
  input clk, rst,
  input up,
  output reg [3:0]count
);
  
  always@(posedge clk)begin
    if(rst)
      count <= 4'd0;
    else if(up)
      count <= count + 4'd1;
    else 
      count <= count - 4'd1;
  end
  
endmodule

// Testbench
module up_down_counter_tb;
  reg clk, rst;
  reg up;
  wire [3:0]count;
  
  up_down_counter dut (clk,rst,up,count);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
    $monitor("Time = %0b clk =%0b rst = %0b up = %0b count = %0b", $time, clk, rst, up, count);
    
    rst = 1;
    #20 rst = 0; up = 1;
    #80 up = 0;
    #500 $finish;
    
  end
endmodule
