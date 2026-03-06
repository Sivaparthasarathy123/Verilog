// 4 bit Ring Counter
module ring_counter#(parameter N = 4)(
  input clk, rst,
  output reg [N-1:0] q
);
  
  always@(posedge clk)begin
    if(rst)
      q <= 4'b0000;
    else if(q == 4'b1111)
      q <= 4'b0000;
    else
      q <= q + 4'b0001 ;
  end
endmodule

// Testbench
module ring_counter_tb;
  parameter N = 4;
  reg clk;
  reg rst;
  wire [N-1:0] q;

  ring_counter #(.N(4)) dut (clk, rst, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t clk = %b rst = %b ring = %b",$time,clk,rst,q);

    rst = 1;
    #15 rst = 0;

    #1000 $finish;
  end

endmodule
    
