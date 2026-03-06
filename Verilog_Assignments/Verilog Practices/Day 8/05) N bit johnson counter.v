// 4 bit Johnson Counter
module johnson_counter#(parameter N = 4)(
  input clk, rst,
  output reg [3:0] q
);
  
  always@(posedge clk)begin
    if(rst)
      q <= 4'b0000;
    else
      q <= {q[N-2:0], ~q[N-1]};
  end
endmodule

// Testbench
module johnson_counter_tb;
  reg clk;
  reg rst;
  wire [3:0] q;

  johnson_counter #(.N(4)) dut (clk, rst, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t clk = %b rst = %b q = %b",$time,clk,rst,q);

    rst = 1;
    #15 rst = 0;

    #100 $finish;
  end

endmodule
    
