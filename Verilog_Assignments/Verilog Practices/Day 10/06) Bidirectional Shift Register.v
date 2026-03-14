// Bidirectional Shift Register
module bidirectional_shift(
  input clk,rst,
  input dir,
  input si,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if(rst)
      q<=0;

    else begin
      if(dir)
        q<={q[2:0],si}; // left
      else
        q<={si,q[3:1]}; // right
    end

  end

endmodule

// Testbench
module Bidirectional_Shift_tb;

  reg clk, rst;
  reg dir;
  reg si;
  wire [3:0] q;  

  bidirectional_shift dut (clk,rst,dir,si,q);

  initial clk = 0;
  always #10 clk = ~clk;

  initial begin
    $monitor("Time = %0t | dir = %0b | si = %0b | q = %04b", $time, dir, si, q);
    $dumpfile("bsr.vcd");
    $dumpvars;
    rst = 1;
    dir = 0;
    si  = 0;

    #20 rst = 0;

    // Shift Left
    dir = 1;
    #20 si = 1; 
    #20 si = 0; 
    #20 si = 1;

    // Shift Right
    dir = 0;
    #20 si = 1; 
    #20 si = 0; 

    #100 $finish;
  end

endmodule
