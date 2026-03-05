// 4 bit Binary Counter
module bin_counter(
  input clk, rst,
  output reg [3:0]count
);
  
  always@(posedge clk)begin
    if(rst)
      count <= 4'b0000;
    else
      count <= count + 4'b0001;
  end
  
endmodule

// Testbench
module bin_counter_tb;
  reg clk, rst;
  wire [3:0]count;
  
  bin_counter dut (clk,rst,count);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
    $monitor("Time = %0b clk =%0b rst = %0b count = %0b", $time, clk, rst, count);
    
    rst = 1;
    #20 rst = 0;
    #100 $finish;
    
  end
endmodule
